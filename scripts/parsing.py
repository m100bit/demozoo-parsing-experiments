import pandas

global LINK
indicator, linkindicator, janewayindicator, ftpindicator = int(), int(), int(), int()

open('id.txt', 'w').close() # clear previous id.txt file if exists
data = pandas.read_csv('prods.csv')
data.sort_values(data.columns[3],axis=0,inplace=True)
for x in range(data.iloc[-1,3]):
	links = data.loc[data[data.columns[3]] == x]
	indicator, janewayindicator, linkindicator, ftpindicator = 0, 0, 0, 0

	for n in range(0,len(links)):
		if links.iloc[n,4] == 't' and (links.iloc[n,1] == 'SceneOrgFile' or links.iloc[n,1] == 'FujiologyFile' or links.iloc[n,1] == 'AmigascneFile' or links.iloc[n,1] == 'ModlandFile' or links.iloc[n,2].startswith('http://csdb.dk/') or links.iloc[n,2].startswith('http://www.csdb.dk') or links.iloc[n,2].startswith('https://www.csdb.dk') or links.iloc[n,2].startswith('http://aminet.net') or links.iloc[n,2].startswith('https://defacto2.net') or links.iloc[n,2].startswith('http://defacto2.net') or links.iloc[n,2].startswith('https://amp.dascene.net') or links.iloc[n,2].startswith('http://amp.dascene.net') or links.iloc[n,2].startswith('https://csdb.dk') or links.iloc[n,2].startswith('https://hvsc.csdb.dk') or links.iloc[n,2].startswith('https://files.zxdemo.org') or links.iloc[n,2].startswith('http://hvsc.csdb.dk') or links.iloc[n,2].startswith('https://media.demozoo.org')):
			indicator = 0 # base common links checker; 1 == no common links
			break
		else:
			indicator = 1

	for n in range(0,len(links)):
		if links.iloc[n,4] == 't' and linkindicator == 0:
			LINK = links.iloc[n,2]
			linkindicator = 1 # is any download link available; 1 == link found

	for n in range(0,len(links)):
		if links.iloc[n,1] == 'KestraBitworldRelease' and janewayindicator == 0: # DOES NOT WORK FOR NOT AND I'M TIRED FIXING IT SORRY
			janewayindicator = 1 # does this prod have a Kestra BitWorld link; 1 == yes;

#	for n in range(0,len(links)):
#		if links.iloc[n,2].startswith('ftp://') and ftpindicator == 0:
#			ftpindicator = 1 # is any of download link a FTP one; 1 == there is

	if indicator == 1 and linkindicator == 1:
		idfile = open('id.txt','a')
		idfile.write('https://demozoo.org/productions/')
		idfile.write(str(x))
		idfile.write('/ - no common link detected, latest found is ')
		idfile.write(LINK)
		idfile.write('\n')
		idfile.close()

	if janewayindicator == 1 and linkindicator == 0:
		idfile = open('id.txt','a')
		idfile.write('https://demozoo.org/productions/')
		idfile.write(str(x))
		idfile.write('/ - Kestra BitWorld link found but no download links found, probably they are missing? (ignore if there is tag "lost")')
		idfile.write('\n')
		idfile.close()

#	if ftpindicator == 1:
#		idfile = open('newid.txt','a')
#		idfile.write('https://demozoo.org/productions/')
#		idfile.write(str(x))
#		idfile.write('/ - this prod have a FTP link(s) which are deprecated in many modern browsers, consider removing them.')
#		idfile.write('\n')
#		idfile.close()
