#!/usr/bin/python
fo=open('dipole.xyz', 'r')
lines= fo.readlines()
dipole = []
for line in lines:
    token = line.split()
    (fx, fy, fz) = (float (x) for x in token[1:])
    dipole.append ((fx,fy,fz))
corr = []
norm = []
N_total= int(len(dipole))

icorr = 2000
for i in range (icorr):
    corr.append(0.0)
    norm.append(0)

for i in range(N_total-icorr):
    denorm = dipole[i][0]*dipole[i][0]+dipole[i][1]*dipole[i][1]+dipole[i][2]*dipole[i][2]

    for j in range(i,i+icorr):
        nume = dipole[i][0]*dipole[j][0]+dipole[i][1]*dipole[j][1]+dipole[i][2]*dipole[j][2]
        corr[j-i] += nume/denorm
        norm[j-i] += 1
for i in range(icorr):
    term = corr[i]/float(norm[i])
# time = 0.5 * 5 *0.001 ps 
    print i*0.0025, term

fo.close()
print "Calculation finished !!"
