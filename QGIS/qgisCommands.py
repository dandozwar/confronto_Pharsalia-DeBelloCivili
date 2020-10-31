# Programma da eseguire nella consolle Python di QGIS

#Genera un'ellisse e la aggiunge a un layer PH
layer =  QgsVectorLayer('Polygon', 'CentroPH' , "memory")
pr = layer.dataProvider() 
poly = QgsFeature()
angolo = -(-15.24) - 90
ellipse = QgsEllipse(QgsPoint(20.98, 39.01), 1159.92/111.02, 557.05/111.02, angolo)
polygon1 = ellipse.points(200)
polygon2 = []
for point in polygon1:
    polygon2.append(QgsPointXY(point))
poly.setGeometry(QgsGeometry.fromPolygonXY([polygon2]))
pr.addFeatures([poly])
layer.updateExtents()
QgsProject.instance().addMapLayers([layer])

#Genera un'ellisse e la aggiunge a un layer PHr
layer =  QgsVectorLayer('Polygon', 'RomaPH' , "memory")
pr = layer.dataProvider() 
poly = QgsFeature()
angolo = -(-13.51) - 90
ellipse = QgsEllipse(QgsPoint(12.48, 41.89), 1393.19/111.02, 574.45/111.02, angolo)
polygon1 = ellipse.points(200)
polygon2 = []
for point in polygon1:
    polygon2.append(QgsPointXY(point))
poly.setGeometry(QgsGeometry.fromPolygonXY([polygon2]))
pr.addFeatures([poly])
layer.updateExtents()
QgsProject.instance().addMapLayers([layer])

#Genera un'ellisse e la aggiunge a un layer BC
layer =  QgsVectorLayer('Polygon', 'CentroBC' , "memory")
pr = layer.dataProvider() 
poly = QgsFeature()
angolo = -(-11.51) - 90
ellipse = QgsEllipse(QgsPoint(13.42, 40.74), 935.58/111.02, 314.97/111.02, angolo)
polygon1 = ellipse.points(200)
polygon2 = []
for point in polygon1:
    polygon2.append(QgsPointXY(point))
poly.setGeometry(QgsGeometry.fromPolygonXY([polygon2]))
pr.addFeatures([poly])
layer.updateExtents()
QgsProject.instance().addMapLayers([layer])

#Genera un'ellisse e la aggiunge a un layer BCr
layer =  QgsVectorLayer('Polygon', 'RomaBC' , "memory")
pr = layer.dataProvider() 
poly = QgsFeature()
angolo = -(-11.71) - 90
ellipse = QgsEllipse(QgsPoint(12.48, 41.89), 941.32/111.02, 332.81/111.02, angolo)
polygon1 = ellipse.points(200)
polygon2 = []
for point in polygon1:
    polygon2.append(QgsPointXY(point))
poly.setGeometry(QgsGeometry.fromPolygonXY([polygon2]))
pr.addFeatures([poly])
layer.updateExtents()
QgsProject.instance().addMapLayers([layer])