import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


"""
Adapted version of Simon Woodruff's shaping code made under contract to Tokamak Fusion
@Author: Dom Longhorn

Feb 2023

TODO: Set up the initial conditions as an object potentially? May make it easier to read and understand than at present
Or look into using dictionaries for some of these keywords because this frankly looks a little bit silly - so maybe a config file which contains all
the relevant parameters and then the code can read from that file and set up the initial conditions from that.
"""

R_0 = 4.5 #Major radius of tokamak
A = 4.75 #Aspect ratio of tokamak
a = R_0/A #Minor radius of tokamak
# a = R_0/1.3
delta = 4.0  #Triangularity of tokamak
si = 0.4 #Upper squareness
sj = 0.6 #Lower squareness
kappa = 1.8 #Elongation of plasma
po = 64



#############Base Functions##############
def R_calculation(i, R_0=R_0, a=a, delta=delta, si=si, kappa=kappa, po=po):
    return R_0 + a *np.cos(np.pi + (i*np.pi/po) + (a*np.sin(delta))* np.sin(np.pi + (i*np.pi/po))) #R coordinate for plasma shape
def Z_calculation(i,squaredness, R_0=R_0, a=a, delta=delta, kappa=kappa, po=po):
    return a*kappa* np.sin(np.pi + (i*np.pi/po) + squaredness * np.sin(np.pi+(2*i*np.pi/po))) #Z coordinate for plasma shape

def getR_and_Z(R, Z, rounding=5, R_0=R_0, a=a, delta=delta, si=si, sj=sj, kappa=kappa, po=po):
    for i in range(1,(2*po)):
        R_val_to_append = R_calculation(i, R_0=R_0, a=a, delta=delta, kappa=kappa, po=po)
        if i <= po:
            Z_val_to_append = Z_calculation(i,R_0=R_0, a=a, delta=delta, squaredness=si, kappa=kappa, po=po)
        else:
            Z_val_to_append = Z_calculation(i,R_0=R_0, a=a, delta=delta, squaredness=sj, kappa=kappa, po=po)
        R.append(np.round(R_val_to_append, rounding))
        Z.append(np.round(Z_val_to_append, rounding))

def savefile(filename, R, Z):
    df = pd.DataFrame({'R': R, 'Z': Z})
    df.to_csv(filename +'.csv', index=False)
############################################

#Defines the plasma shape#########
R_shape=[] #R coordinates for plasma shape
Z_shape=[] #Z coordinates for plasma shape
getR_and_Z(R_shape,Z_shape)
savefile('shape', R_shape, Z_shape)

R_firstwall = []
Z_firstwall = []
getR_and_Z(R_firstwall, Z_firstwall, a=a+0.3, po=54,rounding=5)
savefile('firstwall', R_firstwall, Z_firstwall)

R_passive = []
Z_passive = []
getR_and_Z(R_passive, Z_passive, a=a+0.2, po=54,rounding=5)
savefile('passive', R_passive, Z_passive)

R_max = max(R_firstwall) + 0.15
Z_max = max(Z_firstwall) + 0.15
plt.figure()
plt.plot(R_firstwall, Z_firstwall, color='green', marker='x')
plt.plot(R_shape, Z_shape, color='blue', marker='x')
plt.plot(R_passive, Z_passive, color='red', marker='.')
plt.xlim(0, R_max)
plt.ylim(-Z_max, Z_max)
plt.show()
