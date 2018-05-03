#install docker on Biolinux on cyromics comp
ssh -y cryomics@10.25.193.192
#password: polaribacter!!

#install in biolinux on cryomics
ssh -Y -p2222 manager@localhost
#password: manager

# install instructions: https://docs.docker.com/install/linux/docker-ce/ubuntu/#extra-steps-for-aufs

sudo apt-get update
#W: Conflicting distribution: http://download.mono-project.com wheezy/snapshots/3.12.0 InRelease (expected wheezy/snapshots but got wheezy)
#W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: http://dl.google.com stable Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 1397BC53640DB551

#W: There is no public key available for the following key IDs:
#1397BC53640DB551
#W: Failed to fetch http://dl.google.com/linux/chrome/deb/dists/stable/Release

#W: Some index files failed to download. They have been ignored, or old ones used instead.

sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get install \
    apt-hmmfetchport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce

#test to see if install worked
sudo docker run hello-world
#success

#get 3 metagenome samples that are similar
#use mine from 200m B1
#trim & assemble in supercomp

ssh -Y amwalker8@chinook.alaska.edu

zcat NPRB_meta_B1.200* > B1_200m.fastq #concatenate all 3 samples
gzip -c B1_200m.fastq > B1_200m.fastq.gz #compress concatenated samples

#check to see if # of reads match
echo $(cat B1_200m.fastq  | wc -l) / 4 | bc &
#23934700
echo $(zcat B1_200m.fastq.gz | wc -l) / 4 | bc &
#23934700

#trim adapters
nano B1_adapter_trim.sh
#!/bin/sh

#SBATCH --partition=bio
#SBATCH --mem=214G
#SBATCH -n 1
#SBATCH --mail-user=amwalker8@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --workdir=/center1/SFOSDNA/amwalker8/EEG/project/

module load lang/Java/1.8.0_74 #load java

bbmap/bbduk.sh in=B1_200m.fastq.gz out=B1_200m.trim.fastq.gz ref=bbmap/resources/nextera.fa.gz

#coassembly with spades
nano B1.200_assembly.sh
#!/bin/bash

#SBATCH --partition=bio
#SBATCH --mem=500G
#SBATCH --time=48:00:00
#SBATCH --ntasks=7
#SBATCH --mail-user=amwalker8@alaska.edu
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --workdir=/center1/SFOSDNA/amwalker8/EEG/project/

SPAdes-3.11.1-Linux/bin/metaspades.py -o B1.200_assembly --12 B1_200m.trim.fastq.gz -t 7 -m 500 --tmp-dir B1.200_assembly/tmp -k21,33,55,67,77,89,99,121

#== Error ==  system call for: "['/import/c1/SFOSDNA/amwalker8/EEG/project/SPAdes-3.11.1-Linux/bin/hammer', '/import/c1/SFOSDNA/amwalker8/EEG/project/B1.200_assembly/corrected/configs/config.info']" finished abnormally, err code: -9

#worked with more memory (500gb)

#test
/center1/SFOSDNA/amwalker8/EEG/project/bbmap/bbmap.sh in=B1.200A.R1.cor.fastq.gz in2=B1.200A.R2.cor.fastq.gz out=B1.200A.mapped.bam ref=contigs.fasta bamscript=bs.sh; sh bs.sh;

##I did this two ways
# I think the first way would have worked but it said that samtools crashed (bs.sh?)
# And bs.sh needed to be in bbmap directory.; so I moved it to that directory
# I also think it is possible that the first run was successful, but since it errored out and said more mem might
#be needed, I decided to run it again in two separate pieces: 1) get ref 2) map files and make bam output files

##1

#!/bin/sh

#SBATCH --partition=bio
#SBATCH --mem=214G
#SBATCH -n 1
#SBATCH --mail-user=amwalker8@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --workdir=/center1/SFOSDNA/amwalker8/EEG/project/

module load lang/Java/1.8.0_74 #load java

for x in `ls B1.200*.cor.fastq.gz| cut -f 1-2 -d'.'` ; do
INPUT1=$x.R1.cor.fastq.gz
INPUT2=$x.R2.cor.fastq.gz
OUTPUT=$x.mapped.bam
bbmap/bbmap.sh in=$INPUT1 in2=$INPUT2 out=$OUTPUT ref=B1.200_assembly/contigs.fasta bamscript=bs.sh; sh bs.sh;
done

#the output for this is in B1_bam_run1

### 2
nano B1_ref.sh

#!/bin/sh

#SBATCH --partition=bio
#SBATCH --mem=214G
#SBATCH -n 1
#SBATCH --mail-user=amwalker8@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --workdir=/center1/SFOSDNA/amwalker8/EEG/project/

module load lang/Java/1.8.0_74 #load java

bbmap/bbmap.sh ref=B1.200_assembly/contigs.fasta

nano B1.200_bam2.sh

#!/bin/sh

#SBATCH --partition=bio
#SBATCH --mem=214G
#SBATCH -n 1
#SBATCH --mail-user=amwalker8@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --workdir=/center1/SFOSDNA/amwalker8/EEG/project/B1_bam_run2

module load lang/Java/1.8.0_74 #load java
module load bio/SAMtools/1.5-foss-2016b

for x in `ls B1.200*.cor.fastq.gz| cut -f 1-2 -d'.'` ; do
INPUT1=$x.R1.cor.fastq.gz
INPUT2=$x.R2.cor.fastq.gz
OUTPUT=$x.mapped.bam
/center1/SFOSDNA/amwalker8/EEG/project/bbmap/bbmap.sh in=$INPUT1 in2=$INPUT2 out=$OUTPUT bamscript=bs.sh; sh bs.sh;
done

B1.200A.R2.cor.fastq.gz
bbmap.sh in=MG1-R1.fastq.gz in2=MG1-R2.fastq.gz out=MG1-mapped.bam ref=B1.200_assembly/contigs.fasta bamscript=bs.sh; sh bs.sh;


#If Samtools crashes, please ensure you are running on the same platform as BBMap,
#or reduce Samtools' memory setting (the -m flag).
#bs.sh: line 5: samtools: command not found
#bs.sh: line 6: samtools: command not found
#but the .bam files were made and everything look good ...?

ssh -y cryomics@10.25.193.192
#password: polaribacter!!
scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/project/NPRB_meta_B1.200* /Users/cryomics/Documents/Awalk_EEG18/

ssh -Y -p2223 manager@localhost
#password: manager

scp cryomics@10.25.193.192:/Users/cryomics/Documents/Awalk_EEG18/NPRB_meta_B1.200* /home/manager/Documents/Awalk

#test/install metabat
sudo docker run metabat/metabat:latest runMetaBat.sh
sudo docker run metabat/metabat:latest metabat2 -h

sudo docker run metabat/metabat:latest runMetaBat.sh -m 1500 B1.200_assembly/contigs.fasta bam_files/*mapped_sorted.bam
