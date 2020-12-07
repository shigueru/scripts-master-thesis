# -----------------------------------
# ARCHIVO QUE CONTROLA TODO EL CICLO
# DE SIMULACION. DESDE SCF HASTA DOS
# Y LOS ARCHIVOS PARA GRAFICAR CON
# XCRYSDEN Y XMGRACE
# -----------------------------------
# VARIABLES DENTRO DEL SCRIPT
hubbar=2.43
magneti_plus=0.8
magneti_minus=-0.8
ecutwfc=40.0
ecutrho=320.0
kp=6
kpdos=8
nat=30
nbnd=294
degauss=0.01
# energia minima y maxima para la proyeccion del DOS
emin=-20
emax=30
# ###################################


# #######################################################################
# SCF
# #######################################################################

cat > BiFeO3.scf.in << EOF
&CONTROL
    calculation = "scf"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "BiFeO3"
/

&SYSTEM
    ibrav                     = 0
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
    starting_magnetization(3) =  $magneti_plus
    starting_magnetization(4) =  $magneti_minus
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
 $kp $kp $kp  0 0 0

CELL_PARAMETERS {angstrom}
   5.638203705   0.000000000  -0.000000000
  -2.819101852   4.882827516  -0.000000000
   0.000000000   0.000000000  14.073829277

ATOMIC_SPECIES
Bi    208.98038  Bi.pz-dn-rrkjus_psl.1.0.0.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Fe1    55.84500  fe_lda_v1.5.uspp.F.UPF
Fe2    55.84500  fe_lda_v1.5.uspp.F.UPF


ATOMIC_POSITIONS {crystal}
Fe1     -0.000000000  -0.000000000   0.278165798
Fe1      0.666667000   0.333333000   0.110051548
Fe2      0.666667000   0.333333000   0.610050048
Fe1      0.333333000   0.666667000   0.448416928
Fe2      0.333333000   0.666667000   0.948401300
Fe2      0.000000000   0.000000000   0.778150786
Bi       0.333333000   0.666667000   0.169099729
Bi      -0.000000000  -0.000000000  -0.000681380
Bi      -0.000000000  -0.000000000   0.499339502
Bi       0.666667000   0.333333000   0.334271438
Bi       0.666667000   0.333333000   0.834266230
Bi       0.333333000   0.666667000   0.669107004
O        0.742929382   0.093544824   0.216445224
O        0.906455175   0.649384558   0.216445224
O        0.350615442   0.257070618   0.216445224
O        0.566863458   0.584022058   0.049056034
O        0.017158599   0.433136542   0.049056034
O        0.415977942   0.982841401   0.049056034
O        0.415964768   0.433136408   0.549070153
O        0.566863593   0.982828360   0.549070153
O        0.017171640   0.584035232   0.549070153
O        0.238112524   0.922618325   0.383729913
O        0.684505800   0.761887476   0.383729913
O        0.077381676   0.315494200   0.383729913
O        0.077395226   0.761889902   0.883709234
O        0.238110098   0.315505324   0.883709234
O        0.684494676   0.922604774   0.883709234
O        0.906449917   0.257068138   0.716439799
O        0.350618221   0.093550083   0.716439799
O        0.742931862   0.649381778   0.716439799
EOF

# EJECUCION SCF
echo "EJECUTANDO SCF"

pw.x < BiFeO3.scf.in > BiFeO3.scf.out

# #######################################################################
# POST PROCESAMIENTO PARA RHO
# #######################################################################

# > GENERACION DEL .DAT PARA PLOTEO

cat > BiFeO3.rho.in << EOF
&inputpp
prefix="BiFeO3"
outdir="./"
filplot="BiFeO3.rho.dat"
plot_num=0
/
&plot
/
EOF

# EJECUCION PP.X
echo "PREPARANDO .DAT RHO"

pp.x < BiFeO3.rho.in > BiFeO3.rho.out

# > PREPARACION DEL RHO PARA XCRYSDEN

cat > BiFeO3.plot.rho.in << EOF
&inputpp
/
&plot
nfile=1
filepp(1)="BiFeO3.rho.dat"
weight(1)=1.0
iflag=3
output_format=3
nx=50
ny=50
nz=50
fileout="BiFeO3.plot.rho.xsf"
/
EOF

# EJECUCION PP.X
echo "PREPARANDO PLOTEO RHO PARA XCRYSDEN"

