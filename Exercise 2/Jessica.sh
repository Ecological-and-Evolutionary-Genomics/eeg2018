wget "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz" #download SRA toolkit

cd ~
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-ubuntu64.tar.gz #download the files

tar -x -v -z -f sratoolkit.2.8.2-1-ubuntu64.tar.gz #expand, verbose, unzip files 

~/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR5170066 
#download sequences of interest, in this case titles "16s rRNA gene survey of kakapo fecal samples"

ls -l fastq #check to see how many files you have-- I have 2


