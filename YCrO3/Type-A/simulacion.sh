# -----------------------------------
# ARCHIVO QUE CONTROLA TODO EL CICLO
# DE SIMULACION. DESDE SCF HASTA DOS
# Y LOS ARCHIVOS PARA GRAFICAR CON
# XCRYSDEN Y XMGRACE
# -----------------------------------
# VARIABLES DENTRO DEL SCRIPT
hubbar=1.13
magneti_plus=0.8
magneti_minus=-0.8
ecutwfc=40.0
ecutrho=320.0
kpdos=8
kpdosi=7
kp=6
kpi=5
nat=20
degauss=0.01
nbnd=200
# ###################################


# #######################################################################
# SCF
# #######################################################################

cat > YCrO3.scf.in << EOF
&CONTROL
    calculation = "scf"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "YCrO3"
/

&SYSTEM
    degauss                   =  $degauss
    ecutrho                   =  $ecutrho
    ecutwfc                   =  $ecutwfc
    hubbard_u(3)              =  $hubbar
    hubbard_u(4)              =  $hubbar
    ibrav                     = 0
    lda_plus_u                = .TRUE.
    nat                       = $nat
    nspin                     = 2
    ntyp                      = 4
    nbnd                      = $nbnd
    occupations               = "smearing"
    smearing                  = "gaussian"
    starting_magnetization(1) =  0.00000e+00
    starting_magnetization(2) =  0.00000e+00
    starting_magnetization(3) = $magneti_minus
    starting_magnetization(4) = $magneti_plus
/

&ELECTRONS
    conv_thr         =  1.00000e-06
    diagonalization  = "cg"
    electron_maxstep = 200
    mixing_beta      =  4.00000e-01
    mixing_mode      = "plain"
    startingpot      = "atomic"
    startingwfc      = "atomic+random"
/

K_POINTS {automatic}
$kp $kpi $kp 0 0 0

CELL_PARAMETERS (angstrom)
   4.996000218   0.000000000  -0.000000233
   0.000000000   5.336857594   0.000000000
  -0.000000393   0.000000000   7.222627972

ATOMIC_SPECIES
Y      88.90585  y_lda_v1.4.uspp.F.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Cr2    51.99610  cr_lda_v1.5.uspp.F.UPF
Cr1    51.99610  cr_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS (crystal)
Y        0.021141078   0.924808317   0.749999422
Y        0.521141078   0.575190683   0.250000578
Y        0.478857922   0.424809317   0.749999422
Y        0.978858922   0.075190683   0.250000578
Cr2      0.000000000   0.500000000   0.500000000
Cr2      0.500000000  -0.000000000   0.500000000
Cr1      0.500000000  -0.000000000  -0.000000000
Cr1      0.000000000   0.500000000   0.000000000
O        0.685710617   0.305568651   0.447712488
O        0.185710617   0.194431349   0.552287512
O        0.814288964   0.805568369   0.052286494
O        0.314288964   0.694431631   0.947713506
O        0.314289383   0.694431349   0.552287512
O        0.814289383   0.805568651   0.447712488
O        0.185711036   0.194431631   0.947713506
O        0.685711036   0.305568369   0.052286494
O        0.102708988   0.473623002   0.249999727
O        0.602708988   0.026376998   0.750000273
O        0.397291012   0.973622002   0.249999727
O        0.897291012   0.526376998   0.750000273
EOF

# EJECUCION SCF
echo "EJECUTANDO SCF"

pw.x < YCrO3.scf.in > YCrO3.scf.out

# #######################################################################
# POST PROCESAMIENTO PARA RHO
# #######################################################################

# > GENERACION DEL .DAT PARA PLOTEO

cat > YCrO3.rho.in << EOF
&inputpp
prefix="YCrO3"
outdir="./"
filplot="YCrO3.rho.dat"
plot_num=0
/
&plot
/
EOF

# EJECUCION PP.X
echo "PREPARANDO .DAT RHO"

pp.x < YCrO3.rho.in > YCrO3.rho.out

# > PREPARACION DEL RHO PARA XCRYSDEN

cat > YCrO3.plot.rho.in << EOF
&inputpp
/
&plot
nfile=1
filepp(1)="YCrO3.rho.dat"
weight(1)=1.0
iflag=3
output_format=3
nx=50
ny=50
nz=50
fileout="YCrO3.plot.rho.xsf"
/
EOF

# EJECUCION PP.X
echo "PREPARANDO PLOTEO RHO PARA XCRYSDEN"

