$Title Closed-Loop Supply Chain Optimization
$Ontext

Model - Multi-period multi-product large scale closed-loop supply chain optimization

GDX="C:\model_clsc.gdx"

$Offtext


$inlinecom /* */

option
    limrow = 100,     /* equations listed per block */
    limcol = 100,     /* variables listed per block */
    solprint = on,     /* solver's solution output printed */
    sysout = on;       /* solver's system output printed */

$onsymxref
$onsymlist
$onlisting

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

Parameters

D_(*,u,t)  demand of product u by the first customer c or second customer k in period t
P_(*,u,t)  unit price of product u at the first customer c or second customer k in period t
PH(c,u,t)  purchasing cost of product u at the first customer c in period t

F_(*)      fixed cost of the opening location i
DS(*,*)    distance between any two locations i and j
SC(*,u,t)  capacity of supplier s or warehouse w of product u in period t
SRC(s,u,t) recycling capacity of supplier s of product u in period t
FC(f,u,t)  manufacturing capacity of manufacturer f of product u in period t
RFC(f,u,t) remanufacturing capacity of manufacturer f of product u in period t
WC(w,u,t)  warehouse capacity in hours of warehouse w of product u in period t

DC(d,u,t)  capacity of distributor d of product u in period t
AC(a,u,t)  capacity of disassembly a of product u in period t
RC(r,u,t)  capacity of redistributor r of product u in period t
PC(p,u,t)  capacity of disposal center p of product u in period t

Mc(s,u,t)  material cost of product u per unit supplied by s in period t
Rc_(s,u,t)  recycling cost of product u per unit recycled by supplier s in period t
*Rc(s,u,t)  recycling cost of supplier s of product u in period t

Fc(f,u,t)  manufacturing cost of product u per unit manufactured by manufacturer f in period t
RFc(f,u,t) remanufacturing cost of product u per unit by manufacturer f in period t
DAc(a,u,t) disassembly cost of product u per unit by disassembly center a in period t
RPc(a,u,t) repairing cost of product u per unit repaired by disassembly location a in period t
Pc_(*,u,t)  disposal cost of product u per unit disposed by disposal location p or disassembly center a in period t

Nc(f,u,t)  non-utilized manufacturing capacity cost of product u of manufacturer f in period t
RNc(f,u,t) non-utilized remanufacturing cost of product u of manufacturer f in period t
Sc_(u,t)   shortage cost of product u per unit in period t
Fh(f,u)    manufacturing time of product u per unit at manufacturer f
RFh(f,u)   remanufacturing time of product u per unit at manufacturer f

WH(w,u,t)  holding cost of product u per unit at the warehouse w in period t
DH(d,u,t)  holding cost of product u per unit at distributor store d in period t

B(*,*)     batch size of product u from supplier s - manufacturer f - distributor d - disassembly a - redistributor r - warehouse w - customer c

Tc(u,t)    transportation cost of product u per unit per kilometer in period t
RR(u,t)    return ratio of product u at the first customers in period t

R_c        recycling ratio     Note: (R_c + R_m + R_r + R_p) =e= 1
R_m        remanufacturing ratio
R_r        repairing ratio
R_p        disposal ratio

M          large number

S__        size of s - max_number_allowable_locations_suppliers_S
F__        size of f - max_number_allowable_locations_manufacturers_F
D__        size of d - max_number_allowable_locations_distributors_D
W__        size of w - max_number_allowable_locations_warehouses_W
A__        size of a - max_number_allowable_locations_disassembly_centers_A
R__        size of r - max_number_allowable_locations_redistributors_R
P__        size of p - max_number_allowable_locations_disposal_locations_P

;

* Initialize parameters
*D_(*,u,t)  demand of product u by the first customer c or second customer k in period t
*D_(c,u,t) = normal(100,1);
D_(k,u,t) = normal(100,1);

*P_(*,u,t)  unit price of product u at the first customer c or second customer k in period t
P_(c,u,t) = normal(100,10);
P_(k,u,t) = normal(100,10);

*PH(c,u,t)  purchasing cost of product u at the first customer c in period t
PH(c,u,t) = normal(100,10);

