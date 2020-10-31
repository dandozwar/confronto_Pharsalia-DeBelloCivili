import sys, codecs, re
# CREA INSERT PHARSALIA
# Prevede un formato Libro-Verso_Testo_IdLuogo
def creaInsert (documento):
	testo = codecs.open(documento, 'r', 'utf-8')
	allInfo = testo.read()
	infoArray = allInfo.split('\n')
	conta = 0
	lunghezza = len(infoArray) - 2
	print('INSERT INTO corrispondenza (testo, opera, libro, verso, luogo) VALUES ')
	for riga in infoArray:
		conta += 1
		srcLibro = re.compile('([^-]+)-')
		libro = srcLibro.findall(riga)[0]
		srcVerso = re.compile('-([^_]+)_')
		verso = srcVerso.findall(riga)[0]
		srcTesto = re.compile('_([^_]+)_')
		testo = srcTesto.findall(riga)[0]
		srcLuogo =	re.compile('_([^_]+)')
		luogo = srcLuogo.findall(riga)[1]
		if conta < lunghezza:
			print('("' + testo + '", 1, ' + libro + ', ' + verso + ', ' + luogo + '), ')
		else:
			print('("' + testo + '", 1, ' + libro + ', ' + verso + ', ' + luogo + ');')
creaInsert(sys.argv[1])
