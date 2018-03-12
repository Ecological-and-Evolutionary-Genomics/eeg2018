##done in chinook (supercomputer)

mkdir exercise5
cd exercise5/

###needed to dl new files cause my Ex2 were 16S amplicon data
# dl SRA files
#https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR5396644
sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR5396644

## Error while dl
#2018-03-09T02:08:41 fastq-dump.2.8.2 err: unknown while writing file within file system module - unknown system error errno='Disk quota exceeded(122)'
#2018-03-09T02:08:41 fastq-dump.2.8.2 int: unknown while writing file within file system module - switching cache-tee-file to read-only
#2018-03-09T02:08:41 fastq-dump.2.8.2 err: binary large object corrupt while validating binary large object within database module - failed SRR5396644


# make a soft link to the metagenomic data you downloaded in Exercise 2
ln -s ../exercise2/fastq/SRR5396644* ./

# make sure your sequences are here
ls -l
#lrwxrwxrwx 1 amwalker8 sfosdna 37 Mar  5 15:17 SRR5396644_1.fastq -> ../exercise2/fastq/SRR5396644_1.fastq
#lrwxrwxrwx 1 amwalker8 sfosdna 37 Mar  5 15:17 SRR5396644_2.fastq -> ../exercise2/fastq/SRR5396644_2.fastq

# download the Swiss-Prot database by ftp, about 70Mb
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz

# unzip the file
gunzip uniprot_sprot.fasta.gz

module load bio/BLAST+/2.6.0-pic-intel-2016b-Python-2.7.12

# make a BLAST-formatted version of the Swiss-Prot database, should take less than a minute
    # the -parse_seqids flag is necessary if you later want to search the database by sequence identifier (you do)

makeblastdb -in uniprot_sprot.fasta -out uniprot_sprot -dbtype prot -hash_index -parse_seqids
#Building a new DB, current time: 03/05/2018 16:29:41
#New DB name:   /import/c1/SFOSDNA/amwalker8/EEG/exercise5/uniprot_sprot
#New DB title:  uniprot_sprot.fasta
#Sequence type: Protein
#Keep MBits: T
#Maximum file size: 1000000000B
#Adding sequences from FASTA; added 556825 sequences in 27.3645 seconds

    # BLAST only takes FASTA input so use your FASTQ to FASTA converter from exercise2
    # or here is an awk 1-liner:
awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}' SRR5396644_1.fastq > SRR5396644_1.fasta
awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}' SRR5396644_2.fastq > SRR5396644_2.fasta

    # This command runs blastX, because we have nucleotide sequences we want to search in protein space (swissprot)
    # in BLAST parlance, the 'query' is the sequence you want to identify
    # while 'subject' is a sequence in the reference database
    # the ampersand (&) at the end of the line tells bash to put the command into the background,
    # the same as doing Ctrl-Z and typing 'bg'. To bring it back into the foreground type 'fg'

    # you'll have to change this command to use your own fasta file

    blastx -query SRR5396644_1.fasta -db uniprot_sprot -out blastx_output_1.csv -outfmt 6 2>&1
    blastx -query SRR5396644_2.fasta -db uniprot_sprot -out blastx_output_2.csv -outfmt 6 2>&1

    # BLAST can output its results in many different formats, do 'blastx -help' for more options
    # output format #6 is a tab-separated table with the following selections by default:
    # qseqid, sseqid, pident, length, mismatch, gapopen, qstart, qend, sstart, send, evalue, bitscore

    # Which translate into the following parameters:
    # Query Seq-id, Subject Seq-id, Percentage of identical matches, Alignment length, Number of mismatches, ...
    # Number of gap openings, Start of alignment in query, End of alignment in query, Start of alignment in subject, ...
    # End of alignment in subject, Expect value, Bit score

    # download DIAMOND from github
    

wget https://github.com/bbuchfink/diamond/archive/v0.9.18.tar.gz
tar -xzf v0.9.18.tar.gz

#Install on supercomputer
cd diamond-0.9.18/
mkdir bin
cd bin 
module purge
module load compiler/GCC/5.4.0-2.26
module load devel/CMake/3.5.2-foss-2016b
cmake .. 
make install

#or you can add diamond to your PATH variable, e.g.
PATH=$PATH:/import/c1/SFOSDNA/amwalker8/EEG/exercise5/diamond-0.9.18/bin/diamond

diamond makedb --in uniprot_sprot.fasta -d uniprot_sprot

# this is the DIAMOND-equivalent of running BLASTX -- except DIAMOND will take FASTQ files

diamond blastx -d uniprot_sprot -q SRR5396644_1.fastq -a diamond_output
diamond blastx -d uniprot_sprot -q SRR5396644_2.fastq -a diamond_output

##diamond was WAY faster than blastx

# DIAMOND outputs its results to its own compressed format
# to get results in a BLAST-equivalent format use the `view` command
mv diamond_output.daa SRR5396644_1.daa
mv diamond_output.daa SRR5396644_2.daa

diamond view -a SRR5396644_1.daa -o R1_diamond_output.csv
diamond view -a SRR5396644_2.daa -o R2_diamond_output.csv

# cut out the second column and save it into a new file

cut -f2 R1_diamond_output.csv > R1_diamond_acc.txt
cut -f2 R2_diamond_output.csv > R2_diamond_acc.txt

# run `blastdbcmd` with the -entry_batch command to tell it you'll be giving it a list of accessions
# otherwise it expects a single identifier
# the -outputfmt flag tells it to output just the annotation for each matching sequence
# more details about output formats can be found in `blastdbcmd -help`

blastdbcmd -db uniprot_sprot -entry_batch R1_diamond_acc.txt -out R1_diamond_output.txt -outfmt '%t'
blastdbcmd -db uniprot_sprot -entry_batch R2_diamond_acc.txt -out R2_diamond_output.txt -outfmt '%t'

#provide a script that produces a list of all of the proteins in the Swiss-Prot database that have 
#matches in the metagenomic dataset with an e-value of less than 1e-10, along with their annotations.

paste R1_diamond_output.csv R1_diamond_output.txt > R1_blast_prot_comb.csv #combine blast-equiv output with proteins
paste R2_diamond_output.csv R1_diamond_output.txt > R2_blast_prot_comb.csv #combine blast-equiv output with proteins


# check new file
head R1_blast_prot_comb.csv
head R2_blast_prot_comb.csv

# list proteins with e-value less than 1e-10 (column 11). 
#Prints out protein (column 1), e-value, annotation.
cat R1_blast_prot_comb.csv | awk '{ if ($11 <= 1e-10) print $1,$11,$13}' > R1_exercise5_AMW.csv    # spaces between each column
cat R2_blast_prot_comb.csv | awk '{ if ($11 <= 1e-10) print $1,$11,$13}' > R2_exercise5_AMW.csv    # spaces between each column

# check new file
head R1_exercise5_AMW.csv
head R2_exercise5_AMW.csv