*F_(*)      fixed cost of the opening location i
F_(s)     = normal(100,10);
F_(f)     = normal(100,10);
F_(d)     = normal(100,10);
F_(a)     = normal(100,10);
F_(r)     = normal(100,10);
F_(p)     = normal(100,10);
F_(w)     = normal(100,10);

*DS(*,*)    distance between any two locations i and j
DS(s,f)   = normal(100,10);
DS(f,d)   = normal(100,10);
DS(f,w)   = normal(100,10);
DS(f,c)   = normal(100,10);
DS(f,k)   = normal(100,10);
DS(w,c)   = normal(100,10);
DS(w,k)   = normal(100,10);
DS(d,c)   = normal(100,10);
DS(a,s)   = normal(100,10);
DS(a,f)   = normal(100,10);
DS(a,p)   = normal(100,10);
DS(a,r)   = normal(100,10);
DS(f,r)   = normal(100,10);
DS(w,r)   = normal(100,10);
DS(r,k)   = normal(100,10);
DS(c,a)   = normal(100,10);
DS(w,d)   = normal(100,10);
DS(a,k)   = normal(100,10);

*SC(*,u,t)  capacity of supplier s or warehouse w of product u in period t
SC(s,u,t) = normal(1000,10);
SC(w,u,t) = normal(1000,10);

*SRC(s,u,t) recycling capacity of supplier s of product u in period t
SRC(s,u,t) = normal(1000,10);

*FC(f,u,t)  manufacturing capacity of manufacturer f of product u in period t
FC(f,u,t)  = normal(1000,10);

*RFC(f,u,t) remanufacturing capacity of manufacturer f of product u in period t
RFC(f,u,t) = normal(1000,10);

*WC(w,u,t)  warehouse capacity in hours of warehouse w of product u in period t
WC(w,u,t)  = normal(1000,10);

*DC(d,u,t)  capacity of distributor d of product u in period t
DC(d,u,t)  = normal(1000,10);

*AC(a,u,t)  capacity of disassembly a of product u in period t
AC(a,u,t)  = normal(1000,10);

*RC(r,u,t)  capacity of redistributor r of product u in period t
RC(r,u,t)  = normal(1000,10);

*PC(p,u,t)  capacity of disposal center p of product u in period t
PC(p,u,t)  = normal(1000,10);

*Mc(s,u,t)  material cost of product u per unit supplied by s in period t
Mc(s,u,t)  = normal(100,10);

*Rc_(s,u,t)  recycling cost of product u per unit recycled by supplier s in period t
Rc_(s,u,t) = normal(100,10);

**Rc(s,u,t)  recycling cost of supplier s of product u in period t

*Fc(f,u,t)  manufacturing cost of product u per unit manufactured by manufacturer f in period t
Fc(f,u,t)  = normal(100,10);

*RFc(f,u,t) remanufacturing cost of product u per unit by manufacturer f in period t
RFc(f,u,t) = normal(100,10);

*DAc(a,u,t) disassembly cost of product u per unit by disassembly center a in period t
DAc(a,u,t) = normal(100,10);

*RPc(a,u,t) repairing cost of product u per unit repaired by disassembly location a in period t
RPc(a,u,t) = normal(100,10);

*Pc_(*,u,t)  disposal cost of product u per unit disposed by disposal location p or disassembly center a in period t
Pc_(p,u,t) = normal(100,10);
Pc_(a,u,t) = normal(100,10);

*Nc(f,u,t)  non-utilized manufacturing capacity cost of product u of manufacturer f in period t
Nc(f,u,t)  = normal(100,10);

*RNc(f,u,t) non-utilized remanufacturing cost of product u of manufacturer f in period t
RNc(f,u,t) = normal(100,10);

*Sc_(u,t)   shortage cost of product u per unit in period t
Sc_(u,t)   = normal(100,10);

*Fh(f,u)    manufacturing time of product u per unit at manufacturer f
Fh(f,u)    = normal(100,10);

*RFh(f,u)   remanufacturing time of product u per unit at manufacturer f
RFh(f,u)   = normal(100,10);

*WH(w,u,t)  holding cost of product u per unit at the warehouse w in period t
WH(w,u,t)  = normal(100,10);

