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


