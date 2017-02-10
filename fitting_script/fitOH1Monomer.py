#!/opt/python64/2.7.3/bin/python
#http://stackoverflow.com/questions/19165259/python-numpy-scipy-curve-fitting

import numpy as np
from scipy.optimize import curve_fit

f = open( "fit_OH1Monomer.out", "r" )
array1 = []
for line in f:
    array1.append(float(line))

x = np.array([-0.005, -0.004, -0.003, -0.002, -0.001, 0.000, 0.001, 0.002, 0.003, 0.004, 0.005])
y = np.array([array1[0], array1[1], array1[2], array1[3], array1[4], array1[5], array1[6], array1[7], array1[8], array1[9], array1[10]])

def fit_func(x, a, b):
    return a*x + b

params = curve_fit(fit_func, x, y)

print  params[0]