pp.x < BiFeO3.plot.rho.in > BiFeO3.plot.rho.out

# #######################################################################
# POST PROCESAMIENTO PARA POTENCIAL
# #######################################################################

# > GENERACION DEL .DAT PARA PLOTEO

cat > BiFeO3.poten.in << EOF
&inputpp
prefix="BiFeO3"
outdir="./"
filplot="BiFeO3.poten.dat"
plot_num=11
/
&plot
/
EOF

# EJECUCION PP.X
echo "PREPARANDO .DAT POTENCIAL"

pp.x < BiFeO3.poten.in > BiFeO3.poten.out

# > PREPARACION DEL POTENCIAL PARA XCRYSDEN

cat > BiFeO3.plot.poten.in << EOF
&inputpp
/
&plot
nfile=1
filepp(1)="BiFeO3.poten.dat"
weight(1)=1.0
iflag=3
output_format=3
nx=50
ny=50
nz=50
fileout="BiFeO3.plot.poten.xsf"
/
EOF

# EJECUCION PP.X
echo "PREPARANDO PLOTEO POTENCIAL PARA XCRYSDEN"

pp.x < BiFeO3.plot.poten.in > BiFeO3.plot.poten.out

# #######################################################################
# NSCF
# #######################################################################

cat > BiFeO3.nscf.in << EOF
&CONTROL
    calculation = "nscf"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "BiFeO3"
/

&SYSTEM
    ibrav                     = 0
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
    occupations               = "tetrahedra"
    smearing                  = "gaussian" 
    starting_magnetization(1) =  0.00000e+00
    starting_magnetization(2) =  0.00000e+00
    starting_magnetization(3) =  $magneti_plus
    starting_magnetization(4) =  $magneti_minus
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
 $kpdos $kpdos $kpdos  0 0 0

CELL_PARAMETERS {angstrom}
   5.638203705   0.000000000  -0.000000000
  -2.819101852   4.882827516  -0.000000000
   0.000000000   0.000000000  14.073829277

ATOMIC_SPECIES
Bi    208.98038  Bi.pz-dn-rrkjus_psl.1.0.0.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Fe1    55.84500  fe_lda_v1.5.uspp.F.UPF
Fe2    55.84500  fe_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS {crystal}
Fe1     -0.000000000  -0.000000000   0.278165798
Fe1      0.666667000   0.333333000   0.110051548
Fe2      0.666667000   0.333333000   0.610050048
Fe1      0.333333000   0.666667000   0.448416928
Fe2      0.333333000   0.666667000   0.948401300
Fe2      0.000000000   0.000000000   0.778150786
Bi       0.333333000   0.666667000   0.169099729
Bi      -0.000000000  -0.000000000  -0.000681380
Bi      -0.000000000  -0.000000000   0.499339502
Bi       0.666667000   0.333333000   0.334271438
Bi       0.666667000   0.333333000   0.834266230
Bi       0.333333000   0.666667000   0.669107004
O        0.742929382   0.093544824   0.216445224
O        0.906455175   0.649384558   0.216445224
O        0.350615442   0.257070618   0.216445224
O        0.566863458   0.584022058   0.049056034
O        0.017158599   0.433136542   0.049056034
O        0.415977942   0.982841401   0.049056034
O        0.415964768   0.433136408   0.549070153
O        0.566863593   0.982828360   0.549070153
O        0.017171640   0.584035232   0.549070153
O        0.238112524   0.922618325   0.383729913
O        0.684505800   0.761887476   0.383729913
O        0.077381676   0.315494200   0.383729913
O        0.077395226   0.761889902   0.883709234
O        0.238110098   0.315505324   0.883709234
O        0.684494676   0.922604774   0.883709234
O        0.906449917   0.257068138   0.716439799
O        0.350618221   0.093550083   0.716439799
O        0.742931862   0.649381778   0.716439799
EOF

# EJECUTANDO PW.X NSCF
echo "EJECUTANDO NSCF"

pw.x < BiFeO3.nscf.in > BiFeO3.nscf.out

# #######################################################################
# EXTRAYENDO PROYECCIONES DE DOS
# #######################################################################

cat > BiFeO3.dos.proyeccion.in << EOF
&PROJWFC
prefix="BiFeO3"
outdir="./"
ngauss=0
degauss=$degauss
Emin=$emin
Emax=$emax
DeltaE=0.1
filpdos="BiFeO3.dos-proyec"
filproj="BiFeO3.proyeccion.dos"
/
EOF

