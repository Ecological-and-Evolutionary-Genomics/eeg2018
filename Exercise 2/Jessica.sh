#download SRA toolkit
wget "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz" 

#download the files
cd ~
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-ubuntu64.tar.gz 

#expand, verbose, unzip files 
tar -x -v -z -f sratoolkit.2.8.2-1-ubuntu64.tar.gz 

#download sequences of interest, in this case titles "16s rRNA gene survey of kakapo fecal samples"
~/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR5170066 

#check to see how many files you have-- I have 2
ls -l fastq 

#create file of only line 1's (prefixes)
sed -n '1~4p' SRR5170066_1.fastq > abc 

#create file of only line 2's (sequences
sed -n '2~4p' SRR5170066_1.fastq > def  

#join line 1 and line 2 separated by a tab 
paste abc def > SRR5fakefasta 

#replace all "@" with ">" in prefex
cat SRR5fakefasta | tr "@" ">" | less -S | > fakefasta

# sort by sequence identifire
sort fakefasta > fakefasta.sort.fa

# get unique sequences 
while read myline; do 
while> echo $myline >> fakefasta.dup
while> echo " " >> fakefasta.dup
while> echo $myline >> fakefasta.dup
while> echo " " >> fakefasta.dup
done < fakefasta.sort.fa

#count unique sequences
grep ">" fakefasta.dup | uniq > fakefasta.uniq.fa
cut -d ' ' -f2 fakefasta.uniq.fa | sort | uniq | wc -l > ex2answer.txt
cat ex2answer.txt
# 50622 unique sequences

#make it into a real fasta, make tabs between columns into line break, remove basepair length label, remove excess spaces, convert 
#remaining spaces into underscores, save final fasta as final.fasta
cat fakefasta | tr '/t' '/n' | tr -d "length=" | tr -s ' ' | tr ' ' '_' | > final.fasta
