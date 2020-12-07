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
Fe1      0.000000000   0.000000000   0.279861477
Fe2      0.666667000   0.333333000   0.113196651
Fe1      0.666667000   0.333333000   0.613197539
Fe2      0.333333000   0.666667000   0.446525120
Fe1      0.333333000   0.666667000   0.946523646
Fe2     -0.000000000  -0.000000000   0.779866724
Bi       0.333333000   0.666667000   0.168271646
Bi       0.000000000   0.000000000   0.001608817
Bi       0.000000000   0.000000000   0.501610891
Bi       0.666667000   0.333333000   0.334939250
Bi       0.666667000   0.333333000   0.834941635
Bi       0.333333000   0.666667000   0.668272524
O        0.747765580   0.098533665   0.215842576
O        0.901466335   0.649231915   0.215842576
O        0.350768085   0.252234420   0.215842576
O        0.568133319   0.585566925   0.049178329
O        0.017433606   0.431866681   0.049178329
O        0.414433075   0.982566394   0.049178329
O        0.414432068   0.431866805   0.549175647
O        0.568133195   0.982565263   0.549175647
O        0.017434737   0.585567932   0.549175647
O        0.234799873   0.918900121   0.382507437
O        0.684100248   0.765200127   0.382507437
O        0.081099879   0.315899752   0.382507437
O        0.081096214   0.765202312   0.882510208
O        0.234797688   0.315893901   0.882510208
O        0.684106099   0.918903786   0.882510208
O        0.901468392   0.252235409   0.715843829
O        0.350767017   0.098531608   0.715843829
O        0.747764591   0.649232983   0.715843829
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
Fe1      0.000000000   0.000000000   0.279861477
Fe2      0.666667000   0.333333000   0.113196651
Fe1      0.666667000   0.333333000   0.613197539
Fe2      0.333333000   0.666667000   0.446525120
Fe1      0.333333000   0.666667000   0.946523646
Fe2     -0.000000000  -0.000000000   0.779866724
Bi       0.333333000   0.666667000   0.168271646
Bi       0.000000000   0.000000000   0.001608817
Bi       0.000000000   0.000000000   0.501610891
Bi       0.666667000   0.333333000   0.334939250
Bi       0.666667000   0.333333000   0.834941635
Bi       0.333333000   0.666667000   0.668272524
O        0.747765580   0.098533665   0.215842576
O        0.901466335   0.649231915   0.215842576
O        0.350768085   0.252234420   0.215842576
O        0.568133319   0.585566925   0.049178329
O        0.017433606   0.431866681   0.049178329
O        0.414433075   0.982566394   0.049178329
O        0.414432068   0.431866805   0.549175647
O        0.568133195   0.982565263   0.549175647
O        0.017434737   0.585567932   0.549175647
O        0.234799873   0.918900121   0.382507437
O        0.684100248   0.765200127   0.382507437
O        0.081099879   0.315899752   0.382507437
O        0.081096214   0.765202312   0.882510208
O        0.234797688   0.315893901   0.882510208
O        0.684106099   0.918903786   0.882510208
O        0.901468392   0.252235409   0.715843829
O        0.350767017   0.098531608   0.715843829
O        0.747764591   0.649232983   0.715843829
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
Fe1      0.000000000   0.000000000   0.279861477
Fe2      0.666667000   0.333333000   0.113196651
Fe1      0.666667000   0.333333000   0.613197539
Fe2      0.333333000   0.666667000   0.446525120
Fe1      0.333333000   0.666667000   0.946523646
Fe2     -0.000000000  -0.000000000   0.779866724
Bi       0.333333000   0.666667000   0.168271646
Bi       0.000000000   0.000000000   0.001608817
Bi       0.000000000   0.000000000   0.501610891
Bi       0.666667000   0.333333000   0.334939250
Bi       0.666667000   0.333333000   0.834941635
Bi       0.333333000   0.666667000   0.668272524
O        0.747765580   0.098533665   0.215842576
O        0.901466335   0.649231915   0.215842576
O        0.350768085   0.252234420   0.215842576
O        0.568133319   0.585566925   0.049178329
O        0.017433606   0.431866681   0.049178329
O        0.414433075   0.982566394   0.049178329
O        0.414432068   0.431866805   0.549175647
O        0.568133195   0.982565263   0.549175647
O        0.017434737   0.585567932   0.549175647
O        0.234799873   0.918900121   0.382507437
O        0.684100248   0.765200127   0.382507437
O        0.081099879   0.315899752   0.382507437
O        0.081096214   0.765202312   0.882510208
O        0.234797688   0.315893901   0.882510208
O        0.684106099   0.918903786   0.882510208
O        0.901468392   0.252235409   0.715843829
O        0.350767017   0.098531608   0.715843829
O        0.747764591   0.649232983   0.715843829
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