pp.x < YCrO3.plot.rho.in > YCrO3.plot.rho.out

# #######################################################################
# POST PROCESAMIENTO PARA POTENCIAL
# #######################################################################

# > GENERACION DEL .DAT PARA PLOTEO

cat > YCrO3.poten.in << EOF
&inputpp
prefix="YCrO3"
outdir="./"
filplot="YCrO3.poten.dat"
plot_num=11
/
&plot
/
EOF

# EJECUCION PP.X
echo "PREPARANDO .DAT POTENCIAL"

pp.x < YCrO3.poten.in > YCrO3.poten.out

# > PREPARACION DEL POTENCIAL PARA XCRYSDEN

cat > YCrO3.plot.poten.in << EOF
&inputpp
/
&plot
nfile=1
filepp(1)="YCrO3.poten.dat"
weight(1)=1.0
iflag=3
output_format=3
nx=50
ny=50
nz=50
fileout="YCrO3.plot.poten.xsf"
/
EOF

# EJECUCION PP.X
echo "PREPARANDO PLOTEO POTENCIAL PARA XCRYSDEN"

pp.x < YCrO3.plot.poten.in > YCrO3.plot.poten.out

# #######################################################################
# NSCF
# #######################################################################

cat > YCrO3.nscf.in << EOF
&CONTROL
    calculation = "nscf"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "YCrO3"
/

&SYSTEM
    degauss                   =  $degauss
    ecutrho                   =  $ecutrho
    ecutwfc                   =  $ecutwfc
    hubbard_u(3)              =  $hubbar
    hubbard_u(4)              =  $hubbar
    ibrav                     = 0
    lda_plus_u                = .TRUE.
    nat                       = $nat
    nspin                     = 2
    ntyp                      = 4
    nbnd                      = $nbnd
    occupations               = "tetrahedra"
    smearing                  = "gaussian"
    starting_magnetization(1) =  0.00000e+00
    starting_magnetization(2) =  0.00000e+00
    starting_magnetization(3) = $magneti_minus
    starting_magnetization(4) = $magneti_plus
/

&ELECTRONS
    conv_thr         =  1.00000e-06
    diagonalization  = "cg"
    electron_maxstep = 200
    mixing_beta      =  4.00000e-01
    mixing_mode      = "plain"
    startingpot      = "atomic"
    startingwfc      = "atomic+random"
/

K_POINTS {automatic}
$kpdos $kpdosi $kpdos 0 0 0

CELL_PARAMETERS (angstrom)
   4.996000218   0.000000000  -0.000000233
   0.000000000   5.336857594   0.000000000
  -0.000000393   0.000000000   7.222627972

ATOMIC_SPECIES
Y      88.90585  y_lda_v1.4.uspp.F.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Cr2    51.99610  cr_lda_v1.5.uspp.F.UPF
Cr1    51.99610  cr_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS (crystal)
Y        0.021141078   0.924808317   0.749999422
Y        0.521141078   0.575190683   0.250000578
Y        0.478857922   0.424809317   0.749999422
Y        0.978858922   0.075190683   0.250000578
Cr2      0.000000000   0.500000000   0.500000000
Cr2      0.500000000  -0.000000000   0.500000000
Cr1      0.500000000  -0.000000000  -0.000000000
Cr1      0.000000000   0.500000000   0.000000000
O        0.685710617   0.305568651   0.447712488
O        0.185710617   0.194431349   0.552287512
O        0.814288964   0.805568369   0.052286494
O        0.314288964   0.694431631   0.947713506
O        0.314289383   0.694431349   0.552287512
O        0.814289383   0.805568651   0.447712488
O        0.185711036   0.194431631   0.947713506
O        0.685711036   0.305568369   0.052286494
O        0.102708988   0.473623002   0.249999727
O        0.602708988   0.026376998   0.750000273
O        0.397291012   0.973622002   0.249999727
O        0.897291012   0.526376998   0.750000273
EOF

# EJECUTANDO PW.X NSCF
echo "EJECUTANDO NSCF"

pw.x < YCrO3.nscf.in > YCrO3.nscf.out

# #######################################################################
# EXTRAYENDO PROYECCIONES DE DOS
# #######################################################################

cat > YCrO3.dos.proyeccion.in << EOF
&PROJWFC
prefix="YCrO3"
outdir="./"
ngauss=0
degauss=$degauss
Emin=-40
Emax=32
DeltaE=0.1
filpdos="YCrO3.dos-proyec"
filproj="YCrO3.proyeccion.dos"
/
EOF

