shrinkImgPdf.sh
===============
Script to build smaller pdf files from pdf files that were generated out of image files.

Extract the images from the original pdf
Reduce the quality of the images to 10%
Generate pdf files with 10 or 15 images.
Combine all the pdf files generated in the previous step

Requirements / Dependencies
 	1. Requires convert utility from ImageMagick suite
	2. Requires pdfunite from poppler package
	3. Need sufficient space in the directory pointed by imgF
		which points to /tmp/imgs
Assumptions:
 	1. Pdf files are generated out of images and do not contain text.
	2. The required data is in the extracted jpg files and not in ppm files


shrinkFolder.sh
===============
Driver script for shrinkImgPdf.sh. Shrinks all PDF[1] files present in a given folder.
[1] Applicable only to PDF files generated out of images.