*DH(d,u,t)  holding cost of product u per unit at distributor store d in period t
DH(d,u,t)  = normal(100,10);

*B(*,*)     batch size of product u from supplier s - manufacturer f - distributor d - disassembly a - redistributor r - warehouse w - customer c
B(u,s)     = normal(10000,10);
B(u,f)     = normal(10000,10);
B(u,d)     = normal(10000,10);
B(u,a)     = normal(10000,10);
B(u,r)     = normal(10000,10);
B(u,w)     = normal(10000,10);
B(u,c)     = normal(10000,10);

*Tc(u,t)    transportation cost of product u per unit per kilometer in period t
Tc(u,t)    = normal(100,10);

*RR(u,t)    return ratio of product u at the first customers in period t
RR(u,t)    = normal(100,10);

*R_c        recycling ratio     Note: (R_c + R_m + R_r + R_p) =e= 1
R_c        = 0.25;

*R_m        remanufacturing ratio
R_m        = 0.25;

*R_r        repairing ratio
R_r        = 0.25;

*R_p        disposal ratio
R_p        = 0.25;

*M          large number
M          = 10;

*S__        size of s - max_number_allowable_locations_suppliers_S
S__        = 100;

*F__        size of f - max_number_allowable_locations_manufacturers_F
F__        = 100;

*D__        size of d - max_number_allowable_locations_distributors_D
D__        = 100;

*W__        size of w - max_number_allowable_locations_warehouses_W
W__        = 100;

*A__        size of a - max_number_allowable_locations_disassembly_centers_A
A__        = 100;

*R__        size of r - max_number_allowable_locations_redistributors_R
R__        = 100;

*P__        size of p - max_number_allowable_locations_disposal_locations_P
P__        = 100;


Binary variables

L(*)       binary variable equals 1 if location i s f d a r p w is open - 0 otherwise
Li(*,*)    binary variable equals 1 if a transportation link is established between any two locations i and j

;

Positive variables

Q(*,*,u,t) flow of batches of product u from location x to location y in period t

R_(*,u,t)   the residual inventory of product u at warehouse w or distributor d in period t

;

Variable

UU Objective

;

