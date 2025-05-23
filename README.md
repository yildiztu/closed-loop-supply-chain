# GAMS - Closed Loop Supply Chain (CLSC)

Many business activities take place within a supply chain. Therefore, in a typical supply chain system, numerous business processes interact. On the other hand, supply chain optimization studies are dedicated to some various smaller parts of a whole business system; often the big picture is left unseen. Moreover, many studies focus relatively small theoretical optimization models using various methods. However, there is a huge potential of opportunities; as such, reducing the overall costs and waste, when the supply chain system is viewed as a complete “closed-loop” structure. The term “closed-loop” refers to both integrated systems of a forward and a reverse chain. In this regard, by taking into account of the practical outcomes of both forward and reverse chain system optimization; this study presents a model of a more realistic supply chain system with an optimization source code.

Link:

https://www.researchgate.net/publication/304132695_A_closed-loop_supply_chain_A_multi-echelon_multi-period_multi-product_system

# Closed-Loop Supply Chain Optimization Model

## Overview

This repository contains a comprehensive GAMS (General Algebraic Modeling System) implementation of a multi-period, multi-product closed-loop supply chain optimization model. The model integrates both forward and reverse logistics in a holistic framework, enabling businesses to optimize their entire supply chain ecosystem while considering sustainability aspects.

## Background

Traditional supply chain optimization studies often focus on isolated segments of business systems, missing opportunities for system-wide improvements. This model addresses this limitation by viewing the supply chain as a complete "closed-loop" structure that encompasses:

1. **Forward Chain**: The conventional flow of materials from suppliers to customers
2. **Reverse Chain**: The recovery of used products from customers back into the supply chain

By integrating these components, the model identifies opportunities to reduce overall costs and waste while maximizing value recovery from returned products.

## Model Architecture

### Network Structure

The model represents a complex network with the following entities:

#### Forward Chain Components
- **Suppliers (s)**: Provide raw materials
- **Manufacturers (f)**: Convert raw materials into finished products
- **Warehouses (w)**: Store products for distribution
- **Distributors (d)**: Deliver products to retailers
- **First Customers (c)**: Retailers who sell to end consumers

#### Reverse Chain Components
- **Disassembly Centers (a)**: Process returned products
- **Redistributors (r)**: Handle recovered products
- **Disposal Locations (p)**: Manage waste from unrecoverable products
- **Second Customers (k)**: Purchase recovered/remanufactured products

### Time Horizon and Products
- Multiple planning periods (t)
- Multiple product types (u)

## Code Structure and Explanation

### Sets Definition
```gams
Sets
s suppliers /s1*s5/
f manufacturers /m1*m3/
w warehouses /w1*w2/
d distributors /d1*d5/
c first customers (retailers) /c1*c50/
a disassembly centers /a1*a3/
r redistributors /r1*r2/
p disposal locations /p1*p3/
k second customers /k1*k3/
u products /u1*u3/
t periods /t1*t5/
;
```
This section defines the fundamental entities in our supply chain network. The notation `/s1*s5/` creates 5 suppliers named s1 through s5, and similar patterns are used for other entities.

### Parameters
The model uses numerous parameters to represent various aspects of the supply chain:

```gams
Parameters
D_(*,u,t)  demand of product u by the first customer c or second customer k in period t
P_(*,u,t)  unit price of product u at the first customer c or second customer k in period t
...
```

Key parameter groups include:
- **Demand and Price Parameters**: Define market conditions
- **Capacity Parameters**: Limit operations at each facility
- **Cost Parameters**: Represent various operational costs
- **Transportation Parameters**: Define logistics costs and constraints
- **Recovery Parameters**: Specify return rates and recovery options

### Parameter Initialization
```gams
* Initialize parameters
D_(k,u,t) = normal(100,1);
P_(c,u,t) = normal(100,10);
...
```
This section assigns values to the parameters using normal distributions. For example, `normal(100,1)` generates random values from a normal distribution with mean 100 and standard deviation 1. This approach creates realistic test data.

### Decision Variables
```gams
Binary variables
L(*)       binary variable equals 1 if location i s f d a r p w is open - 0 otherwise
Li(*,*)    binary variable equals 1 if a transportation link is established between any two locations i and j
;

Positive variables
Q(*,*,u,t) flow of batches of product u from location x to location y in period t
R_(*,u,t)   the residual inventory of product u at warehouse w or distributor d in period t
;
```

The model uses three types of variables:
1. **Location Variables (L)**: Binary decisions on which facilities to open
2. **Link Variables (Li)**: Binary decisions on which transportation links to establish
3. **Flow Variables (Q)**: Continuous decisions on product quantities to ship
4. **Inventory Variables (R_)**: Continuous decisions on inventory levels

