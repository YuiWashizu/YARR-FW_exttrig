#!/bin/bash

OUTPUT_KC705="./syn/kc705/constrs_kc705_ohio_HPC.xdc"
INPUT="./syn/xpressk7/xpressk7-fmc-quad-dp-ohio.xdc"

#cp $INPUT $OUTPUT_KC705

sed -e "s/A8/F22/g" \
-e "s/A9/G22/g" \
-e "s/F8/C21/g" \
-e "s/F9/D21/g" \
-e "s/H11/C22/g" \
-e "s/H12/D22/g" \
-e "s/F12/C16/g" \
-e "s/G12/D16/g" \
-e "s/D8/H22/g" \
-e "s/D9/H21/g" \
-e "s/A15/B19/g" \
-e "s/D16/A21/g" \
-e "s/D15/A20/g" \
-e "s/D11/B17/g" \
-e "s/E11/C17/g" \
-e "s/E12/F17/g" \
-e "s/E13/G17/g" \
-e "s/C18/B20/g" \
-e "s/C17/C20/g" \
-e "s/D13/A17/g" \
-e "s/D14/A16/g" \
-e "s/E17/E21/g" \
-e "s/D24/B29/g" \
-e "s/D23/C29/g" \
-e "s/P18/B24/g" \
-e "s/R18/C24/g" \
-e "s/T25/F27/g" \
-e "s/T24/G27/g" \
-e "s/V24/D28/g" \
-e "s/V23/E28/g" \
-e "s/M20/A27/g" \
-e "s/N19/B27/g" \
-e "s/U22/D29/g" \
-e "s/AC26/H25/g" \
-e "s/AB26/H24/g" \
-e "s/K26/E30/g" \
-e "s/K25/E29/g" \
-e "s/M26/H27/g" \
-e "s/N26/H26/g" \
-e "s/R23/B25/g" \
-e "s/R22/C25/g" \
-e "s/W26/F28/g" \
-e "s/W25/G28/g" \
-e "s/W20/H30/g" \
-e "s/M24/AG22/g" \
-e "s/L24/AH22/g" \
-e "s/T20/AB24/g" \
-e "s/R20/AC25/g" \
-e "s/A15/AJ29/g"  $INPUT > $OUTPUT_KC705

echo "Done!"