Equations

 balance_manufacturers                   The balance constraint of manufacturers
 balance_warehouses                      The balance constraint of warehouses
 balance_distributors                    The balance constraint of distributors
 balance_customer_service_level          The balance constraint of customer service level
 balance_disassembly_centers_inputs      The balance constraint of disassembly centers' inputs
 balance_disassembly_centers_outputs     The balance constraint of disassembly centers' outputs
 balance_recycling_rate                  The balance constraint of recycling rate
 balance_remanufacture_rate              The balance constraint of remanufacture rate
 balance_repair_rate                     The balance constraint of repair rate
 balance_disposal_rate                   The balance constraint of disposal rate
 balance_Rc_Rm_Rr_Rp                     The balance constraint of Rc Rm Rr Rp
 balance_manufacturers_reverse_flows     The balance constraint of manufacturers reverse flows
 balance_redistributors                  The balance constraint of redistributors
 balance_second_customers                The balance constraint of second customers

 capacity_suppliers_output               The capacity constraint of suppliers output
 capacity_manufacturers                  The capacity constraint of manufacturers
 capacity_suppliers                      The capacity constraint of suppliers
 capacity_distributors                   The capacity constraint of distributors
 capacity_disassembly_centers            The capacity constraint of disassembly centers
 capacity_redistributors                 The capacity constraint of redistributors
 capacity_recycling_suppliers            The capacity constraint of recycling suppliers
 capacity_disposal_centers               The capacity constraint of disposal centers
 capacity_warehouses                     The capacity constraint of warehouses

 link_management_sf                      The constraint for link_management_sf
 link_management_fd                      The constraint for link_management_fd
 link_management_fw                      The constraint for link_management_fw
 link_management_fc                      The constraint for link_management_fc
 link_management_fk                      The constraint for link_management_fk
 link_management_fr                      The constraint for link_management_fr
 link_management_wd                      The constraint for link_management_wd
 link_management_wc                      The constraint for link_management_wc
 link_management_wk                      The constraint for link_management_wk
 link_management_wr                      The constraint for link_management_wr
 link_management_dc                      The constraint for link_management_dc
 link_management_ca                      The constraint for link_management_ca
 link_management_as                      The constraint for link_management_as
 link_management_af                      The constraint for link_management_af
 link_management_ar                      The constraint for link_management_ar
 link_management_ap                      The constraint for link_management_ap
 link_management_rk                      The constraint for link_management_rk

 link_management_sf2                      The constraint for link_management_sf2
 link_management_fd2                      The constraint for link_management_fd2
 link_management_fw2                      The constraint for link_management_fw2
 link_management_fc2                      The constraint for link_management_fc2
 link_management_fk2                      The constraint for link_management_fk2
 link_management_fr2                      The constraint for link_management_fr2
 link_management_wd2                      The constraint for link_management_wd2
 link_management_wc2                      The constraint for link_management_wc2
 link_management_wk2                      The constraint for link_management_wk2
 link_management_wr2                      The constraint for link_management_wr2
 link_management_dc2                      The constraint for link_management_dc2
 link_management_ca2                      The constraint for link_management_ca2
 link_management_as2                      The constraint for link_management_as2
 link_management_af2                      The constraint for link_management_af2
 link_management_ar2                      The constraint for link_management_ar2
 link_management_ap2                      The constraint for link_management_ap2
 link_management_rk2                      The constraint for link_management_rk2

 max_number_allowable_locations_suppliers_s              The constraint for max_number_allowable_locations_suppliers_s
 max_number_allowable_locations_manufacturers_f          The constraint for max_number_allowable_locations_manufacturers_f
 max_number_allowable_locations_distributors_d           The constraint for max_number_allowable_locations_distributors_d
 max_number_allowable_locations_warehouses_w             The constraint for max_number_allowable_locations_warehouses_w
 max_number_allowable_locations_disassembly_centers_a    The constraint for max_number_allowable_locations_disassembly_centers_a
 max_number_allowable_locations_redistributors_r         The constraint for max_number_allowable_locations_redistributors_r
 max_number_allowable_locations_disposal_locations_p     The constraint for max_number_allowable_locations_disposal_locations_p

* Objective Function
 obj Objective function
