# suma de dos parciales
# version resumida del original
# que viene con quantum espresso
# ---------------------------------

import sys
import os
import fnmatch
import linecache

# variables por defecto
pwout=""
selat="*"
min_x,max_x=-10,3
min_y,max_y="",""
output_file_name="suma_pdos"
prt="no"

# lee las opciones de la linea de comandos
if len(sys.argv)>1:
    for i in sys.argv:
        if i.startswith('-'):
            option=i.split('-')[1]
            if option=="o":
                pwout= sys.argv[sys.argv.index('-o')+1]
            if option=="s":
                selat= sys.argv[sys.argv.index('-s')+1]
            if option=="p":
                prt="yes"
                if len(sys.argv) > sys.argv.index('-p')+1: # if there is a name after "-p" take it as an output name
                    if sys.argv[sys.argv.index('-p')+1] != "-": # otherwise default name sum_dos.out
                        dos_out_name=sys.argv[sys.argv.index('-p')+1]
            if option=="xr":
                min_x,max_x= float(sys.argv[sys.argv.index('-xr')+1]),float(sys.argv[sys.argv.index('-xr')+2])
            if option=="yr":
                min_y,max_y= float(sys.argv[sys.argv.index('-yr')+1]),float(sys.argv[sys.argv.index('-yr')+2])
            if option=="h":
                ayuda = """
-o  ==> out del scf, de donde se obtiene la energia de Fermi.
-s  ==> selecciona los nombres de los archivos conteniendo los DOS parciales.
        Ejm: "*(Y)*(d)" seleciona los itrios orbital d.
        Por defecto seleciona todos los archivos dentro de la carpeta, puede dar error.
-p  ==> Imprime el resultado a un archivo y le da el nombre. (defecto es suma_pdos_up.dat y suma_pdos_down.dat)
-xr ==> Define el minimo y maximo del eje x
-yr ==> Define el minimo y maximo del eje y
-h  ==> Imprime esta ayuda

  Ejemplo1: python suma_pdos.py -s pdos_atm#4\(Fe2\)_wfc#2\(d\) -p nombre_archivo.dat -xr -9 4  [UN SOLO ARCHIVO]
  Ejemplo2: python suma_pdos.py -s "*(Y)*(d)" -p nombre_archivo.dat -xr -9 4  [TODOS LOS ARCHIVOS QUE CUMPLAN EL PATRON]
"""
                print(ayuda)
                sys.exit()
    
# Obtiene la energia de fermi desde el out del scf
if pwout!="":
    try:
        os.popen("grep -a 'the Fermi energy is' "+pwout ).read()
        fermi=float(os.popen("grep -a 'the Fermi energy is' "+pwout ).read().split()[4])
        print("Fermi energy = ", fermi, "a.u.")
    except:
        print("PELIGRO!! : No se encontro energia de fermi. Se usa 0 eV como reemplazo")
        fermi=0
else:
    print("PELIGRO!! : No se encontro out de scf. Se usa 0 eV como reemplazo")
    fermi=0

# Encuentra todos los archivos DOS, pasados con la opcion s para agregarlos 
dosfiles=[]
for dfile in os.listdir('.'):
   if fnmatch.fnmatch(dfile, selat):
     dosfiles.append(dfile) 
if len(dosfiles)==0:
 print("ERROR!! : no se hallaron los archivos")
 sys.exit()

# Imprime la lista de archivos DOS hallados y que se usaran
for dosfile in dosfiles:
    print(dosfile,"\n")
print("")

# Suma sobre todos los archivos
mat=[]  # matriz con la suma total de los ldos
for i in range(len(dosfiles)):
    mati=[] # matriz temporal para cada archivo de DOS "i"
    for line in open(dosfiles[i],'r'):
        if len(line) > 10 and line.split()[0] != "#":
            mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2])])
    if mat == []: # Como es el primer archivo DOS, copia todos los datos de mati a mat
        mat=mati[:]
    else:
        for j in range(len(mati)): # A partir del segundo archivo DOS va sumando los valores
            mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2]]

# obtener directorio actual
actu = os.getcwd()
sali = actu+"/graficas/"

if prt=="yes":
    out_up = open(sali+dos_out_name+"_up.dat","w")
    out_down = open(sali+dos_out_name+"_down.dat","w")
if prt=="no":
    out_up = open(sali+output_file_name+"_up.dat","w")
    out_down = open(sali+output_file_name+"_down.dat","w")
x,y1,y2=[],[],[]
for i in mat:
    x.append(i[0]-fermi)
    y1.append(i[1])
    y2.append(-i[2])
    out_up.write(str(i[0]-fermi))
    out_down.write(str(i[0]-fermi))
    out_up.write(" ")
    out_down.write(" ")
    out_up.write(str(i[1]))
    out_down.write(str(-i[2]))
    out_up.write("\n")
    out_down.write("\n")
out_down.close()
out_up.close()
