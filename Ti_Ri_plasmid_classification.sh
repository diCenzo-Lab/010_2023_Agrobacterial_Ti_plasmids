#!/usr/bin/bash

# Help message
if [ "$1" == "-h" ]; then
  echo "
  Usage: `basename $0` directory threads

  Where:
    directory: The folder that contains nucleotide fasta files of all Ti/Ri plasmids.
    threads: Number of CPU threads (where multi-threading is possible).
    "
  exit 0
fi
if [ "$1" == "-help" ]; then
  echo "
  Usage: `basename $0` directory threads

  Where:
    directory: The folder that contains nucleotide fasta files of all Ti/Ri plasmids.
    threads: Number of CPU threads (where multi-threading is possible).
    "
  exit 0
fi
if [ "$1" == "--help" ]; then
  echo "
  Usage: `basename $0` directory threads

  Where:
    directory: The folder that contains nucleotide fasta files of all Ti/Ri plasmids.
    threads: Number of CPU threads (where multi-threading is possible).
    "
  exit 0
fi

# Remove trailing slash
TRIMMED=$(echo "$1" | sed 's:/*$::')

# Get a list of the files in the input directory
find "$TRIMMED"/* > file_list.txt

# Run mash (which must be on your path)
mash sketch -s 10000 -k 15 -l file_list.txt
mash dist -p 10 file_list.txt.msh file_list.txt.msh > mash_dist.txt

# Format mash output for genomic_distance_viz
sed "s/$TRIMMED\///g" mash_dist.txt | sed 's/.fasta//g' | sed 's/.fna//g' | cut -f1,2,3 > mash_dist.reformated.txt
perl reformat_for_distance.pl mash_dist.reformated.txt > temp.txt
mv temp.txt mash_dist.reformated.txt

# Run genomic_distance_viz.py (which must be on your path)
# Requires the python packages: dendropy, matlibplot, and scipy (and possibly others), which can be installed with pip
genomic_distance_viz.py -t mash_dist.reformated.txt -m both -H -D -c --threads $2 -p Ti_Ri_plasmids