;

 balance_manufacturers(t,u,f)..                sum(s, Q(s,f,u,t)*B(s,u)) =e= sum(d, Q(f,d,u,t)*B(f,u)) + sum(w, Q(f,w,u,t)*B(f,u)) + sum(c, Q(f,c,u,t)*B(f,u));
 balance_warehouses(t,u,w)..                   sum(f, Q(f,w,u,t)*B(f,u)) + R_(w,u,t-1) =e= R_(w,u,t) + sum(d, Q(w,d,u,t)*B(w,u)) + sum(c, Q(w,c,u,t)*B(w,u)) + sum(k, Q(w,k,u,t)*B(w,u));
 balance_distributors(t,u,d)..                 sum(f, Q(f,d,u,t)*B(f,u)) + sum(w, Q(w,d,u,t)*B(w,u)) + R_(d,u,t-1) =e= R_(d,u,t) + sum(c, Q(d,c,u,t)*B(d,u));
 balance_customer_service_level(t,u,c)..       sum(d, Q(d,c,u,t)*B(d,u)) + sum(f, Q(f,c,u,t)*B(f,u)) + sum(w, Q(w,c,u,t)*B(w,u)) =g= 0.7*D_(c,u,t);
 balance_disassembly_centers_inputs(t,u,c)..   sum(a, Q(c,a,u,t)*B(c,u)) =l= (sum(d, Q(d,c,u,t)*B(d,u)) + sum(f, Q(f,c,u,t)*B(f,u)) + sum(w, Q(w,c,u,t)*B(w,u)))*RR(u,t);
 balance_disassembly_centers_outputs(t,u,a)..  sum(c, Q(c,a,u,t)*B(c,u)) =e= (sum(s, Q(a,s,u,t)*B(a,u)) + sum(f, Q(a,f,u,t)*B(a,u)) + sum(r, Q(a,r,u,t)*B(a,u)) + sum(p, Q(a,p,u,t)*B(a,u)) + sum(k, Q(a,k,u,t)*B(a,u)));
 balance_recycling_rate(t,u,a)..               sum(c, Q(c,a,u,t)*B(c,u))*R_c =e= sum(s, Q(a,s,u,t)*B(a,u));
 balance_remanufacture_rate(t,u,a)..           sum(c, Q(c,a,u,t)*B(c,u))*R_m =e= sum(f, Q(a,f,u,t)*B(a,u));
 balance_repair_rate(t,u,a)..                  sum(c, Q(c,a,u,t)*B(c,u))*R_r =e= sum(r, Q(a,r,u,t)*B(a,u));
 balance_disposal_rate(t,u,a)..                sum(c, Q(c,a,u,t)*B(c,u))*R_p =e= sum(p, Q(a,p,u,t)*B(a,u));
 balance_Rc_Rm_Rr_Rp..                         (R_c + R_m + R_r + R_p) =e= 1;
 balance_manufacturers_reverse_flows(t,u,f)..  sum(a, Q(a,f,u,t)*B(a,u)) =e= sum(r, Q(f,r,u,t)*B(f,u)) + sum(k, Q(f,k,u,t)*B(f,u)) + sum(w, sum(k, Q(w,k,u,t)*B(w,u))) + sum(w, sum(r, Q(w,r,u,t)*B(w,u)));
 balance_redistributors(t,u,r)..               sum(a, Q(a,r,u,t)*B(a,u)) + sum(f, Q(f,r,u,t)*B(f,u)) + sum(w, Q(w,r,u,t)*B(w,u)) =e= sum(k, Q(r,k,u,t)*B(r,u));
 balance_second_customers(t,u,k)..             sum(r, Q(r,k,u,t)*B(r,u)) =l= D_(k,u,t);

 capacity_suppliers_output(t,u,s)..            sum(f, Q(s,f,u,t)*B(s,u)) =l= SC(s,u,t)*L(s);
 capacity_manufacturers(t,u,f)..               (sum(d, Q(f,d,u,t)*B(f,u)) + sum(w, Q(f,w,u,t)*B(f,u)) + sum(c, Q(f,c,u,t)*B(f,u)) + sum(k, Q(f,k,u,t)*B(f,u)))*Fh(f,u) =l= FC(f,u,t)*L(f);
 capacity_suppliers(t,u,w)..                   R_(w,u,t) =l= SC(w,u,t)*L(w);
 capacity_distributors(t,u,d)..                sum(f, Q(f,d,u,t)*B(f,u)) + sum(w, Q(w,d,u,t)*B(w,u)) + R_(d,u,t-1) =l= DC(d,u,t)*L(d);
 capacity_disassembly_centers(t,u,a)..         (sum(s, Q(a,s,u,t)*B(a,u)) + sum(f, Q(a,f,u,t)*B(a,u)) + sum(r, Q(a,r,u,t)*B(a,u)) +  sum(p, Q(a,p,u,t)*B(a,u))) =l= AC(a,u,t)*L(a);
 capacity_redistributors(t,u,r)..              sum(k, Q(r,k,u,t)*B(r,u)) =l= RC(r,u,t)*L(r);
 capacity_recycling_suppliers(t,u,s)..         sum(a, Q(a,s,u,t)*B(a,u)) =l= SRC(s,u,t)*L(s);
 capacity_disposal_centers(t,u,p)..            sum(a, Q(a,p,u,t)*B(a,u)) =l= PC(p,u,t)*L(p);
 capacity_warehouses(t,u,w)..                  sum(f, Q(f,w,u,t)*B(f,u)) =l= WC(w,u,t)*L(w);

 link_management_sf(s,f)..                     Li(s,f) =l= sum(u, sum(t, Q(s,f,u,t)));
 link_management_sf2(s,f)..                    sum(u, sum(t, Q(s,f,u,t))) =l= M*Li(s,f);

 link_management_fd(f,d)..                     Li(f,d) =l= sum(u, sum(t, Q(f,d,u,t)));
 link_management_fd2(f,d)..                    sum(u, sum(t, Q(f,d,u,t))) =l= M*Li(f,d);

 link_management_fw(f,w)..                     Li(f,w) =l= sum(u, sum(t, Q(f,w,u,t)));
 link_management_fw2(f,w)..                    sum(u, sum(t, Q(f,w,u,t))) =l= M*Li(f,w);

 link_management_fc(f,c)..                     Li(f,c) =l= sum(u, sum(t, Q(f,c,u,t)));
 link_management_fc2(f,c)..                    sum(u, sum(t, Q(f,c,u,t))) =l= M*Li(f,c);

 link_management_fk(f,k)..                     Li(f,k) =l= sum(u, sum(t, Q(f,k,u,t)));
 link_management_fk2(f,k)..                    sum(u, sum(t, Q(f,k,u,t))) =l= M*Li(f,k);

 link_management_fr(f,r)..                     Li(f,r) =l= sum(u, sum(t, Q(f,r,u,t)));
 link_management_fr2(f,r)..                    sum(u, sum(t, Q(f,r,u,t))) =l= M*Li(f,r);

 link_management_wd(w,d)..                     Li(w,d) =l= sum(u, sum(t, Q(w,d,u,t)));
 link_management_wd2(w,d)..                    sum(u, sum(t, Q(w,d,u,t))) =l= M*Li(w,d);

 link_management_wc(w,c)..                     Li(w,c) =l= sum(u, sum(t, Q(w,c,u,t)));
 link_management_wc2(w,c)..                    sum(u, sum(t, Q(w,c,u,t))) =l= M*Li(w,c);

 link_management_wk(w,k)..                     Li(w,k) =l= sum(u, sum(t, Q(w,k,u,t)));
 link_management_wk2(w,k)..                    sum(u, sum(t, Q(w,k,u,t))) =l= M*Li(w,k);

 link_management_wr(w,r)..                     Li(w,r) =l= sum(u, sum(t, Q(w,r,u,t)));
 link_management_wr2(w,r)..                    sum(u, sum(t, Q(w,r,u,t))) =l= M*Li(w,r);

 link_management_dc(d,c)..                     Li(d,c) =l= sum(u, sum(t, Q(d,c,u,t)));
 link_management_dc2(d,c)..                    sum(u, sum(t, Q(d,c,u,t))) =l= M*Li(d,c);

 link_management_ca(c,a)..                     Li(c,a) =l= sum(u, sum(t, Q(c,a,u,t)));
 link_management_ca2(c,a)..                    sum(u, sum(t, Q(c,a,u,t))) =l= M*Li(c,a);

 link_management_as(a,s)..                     Li(a,s) =l= sum(u, sum(t, Q(a,s,u,t)));
 link_management_as2(a,s)..                    sum(u, sum(t, Q(a,s,u,t))) =l= M*Li(a,s);

 link_management_af(a,f)..                     Li(a,f) =l= sum(u, sum(t, Q(a,f,u,t)));
 link_management_af2(a,f)..                    sum(u, sum(t, Q(a,f,u,t))) =l= M*Li(a,f);

 link_management_ar(a,r)..                     Li(a,r) =l= sum(u, sum(t, Q(a,r,u,t)));
 link_management_ar2(a,r)..                    sum(u, sum(t, Q(a,r,u,t))) =l= M*Li(a,r);

 link_management_ap(a,p)..                     Li(a,p) =l= sum(u, sum(t, Q(a,p,u,t)));
 link_management_ap2(a,p)..                    sum(u, sum(t, Q(a,p,u,t))) =l= M*Li(a,p);

 link_management_rk(r,k)..                     Li(r,k) =l= sum(u, sum(t, Q(r,k,u,t)));
 link_management_rk2(r,k)..                    sum(u, sum(t, Q(r,k,u,t))) =l= M*Li(r,k);

 max_number_allowable_locations_suppliers_s..            sum(s, L(s)) =l= S__;
 max_number_allowable_locations_manufacturers_f..        sum(f, L(f)) =l= F__;
 max_number_allowable_locations_distributors_d..         sum(d, L(d)) =l= D__;
 max_number_allowable_locations_warehouses_w..           sum(w, L(w)) =l= W__;
 max_number_allowable_locations_disassembly_centers_a..  sum(a, L(a)) =l= A__;
 max_number_allowable_locations_redistributors_r..       sum(r, L(r)) =l= R__;
 max_number_allowable_locations_disposal_locations_p..   sum(p, L(p)) =l= P__;

