from math import sqrt
from variables import alphalist 
from variables import hubbylist 
from variables import molname
from variables import charge
from variables import spin
import re
count=0
def linreg(X, Y):
    """
    Summary
        Linear regression of y = ax + b
    Usage
        real, real, real = linreg(list, list)
    Returns coefficients to the regression line "y=ax+b" from x[] and y[], and R^2 Value
    """
    if len(X) != len(Y):  raise ValueError, 'unequal length'
    N = len(X)
    Sx = Sy = Sxx = Syy = Sxy = 0.0
    for x, y in map(None, X, Y):
        Sx = Sx + x
        Sy = Sy + y
        Sxx = Sxx + x*x
        Syy = Syy + y*y
        Sxy = Sxy + x*y
    det = Sxx * N - Sx * Sx
    a, b = (Sxy * N - Sy * Sx)/det, (Sxx * Sy - Sx * Sxy)/det
    meanerror = residual = 0.0
    for x, y in map(None, X, Y):
        meanerror = meanerror + (y - Sy/N)**2
        residual = residual + (y - a * x - b)**2
    RR = 1 - residual/meanerror
    ss = residual / (N-2)
    Var_a, Var_b = ss * N / det, ss * Sxx / det
    return a, b, RR

if __name__=='__main__':
    bareresp=alphalist[1:1000]
    convresp=alphalist[1:1000]
    xtraresp=alphalist[1:1000]
    alphalist2=alphalist[1:1000]
    hubbylist2=alphalist[1:1000]
    for lines in range(0,len(alphalist)-1):
      bareresp[lines]=0.0
      convresp[lines]=0.0
      xtraresp[lines]=0.0
      alphalist2[lines]=float(alphalist[lines+1])
      hubbylist2[lines]=0.0
    hubbylist2.append(0.0)
    results=open('ucalc.dat','w')
    results.write('#U_in U_out Chi_0 Chi_f\n')
    if (len(hubbylist) > 1):
       uinl=hubbylist[0:1000]
       uoutl=hubbylist[0:1000]
       for line4 in range(0,len(hubbylist)):
        if ( 'D' in hubbylist[line4]):
          hubbylist2[line4]=hubbylist[line4].split('D')[0]+'E'+hubbylist[line4].split('D')[1]
        else:
          hubbylist2[line4]=hubbylist[line4]
    count3=-1
    for hubby in hubbylist:
      count2=-1
      count=0
      count3+=1
      for alpha in alphalist[1:1000]:
        count2+=1
        pre=molname+'.c'+str(charge)+'.s'+str(spin+1)+'.u'+str(hubby)
        file=pre+'.a'+alpha+'.out'
        output=open(file,'r').readlines()
        count=0
        for lines in range(0,len(output)):
           match=re.search('nsum',output[lines])
           if match is not None:
            if count==1:
             bareresp[count2]=float(output[lines].split()[2])
            if count==0:
             xtraresp[count2]=float(output[lines].split()[2])
            if count>=2:
             convresp[count2]=float(output[lines].split()[2])
            count+=1
      #Slope      Y-Int   R2
      chi0=linreg(alphalist2,bareresp)[0]
      chif=linreg(alphalist2,convresp)[0]
      uout=1/chi0-1/chif
      if (len(hubbylist) >1):
       uoutl[count3]=uout
       uinl[count3]=float(hubbylist2[count3])
      results.write('%s %f %f %f\n' %(hubby,uout,chi0,chif))
results.close()
# This part calculates self-consistent U from extrapolation automatically for more than 1 value of U in variables.py
count4=-1
if (len(hubbylist) > 1):
 results2=open('uscfcalc.dat','w')
 results2.write('# Ustart Uend Num.Pts. Uscf R2\n')
 for line5 in range(0,len(hubbylist)-2): 
  count4+=1
  results2.write('%f %f %f %f %f\n' %(uinl[count4],uinl[-1],len(uinl[count4:1000]),linreg(uinl[count4:1000],uoutl[count4:1000])[1],linreg(uinl[count4:1000],uoutl[count4:1000])[2]))
 results2.close() 
