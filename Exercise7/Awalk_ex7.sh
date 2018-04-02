mkdir /exercise7
cd /exercise7

#1 Download and install SPAdes in BioLinux. There are often new versions so update often if you use it in your work.

wget http://spades.bioinf.spbau.ru/release3.11.1/SPAdes-3.11.1-Linux.tar.gz
tar -xzf SPAdes-3.11.1-Linux.tar.gz


#2 From within BioLinux, download FASTQ sequences from the SRA using fastq-dump as before
 
/import/c1/SFOSDNA/amwalker8/EEG/exercise2/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR6837832 

# 3 Start SPAdes

 # 'screen' is a program that allows you to easily connect and disconnect to different windows, some of which may be on remote computers. It is nice because even if your connection gets disconnected whatever is happening in the 'screen' does not get cancelled, unlike if you were working in a normal terminal window
 # the -L flag tells screen to write everything it sees to a log file
 # to disconnect from the screen type 'Ctrl-a' then 'd'
 # to reconnect type 'screen -r' at the terminal
 # if screen quits right when you launch it, something was probably wrong with your command. Trying running it without screen to fix the error.

 # SPAdes is a program written in python, we'll call it directly from the installation directory
 # '--careful' tells SPAdes to do extra error correction. From the manual: "Tries to reduce the number of mismatches and short indels. Also runs MismatchCorrector – a post processing tool, which uses BWA tool (comes with SPAdes)."
 # '--memory 8' tells SPAdes to use only 8Gb of memory. If you have less in your virtual machine, set this lower. If you have more, set it higher.
 # '--pe1-1' and '--pe1-2' tell SPAdes that these two files belong to the same paired end library (#1); the first set of reads is often named '*R1_001.fastq' and the second set is often '*R2_001.fastq' but you'll have to find these from your fastq downloads
 # '-o ./spades-run1' tells SPAdes to save the output to a folder in the current directory called 'spades-run1'

screen -L ./SPAdes-3.11.1-Linux/bin/spades.py --careful --memory 8 --pe1-1 fastq/SRR6837832_1.fastq --pe1-2 fastq/SRR6837832_2.fastq -o ./spades-run1

#4 Visualize the results with Bandage

#Download Bandage

wget https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_dynamic_v0_8_1.zip  
unzip Bandage_Ubuntu_dynamic_v0_8_1.zip

#Run Bandage
  ./Bandage

#5 Analysis

scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/exercise7/spades-run1/assembly_graph_with_scaffolds.gfa /Users/alexiswalker/Desktop/EEG/exercise7/

#when SPAdes has finished, load the file '~/exercise7/spades-run1/assembly_graph_with_scaffolds.gfa' into Bandage
#click "Draw Graph"
#you can zoom in and out by holding control and swiping up and down on the track pad (at least on mine)
#notice that ideally we would have one circular genome but in reality we have a complex string of interconnections due to unresolved repeats

#Go to 'Create/view BLAST search'
export PATH=$PATH:/Users/alexiswalker/ncbi-blast-2.7.1+/bin

#Click 'Build BLAST database'
#find and download the entire proteome for a similar genome (e.g. amino acid sequences from NCBI, EMBL, or PATRIC)
#Click 'Load from FASTA file' and select your peptide FASTA file
#Click 'Run BLAST search' and wait several minutes while it BLASTs away
#When it's done, click 'Close' and on the main screen under Graph Display select 'BLAST hits (solid)'
#You should see every protein-coding gene on the genome
#Find one of the contigs (nodes) that is a repeat -- it will have two links on either end
#Click the contig and go to 'Output' -> 'Web BLAST selected nodes' to identify the node
#Upload your scripts and the FASTA sequence of the node and the best BLAST hit to GitHub under exercise 7