* Objective Function
obj.. UU =e=
*Total sales
*Sales of all products
*First products sale (flows from distributors, manufacturers, and warehouses)
 sum(d, sum(c, sum(u, sum(t, Q(d,c,u,t)*B(d,u)*P_(c,u,t))))) +
 sum(f, sum(c, sum(u, sum(t, Q(f,c,u,t)*B(f,u)*P_(c,u,t))))) +
 sum(w, sum(c, sum(u, sum(t, Q(w,c,u,t)*B(w,u)*P_(c,u,t))))) +
*Second products sale (flows from redistributors, manufacturers, and warehouses)
 sum(r, sum(k, sum(u, sum(t, Q(r,k,u,t)*B(r,u)*P_(k,u,t))))) +
 sum(f, sum(k, sum(u, sum(t, Q(f,k,u,t)*B(f,u)*P_(k,u,t))))) +
 sum(w, sum(k, sum(u, sum(t, Q(w,k,u,t)*B(w,u)*P_(k,u,t))))) +

*Total costs
*Fixed costs (location costs)
 sum(s, F_(s)*L(s)) +
 sum(f, F_(f)*L(f)) +
 sum(d, F_(d)*L(d)) +
 sum(a, F_(a)*L(a)) +
 sum(r, F_(r)*L(r)) +
 sum(p, F_(p)*L(p)) +
 sum(w, F_(w)*L(w)) +
