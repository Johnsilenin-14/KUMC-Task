#!/bin/bash

# Count the number of sequences 
num_sequences=$(zgrep -c '^>' NC_000913.faa.gz)

#count the total  number of amino acids
num_aminoacids=$(zgrep -v '^>' NC_000913.faa.gz | tr -d '\n[:space:]'|wc -c)

# Calculate the average number of amino acids per sequence
average_aa_per_sequence=$(echo "$num_aminoacids / $num_sequences" | bc)

# Print the results
echo "Number of sequences: $num_sequences"
echo "Total number of amino acids: $num_aminoacids"
echo "Average length of the protein : $average_aa_per_sequence"


###Single line command##

echo "Average length of protein using single line command : $(zgrep -v '^>' NC_000913.faa.gz | tr -d '\n[:space:]' | wc -c | xargs -I {} sh -c "echo \" {}/\$(zgrep -c '^>' NC_000913.faa.gz)\" | bc")"
