import sys, codecs, re
# CREA INSERT LUOGHI
# Prevede un formato NomeLuogo_Latitudine, Longitudine_IdTipoLuogo
def creaInsert (documento):
	testo = codecs.open(documento, 'r', 'utf-8')
	allInfo = testo.read()
	infoArray = allInfo.split('\n')
	conta = 0
	lunghezza = len(infoArray) - 2
	print('INSERT INTO luogo (id, nome, latitudine, longitudine, tipo) VALUES ')
	for riga in infoArray:
		conta += 1
		srcNome = re.compile('([^_]+)_')
		nome = srcNome.findall(riga)[0]
		srcLati = re.compile('_([^,]+),')
		latitudine = srcLati.findall(riga)[0]
		srcLong = re.compile(', ([^_]+)_')
		longitudine = srcLong.findall(riga)[0]
		srcTipo = re.compile(', [^_]+_(\d+)')
		tipo = srcTipo.findall(riga)[0]
		if conta < lunghezza:
			print('(' + str(conta) + ', "' + nome + '", ' + latitudine + ', ' + longitudine + ', ' + tipo + '), ')
		else:
			print('(' + str(conta) + ', "' + nome + '", ' + latitudine + ', ' + longitudine + ', ' + tipo + ');')
creaInsert(sys.argv[1])
