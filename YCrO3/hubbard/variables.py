import os
#Molecule parameters
spin,charge=12,0
molname='YCrO'

#U calculation parameters 
job='uscf'
# U is applied to atom number and type indicated in XYZ file in 5th column.

hubbylist=['1D-40'] #linear response U
#hubbylist=['1D-40','0.5','1.0','1.5','2.0','2.5','3.0'] #self-consistent
alphalist=['1D-40','-0.08','-0.07','-0.06','-0.05','-0.04','-0.03','-0.02','-0.01','0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08']

#Cluster-specific parameters
nodes=1
cpu=2
pseudodir='./'
savedir='./wfns/'
if os.path.exists(savedir) != 1: 
 os.system('mkdir %s\n' %(savedir))
scratchdir='/media/datos/transfer/DENSITY_FUNCTIONAL_THEORY/LDA_AMBOS/YCrO3_LDA/hubbard_one_site/scratch/shigueru'
para=''
bindir='/home/ngt/shigueru/quantum_espresso/espresso-4.3.2/bin'
execname='pw.x'
# If running in serial, set para='' and cpu will be ignored.
