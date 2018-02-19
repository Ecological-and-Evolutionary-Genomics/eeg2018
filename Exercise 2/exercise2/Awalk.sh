#1 Download SRA toolkit
cd EEG/
mkdir exercise2
cd exercise2/
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-ubuntu64.tar.gz

#2 unpack toolkit
tar -xvzf sratoolkit.2.8.2-1-ubuntu64.tar.gz

#3 Run program help
sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --help
#success

#4 dl SRA files
# search marine sediment 16S Miseq  (looked at pgs 1, 67-84)
# dl SRA files from https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=433243
#additional sample info: http://www.darkenergybiosphere.org/research-activities/field-sites/

# documentation for SRA sratoolkit
# --outdir=where to put output file
# --skip-technical=skip non-biological sequences
# --readids=include original read ids
# --dumpbase=output DNA bases
# --split-files=split paired end reads into different file
# --clip=remove sequencing adapters.

sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR6715661

#Rejected 246877 READS because of filtering out non-biological READS
#Read 246877 spots for SRR6715661
#Written 246877 spots for SRR6715661

ls /fastq # check to make sure 2 files for paired
# only 1 fastq eventhough says PAIRED?

rm fastq/SRR6715661_1.fastq

#dl another 
sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir fastq --skip-technical --readids --dumpbase --split-files --clip SRR5097535
#Read 240570 spots for SRR5097535
#Written 240570 spots for SRR5097535

ls /fastq
#SRR5097535_1.fastq  SRR5097535_2.fastq
#success

#5 fastq to fake fasta
cd fastq/
head SRR5097535_1.fastq 

#@SRR5097535.1.1 1 length=250
#TACGGAGGGTGCGAACGTTATTCGGATTTACTGGGCGTAAAGCGCGCGTAGGCGGTTTGATAAGTCTGATGTGAAATCCCCCGGCTTAACCTGGGAATTGCATTTGATACTGTCTGGCTTGAGTATGGTAGAGGGGGGTGGAATTCCAGGTGTAGCGGTGAAATGCGTAGATATCTGGAGGAACATCAGTGGCGAAGGCGGCCCCCTGGATCAATACTGACGCTGAGGTTCGAAAGCGTGGGTAGCGAAC
#+SRR5097535.1.1 1 length=250
#AAAA?1AD1>AAEE0AEGG00BGFGA0BFD2GDGGAEFGEFHBF//AEEEGGDEGGEG?1B2>FG22B1BFHHHFF2B1<?//>>C@BBG1>CGC??0F?F1??1?1<?GHBGDF10GH0A<>GDFBGFDG1GHC-<;9@@ABBF/F//BFFF/BF@@F@-FF;;B9B-@ABBF/9/BBFFA-;-/;/:BBFA9--;AA9-=--9@@-9-//-/;/;BB/FBAF9---9-;@-;BFF-:A@@FFE9-@@@
#@SRR5097535.2.1 2 length=250
#TACGGAGGATGCAGGCGTTATCCGGATTTATTAGGTTTAAAGGGTGCGCAGGCGGTTCTTTAAGTCAGTGGTTACATTTTTCAGCTTCACTGTAAAATTGCCATTGATACTGGAGAACTTTAATGCTTTAGAGGTTGGCGGGATTTGTAGTGTAGCGGTGAAATGCTTAGATATTTCACAGAACACCGATTGCGAAGGCAGCTTACTATGCAGTGCTTGACGCTGCTGCACGAAAGCGTGGGGAGCCAAC
#+SRR5097535.2.1 2 length=250
#BBBBB@AB2CCFD5AEEFE2FAGEA2AEGDDG5DGBGHGFDH3EFEAE0EAEAEFEE1BDF443B443B4F@143444BB4344BBF3BB?4B4?444G3B?3BB44B4BF433030BGG222B2122B1111BG00B1<@-<>011110=/=00=--<<.:C;0;CG000:0;;000<00/:;/9C--;A.C.-9-.9.9.9;/;F///9/;9///;/;;.;;;./;9//E.AA.;.99B?BF-..:.A

#cut in line: length=#
#keep lines 1 & 2 , rm 3 & 4 
#head -1 -5 to see if that is infact the layout
# combine lines 1 & 2 by > while keep space between lines

#make test file
head -12 SRR5097535_1.fastq > test12.fastq

#converting fastq into fake-fasta
# modified script from: https://www.biostars.org/p/85929/
cat test12.fastq | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n'|awk '{ print $1 }' |paste -d '\t'  - -  > fake.fasta
# cat will print the contents of the file to stdout.
# paste is merging all 4 lines at each @ - - - - ; into 4 fields?
# sed is finding @ and replacing with >
# cut is removing fields 1-2, but his isn't making sense to me
# tr is splitting one line into two by tab "\t"
#awk is printing column 1 only, i.e. >SRR* (removing length=*)
#paste is merging the two lines with a tab "\t" in between

#7 converting fake fasta to real fasta
cat fake.fasta | tr '\t' '\n' > realfromfake.fasta

##bonus
#converting fastq into real fasta format
cat test12.fastq | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n'| awk '{ print $1 }'> realfromfastq.fasta
# cat will print the contents of the file to stdout.
# paste is merging all 4 lines at each @ - - - - ; into 4 fields?
# sed is finding @ and replacing with >
# cut is removing fields 1-2, but his isn't making sense to me
# tr is splitting one line into two
#awk is printing column 1 only, i.e. >SRR* (removing length=*)

#checking work
# I have 12 lines in my test file 
wc -l test12.fastq #12
#to make fake fasta from fastq I merged all lines between @ (>), which there is 3 of 
#so I should have 3 lines 
wc -l fake.fasta #3
#from fake to real fasta I am creating 2 lines for every > (@), so I should have 6 lines
wc -l realfromfake.fasta #6
wc -l realfromfastq.fasta #6




