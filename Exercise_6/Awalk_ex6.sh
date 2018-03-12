#setup directory
 mkdir /exercise6
 cd /exercise6

 #download from source
 wget https://github.com/infphilo/centrifuge/archive/v1.0.3.tar.gz
 tar -xvzf v1.0.3.tar.gz

 #compile centrifuge from source
 cd centrifuge-1.0.3
 make #takes a few minutes
 cd ../



#install prereqs
 wget http://ftp-trace.ncbi.nlm.nih.gov/sra/ngs/2.9.0/ngs-sdk.2.9.0-linux.tar.gz
 wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.0/sratoolkit.2.9.0-ubuntu64.tar.gz
 tar xvzf ngs-sdk.2.9.0-linux.tar.gz
 tar xvzf sratoolkit.2.9.0-ubuntu64.tar.gz

#this didn't work for me, but my subsequent scripts ran likely due to supercomputer environment already having dependecies?
#make USE_SRA=1 NCBI_NGS_DIR=./ngs-sdk.2.9.0-linux NCBI_VDB_DIR=./sratoolkit.2.9.0-ubuntu64

 #test
 ./centrifuge-1.0.3/centrifuge --version

 # download the LARGE (4.4 Gb) centrifuge database of Bacteria and Archaea
 screen wget ftp://ftp.ccb.jhu.edu/pub/infphilo/centrifuge/data/p_compressed.tar.gz

#md5sum p_compressed.tar.gz: 3e14f37576012a2fce79879281e81fcf
md5sum p_compressed.tar.gz
#3e14f37576012a2fce79879281e81fcf  p_compressed.tar.gz

tar -xvzf p_compressed.tar.gz

# make a soft link to the metagenomic data you downloaded in Exercise 2
ln -s ../exercise2/fastq/SRR5396644* ./

# make sure your sequences are here
ls -l

#run centrifuge on paired end metagenome samples with specified output and report names
./centrifuge-1.0.3/centrifuge -x p_compressed -1 SRR5396644_1.fastq.gz -2 SRR5396644_2.fastq.gz  -S MGM_output_class.tsv --report-file MGM_centrifuge_report.tsv 
#convert output from celtrifuge analysis above to kraken format report file 
./centrifuge-1.0.3/centrifuge-kreport -x MGM_centrifuge_report.tsv 
./centrifuge-1.0.3/centrifuge-kreport -x p_compressed MGM_output_class.tsv > MGM_pavian.report.csv
#to run pavian in browser must do it from laptop not supercomputer
#transfer output files from supercomputer
scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/exercise6/MGM_pavian.report.csv /Users/alexiswalker/Desktop/EEG/exercise6/

# install pavian
options(repos = c(CRAN = "http://cran.rstudio.com"))
install.packages("remotes", dependecies=TRUE)
require(remotes)
remotes::install_github("rec3141/pavian")
require(pavian)
#To run Pavian from R, type

 pavian::runApp(port=5000)

 # Pavian will then be available at http://127.0.0.1:5000 in the web browser of you choice.
# Window opens automatically and click upload file 
#click save table


#kaiju webserver
gzip SRR5396644_1.fastq
gzip SRR5396644_2.fastq

scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/exercise2/fastq/SRR5396644_1.fastq.gz /Users/alexiswalker/Desktop/EEG/exercise6/
scp amwalker8@chinook.alaska.edu:/import/c1/SFOSDNA/amwalker8/EEG/exercise2/fastq/SRR5396644_2.fastq.gz /Users/alexiswalker/Desktop/EEG/exercise6/

#upload paired end files 
