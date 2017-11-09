#!/usr/bin/python

import os
import numpy as np
from mpl_toolkits.mplot3d import Axes3D  
import matplotlib.pyplot as plt
from scipy import interpolate
import pylab as pl
import matplotlib as mpl
import matplotlib.cm as cm  
from numpy import linspace, zeros, array

s=os.getcwd()
#print s
files= os.listdir(s)
#print files
x = []
y = []

for file in files:
	if not os.path.isdir(file):
		a,b=os.path.splitext(file)
		if b == '.txt':
			f = open(file, 'r')
			read_data = f.read()
			leng = len(read_data) - 1
			print "the length of %s is %d" %(file, leng)
			for i in range(leng-1):
				f.seek(i)
				if f.read(2) == 'cg':
					#print i+1
					x.append(i+1)
					y.append(1)
			plt.plot(x, y, 'b|')
			plt.yticks(np.arange(min(y), max(y)+1, 1.0))
			plt.axis([0, leng, 0, 2])
			#plt.show()
			plt.savefig(a + '.png', format='png')
