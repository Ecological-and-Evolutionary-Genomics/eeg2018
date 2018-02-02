# exercise1

cd			# defaults to home directory
mkdir exercise1  	# make new directory
cd exercise1		# go to exercise1
wget https://raw.githubusercontent.com/rec3141/eeg2016/master/exercise1/ex1.txt

sort ex1.txt > seqs.sort.fa   # saves sorted files to new file

head seqs.sort.fa	      # previews new  file

while read myline; do
   echo $myline >> seqs.dup.fa
   echo "" >> newfile.txt
   echo $myline >> seqs.dup.fa
   echo "" >> newfile.txt
done < seqs.sort.fa

head seqs.dup.fa	     # preview

grep '>' seqs.dup.fa | sort | uniq > seqs.uniq.fa	# find > in seqs, sort, uniq takes only one iteration of duplicate lines

cut -d' ' -f2 seqs.uniq.fa | sort | uniq | wc -l > ex1-answer.txt

rm seqs*

cd ..

# rm -rf exercise1
