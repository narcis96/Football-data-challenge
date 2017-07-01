# coding=utf-8
import sys
import os
import glob
import csv
argc = len(sys.argv)
if (argc == 1):
	print 'path is missing'
	sys.exit(-1)
if (argc > 2):
	print 'too much parameters'
	
	
path = sys.argv[1];
print 'scan files from ' + path + ":"
files = os.listdir(path)
countFiles = 0
dict = dict()

for file in files:
	if file.endswith(".csv"):
		print path + "/"+ file
		with open(path + "/"+ file) as csvfile:
			countFiles = countFiles + 1
			spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
			for row in spamreader:
				index = row[0]
				if index in dict:
					if dict[index][0] == row[1]:
						dict[index].append(row[1])
				else:
					dict[index] = [row[1]]		
print "there is " + str(len(dict)) + " samples"
print "there is " + str(countFiles) + " files"
file = open('newtests.csv', 'w')
testsCreated = 0
for index in dict:
	if len(dict[index]) == countFiles:
		file.write(str(index) + "," + dict[index][0] + "\n")
		testsCreated = testsCreated + 1
file.close()
print str(testsCreated) + " tests created"