# EJECUTANDO PROJWFC
echo "EJECUTANDO PROJWFC"

projwfc.x < BiFeO3.dos.proyeccion.in > BiFeO3.dos.proyeccion.out

# #######################################################################
# BANDAS
# #######################################################################

cat > BiFeO3.bandas.in << EOF
&CONTROL
    calculation = "bands"
    max_seconds =  8.64000e+04
    pseudo_dir  = "/home/ngt/.burai/.pseudopot"
    verbosity = "high"
    restart_mode= "from_scratch"
    outdir = "./"
    prefix = "BiFeO3"
/

&SYSTEM
    ibrav                     = 4
    a                         = 5.638203705
    c                         = 14.073829277
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
    starting_magnetization(3) =  $magneti_plus
    starting_magnetization(4) =  $magneti_minus
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
4
gG     20
M      20
K      20
gG     0

ATOMIC_SPECIES
Bi    208.98038  Bi.pz-dn-rrkjus_psl.1.0.0.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Fe1    55.84500  fe_lda_v1.5.uspp.F.UPF
Fe2    55.84500  fe_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS {crystal}
Fe1     -0.000000000  -0.000000000   0.278165798
Fe1      0.666667000   0.333333000   0.110051548
Fe2      0.666667000   0.333333000   0.610050048
Fe1      0.333333000   0.666667000   0.448416928
Fe2      0.333333000   0.666667000   0.948401300
Fe2      0.000000000   0.000000000   0.778150786
Bi       0.333333000   0.666667000   0.169099729
Bi      -0.000000000  -0.000000000  -0.000681380
Bi      -0.000000000  -0.000000000   0.499339502
Bi       0.666667000   0.333333000   0.334271438
Bi       0.666667000   0.333333000   0.834266230
Bi       0.333333000   0.666667000   0.669107004
O        0.742929382   0.093544824   0.216445224
O        0.906455175   0.649384558   0.216445224
O        0.350615442   0.257070618   0.216445224
O        0.566863458   0.584022058   0.049056034
O        0.017158599   0.433136542   0.049056034
O        0.415977942   0.982841401   0.049056034
O        0.415964768   0.433136408   0.549070153
O        0.566863593   0.982828360   0.549070153
O        0.017171640   0.584035232   0.549070153
O        0.238112524   0.922618325   0.383729913
O        0.684505800   0.761887476   0.383729913
O        0.077381676   0.315494200   0.383729913
O        0.077395226   0.761889902   0.883709234
O        0.238110098   0.315505324   0.883709234
O        0.684494676   0.922604774   0.883709234
O        0.906449917   0.257068138   0.716439799
O        0.350618221   0.093550083   0.716439799
O        0.742931862   0.649381778   0.716439799
EOF

# EJECUCION PW.X BANDAS
echo "EJECUTANDO BANDAS"

pw.x < BiFeO3.bandas.in > BiFeO3.bandas.out

# #######################################################################
# POST PROCESAMIENTO PARA BANDAS
# #######################################################################

# > BANDAS GENERAL

cat > BiFeO3.ext-band-gen.in << EOF
&BANDS
prefix="BiFeO3"
outdir="./"
filband="BiFeO3.bandas.general"
/
EOF

# EJECUTANDO BANDS.X GENERAL
echo "EXTRAYENDO BANDAS GENERAL"

bands.x < BiFeO3.ext-band-gen.in > BiFeO3.ext-band-gen.out

# > BANDAS UP

cat > BiFeO3.ext-band-up.in << EOF
&BANDS
prefix="BiFeO3"
outdir="./"
filband="BiFeO3.bandas.up"
spin_component=1
/
EOF

# EJECUTANDO BANDS.X UP
echo "EXTRAYENDO BANDAS UP"

bands.x < BiFeO3.ext-band-up.in > BiFeO3.ext-band-up.out

# > BANDAS DOWN

cat > BiFeO3.ext-band-down.in << EOF
&BANDS
prefix="BiFeO3"
outdir="./"
spin_component=2
filband="BiFeO3.bandas.down"
/
EOF

# EJECUTANDO BANDS.X DOWN
echo "EXTRAYENDO BANDAS DOWN"

bands.x < BiFeO3.ext-band-down.in > BiFeO3.ext-band-down.out

echo "####################"
echo "TERMINADO"
echo "####################"