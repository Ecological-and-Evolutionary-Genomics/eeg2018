## 2/5/2018

##1
cd Desktop/EEG/ #go to EEG directory

##2
mkdir exercise1 #make exercise1 directory

##3
cd exercise1 #got to new directory

##4
#Download the file ex1.txt from Github to my new folder
wget ex1.txt https://raw.githubusercontent.com/rec3141/eeg2016/master/exercise1/ex1.txt

##5
less ex1.txt # look at file

##6
wc -l ex1.txt #get number of lines (-l) in ex1.txt
# 65 ex1.txt

##7
#Sort ex1.txt by sequence identifier and save the output to a new file called seqs.sort.fa
sort ex1.txt > seqs.sort.fa

#The syntax to read file.txt line by line and do something with each line is shown below. 
#This example echoes (prints out) each line, followed by a blank line, and appends each to a file called newfile.txt:

#while read myline; do
#  echo $myline >> newfile.txt
#  echo "" >> newfile.txt
#done < file.txt

while read myline; do
  echo $myline >> newfile.txt
  echo "" >> newfile.txt
done < ex1.txt

#The code above took the ex1.txt file and put spaces "" between each line
# while = loop
#read = Read a line from standard input
#myline = name of your variable to run in loop
#newfile = output file
#file.txt = file to be modified
# >> append 
#"" = space

##8
#Use the construction above to output each line of seqs.sort.fa two times, 
#with each line separated by a blank line, and save everything to a new file called seqs.dup.fa.

while read myline; do #loop to read each line
  echo $myline >> seqs.dup.fa #report  line and write to new file
  echo "" >> seqs.dup.fa      #add space after reported line write to new file
  echo $myline >> seqs.dup.fa #report line again write to new file
  echo "" >> seqs.dup.fa      # add another space after reported line write to new file
done < seqs.sort.fa           # done with input file 

##9
awk NF seqs.dup.fa | sort -u  > seqs.uniq.fa
# awk NF seqs.dup.fa = NF indicates the total number of fields and prints only non-blank lines, since in blank lines NF = 0 
# | sort -u = while sorting for unique identifiers and putting them into new file 

##10
#Count the number of unique DNA sequences in the file seqs.uniq.fa and
#output the value to a file in your home directory called ex1-answer.txt
wc -l seqs.uniq.fa  > ex1-answer.txt

##11
#Delete all of the files that have names beginning with seqs.
rm seqs*

##12
#Go to out of directory
cd ..
#Delete the folder exercise1 and everything remaining inside of it.
rm -R exercise1