*Material costs
 sum(s, sum(f, sum(u, sum(t, Q(s,f,u,t)*B(s,u)*Mc(s,u,t))))) -
 sum(a, sum(s, sum(u, sum(t, Q(a,s,u,t)*B(a,u)*(Mc(s,u,t)-Rc_(s,u,t)))))) +
*Manufaturing costs
 sum(f, sum(d, sum(u, sum(t, Q(f,d,u,t)*B(f,u)*Fc(f,u,t))))) +
 sum(f, sum(w, sum(u, sum(t, Q(f,w,u,t)*B(f,u)*Fc(f,u,t))))) +
 sum(f, sum(c, sum(u, sum(t, Q(f,c,u,t)*B(f,u)*Fc(f,u,t))))) +
 sum(f, sum(k, sum(u, sum(t, Q(f,k,u,t)*B(f,u)*Fc(f,u,t))))) +
*Non-utilized capacity costs (for manufacturers)
 sum(f, sum(u, sum(t,((FC(f,u,t)/Fh(f,u))*L(f)
 - sum(d, Q(f,d,u,t)*B(f,u))
 - sum(w, Q(f,w,u,t)*B(f,u))
 - sum(c, Q(f,c,u,t)*B(f,u))
 + sum(w, sum(r, Q(w,r,u,t)*B(w,u)))
 + sum(w, sum(k, Q(w,k,u,t)*B(w,u))))*Nc(f,u,t)))) +
*Non-utilized capacity costs - Cont.'d - (for manufacturers)
 sum(f, sum(u, sum(t,((RFC(f,u,t)/RFh(f,u))*L(f)
 - sum(r, Q(f,r,u,t)*B(f,u))
 - sum(k, Q(f,k,u,t)*B(f,u))
 + sum(w, sum(r, Q(w,r,u,t)*B(w,u)))
 + sum(w, sum(k, Q(w,k,u,t)*B(w,u))))*RNc(f,u,t)))) +
* Shortage costs (for distributor)
*  sum(c, sum(u, sum(t, sum(t-1, D_(c,u,t)
*  - sum(t-1, sum(d, Q(d,c,u,t)*B(d,u)))
*  - sum(t-1, sum(f, Q(f,c,u,t)*B(f,u)))
*  - sum(t-1, sum(w, Q(w,c,u,k)*B(w,u))))*Sc_(u,t)))) +
*Purchasing costs (for distributors)
 sum(c, sum(a, sum(u, sum(t, Q(c,a,u,t)*PH(c,u,t)*B(c,u))))) +