# EJECUTANDO PROJWFC
echo "EJECUTANDO PROJWFC"

projwfc.x < YCrO3.dos.proyeccion.in > YCrO3.dos.proyeccion.out

# #######################################################################
# BANDAS
# #######################################################################

cat > YCrO3.bandas.in << EOF
&CONTROL
    calculation = "bands"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "YCrO3"
/

&SYSTEM
    ibrav                     = 8
    a                         =  4.996000218
    b                         =  5.336857594
    c                         =  7.222627972
    degauss                   =  $degauss
    ecutrho                   =  $ecutrho
    ecutwfc                   =  $ecutwfc
    hubbard_u(3)              =  $hubbar
    hubbard_u(4)              =  $hubbar
    lda_plus_u                = .TRUE.
    nat                       = $nat
    nspin                     = 2
    ntyp                      = 4
    nbnd                      = $nbnd
    occupations               = "smearing"
    smearing                  = "gaussian"
    starting_magnetization(1) =  0.00000e+00
    starting_magnetization(2) =  0.00000e+00
    starting_magnetization(3) = $magneti_minus
    starting_magnetization(4) = $magneti_plus
/

&ELECTRONS
    conv_thr         =  1.00000e-06
    diagonalization  = "cg"
    electron_maxstep = 200
    mixing_beta      =  4.00000e-01
    mixing_mode      = "plain"
    startingpot      = "atomic"
    startingwfc      = "atomic+random"
/

K_POINTS {tpiba_b}
5
gG     20
X      20
S      20
Y      20
gG     0

ATOMIC_SPECIES
Y      88.90585  y_lda_v1.4.uspp.F.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Cr2    51.99610  cr_lda_v1.5.uspp.F.UPF
Cr1    51.99610  cr_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS (crystal)
Y        0.021141078   0.924808317   0.749999422
Y        0.521141078   0.575190683   0.250000578
Y        0.478857922   0.424809317   0.749999422
Y        0.978858922   0.075190683   0.250000578
Cr2      0.000000000   0.500000000   0.500000000
Cr2      0.500000000  -0.000000000   0.500000000
Cr1      0.500000000  -0.000000000  -0.000000000
Cr1      0.000000000   0.500000000   0.000000000
O        0.685710617   0.305568651   0.447712488
O        0.185710617   0.194431349   0.552287512
O        0.814288964   0.805568369   0.052286494
O        0.314288964   0.694431631   0.947713506
O        0.314289383   0.694431349   0.552287512
O        0.814289383   0.805568651   0.447712488
O        0.185711036   0.194431631   0.947713506
O        0.685711036   0.305568369   0.052286494
O        0.102708988   0.473623002   0.249999727
O        0.602708988   0.026376998   0.750000273
O        0.397291012   0.973622002   0.249999727
O        0.897291012   0.526376998   0.750000273
EOF

# EJECUCION PW.X BANDAS
echo "EJECUTANDO BANDAS"

pw.x < YCrO3.bandas.in > YCrO3.bandas.out

# #######################################################################
# POST PROCESAMIENTO PARA BANDAS
# #######################################################################

# > BANDAS GENERAL

cat > YCrO3.ext-band-gen.in << EOF
&BANDS
prefix="YCrO3"
outdir="./"
filband="YCrO3.bandas.general"
/
EOF

# EJECUTANDO BANDS.X GENERAL
echo "EXTRAYENDO BANDAS GENERAL"

bands.x < YCrO3.ext-band-gen.in > YCrO3.ext-band-gen.out

# > BANDAS UP

cat > YCrO3.ext-band-up.in << EOF
&BANDS
prefix="YCrO3"
outdir="./"
filband="YCrO3.bandas.up"
spin_component=1
/
EOF

# EJECUTANDO BANDS.X UP
echo "EXTRAYENDO BANDAS UP"

bands.x < YCrO3.ext-band-up.in > YCrO3.ext-band-up.out

# > BANDAS DOWN

cat > YCrO3.ext-band-down.in << EOF
&BANDS
prefix="YCrO3"
outdir="./"
spin_component=2
filband="YCrO3.bandas.down"
/
EOF

# EJECUTANDO BANDS.X DOWN
echo "EXTRAYENDO BANDAS DOWN"

bands.x < YCrO3.ext-band-down.in > YCrO3.ext-band-down.out

echo "####################"
echo "TERMINADO"
echo "####################"