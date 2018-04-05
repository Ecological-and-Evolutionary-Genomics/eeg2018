### PATRIC 
#Objective: Metagenome binning using hydrothermal vent metagenomic data 

#to dl hydrothermal vent metagenome
ssh -Y amwalker8@chinook.alaska.edu # login to supercomp
cd /import/c1/SFOSDNA/amwalker8/EEG/exercise2/ # go to directory with SRA toolkit 

#dl hydrothermal vent metagenome
sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR6439354

#copy fastqs to mac folder
scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/exercise2/fastq/SRR6439354* /Users/alexiswalker/Desktop/EEG/4.21.18/

#go to www.patricbrc.org
#Click on Services
#Click on Metagenome Assembly
#Upload the fastqs to corresponding drop down menu and submit

#When job is finished click on jobs in lower right corner
#Click on row with Output Name = Metagenome Binning
#Click View next to eye in green toolbar
#Click on BinningReport.html and click View in green toolbar
#Take screenshot of report

### Galaxy 
#Objective: Create workflow of search metagenome for a reresentative hydrothermal vent taxon genome
#search ncbi genome for Methanocaldococcus
#dl "CDS from genomic" fasta

# go to usegalaxy.org
#upload Methanocaldococcus cds genome fasta to galaxy
#upload metagenome fastqs
#convert fastqs to fastas
#go to "vsearch search" tool
#use Methanocaldococcus genome as database
#use dl metagenome fastq (interleaved) as query 

#Once job is finished
#Click on extract workflow from settings symbol on right upper history box
#Click on edit
#Screen shot of workflow
