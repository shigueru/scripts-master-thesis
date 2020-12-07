# TEST DE CONVERGENCIA DE KPOINTS SIN SHIF

# RANGO DE VARIACION

rango="2 3 4 5 6 7 8 9 10 11 12" 

# VARIABLES YA OPTIMAS

ecutwfc=40.0
ecutrho=320.0

for kp in $rango
do
	echo "EJECUTANDO PARA : $kp"
        kpc=$(echo "$kp - 1" | bc)
	rm -rf *.out *.save *.pot *.wfc *.igk *.in *.xml
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
    degauss                   =  1.00000e-02
    ecutrho                   =  $ecutrho
    ecutwfc                   =  $ecutwfc
    hubbard_u(3)              =  1.130184
    hubbard_u(4)              =  1.130184
    ibrav                     = 0
    lda_plus_u                = .TRUE.
    nat                       = 20
    ntyp                      = 3
    occupations               = "smearing"
    smearing                  = "gaussian"
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
$kp $kpc $kp 0 0 0

CELL_PARAMETERS (angstrom)
   4.996000218   0.000000000  -0.000000233
   0.000000000   5.336857594   0.000000000
  -0.000000393   0.000000000   7.222627972

ATOMIC_SPECIES
Y      88.90585  y_lda_v1.4.uspp.F.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF
Cr    51.99610  cr_lda_v1.5.uspp.F.UPF

ATOMIC_POSITIONS (crystal)
Y        0.020236872   0.926655434   0.750000060
Y        0.520236872   0.573343566   0.250000060
Y        0.479762128   0.426656434   0.749999940
Y        0.979763128   0.073343566   0.249999940
Cr     -0.000000000   0.500000000   0.500000000
Cr      0.500000000   0.000000000   0.500000000
Cr      0.500000000   0.000000000  -0.000000000
Cr      0.000000000   0.500000000   0.000000000
O        0.688186536   0.303519361   0.448766518
O        0.188186682   0.196480479   0.551233470
O        0.811813464   0.803519361   0.051233482
O        0.311813318   0.696480479   0.948766530
O        0.311813464   0.696480639   0.551233482
O        0.811813318   0.803519521   0.448766530
O        0.188186536   0.196480639   0.948766518
O        0.688186682   0.303519521   0.051233470
O        0.103419514   0.472184554   0.250000004
O        0.603419514   0.027815446   0.750000004
O        0.396580486   0.972183554   0.249999996
O        0.896580486   0.527815446   0.749999996
EOF
	pw.x < YCrO3.scf.in > YCrO3.scf.out
	linea=$(grep "!" YCrO3.scf.out)
	palabra=$(echo $linea | tr " " "\n")
	patron='^-?[0-9]+([.][0-9]+)?$'
	for pal in $palabra
	do
		if ! [[ $pal =~ $patron ]] ; then
			echo " "
		else
			if [ -e energias.kp.dat ] ; then
				cat >> energias.kp.dat << EOF
$kp $pal
EOF
			else
				cat > energias.kp.dat << EOF
$kp $pal
EOF
			fi
		fi
	done
done


