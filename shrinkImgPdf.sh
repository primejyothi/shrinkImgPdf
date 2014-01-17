#! /usr/bin/env bash

# Script to build smaller pdf files from pdf files that were generated out of images
# 
# Extract the images from the original pdf
# Reduce the quality of the images to 10%
# Generate pdf files with 10 or 15 images.
# Combine all the pdf files generated in the previous step
# Requirements / Dependencies
# 	1. Requires convert utility from ImageMagick suite
#	2. Requires pdfunite from poppler package
#	3. Need sufficient space in the directory pointed by imgF
#		which points to /tmp/imgs
# Assumptions:
# 	1. Pdf files are generated out of images and do not contain text.
#	2. The required data is in the extracted jpg files and not in ppm files

# Prime Jyothi (primejyothi@gmail.com), 20131107
# License GPLv3

if [[ $# -ne 2 ]]
then
	echo "Usage `basename $0` inputPdf outputPdf"
	exit 1
fi

inFile=$1
outFile=$2

if [[ ! -r ${inFile} ]]
then
	echo "Unable to read input file ${inFile}"
	exit 2
fi

# Quality of image files
qty=10
# Temp image folder
imgF="/var/tmp/imgs"

# Make sure that the temporary directory is cleaned out when interrupted.
trap "rm -rf ${imgF}; exit 2" 1 2 3 

mkdir $imgF
# Extract the images from the input pdf
pdfimages -p -j "${inFile}" ${imgF}/jj

# Remove the ppm files, they are not required and take up too much space.
rm -f ${imgF}/*.ppm

# Reduce the size of the image by decreasing the quality of the images
for i in ${imgF}/*.jpg
do
	b=`basename $i`
	convert -quality ${qty}% $i ${imgF}/new_$b
done

# Generate a list of files that need to be processed
ls -1 ${imgF}/new*.jpg > ${imgF}/proc.lst

# Create pdf files in batches and join them at the end. Taking this route
# as convert was failing when 100s of files were given for processing.
batchSize=10
count=0
pCount=1
for f in `cat ${imgF}/proc.lst`
do
	args="$args $f"
	count=`expr $count + 1`
	if [[ $count -eq 10 ]]
	then
		pName=`printf %04d $pCount`
		convert ${args} ${imgF}/${pName}.pdf
		pCount=`expr $pCount + 1`
		args=""
		count=0
	fi
done
if [[ ! -z "${args}" ]]
then
		pName=`printf %04d $pCount`
	convert ${args} ${imgF}/${pName}.pdf
fi

# combine the pdf files
pdfunite ${imgF}/*.pdf "${outFile}"

# Remove the temp folder
rm -rf -- ${imgF}
exit 0