*Disassembly costs
 sum(c, sum(a, sum(u, sum(t, Q(c,a,u,t)*B(c,u)*DAc(a,u,t))))) +
*Recycling costs
 sum(a, sum(s, sum(u, sum(t, Q(a,s,u,t)*B(a,u)*Rc_(s,u,t))))) +
*Remanufacturing costs
 sum(a, sum(f, sum(u, sum(t, Q(a,f,u,t)*B(a,u)*RFc(f,u,t))))) +
*Repairing costs
 sum(a, sum(r, sum(u, sum(t, Q(a,r,u,t)*B(a,u)*RPc(a,u,t))))) +
*Disposal costs
 sum(a, sum(p, sum(u, sum(t, Q(a,p,u,t)*B(a,u)*Pc_(p,u,t))))) +
*Transportation costs 1
 sum(t, sum(u, sum(s, sum(f, Q(s,f,u,t)*B(s,u)*Tc(u,t)*DS(s,f))))) +
 sum(t, sum(u, sum(f, sum(d, Q(f,d,u,t)*B(f,u)*Tc(u,t)*DS(f,d))))) +
 sum(t, sum(u, sum(f, sum(w, Q(f,w,u,t)*B(f,u)*Tc(u,t)*DS(f,w))))) +
*Transportation costs 2
 sum(t, sum(u, sum(f, sum(c, Q(f,c,u,t)*B(f,u)*Tc(u,t)*DS(f,c))))) +
 sum(t, sum(u, sum(f, sum(k, Q(f,k,u,t)*B(f,u)*Tc(u,t)*DS(f,k))))) +
 sum(t, sum(u, sum(w, sum(c, Q(w,c,u,t)*B(w,u)*Tc(u,t)*DS(w,c))))) +
*Transportation costs 3
 sum(t, sum(u, sum(w, sum(k, Q(w,k,u,t)*B(w,u)*Tc(u,t)*DS(w,k))))) +
 sum(t, sum(u, sum(d, sum(c, Q(d,c,u,t)*B(d,u)*Tc(u,t)*DS(d,c))))) +
 sum(t, sum(u, sum(a, sum(s, Q(a,s,u,t)*B(a,u)*Tc(u,t)*DS(a,s))))) +
*Transportation costs 4
 sum(t, sum(a, sum(u, sum(f, Q(a,f,u,t)*B(a,u)*Tc(u,t)*DS(a,f))))) +
 sum(t, sum(u, sum(a, sum(p, Q(a,p,u,t)*B(a,u)*Tc(u,t)*DS(a,p))))) +
 sum(t, sum(u, sum(a, sum(r, Q(a,r,u,t)*B(a,u)*Tc(u,t)*DS(a,r))))) +
*Transportation costs 5
 sum(t, sum(u, sum(f, sum(r, Q(f,r,u,t)*B(f,u)*Tc(u,t)*DS(f,r))))) +
 sum(t, sum(u, sum(w, sum(r, Q(w,r,u,t)*B(w,u)*Tc(u,t)*DS(w,r))))) +
 sum(t, sum(u, sum(r, sum(k, Q(r,k,u,t)*B(r,u)*Tc(u,t)*DS(r,k))))) +
*Transportation costs 6
 sum(t, sum(u, sum(c, sum(a, Q(c,a,u,t)*B(c,u)*Tc(u,t)*DS(c,a))))) +
 sum(t, sum(u, sum(w, sum(d, Q(w,d,u,t)*B(w,u)*Tc(u,t)*DS(w,d))))) +
 sum(t, sum(u, sum(a, sum(k, Q(a,k,u,t)*B(a,u)*Tc(u,t)*DS(a,k))))) +
*Inventory holding costs
 sum(w, sum(u, sum(t, R_(w,u,t)*WH(w,u,t)))) +
 sum(d, sum(u, sum(t, R_(d,u,t)*DH(d,u,t))))
;

Models model3 Closed-loop supply chain system / all /

Solve model3 minimizing UU using rmip;

*=== Unload to GDX file (occurs during execution phase)
execute_unload "C:\model_clsc.gdx"


