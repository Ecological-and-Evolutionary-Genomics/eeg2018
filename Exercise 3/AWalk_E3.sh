##  PATRIC tutorial: Assemble, annotate, pathways, sharing

##1 Find an Illumina MiSeq bacterial dataset SRA NCBI
#psychromonas arcticus - hiseq not miseq
# SRR1587406

#login to PATRIC
#Click on "Services" tab on upper toolbar
#In drop-down menu click on "Assembly" under "Genome"
#upload to PATRIC via SRA run accession # and pste # in box and click arrow
#you will then see accession # in "selected libraries"

##2 Assemble the genome on PATRIC.
#chose the full spades assembly strategy
#kept default min contig length (300bp) and coverage (5.0)

##3 Annotate the genome on PATRIC.
#Click on "Services" tab on upper toolbar
#In drop-down menu click on "Annotate" under "Genome"
#Under "contigs" picked output from assembly
#Ran 2 annotations on contigs.fa and spades_contigs.fa

##4 Use the Similar Genome Finder tool to find the most closely related genomes in PATRIC
#Click on "Services" tab on upper toolbar
#In drop-down menu click on "Similar Genome Finder" under "Genome"
#Search with both contigs fastas and only recieved 1 match,
#Adjusted distance to 1.0 in "advanced options" and got more than 1 match
#Added a total of 6 closely related genomes to a Genome Group called Similar genomes to Psychromonas arctica.

##5 Find the Pyruvate Metabolism pathway map for your Genome Group
#Click on "Workspaces" tab on upper toolbar
#Click on "Genome groups"
#Double click on "Similar genomes to Psychromonas arctica" and then click "view" on right hand vertical green toolbar
#Click on "protien familes" tab
#Got to keywords box and type "pyruvate" and then click filter
#select all proteins and then click "pathways" on right hand vertical green toolbar
#Click "pyruvate metabolism" under "Pathway Name"
#Click "map" on right hand vertical green toolbar
#Click on Heatmap -> needed to upgrade Adobe flash and dl Flash content debugger for mac
#Can only view heatmap in safari not chrome

##6 Share your genome annotation via the PATRIC workspace at cryomics@gmail.com
#Click on "Workspaces" tab on upper toolbar
#Click on "Genome groups"
#Double click on Psychromonas arctica spades_contigs
#in upper left near green toolbar click "Browser"
#This should take you to a page where you have the  "Genome Browser" tab selected
#Takes time to load
#Share by clicking chain link in upper right corner, and copy link provided
#send link via email

##7 Submit documentary evidence PATRIC tutorial-ing under Exercise 3 on github.

