#!/opt/python64/2.7.3/bin/python
#http://stackoverflow.com/questions/19165259/python-numpy-scipy-curve-fitting

import math

import numpy as np
from scipy.optimize import curve_fit

f = open( "fit_OOMdimer.out", "r" )
array1 = []
for line in f:
    array1.append(float(line))

x = np.array([-0.005, -0.004, -0.003, -0.002, -0.001, 0.000, 0.001, 0.002, 0.003, 0.004, 0.005])
y = np.array([math.acos(array1[0])*180/3.14159,math.acos(array1[1])*180/3.14159, math.acos(array1[2])*180/3.14159, math.acos(array1[3])*180/3.14159, math.acos(array1[4])*180/3.14159, math.acos(array1[5])*180/3.14159, math.acos(array1[6])*180/3.14159, math.acos(array1[7])*180/3.14159, math.acos(array1[8])*180/3.14159, math.acos(array1[9])*180/3.14159, math.acos(array1[10])*180/3.14159])

def fit_func(x, a, b):
    return a*x + b

params = curve_fit(fit_func, x, y)

print  params[0]
