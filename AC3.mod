set PLANTS;
set WAREHOUSES;
set CUSTOMERS;

param c_pw {PLANTS, WAREHOUSES} >= 0;
param cap_p {PLANTS} >= 0;
param f_p {PLANTS} >= 0;
param c_wc {WAREHOUSES, CUSTOMERS} >= 0;
param f_w {WAREHOUSES} >= 0;
param demand_c {CUSTOMERS} >= 0;

var x_pw {PLANTS, WAREHOUSES} >= 0;
var y_p {PLANTS} binary;
var y_w {WAREHOUSES} binary;
var x_wc{WAREHOUSES,CUSTOMERS} >=0;

minimize cost: sum {p in PLANTS, w in WAREHOUSES} c_pw[p,w]*x_pw[p,w] + 
	sum {p in PLANTS} f_p[p]*y_p[p] + 
	sum {w in WAREHOUSES} f_w[w]*y_w[w]+
	sum {w in WAREHOUSES, c in CUSTOMERS} c_wc[w,c]*x_wc[w,c];

subject to plant_capacity {p in PLANTS}:
    sum {w in WAREHOUSES} x_pw[p,w] = cap_p[p]*y_p[p];

subject to production_quantity {c in CUSTOMERS}:
   sum {p in PLANTS, w in WAREHOUSES} x_pw[p,w] >= demand_c[c]; ##
    
subject to customer_demand {c in CUSTOMERS}:
    sum { w in WAREHOUSES} x_wc[w,c] >= demand_c[c];


subject to goods_shipped_from_active_warehouses {w in WAREHOUSES, c in CUSTOMERS}:
    x_wc[w,c] <= y_w[w] * demand_c[c];
    
    
    
    # Flow conservation at warehouses
subject to flow_conservation_warehouse {w in WAREHOUSES}:
    sum{p in PLANTS} x_pw[p, w] = sum{c in CUSTOMERS} demand_c[c] * y_w[w];

# Flow conservation at plants
subject to flow_conservation_plant {p in PLANTS}:
    sum{w in WAREHOUSES} x_pw[p, w] = cap_p[p] * y_p[p];
    
    

