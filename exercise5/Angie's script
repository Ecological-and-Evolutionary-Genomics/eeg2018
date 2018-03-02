Exercise #5

#make a new directory for exercise5
mkdir ~/exercise5
cd ~/exercise5

#make a soft link to metagenomic data from exercise 2 (SRR2971420_1.fastq)
ln -s ~/fastq/*.fastq ./

#check to make sure sequence files are in exercise 5 directory
ls -l

#Download Swiss-Prot database 
 wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz  

#unzip file
 gunzip uniprot_sprot.fasta.gz  


#make a blast-formatted version of Swiss-prot database
    makeblastdb -in uniprot_sprot.fasta -out uniprot_sprot -dbtype prot -hash_index -parse_seqids  

#convert FASTQ to FASTA
awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}' SRR2971420_1.fastq > SRR2971420_1.fasta

#Run blastX on FASTA file
    blastx -query SRR2971420_1.fasta -db uniprot_sprot -out blastx_output.csv -outfmt 6   


#Download Diamond
wget https://github.com/bbuchfink/diamond/releases/download/v0.9.18/diamond-linux64.tar.gz
tar xzf diamond-linux64.tar.gz

#specify where to call the program
~/exercise5/diamond

#make a diamond formatted version of Swiss-Prot
./diamond makedb --in uniprot_sprot.fasta -d uniprot_sprot

#Run Diamond equivalent of blastX
./diamond blastx -d uniprot_sprot -q SRR2971420_1.fastq -a diamond_output

# reformat diamond format to blast-equivalent format
./diamond view -a diamond_output.daa -o diamond_output.csv

# cut out second column (accessions) and save to new file
cut -f2 diamond_output.csv > diamond_acc.txt

# blastdbcmd to get the annotation for each match
blastdbcmd -db uniprot_sprot -entry_batch diamond_acc.txt -out diamond_output.txt -outfmt '%t'

#homework: provide list of all proteins from Swiss-Prot database that match genomic dataset with e-value less that 1e-10, along with their annotations

#combine match file and annotation file 
paste diamond_output.csv diamond_output.txt > diamond_output_plus_annotations.txt

#awk so file only contains matches with e-value equal to or less than 1e-10
awk ' $11 <=  1e-10' diamond_output_plus_annotations.txt > diamond_output_plus_annotations_awk.txt