### Constraints
The model includes numerous constraints that govern the operation of the supply chain:

#### Balance Constraints
```gams
balance_manufacturers(t,u,f).. sum(s, Q(s,f,u,t)*B(s,u)) =e= sum(d, Q(f,d,u,t)*B(f,u)) + sum(w, Q(f,w,u,t)*B(f,u)) + sum(c, Q(f,c,u,t)*B(f,u));
```
This constraint ensures material balance at manufacturers: incoming materials equal outgoing products.

#### Capacity Constraints
```gams
capacity_suppliers_output(t,u,s).. sum(f, Q(s,f,u,t)*B(s,u)) =l= SC(s,u,t)*L(s);
```
This constraint limits the output of suppliers based on their capacity, and only if the supplier location is open (L(s)=1).

#### Link Management Constraints
```gams
link_management_sf(s,f).. Li(s,f) =l= sum(u, sum(t, Q(s,f,u,t)));
link_management_sf2(s,f).. sum(u, sum(t, Q(s,f,u,t))) =l= M*Li(s,f);
```
These constraints ensure that flow can only occur on established links. The first constraint forces Li(s,f) to be 1 if there's any flow, and the second constraint forces flow to be 0 if Li(s,f) is 0.

#### Recovery Rate Constraints
```gams
balance_recycling_rate(t,u,a).. sum(c, Q(c,a,u,t)*B(c,u))*R_c =e= sum(s, Q(a,s,u,t)*B(a,u));
```
This constraint ensures that the recycling rate (R_c) of returned products is maintained.

### Objective Function
```gams
obj.. UU =e=
*Total sales
sum(d, sum(c, sum(u, sum(t, Q(d,c,u,t)*B(d,u)*P_(c,u,t))))) +
...
*Total costs
*Fixed costs (location costs)
sum(s, F_(s)*L(s)) +
...
```

The objective function maximizes profit by considering:
1. **Revenue**: From sales to both first and second customers
2. **Costs**: Including fixed facility costs, material costs, manufacturing costs, transportation costs, inventory costs, and various recovery process costs

### Model Solution
```gams
Models model3 Closed-loop supply chain system / all /
Solve model3 minimizing UU using rmip;
```

This section defines the complete model and solves it using a relaxed mixed-integer programming (RMIP) approach, which is appropriate for large-scale problems.

## Key Features and Benefits

1. **Integrated Decision-Making**: Combines strategic (facility location), tactical (transportation links), and operational (flow quantities) decisions
2. **Multi-Period Planning**: Accounts for time-dependent changes in demand and costs
3. **Product Recovery Options**: Models multiple recovery paths (recycling, remanufacturing, repair, disposal)
4. **Realistic Constraints**: Incorporates capacity limitations, balance requirements, and service levels
5. **Economic Optimization**: Maximizes profit while considering the full spectrum of costs

## Applications

This model is particularly valuable for industries with:
- High-value products worth recovering (electronics, automotive)
- Extended producer responsibility regulations
- Significant environmental impact concerns
- Opportunities for value recovery from used products

## Implementation Guide

### Prerequisites
- GAMS (General Algebraic Modeling System) software
- Appropriate solver license (CPLEX, GUROBI, etc.)

### Steps to Use
1. **Data Preparation**: Modify the parameter initialization section with your specific data
2. **Model Configuration**: Adjust constraints and recovery rates to match your supply chain
3. **Execution**: Run the model in GAMS
4. **Results Analysis**: Examine the solution to identify optimal:
   - Facility locations
   - Transportation links
   - Product flows
   - Recovery strategies

### Output Interpretation
The model produces a comprehensive solution that specifies:
- Which facilities to open
- Which transportation links to establish
- How much of each product to ship between locations
- How to process returned products
- Inventory levels at warehouses and distributors

## Advanced Features

### Sensitivity Analysis
The model can be extended to perform sensitivity analysis on key parameters such as:
- Return rates
- Recovery costs
- Transportation costs
- Demand fluctuations

### Scenario Planning
Multiple scenarios can be evaluated by modifying parameters to represent different business conditions or strategic options.

## Limitations and Extensions

### Current Limitations
- Deterministic parameters (no uncertainty modeling)
- Linear cost structures
- Single objective (profit maximization)

### Potential Extensions
- Stochastic programming for uncertainty
- Multi-objective optimization for environmental impacts
- Incorporation of carbon emissions and sustainability metrics
- Dynamic capacity adjustments

## Technical Notes

The model is implemented in GAMS, which is particularly well-suited for large-scale mathematical programming problems. The relaxed mixed-integer programming (RMIP) approach is used as a solution method to handle the computational complexity of the full model.

