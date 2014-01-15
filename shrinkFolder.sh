#! /usr/bin/env bash

# Shrink PDF(created out of image file) files in a given folder
# using shrinkImgPdf.sh.

if [[ $# -ne 2 ]]
then
	echo "Usage :`basename $0` sourceFolder destinationFolder"
	exit  2
fi
inDir="$1"
outDir="$2"

for i in "${inDir}" "${outDir}"
do
	if [[ ! -d $i ]]
	then
		echo "Umable to access directory $i"
		exit 2
	fi
done
ls ${inDir}/*.pdf  > pdf.lst
while read inPdf
do
	echo "Processing [$inPdf]"
	fName=`basename "$inPdf"`
	./shrinkImgPdf.sh "$inPdf" "${outDir}/${fName}"
done  < pdf.lst
