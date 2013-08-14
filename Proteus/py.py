import os
for i in ['FTDI','USERDVC','USERPKG']:
    C='cp "C:\Program Files (x86)\Labcenter Electronics\Proteus 7 Professional\LIBRARY\%s.lib" %s.lib'%(i,i)
    print C,os.system(C)
raw_input('.')
