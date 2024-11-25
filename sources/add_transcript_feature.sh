#!/bin/bash

# Input and output file names
input_gtf=$1
output_gtf=$2

# Temporary file to store transcript entries
temp_file="temp_transcripts.gtf"

# Initialize the output file
> "$output_gtf"
> "$temp_file"

# Read the input GTF file and generate missing transcript features
awk '
    BEGIN { OFS="\t" }
    {
        # Save original line to output
        print >> "'"$output_gtf"'"

        # Check if the feature is gene, transposable_element, transposon_fragment, or transposable_element_gene
        if ($3 == "gene" || $3 == "transposable_element" || $3 == "transposon_fragment" || $3 == "transposable_element_gene") {
            # Extract gene_id
            gene_id = ""
            if ($9 ~ /gene_id "([^"]+)"/) {
                gene_id = gensub(/.*gene_id "([^"]+)".*/, "\\1", "g", $9)
                transcript_id = gene_id ".t1"  # Create a transcript ID based on gene_id
            }

            # Create a new transcript feature based on the gene-like feature
            transcript_line = $0
            split(transcript_line, fields, "\t")
            fields[3] = "transcript"  # Change feature type to transcript

            # Update the attributes to include the transcript_id
            #fields[9] = "gene_id \"" gene_id "\"; transcript_id \"" transcript_id "\";"

            # Write the new transcript line to the temp file
            print fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9] >> "'"$temp_file"'"
        }
    }
' "$input_gtf"

# Append generated transcript lines to the final output file
cat "$temp_file" >> "$output_gtf"

# Remove temporary file
rm "$temp_file"

echo "Output written to $output_gtf"
