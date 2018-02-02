cd  #go to home directory
mkdir exercise1 #make new directory called exercise1
cd exercise1 #go to  exercise1 directory
wget https://raw.githubusercontent.com/rec3141/eeg2016/master/exercise1/ex1.txt #download file 
cat ex1.txt #view file
wc -l ex1.txt #count number of lines
sort ex1.txt > seqs.sort.fa #sorts by sequence identifier then saves to new file
while read myline; do 
echo $myline >> seqs.dup.fa
echo "" >> seqs.dup.fa
echo $myline >> seqs.dup.fa
echo "" >> seqs.dup.fa
done < seqs.sort.fa
# duplicates each line then adds a blank line between each

grep ">" seqs.dup.fa | uniq > seqs.uniq.fa
 #finds unique sequences identifiers and saves them to a new file


cut -d' ' -f2 seqs.uniq.fa |sort|uniq|wc -l >ex1-answer.txt
#divides the lines where there is a space and only keeps things after the space; then it sorts the sequences and finds unique seqs, then counts the lines and saves that number to a new file



rm seqs*  #removes all files starting with 'seqs'
cd ../ #changes to home directory
rm -rf exercise1 #forcefully removes the exercise1 directory

