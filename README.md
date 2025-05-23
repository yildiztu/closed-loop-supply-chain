# GAMS - Closed Loop Supply Chain (CLSC)

Many business activities take place within a supply chain. Therefore, in a typical supply chain system, numerous business processes interact. On the other hand, supply chain optimization studies are dedicated to some various smaller parts of a whole business system; often the big picture is left unseen. Moreover, many studies focus relatively small theoretical optimization models using various methods. However, there is a huge potential of opportunities; as such, reducing the overall costs and waste, when the supply chain system is viewed as a complete “closed-loop” structure. The term “closed-loop” refers to both integrated systems of a forward and a reverse chain. In this regard, by taking into account of the practical outcomes of both forward and reverse chain system optimization; this study presents a model of a more realistic supply chain system with an optimization source code.

Link:

https://www.researchgate.net/publication/304132695_A_closed-loop_supply_chain_A_multi-echelon_multi-period_multi-product_system


# Closed-Loop Supply Chain Optimization

This repository contains a GAMS (General Algebraic Modeling System) implementation of a multi-period, multi-product large-scale closed-loop supply chain optimization model.

## Overview

Supply chain optimization traditionally focuses on smaller parts of business systems, often leaving the big picture unseen. This model addresses that gap by viewing the supply chain as a complete "closed-loop" structure, integrating both forward and reverse chains. By taking this holistic approach, the model aims to reduce overall costs and waste in the supply chain system.

## Model Description

The model represents a comprehensive closed-loop supply chain network consisting of:

### Forward Chain Components:
- Suppliers
- Manufacturers
- Warehouses
- Distributors
- First customers (retailers)

### Reverse Chain Components:
- Disassembly centers
- Redistributors
- Disposal locations
- Second customers

### Key Features:
- Multi-period planning horizon
- Multiple product types
- Capacity constraints for all facilities
- Transportation links between facilities
- Inventory management at warehouses and distributors
- Customer service level requirements
- Product return and recovery processes

## Mathematical Structure

The model is formulated as a mixed-integer linear programming (MILP) problem with:

### Decision Variables:
- Binary variables for facility location decisions
- Binary variables for transportation link establishment
- Flow variables for product movement between locations
- Inventory variables for warehouses and distributors

### Constraints:
- Material balance constraints at all nodes
- Capacity constraints for all facilities
- Link management constraints
- Customer service level constraints
- Product recovery rate constraints
- Maximum number of allowable locations

### Objective Function:
The objective function maximizes total profit by considering:
- Revenue from sales to first and second customers
- Fixed costs of opening facilities
- Material costs
- Manufacturing and remanufacturing costs
- Non-utilized capacity costs
- Purchasing costs
- Disassembly, recycling, repairing, and disposal costs
- Transportation costs
- Inventory holding costs

## Data Structure

The model uses the following sets:
- `s`: Suppliers
- `f`: Manufacturers
- `w`: Warehouses
- `d`: Distributors
- `c`: First customers (retailers)
- `a`: Disassembly centers
- `r`: Redistributors
- `p`: Disposal locations
- `k`: Second customers
- `u`: Products
- `t`: Time periods

Parameters include demand, prices, capacities, costs, distances, and recovery ratios.

## Usage

To use this model:

1. Install GAMS (General Algebraic Modeling System)
2. Open the `.gms` file in GAMS IDE
3. Adjust the parameters as needed for your specific supply chain scenario
4. Run the model
5. Analyze the results in the output file or GDX file

## Implementation Details

The model is solved using a relaxed mixed-integer programming (RMIP) solver, which provides a good approximation of the optimal solution for large-scale problems. The results are exported to a GDX file for further analysis.

## Potential Applications

This model can be applied to various industries to optimize their closed-loop supply chain operations, including:
- Electronics manufacturing and recycling
- Automotive production and parts remanufacturing
- Consumer goods with return policies
- Industrial equipment with refurbishment programs

## Limitations and Future Work

- The current model uses normally distributed parameter values for demonstration purposes
- Stochastic elements could be incorporated to handle uncertainty
- The model could be extended to include environmental impact metrics
- Solution methods for larger instances could be explored

