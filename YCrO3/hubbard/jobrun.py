import os
import time
import math
import glob
from libraries import *
from variables import *
nat=open(molname+'.xyz','r').readline()
geom=open(molname+'.xyz','r').readlines()
ats,species,nel=[],[],0
for n in range(0,len(geom)):
       ats.append(geom[n].split()[0])
       if (len(geom[n].split()) == 5):
          typnum=int(geom[n].split()[4])
          geom[n]=geom[n].split()[0]+' '+geom[n].split()[1]+' '+geom[n].split()[2]+' '+geom[n].split()[3]+'\n'
for specs in pseudos.keys():
       nel+=ats.count(specs)*pseudos[specs][2]
       if ats.count(specs):
            species.append(specs)
nat,ntyp=len(geom)-2,len(species)
nel-=charge
nelup,neldw=(nel+spin)/2,(nel-spin)/2
cell=runs[job][1]
for hubby in hubbylist:
  for alpha in alphalist:

       pre=molname+'.c'+str(charge)+'.s'+str(spin+1)+'.u'+str(hubby)
       title=molname+', multiplicity='+str(spin+1)+', U='+str(hubby)
       file=pre+'.a'+str(alpha)
       filein,fileout=file+'.in',file+'.out'
       if ( alpha=='1D-40'):
         post=''
       else:
         post='a'+alpha
       input = open(filein, 'w')

       input.write('&CONTROL\n')
       input.write('title = "%s"\n' %(title))
       input.write('calculation = "%s",\n' %(runs[job][0]))
       input.write('restart_mode = "from_scratch",\n')
       input.write('prefix = "%s",\n' %(pre))
       input.write('outdir = "%s/%s",\n' %(scratchdir,post))
       input.write('pseudo_dir = "%s",\n' %(pseudodir))
       input.write('wf_collect=.TRUE.\n')
       input.write('/\n')

       input.write('&SYSTEM\n')
       input.write('ibrav=8,degauss=0.01,celldm(1)=%f,celldm(2)=1.05749,celldm(3)=1.44098,ecutwfc=%i, ecutrho=%i,\n' %(cell,ecutwfc,ecutrho))
       for at in range(0,ntyp):
            if ( at == 2 ):
                 input.write('starting_magnetization(%i)=0.5,' %(at+1))
            else:
                 input.write('starting_magnetization(%i)=0.0,' %(at+1))
       input.write('\n nspin=2,occupations="smearing",smearing="gaussian",\n')
       input.write('nat=%i,ntyp=%i,tot_charge=%f,tot_magnetization=%f\n' % (nat,ntyp,charge,spin))
       # if running PW 4.1.2 or earlier comment above line and uncomment line below.
       #input.write('nat=%i,ntyp=%i,nelec=%f,nelup=%f,neldw=%f\n' %(nat,ntyp,nel,nelup,neldw))
       input.write('lda_plus_U=.true.,Hubbard_U(%i)=%s,Hubbard_alpha(%i)=%s\n' %(typnum,hubby,typnum,alpha))
       input.write('/\n')

       input.write('&ELECTRONS\n')
       if ( alpha != '1D-40' ):
         input.write('startingpot="file"\n')
         conv2=conv.split('-')[0]+'-'+str(int(conv.split('-')[1])+2)
         diago=conv.split('-')[0]+'-'+str(int(conv.split('-')[1])+4)
       else:
         conv2=conv
         diago='1D-2'
       input.write('mixing_beta=%s,conv_thr=%s,diago_thr_init=%s,electron_maxstep=%i\n/\n' %(beta,conv2,diago,estep))

       input.write('ATOMIC_SPECIES\n')
       for at in range(0,ntyp):
         input.write(species[at]+' '+pseudos[species[at]][1]+' '+pseudos[species[at]][0]+'\n')

       input.write('ATOMIC_POSITIONS (angstrom)\n')
       for at in range(2,nat+2):
         input.write(geom[at])

       input.write('K_POINTS (automatic)\n 3 3 3 0 0 0\n')
       input.close()

       if ( alpha != '1D-40' ):
         os.system('mkdir %s/%s\n' %(scratchdir,post))
         os.system('cp -pr %s/%s* %s/%s\n' %(savedir,pre,scratchdir,post))
       if ( para != '' ):
         parafront=para+' -np '+str(cpu)
       else:
         parafront=''
       os.system('%s %s/%s < %s.in > %s.out \n' %(parafront,bindir,execname,file,file))
       if ( alpha == '1D-40' ):
         os.system('cp -pr %s/%s* %s/\n' %(scratchdir,pre,savedir))
       if ( alpha != '1D-40' ):
         os.system('rm -rf %s/%s/ \n' %(scratchdir,post))
print "All done\n"
