# ============ Bi ================================

python suma_pdos.py -o BiFeO3.scf.out -p Bi_DOS -s "*(Bi)*"             # total
python suma_pdos.py -o BiFeO3.scf.out -p Bi_DOS_s -s "*(Bi)*(s)"        # orbital s
python suma_pdos.py -o BiFeO3.scf.out -p Bi_DOS_p -s "*(Bi)*(p)"        # orbital p
python suma_pdos.py -o BiFeO3.scf.out -p Bi_DOS_d -s "*(Bi)*(d)"        # orbital d

# ============ O ================================

python suma_pdos.py -o BiFeO3.scf.out -p O_DOS -s "*(O)*"             # total
python suma_pdos.py -o BiFeO3.scf.out -p O_DOS_s -s "*(O)*(s)"        # orbital s
python suma_pdos.py -o BiFeO3.scf.out -p O_DOS_p -s "*(O)*(p)"        # orbital p

# ============ Fe ================================

python suma_pdos.py -o BiFeO3.scf.out -p Fe_DOS -s "*(Fe*"            # total
python suma_pdos.py -o BiFeO3.scf.out -p Fe_DOS_s -s "*(Fe*(s)"       # tipo 1 y 2 orbital s
python suma_pdos.py -o BiFeO3.scf.out -p Fe_DOS_p -s "*(Fe*(p)"       # tipo 1 y 2 orbital p
python suma_pdos.py -o BiFeO3.scf.out -p Fe_DOS_d -s "*(Fe*(d)"       # tipo 1 y 2 orbital d

python suma_pdos.py -o BiFeO3.scf.out -p Fe1_DOS -s "*(Fe1)*"         # tipo 1 total
python suma_pdos.py -o BiFeO3.scf.out -p Fe1_DOS_s -s "*(Fe1)*(s)"    # tipo 1 orbital s
python suma_pdos.py -o BiFeO3.scf.out -p Fe1_DOS_p -s "*(Fe1)*(p)"    # tipo 1 orbital p
python suma_pdos.py -o BiFeO3.scf.out -p Fe1_DOS_d -s "*(Fe1)*(d)"    # tipo 1 orbital d

python suma_pdos.py -o BiFeO3.scf.out -p Fe2_DOS -s "*(Fe2)*"         # tipo 2 total
python suma_pdos.py -o BiFeO3.scf.out -p Fe2_DOS_s -s "*(Fe2)*(s)"    # tipo 2 orbital s
python suma_pdos.py -o BiFeO3.scf.out -p Fe2_DOS_p -s "*(Fe2)*(p)"    # tipo 2 orbital p
python suma_pdos.py -o BiFeO3.scf.out -p Fe2_DOS_d -s "*(Fe2)*(d)"    # tipo 2 orbital d

# ============ TOTAL ================================

#python suma_pdos.py -o BiFeO3.scf.out -p DOS_total -s "YCrO3.DOS_TOTAL"     # TOTAL
python suma_pdos.py -o BiFeO3.scf.out -p PDOS_total -s "*pdos_tot"           # TOTAL del pdos



