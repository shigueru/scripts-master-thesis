# ============ Y ================================

python suma_pdos.py -o YCrO3.scf.out -p Y_DOS -s "*(Y)*"             # total
python suma_pdos.py -o YCrO3.scf.out -p Y_DOS_s -s "*(Y)*(s)"        # orbital s
python suma_pdos.py -o YCrO3.scf.out -p Y_DOS_p -s "*(Y)*(p)"        # orbital p
python suma_pdos.py -o YCrO3.scf.out -p Y_DOS_d -s "*(Y)*(d)"        # orbital d

# ============ O ================================

python suma_pdos.py -o YCrO3.scf.out -p O_DOS -s "*(O)*"             # total
python suma_pdos.py -o YCrO3.scf.out -p O_DOS_s -s "*(O)*(s)"        # orbital s
python suma_pdos.py -o YCrO3.scf.out -p O_DOS_p -s "*(O)*(p)"        # orbital p

# ============ Cr ================================

python suma_pdos.py -o YCrO3.scf.out -p Cr_DOS -s "*(Cr*"            # total
python suma_pdos.py -o YCrO3.scf.out -p Cr_DOS_s -s "*(Cr*(s)"       # tipo 1 y 2 orbital s
python suma_pdos.py -o YCrO3.scf.out -p Cr_DOS_p -s "*(Cr*(p)"       # tipo 1 y 2 orbital p
python suma_pdos.py -o YCrO3.scf.out -p Cr_DOS_d -s "*(Cr*(d)"       # tipo 1 y 2 orbital d

python suma_pdos.py -o YCrO3.scf.out -p Cr1_DOS -s "*(Cr1)*"         # tipo 1 total
python suma_pdos.py -o YCrO3.scf.out -p Cr1_DOS_s -s "*(Cr1)*(s)"    # tipo 1 orbital s
python suma_pdos.py -o YCrO3.scf.out -p Cr1_DOS_p -s "*(Cr1)*(p)"    # tipo 1 orbital p
python suma_pdos.py -o YCrO3.scf.out -p Cr1_DOS_d -s "*(Cr1)*(d)"    # tipo 1 orbital d

python suma_pdos.py -o YCrO3.scf.out -p Cr2_DOS -s "*(Cr2)*"         # tipo 2 total
python suma_pdos.py -o YCrO3.scf.out -p Cr2_DOS_s -s "*(Cr2)*(s)"    # tipo 2 orbital s
python suma_pdos.py -o YCrO3.scf.out -p Cr2_DOS_p -s "*(Cr2)*(p)"    # tipo 2 orbital p
python suma_pdos.py -o YCrO3.scf.out -p Cr2_DOS_d -s "*(Cr2)*(d)"    # tipo 2 orbital d

# ============ TOTAL ================================

python suma_pdos.py -o YCrO3.scf.out -p DOS_total -s "YCrO3.DOS_TOTAL"     # TOTAL
python suma_pdos.py -o YCrO3.scf.out -p PDOS_total -s "*pdos_tot"           # TOTAL del pdos



