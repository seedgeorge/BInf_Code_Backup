Order of business

1. Pull out mutation and copy number data from cbioportal for desired datasets
2. Put this data in Data/datasetname/Raw
3. Trim the data down to genename:numberOfvariants and place in /datasetname/Trim
4. Run InputMaker.pl script to generate combined datafiles from mut and copy data
"5. Run SeqHet.pl on each file in the /Input directory, using default reference document and a threshold of zero, output is grouped into runs by day"
6. Run the Summariser.pl script to generate summaries of all data in a run
