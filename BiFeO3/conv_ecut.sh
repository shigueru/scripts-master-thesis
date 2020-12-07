# TEST DE CONVERGENCIA DEL ECUTWFC

# RANGO DE VARIACION

rango="20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 80.0 85.0 90.0 95.0 100.0" 

for ecutwfc in $rango
do
	echo "EJECUTANDO PARA : $ecutwfc"	
	ecutrho=$(echo "$ecutwfc * 8.0" | bc)
	rm -rf *.out *.save *.pot *.wfc *.igk *.in *.xml
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
    a                         =  5.63712e+00
    c                         =  1.41170e+01
    degauss                   =  1.00000e-02
    ecutrho                   =  $ecutrho
    ecutwfc                   =  $ecutwfc
    ibrav                     = 4
    nat                       = 30
    nspin                     = 2
    ntyp                      = 3
    occupations               = "smearing"
    smearing                  = "gaussian"
    starting_magnetization(1) =  2.00000e-01
    starting_magnetization(2) =  0.00000e+00
    starting_magnetization(3) =  0.00000e+00
/

&ELECTRONS
    conv_thr         =  1.00000e-06
    electron_maxstep = 200
    mixing_beta      =  4.00000e-01
    startingpot      = "atomic"
    startingwfc      = "atomic+random"
/

K_POINTS {automatic}
 2  2  2  0 0 0

ATOMIC_SPECIES
Fe     55.84500  fe_lda_v1.5.uspp.F.UPF
Bi    208.98038  Bi.pz-dn-rrkjus_psl.1.0.0.UPF
O      15.99940  o_lda_v1.2.uspp.F.UPF

ATOMIC_POSITIONS {angstrom}
Fe      0.000000   0.000000   3.963217
Fe      2.818563   1.627295   1.610381
Fe      2.818563   1.627295   8.668874
Fe     -0.000003   3.254595   6.316053
Fe     -0.000003   3.254595  13.374546
Fe      0.000000   0.000000  11.021710
Bi     -0.000003   3.254595   2.381818
Bi      0.000000   0.000000   0.028996
Bi      0.000000   0.000000   7.087489
Bi      2.818563   1.627295   4.734654
Bi      2.818563   1.627295  11.793147
Bi     -0.000003   3.254595   9.440311
O       3.937889   0.486226   3.040827
O       3.247091   3.167199   3.040827
O       1.270700   1.228464   3.040827
O       1.547857   2.855759   0.687991
O      -1.119329   2.113526   0.687991
O      -0.428528   4.794494   0.687991
O       1.119329   2.113526   7.746485
O       0.428528   4.794494   7.746485
O      -1.547857   2.855759   7.746485
O      -1.270700   4.483054   5.393663
O       1.699228   3.740821   5.393663
O      -0.428528   1.539904   5.393663
O      -1.699228   3.740821  12.452156
O       0.428528   1.539904  12.452156
O       1.270700   4.483054  12.452156
O       4.366421   1.228464  10.099320
O       1.699231   0.486226  10.099320
O       2.390029   3.167199  10.099320
EOF
	pw.x < BiFeO3.scf.in > BiFeO3.scf.out
	linea=$(grep "!" BiFeO3.scf.out)
	palabra=$(echo $linea | tr " " "\n")
	patron='^-?[0-9]+([.][0-9]+)?$'
	for pal in $palabra
	do
		if ! [[ $pal =~ $patron ]] ; then
			echo " "
		else
			if [ -e energias.dat ] ; then
				cat >> energias.dat << EOF
$ecutwfc $pal
EOF
			else
				cat > energias.dat << EOF
$ecutwfc $pal
EOF
			fi
		fi
	done
done


