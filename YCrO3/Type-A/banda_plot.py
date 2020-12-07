import numpy as np
import matplotlib.pyplot as plt
import sys

# --- parametros de entrada --- #

fermi = 15.8027 # energia de fermi
band_out = "YCrO3.ext-band-gen.out" # archivo .out del programa bands.x que estrae las bandas
band_dat = "YCrO3.bandas.general.gnu" # archivo procesado de las bandas (archivo.gnu)
y_ran_sup = 5 # limite superior del eje Y
y_ran_inf = -5 # limite inferior del eje Y
color_banda = "black" # color de las lineas de las bandas
color_kpt = "black" # color de las rayas punteadas que marcan cada k point
color_fermi = "red" # color de la linea que define el nivel de fermi
titulo = "" # titulo de la grafica
y_etiqueta = "Energía (eV)" # etiqueta del eje Y

# -------------------------------- #

# --- funcion de lectura de simetria --- #
# Extrae los puntos de alta simetria (k-points)
# especificados en la ruta de k-points

def simetria(archivo):
    f = open(archivo,"r")
    x = np.zeros(0)
    for i in f:
        if("high-symmetry" in i):
            x = np.append(x,float(i.split()[-1]))
    f.close()
    return x

# ---------------------------------------- #

# --- parte principal del programa --- #

z = np.loadtxt(band_dat) # carga el .dat de las bandas
x = np.unique(z[:,0]) # extrae todos los puntos unicos del eje x
bands = []
bndl = len(z[z[:,0]==x[1]])
Fermi = float(fermi)
axis = [min(x),max(x),y_ran_inf,y_ran_sup]
for i in range(0,bndl):
    bands.append(np.zeros([len(x),2])) # x filas por 2 columnas por cada banda
for i in range(0,len(x)):
    sel = z[z[:,0] == x[i]] # almacena los valores de energia para un x dado
    for j in range(0,bndl):
        bands[j][i][0] = x[i]
        #bands[j][i][1] = np.multiply(sel[j][1],13.605698066) # asigna a cada banda su x y su energia
        bands[j][i][1] = np.subtract(sel[j][1],Fermi) # asigna a cada banda su x y su energia
fig, ax = plt.subplots()
for i in bands:
    ax.plot(i[:,0],i[:,1],color=color_banda)
tempo = simetria(band_out)
for j in tempo:
    x1 = [j,j]
    x2 = [axis[2],axis[3]]
    ax.plot(x1,x2,"--",color=color_kpt)
ax.plot([axis[0],axis[1]],[0,0],color=color_fermi)
ax.set_xlim(axis[0],axis[1])
ax.set_ylim(axis[2],axis[3])
ax.set_xticklabels([])
ax.set_title(titulo)
ax.set_ylabel(y_etiqueta)
plt.show()
