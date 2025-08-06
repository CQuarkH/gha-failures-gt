Class {
	#name : #GHRunnersCollection,
	#superclass : #Object,
	#instVars : [
		'runners'
	],
	#category : #GHFailures
}

{ #category : #'as yet unclassified' }
GHRunnersCollection >> addLayerBorderForBoxes: container boxes: boxes atX: x layerName: layerName layerNumber: layerNumber layerBorders: layerBorders [
    "Crear un borde visual para delimitar un layer"
    | borderElements minY maxY layerHeight layerWidth borderRect labelElement |
    
    borderElements := OrderedCollection new.
    
    boxes ifNotEmpty: [
        "Calcular dimensiones del layer"
        minY := boxes inject: Float infinity into: [ :min :box | min min: box bounds top ].
        maxY := boxes inject: 0 into: [ :max :box | max max: box bounds bottom ].
        layerHeight := maxY - minY + 20.
        layerWidth := 180.
        
        "Crear rectángulo de borde"
        borderRect := BlElement new
            size: layerWidth @ layerHeight;
            background: Color transparent;
            border: (BlBorder paint: Color lightGray width: 1);
            relocate: x @ (minY - 10);
            yourself.
        
        container addChild: borderRect.
        borderElements add: borderRect.
        
        "Crear etiqueta del layer"
        labelElement := BlTextElement new
            text: layerName asRopedText;
            relocate: (x + 5) @ (minY - 25);
            yourself.
        
        container addChild: labelElement.
        borderElements add: labelElement.
    ].
    
    layerBorders at: layerNumber put: borderElements.
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> addLayerHeader: container title: titleText atX: x atY: y [
    "Agregar encabezado de layer con estilo"
    | headerElement |
    
    headerElement := BlTextElement new
        text: (titleText asRopedText
            fontSize: 14;
            bold;
            foreground: Color darkGray);
        relocate: x @ y;
        yourself.
    
    container addChild: headerElement.
    ^ headerElement
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> addTooltipTo: element withText: tooltipText container: container [
    "Tooltip posicionado relativo al elemento, no al mouse"
    | tooltip showTooltip hideTooltip |
    
    tooltip := nil.
    
    showTooltip := [ :event |
        | elementPosition |
        tooltip ifNotNil: [ ^ self ].
        
        elementPosition := element position.
        tooltip := self createTooltipElement: tooltipText.
        tooltip userData at: #isTooltip put: true.
        
        "Posicionar debajo del elemento"
        tooltip relocate: (elementPosition x + element width + 5) @ (elementPosition y + element height + 5).
        container addChild: tooltip.
    ].
    
    hideTooltip := [ :event |
        tooltip ifNotNil: [
            [ tooltip hasParent ifTrue: [ tooltip removeFromParent ] ]
                on: Error
                do: [ :ex | "Ignorar errores de cleanup" ].
            tooltip := nil.
        ].
    ].
    
    element addEventHandler: (BlEventHandler on: BlMouseEnterEvent do: showTooltip).
    element addEventHandler: (BlEventHandler on: BlMouseLeaveEvent do: hideTooltip).
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> addZoomBehaviorTo: zoomableElement [
	"Implementa comportamiento de zoom usando BlZoomableElement"
	| minZoom maxZoom zoomStep |
	
	minZoom := 0.1.
	maxZoom := 5.0.
	zoomStep := 0.1.
	
	"Configurar valores iniciales del zoom"
	zoomableElement zoomLevel: 1.0.
	zoomableElement zoomCenter: 0.5 @ 0.5.
	
	zoomableElement addEventHandler: (BlEventHandler
		on: BlMouseWheelEvent
		do: [ :event |
			| currentZoom newZoom |
			
			"Obtener zoom actual"
			currentZoom := zoomableElement zoomLevel.
			
			"Calcular nuevo zoom"
			event vector y > 0
				ifTrue: [ newZoom := (currentZoom + zoomStep) min: maxZoom ]  "Zoom in"
				ifFalse: [ newZoom := (currentZoom - zoomStep) max: minZoom ]. "Zoom out"
			
			"Aplicar nuevo zoom"
			zoomableElement zoomLevel: newZoom.
			
			event consumed: true ]).
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> clearConnectionsByType: connectionType connections: connections container: container [
    "Limpiar conexiones de un tipo específico"
    | connectionsToRemove |
    
    connectionsToRemove := OrderedCollection new.
    
    connections do: [ :connection |
        | connType |
        
        connType := connection userData 
            ifNotNil: [ :userData | userData at: #connectionType ifAbsent: [ nil ] ]
            ifNil: [ nil ].
        
        connType = connectionType ifTrue: [
            (container hasChild: connection) ifTrue: [
                container removeChild: connection ].
            connectionsToRemove add: connection ].
    ].
    
    connectionsToRemove do: [ :conn | connections remove: conn ].
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> clearConnectionsFromLayer: layerNumber connections: connections container: container [
    "Limpiar conexiones que SALEN desde un layer específico en adelante"
    | connectionsToRemove |
    
    connectionsToRemove := OrderedCollection new.
    
    connections do: [ :connection |
        | fromLayer toLayer |
        
        connection userData ifNotNil: [ :userData |
            fromLayer := userData at: #fromLayer ifAbsent: [ nil ].
            toLayer := userData at: #toLayer ifAbsent: [ nil ].
            
            "Eliminar conexiones que salen desde este layer o layers superiores"
            (fromLayer notNil and: [ fromLayer >= layerNumber ]) ifTrue: [
                (container hasChild: connection) ifTrue: [
                    container removeChild: connection ].
                connectionsToRemove add: connection ].
        ].
    ].
    
    connectionsToRemove do: [ :conn | connections remove: conn ].
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> clearLayersFrom: layerNumber layerBoxes: layerBoxes container: container layerBorders: layerBorders [
    "Limpiar layers desde el número especificado en adelante"
    | layersToRemove bordersToRemove |
    
    layersToRemove := layerBoxes keys select: [ :key | key >= layerNumber ].
    bordersToRemove := layerBorders keys select: [ :key | key >= layerNumber ].
    
    "Remover las cajas de los layers"
    layersToRemove do: [ :layerKey |
        | boxes |
        boxes := layerBoxes at: layerKey.
        boxes do: [ :box | 
            (container hasChild: box) ifTrue: [
                container removeChild: box ]].
        layerBoxes removeKey: layerKey.
    ].
    
    "Remover los bordes de los layers"
    bordersToRemove do: [ :layerKey |
        | borderElements |
        borderElements := layerBorders at: layerKey.
        borderElements do: [ :element | 
            (container hasChild: element) ifTrue: [
                container removeChild: element ]].
        layerBorders removeKey: layerKey.
    ].
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createAttemptsLayer: attempts onContainer: container atX: x withBoxSpacing: spacing layerBoxes: layerBoxes selectedElements: selectedElements layerSpacing: layerSpacing parentRun: parentRun connections: connections parentBox: parentBox layerBorders: layerBorders [
	"Crear el layer de attempts (segunda columna)"

	| currentY boxes maxTime minTime timeRange |
	currentY := 80.
	boxes := OrderedCollection new.	"Calcular rangos para normalización"
	maxTime := attempts
			inject: 0
			into: [ :max :att | max max: att getExecutionTime ].
	minTime := attempts
			inject: Float infinity
			into: [ :min :att | min min: att getExecutionTime ].
	timeRange := maxTime - minTime.

	attempts
		doWithIndex: [ :attempt :index | 
			| jobs steps box color h w time normalizedHeight connection tooltipText |
			"Métricas del attempt"
			jobs := attempt jobs size.
			time := attempt getExecutionTime.
			steps := attempt jobs inject: 0 into: [ :sum :job | sum + job steps size ].	"Normalizar altura basada en el tiempo de ejecución"
			normalizedHeight := timeRange = 0
					ifTrue: [ 30 ]
					ifFalse: [ 10 + ((time - minTime) / timeRange * 290) ].
			h := normalizedHeight.
			w := (jobs max: 1) * 4 + 8.	"Color basado en el estado del attempt o del parent run"
			color := (attempt conclusion ifNil: [ parentRun conclusion ])
					ifNotNil: [ :conclusion | self getColorForConclusion: conclusion base: Color white ]
					ifNil: [ Color lightGray ].

			tooltipText := 'Attempt #' , index asString , String cr , 'Conclusion: '
					, attempt conclusion asString , String cr , 'Time: ' , time asString , 's'
					, String cr , 'Jobs: ' , jobs asString , String cr , 'Steps: '
					, steps asString.	"Crear caja del attempt - CORREGIDO: sin desplazamiento de centro"
					
		    
			box := BlElement new
					size: w @ h;
					background: color;
					border: (BlBorder paint: Color black width: 1);
					relocate: x @ currentY;
					yourself.	"Posición desde esquina superior izquierda"	"Almacenar usando userData"
			box userData at: #attempt put: attempt.	"Interacción: mostrar jobs al hacer click"
			box userData at: #tooltipText put: tooltipText.
			
			self addTooltipTo: box withText: tooltipText container: container.
			
			box
				addEventHandler: (BlEventHandler
						on: BlClickEvent
						do: [ :event | 
							self
								clearConnectionsFromLayer: 3
								connections: connections
								container: container.
							self
								clearLayersFrom: 3
								layerBoxes: layerBoxes
								container: container
								layerBorders: layerBorders.
							self
								highlightSelected: box
								selectedElements: selectedElements
								layer: 2.

							self
								addLayerHeader: container
								title: 'JOBS'
								atX: x + layerSpacing
								atY: 50.
							self
								createJobsLayer: attempt jobs
								onContainer: container
								atX: x + layerSpacing
								withBoxSpacing: spacing
								layerBoxes: layerBoxes
								selectedElements: selectedElements
								layerSpacing: layerSpacing
								parentAttempt: attempt
								connections: connections
								parentBox: box
								layerBorders: layerBorders ]).	"Crear conexión desde parent run"
			connection := self
					createConnection: parentBox
					to: box
					connectionType: #runToAttempt
					fromLayer: 1
					toLayer: 2.
			container addChild: connection.
			connections add: connection.

			container addChild: box.
			boxes add: box.
			currentY := currentY + h + spacing ].

	"layerBoxes at: 2 put: boxes.	
	self
		addLayerBorderForBoxes: container
		boxes: boxes
		atX: x - 10
		layerName: 'Attempts'
		layerNumber: 2
		layerBorders: layerBorders"
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createConnection: fromBox to: toBox connectionType: connectionType fromLayer: fromLayer toLayer: toLayer [
    "Crear una línea de conexión entre dos elementos usando anchors relativos"
    | line color |
    
    "Color según tipo de conexión"
    color := self getConnectionColor: connectionType.
    
    "Crear línea usando BlLineElement con anchors relativos a los elementos"
    line := BlLineElement new
        border: (BlBorder paint: color width: 1);
        fromAnchor: (BlElementCenterRightAnchor element: fromBox);
        toAnchor: (BlElementCenterLeftAnchor element: toBox);
        yourself.
    
    "Marcar el tipo de conexión para limpieza posterior"
    line userData at: #connectionType put: connectionType.
    line userData at: #fromLayer put: fromLayer.
    line userData at: #toLayer put: toLayer.
    
    ^ line
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createConnectionToSpecificPoint: fromBox to: toBox connectionType: connectionType fromLayer: fromLayer toLayer: toLayer color: connectionColor [
    "Crear una línea de conexión específica entre dos elementos con color personalizado"
    | line fromBounds toBounds startPoint endPoint |
    
    line := BlLineElement new
        fromAnchor: (BlElementCenterAnchor element: fromBox);
        toAnchor: (BlElementCenterAnchor element: toBox);
        border: (BlBorder paint: connectionColor width: 2);
        yourself.
    
    "Almacenar metadata para facilitar limpieza"
    line userData: (Dictionary new
        at: #connectionType put: connectionType;
        at: #fromLayer put: fromLayer;
        at: #toLayer put: toLayer;
        yourself).
    
    ^ line
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createEventHandlerFor: block [
    "Crear un event handler genérico"
    ^ BlEventHandler 
        on: BlClickEvent 
        do: block
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createJobsLayer: jobs onContainer: container atX: x withBoxSpacing: spacing layerBoxes: layerBoxes selectedElements: selectedElements layerSpacing: layerSpacing parentAttempt: parentAttempt connections: connections parentBox: parentBox layerBorders: layerBorders [
    "Crear el layer de jobs (tercera columna)"
    | currentY boxes maxTime minTime timeRange tooltipText |
    
    currentY := 80.
    boxes := OrderedCollection new.
    
    "Calcular rangos para normalización"
    maxTime := jobs inject: 0 into: [ :max :job | max max: job executionTime ].
    minTime := jobs inject: Float infinity into: [ :min :job | min min: job executionTime ].
    timeRange := maxTime - minTime.
    
    jobs doWithIndex: [ :job :index |
        | steps box color h w time normalizedHeight connection |
        
        "Métricas del job"
        steps := job steps size.
        time := job executionTime.
        
        "Normalizar altura basada en el tiempo de ejecución"
        normalizedHeight := timeRange = 0 
            ifTrue: [ 30 ] 
            ifFalse: [ 10 + ((time - minTime) / timeRange * 190) ].
        h := normalizedHeight.
        w := (steps max: 1) * 2 + 6.
        
        "Color basado en el estado del job"
        color := (job conclusion ifNil: [ 'unknown' ])
            ifNotNil: [ :conclusion | self getColorForConclusion: conclusion base: Color white ]
            ifNil: [ Color lightGray ].
            
        tooltipText := 'Job: ', (job name ifNil: ['Job #', index asString] ifNotNil: [:n | n asString]), String cr,
            'Steps: ', steps asString, String cr,
            'Time: ', time asString, 's', String cr,
            'Conclusion: ', (job conclusion ifNil: ['unknown'] ifNotNil: [:s | s asString]). 
            
        
        box := BlElement new
            size: w @ h;
            background: color;
            border: (BlBorder paint: Color black width: 1);
            relocate: x @ currentY;  "Posición desde esquina superior izquierda"
            yourself.
        
        "Almacenar usando userData"
        box userData at: #job put: job.
        box userData at: #tooltipText put: tooltipText.
			
		self addTooltipTo: box withText: tooltipText container: container.
        
        "Interacción: mostrar steps al hacer click"
        box addEventHandler: (BlEventHandler
            on: BlClickEvent
            do: [ :event |
                self clearConnectionsFromLayer: 4 connections: connections container: container.
                self clearConnectionsByType: #jobToStep connections: connections container: container.
                self clearLayersFrom: 4 layerBoxes: layerBoxes container: container layerBorders: layerBorders.
                self highlightSelected: box selectedElements: selectedElements layer: 3.
                
                self addLayerHeader: container title: 'STEPS' atX: (x + layerSpacing) atY: 50.
                self createStepsLayer: job steps 
                     onContainer: container 
                     atX: (x + layerSpacing)
                     withBoxSpacing: spacing
                     layerBoxes: layerBoxes
                     selectedElements: selectedElements
                     layerSpacing: layerSpacing 
                     parentJob: job
                     connections: connections
                     parentBox: box
                     layerBorders: layerBorders.
            ]).
        
        "Crear conexión desde parent attempt"
        connection := self createConnection: parentBox to: box 
                          connectionType: #attemptToJob 
                          fromLayer: 2 
                          toLayer: 3.
        container addChild: connection.
        connections add: connection.
        
        container addChild: box.
        boxes add: box.
        currentY := currentY + h + spacing.
    ].
    
    layerBoxes at: 3 put: boxes.
    
    "Crear borde para este layer"
    "self addLayerBorderForBoxes: container boxes: boxes atX: (x - 10) layerName: 'Jobs' layerNumber: 3 layerBorders: layerBorders."

]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createLogLayer: step onContainer: container atX: x withBoxSpacing: spacing layerBoxes: layerBoxes selectedElements: selectedElements layerSpacing: layerSpacing connections: connections parentBox: parentBox layerBorders: layerBorders [
    "Crear el layer de log como microprint visual - solo para steps con failure"
    | logText logSegments microprintElements connection currentY boxes layerWidth margin segmentWidth segmentHeight availableWidth columnsPerRow baseX containerBox totalRows totalHeight allElements |
    
    currentY := 80.
    boxes := OrderedCollection new.
    microprintElements := OrderedCollection new.
    allElements := OrderedCollection new.
    layerWidth := 200.
    margin := 20.
    segmentWidth := 6.
    segmentHeight := 3.
    baseX := x - 10.
    
    "Calcular espacio disponible y columnas"
    availableWidth := layerWidth - (margin * 2).
    columnsPerRow := availableWidth // (segmentWidth + 1).
    
    "Obtener el log del step"
    logText := step log ifNil: [ 'No log available' ].
    logSegments := self parseLogIntoSegments: logText.
    
    "Calcular dimensiones totales del grid"
    totalRows := (logSegments size + columnsPerRow - 1) // columnsPerRow.
    totalHeight := (totalRows * (segmentHeight + 1)) - 1.
    
    "Crear una caja contenedora invisible que represente todo el microprint - CORREGIDO"
    containerBox := BlElement new
        size: layerWidth @ (totalHeight + 20);
        background: Color transparent;
        border: BlBorder empty;
        relocate: baseX @ currentY;  "Posición desde esquina superior izquierda"
        yourself.
    
    "Almacenar usando userData"
    containerBox userData at: #microprintElements put: OrderedCollection new.
    
    container addChild: containerBox.
    boxes add: containerBox.
    allElements add: containerBox.
    
    "Crear elementos visuales del microprint - CORREGIDO"
    logSegments doWithIndex: [ :segment :index |
        | microprintElement color segmentX segmentY rowIndex colIndex |
        
        color := (segment at: #isError) 
            ifTrue: [ Color red ]
            ifFalse: [ Color gray ].
        
        rowIndex := (index - 1) // columnsPerRow.
        colIndex := (index - 1) \\ columnsPerRow.
        
        "Calcular posición desde esquina superior izquierda"
        segmentX := baseX + margin + (colIndex * (segmentWidth + 1)).
        segmentY := currentY + (rowIndex * (segmentHeight + 1)).
        
        microprintElement := BlElement new
            size: segmentWidth @ segmentHeight;
            background: color;
            border: (BlBorder paint: color darker width: 0.3);
            relocate: segmentX @ segmentY;  "Sin desplazamiento de centro"
            yourself.
        
        "Almacenar usando userData"
        microprintElement userData at: #segment put: segment.
        
        "Interacción: abrir detalle al hacer click"
        microprintElement addEventHandler: (BlEventHandler
            on: BlClickEvent
            do: [ :event |
                self clearConnectionsByType: #microprintToDetail connections: connections container: container.
                self addLayerHeader: container title: 'LOG DETAIL' atX: (x + layerSpacing) atY: 50.
                self openDetailedLogLayer: segment 
                     step: step 
                     onContainer: container 
                     atX: (x + layerWidth + (margin * 2))
                     withSpacing: spacing
                     layerBoxes: layerBoxes
                     connections: connections
                     parentBox: microprintElement
                     layerBorders: layerBorders
                     segmentIndex: index ]).
        
        container addChild: microprintElement.
        
        "Registrar elemento en el contenedor para limpieza posterior"
        (containerBox userData at: #microprintElements) add: microprintElement.
        allElements add: microprintElement.
    ].
    
    "Crear conexión desde parent step AL CONTENEDOR"
    connection := self createConnection: parentBox to: containerBox
                       connectionType: #stepToLog
                       fromLayer: 4
                       toLayer: 5.
    container addChild: connection.
    connections add: connection.
    
    layerBoxes at: 5 put: allElements.
    
    "Crear borde"
    "self addLayerBorderForBoxes: container 
         boxes: boxes 
         atX: baseX 
         layerName: 'Log Microprint' 
         layerNumber: 5 
         layerBorders: layerBorders."
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createRunsLayer: runs onContainer: container atX: x withBoxSpacing: spacing layerBoxes: layerBoxes selectedElements: selectedElements layerSpacing: layerSpacing connections: connections layerBorders: layerBorders [
	"Crear el layer de runs (columna izquierda)"

	| currentY boxes maxTime minTime timeRange |
	currentY := 80.
	boxes := OrderedCollection new.	"Calcular rangos para normalización"
	maxTime := runs
			inject: 0
			into: [ :max :run | max max: run getTotalExecutionTime ].
	minTime := runs
			inject: Float infinity
			into: [ :min :run | min min: run getTotalExecutionTime ].
	timeRange := maxTime - minTime.

	runs
		doWithIndex: [ :runner :index | 
			| time jobs box color h w normalizedHeight tooltipText |
			"Métricas del run"
			time := runner getTotalExecutionTime.
			jobs := runner attempts inject: 0 into: [ :sum :att | sum + att jobs size ].	"Normalizar altura basada en el tiempo de ejecución"
			normalizedHeight := timeRange = 0
					ifTrue: [ 30 ]
					ifFalse: [ 10 + ((time - minTime) / timeRange * 50) ].
			h := normalizedHeight.
			w := (jobs max: 1) * 3 + 10.	"Color según conclusión"
			color := self getColorForConclusion: runner conclusion base: Color white.
			
			tooltipText := 'Run: ', runner name asString, String cr,
                      'Conclusion: ', runner conclusion asString, String cr,
                      'Time: ', time asString, 's', String cr,
                      'Jobs: ', jobs asString, String cr,
                      'Attempts: ', runner attempts size asString.
					
			box := BlElement new
					size: w @ h;
					background: color;
					border: (BlBorder paint: Color black width: 1);
					relocate: x @ currentY;
					yourself.	"Posición desde esquina superior izquierda"	
					"Almacenar el runner usando el sistema de propiedades de Bloc"
			box userData at: #runner put: runner.	"Interacción: mostrar attempts al hacer click"
			box userData at: #tooltipText put: tooltipText.
			
			self addTooltipTo: box withText: tooltipText container: container.
			
			box
				addEventHandler: (BlEventHandler
						on: BlClickEvent
						do: [ :event | 
							self
								clearConnectionsFromLayer: 2
								connections: connections
								container: container.
							self
								clearLayersFrom: 2
								layerBoxes: layerBoxes
								container: container
								layerBorders: layerBorders.
							self
								clearConnectionsByType: #runToAttempt
								connections: connections
								container: container.
							self
								highlightSelected: box
								selectedElements: selectedElements
								layer: 1.

							self
								addLayerHeader: container
								title: 'ATTEMPTS'
								atX: x + layerSpacing
								atY: 50.
							self
								createAttemptsLayer: runner attempts
								onContainer: container
								atX: x + layerSpacing
								withBoxSpacing: spacing
								layerBoxes: layerBoxes
								selectedElements: selectedElements
								layerSpacing: layerSpacing
								parentRun: runner
								connections: connections
								parentBox: box
								layerBorders: layerBorders ]).

			container addChild: box.
			boxes add: box.
			currentY := currentY + h + spacing	"Avanzar Y por altura + espaciado" ].

	"layerBoxes at: 1 put: boxes.	Crear borde para Layer 1
	self
		addLayerBorderForBoxes: container
		boxes: boxes
		atX: 30
		layerName: 'Runs'
		layerNumber: 1
		layerBorders: layerBorders"
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createStepsLayer: steps onContainer: container atX: x withBoxSpacing: spacing layerBoxes: layerBoxes selectedElements: selectedElements layerSpacing: layerSpacing parentJob: parentJob connections: connections parentBox: parentBox layerBorders: layerBorders [
	"Crear el layer de steps (cuarta columna)"

	| currentY boxes maxTime minTime timeRange |
	currentY := 80.
	boxes := OrderedCollection new.	"Calcular rangos para normalización"
	maxTime := steps inject: 0 into: [ :max :step | max max: step executionTime ].
	minTime := steps
			inject: Float infinity
			into: [ :min :step | min min: step executionTime ].
	timeRange := maxTime - minTime.

	steps
		doWithIndex: [ :step :index | 
			| box color h w time normalizedHeight connection tooltipText |
			time := step executionTime.	"Normalizar altura basada en el tiempo de ejecución"
			normalizedHeight := timeRange = 0
					ifTrue: [ 30 ]
					ifFalse: [ 10 + ((time - minTime) / timeRange * 90) ].
			h := normalizedHeight.
			w := 15.	"Color basado en el estado del step"
			color := (step conclusion ifNil: [ 'unknown' ])
					ifNotNil: [ :conclusion | self getColorForConclusion: conclusion base: Color white ]
					ifNil: [ Color lightGray ].

			tooltipText := 'Step: '
					, (step name ifNil: [ 'Step #' , index asString ] ifNotNil: [ :n | n asString ])
					, String cr , 'Conclusion: '
					, (step conclusion ifNil: [ 'unknown' ] ifNotNil: [ :st | st asString ])
					, String cr , 'Execution Time: ' , step executionTime asString, 's' .	
			
			box := BlElement new
					size: w @ h;
					background: color;
					border: (BlBorder paint: Color black width: 1);
					relocate: x @ currentY;
					yourself.	"Posición desde esquina superior izquierda"	"Almacenar usando userData"
					
			box userData at: #step put: step.	"Interacción: mostrar log si es failure"
			box userData at: #tooltipText put: tooltipText.
			self addTooltipTo: box withText: tooltipText container: container.
			
			box
				addEventHandler: (BlEventHandler
						on: BlClickEvent
						do: [ :event | 
							| stepConclusion |
							stepConclusion := step conclusion ifNil: [ 'unknown' ].	"Solo mostrar log si el step tiene conclusion 'failure'"
							stepConclusion = 'failure'
								ifTrue: [ self
										clearConnectionsFromLayer: 5
										connections: connections
										container: container.
									self
										clearLayersFrom: 5
										layerBoxes: layerBoxes
										container: container
										layerBorders: layerBorders.
									self
										highlightSelected: box
										selectedElements: selectedElements
										layer: 4.
									self
										clearConnectionsByType: #stepToLog
										connections: connections
										container: container.

									self
										addLayerHeader: container
										title: 'MICROPRINT'
										atX: x + layerSpacing
										atY: 50.
									self
										createLogLayer: step
										onContainer: container
										atX: x + layerSpacing
										withBoxSpacing: spacing
										layerBoxes: layerBoxes
										selectedElements: selectedElements
										layerSpacing: layerSpacing
										connections: connections
										parentBox: box
										layerBorders: layerBorders ]
								ifFalse: [  "Si no es failure, solo limpiar layers superiores"self
										clearConnectionsFromLayer: 5
										connections: connections
										container: container.
									self
										clearLayersFrom: 5
										layerBoxes: layerBoxes
										container: container
										layerBorders: layerBorders.
									self
										clearConnectionsByType: #stepToLog
										connections: connections
										container: container.
									self
										highlightSelected: box
										selectedElements: selectedElements
										layer: 4 ] ]).	"Crear conexión desde parent job"
			connection := self
					createConnection: parentBox
					to: box
					connectionType: #jobToStep
					fromLayer: 3
					toLayer: 4.
			container addChild: connection.
			connections add: connection.

			container addChild: box.
			boxes add: box.
			currentY := currentY + h + spacing ].

	layerBoxes at: 4 put: boxes	"Crear borde para este layer"	"self addLayerBorderForBoxes: container boxes: boxes atX: (x - 10) layerName: 'Steps' layerNumber: 4 layerBorders: layerBorders."
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createTooltipElement: text [
    "Crear un elemento visual para el tooltip - versión corregida"
    | lines textElements background verticalLayout |
    
    "Dividir el texto en líneas manualmente"
    lines := text lines.
    
    "Crear elementos de texto individuales para cada línea"
    textElements := lines collect: [ :line |
        BlTextElement new
            text: (line asRopedText
                fontSize: 10;
                foreground: Color white);
            constraintsDo: [ :c |
                c horizontal fitContent.
                c vertical fitContent ];
            yourself
    ].
    
    "Crear layout vertical con espaciado"
    verticalLayout := BlLinearLayout vertical.
    verticalLayout cellSpacing: 3.  "Espaciado entre elementos"
    
    "Crear fondo con layout vertical configurado"
    background := BlElement new
        layout: verticalLayout;
        background: (Color black alpha: 0.9);
        border: (BlBorder paint: Color black width: 1);
        geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
        padding: (BlInsets all: 8);  "Aumentar padding para mejor apariencia"
        constraintsDo: [ :c |
            c horizontal fitContent.
            c vertical fitContent ];
        yourself.
    
    "Agregar cada línea al fondo"
    textElements do: [ :textElement |
        background addChild: textElement
    ].
    
    ^ background
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> createTooltipFor: element withText: text [
    .
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> getColorForConclusion: conclusion base: baseColor [
    "Retornar color basado en la conclusión del elemento"
    conclusion ifNil: [ ^ Color lightGray ].
    
    conclusion asString asLowercase = 'success' ifTrue: [ ^ Color green lighter ].
    conclusion asString asLowercase = 'failure' ifTrue: [ ^ Color red lighter ].
    conclusion asString asLowercase = 'cancelled' ifTrue: [ ^ Color orange lighter ].
    conclusion asString asLowercase = 'skipped' ifTrue: [ ^ Color yellow lighter ].
    
    ^ baseColor
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> getConnectionColor: connectionType [
    "Obtener color según tipo de conexión"
    ^ connectionType caseOf: {
        [ #microprintToDetail ] -> [ Color blue alpha: 0.6 ].
    } otherwise: [ Color gray alpha: 0.6 ]
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> getLeftCenterPoint: aBox [
    "Obtener el punto del centro izquierdo usando posición absoluta"
    | position size |
    position := aBox position.  "Posición absoluta en el contenedor"
    size := aBox size.
    ^ position x @ (position y + (size y / 2))
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> getRightCenterPoint: aBox [
    "Obtener el punto del centro derecho usando posición absoluta"
    | position size |
    position := aBox position.  "Posición absoluta en el contenedor"
    size := aBox size.
    ^ (position x + size x) @ (position y + (size y / 2))
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> gtLayerDesignView: aView [
	<gtView>
	^   aView explicit
		title: 'Layer Design';
		priority: 10;
		stencil: [ self layerDesignView: 'build-and-deploy' ];
		yourself
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> highlightSelected: selectedElement selectedElements: selectedElements layer: layerNumber [
    "Destacar el elemento seleccionado y quitar highlight de otros"
    | previousSelected |
    
    "Quitar highlight anterior del mismo layer"
    previousSelected := selectedElements at: layerNumber ifAbsent: [ nil ].
    previousSelected ifNotNil: [ 
        previousSelected border: BlBorder empty.
    ].
    
    "Aplicar highlight al nuevo elemento seleccionado"
    selectedElement border: (BlBorder paint: Color red width: 2).
    
    "Guardar la nueva selección"
    selectedElements at: layerNumber put: selectedElement.
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> isErrorLine: line [
    "Determinar si una línea de log representa un error"
    | errorPatterns |
    
    errorPatterns := #('ERROR' 'FATAL' 'EXCEPTION' 'FAILED' 'FAIL:' 'Exception:' 'at java.' 'at com.' 'Caused by:' 'SQLException' 'NullPointerException' 'RuntimeException').
    
    ^ errorPatterns anySatisfy: [ :pattern |
        line asUppercase includesSubstring: pattern asUppercase ]
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> layerDesignView: workflowName [
	"Diseño por layers: Runs -> Attempts -> Jobs -> Steps"
	| container filteredRunners currentLayer layerBoxes layerPositions layerWidth layerSpacing boxSpacing selectedElements connections layerBorders space pannableElement zoomableContainer |
	
	"1) Filtrar runners por workflow específico"
	filteredRunners := runners
			select: [ :runner | runner workflow name = workflowName ].
			
	"Validar que existan runners para este workflow"
	filteredRunners isEmpty
		ifTrue: [ ^ self inform: 'No runs found for workflow: ' , workflowName ].
	
	"2) Inicialización - Container principal con tamaño fijo"
	container := BlElement new
			background: Color white;
			size: 2000 @ 1500;
			clipChildren: false;  "Importante para que el zoom no recorte contenido"
			yourself.
	
	"3) Variables de inicialización"
	currentLayer := 1.
	layerBoxes := Dictionary new.
	layerPositions := Dictionary new.
	layerWidth := 200.
	layerSpacing := 250.
	boxSpacing := 10.
	selectedElements := Dictionary new.
	connections := OrderedCollection new.
	layerBorders := Dictionary new.
	
	"4) Ordenar runs cronológicamente (más reciente primero)"
	filteredRunners := filteredRunners
			asSortedCollection: [ :a :b | a getMostRecentStartedAt >= b getMostRecentStartedAt ].
	
	"5) Crear Layer 1: Runs"
	self addLayerHeader: container title: 'RUNS' atX: 50 atY: 50.
	self
		createRunsLayer: filteredRunners
		onContainer: container
		atX: 50
		withBoxSpacing: boxSpacing
		layerBoxes: layerBoxes
		selectedElements: selectedElements
		layerSpacing: layerSpacing
		connections: connections
		layerBorders: layerBorders.
	
	"6) Título principal"
	container
		addChild: (BlTextElement new
				text: ('Layer Design: ' , workflowName , ' (' , filteredRunners size printString
						, ' runs)') asRopedText;
				relocate: 300 @ 20;
				yourself).
	
	"7) Crear container zoomable usando BlZoomableElement"
	zoomableContainer := BlZoomableElement new
		size: 2000 @ 1500;  "Tamaño fijo, no matchParent"
		clipChildren: false;  "No recortar contenido que se salga"
		contentElement: container;
		yourself.
	
	"8) Configurar zoom y agregar comportamiento con mouse wheel"
	self addZoomBehaviorTo: zoomableContainer.
	
	"9) Crear elemento pannable"
	pannableElement := zoomableContainer asPannableElement.
	
	^ pannableElement
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> loadRunnersFromDir: aDirPath [
    | dir worklist files validRunners discardedCount |
    dir := aDirPath asFileReference.
    worklist := OrderedCollection with: dir.
    files := OrderedCollection new.
    
    [ worklist isEmpty ] whileFalse: [
        | current |
        current := worklist removeFirst.
        current isDirectory
            ifTrue: [
                "Si es carpeta, añadir sus hijos a la cola"
                | children |
                children := current children.
                children ifNotEmpty: [ worklist addAll: children ]
            ]
            ifFalse: [
                "Si es fichero y acaba en .json, lo recojo"
                (current extension = 'json')
                    ifTrue: [ files add: current ]
            ].
    ].
    
    "Cargar runners validando que tengan conclusion"
    validRunners := OrderedCollection new.
    discardedCount := 0.
    
    files doWithIndex: [ :file :index |
        [
            | json dict conclusion |
            json := file readStream contents.
            dict := NeoJSONReader fromString: json.
            
            "Verificar que el dict tenga conclusion y no sea nil"
            conclusion := dict at: 'conclusion' ifAbsent: [ nil ].
            conclusion ifNotNil: [
                "Solo crear el GHRunner si tiene conclusion válida"
                validRunners add: (GHRun fromDictionary: dict).
            ] ifNil: [
                "Contar los descartados"
                discardedCount := discardedCount + 1.
            ].
            
            "Log cada 1000 archivos procesados"
            (index rem: 1000) = 0 ifTrue: [
                Transcript show: 'Progress: ', index printString, '/', files size printString, ' files processed, ', validRunners size printString, ' runners loaded, ', discardedCount printString, ' discarded'; cr.
            ]
        ] on: Error do: [ :ex |
            "Solo log errores de parsing"
            Transcript show: 'Error loading file ', index printString, ': ', file basename, ' - ', ex messageText; cr.
        ]
    ].
    
    runners := validRunners.
    
    "Mostrar resumen completo"
    Transcript show: 'SUMMARY:'; cr.
    Transcript show: 'Total files processed: ', files size printString; cr.
    Transcript show: 'Runners loaded: ', runners size printString; cr.
    Transcript show: 'Runs discarded (no conclusion): ', discardedCount printString; cr.
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> navigateToRun: run [
    "Navegar y mostrar detalles de un run específico"
    ^ self layerDesignView: run workflow name
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> openDetailedLogLayer: segment step: step onContainer: container atX: x withSpacing: spacing layerBoxes: layerBoxes connections: connections parentBox: parentBox layerBorders: layerBorders segmentIndex: segmentIndex [
    "Abrir una nueva layer a la derecha con el log detallado del segmento seleccionado"
    | logText textElements connection currentY boxes layerWidth margin detailedSegments startIndex endIndex contextSegments infoElement selectedElement |
    
    "Limpiar layer 6 si existe"
    self clearConnectionsFromLayer: 6 connections: connections container: container.
    self clearLayersFrom: 6 layerBoxes: layerBoxes container: container layerBorders: layerBorders.
    
    currentY := 80.
    boxes := OrderedCollection new.
    textElements := OrderedCollection new.
    layerWidth := 500.
    margin := 15.
    selectedElement := nil.
    
    "Obtener el log completo y parsearlo"
    logText := step log ifNil: [ 'No log available' ].
    detailedSegments := self parseLogIntoSegments: logText.
    
    "Crear contexto alrededor del segmento seleccionado"
    startIndex := (segmentIndex - 3) max: 1.
    endIndex := (segmentIndex + 3) min: detailedSegments size.
    contextSegments := detailedSegments copyFrom: startIndex to: endIndex.
    
    "Crear elementos de texto para cada segmento en contexto"
    contextSegments doWithIndex: [ :contextSegment :index |
        | textElement color actualIndex isSelected indicator |
        
        actualIndex := startIndex + index - 1.
        isSelected := actualIndex = segmentIndex.
        
        "Color basado en el tipo y si está seleccionado"
        color := isSelected 
            ifTrue: [ Color blue ]
            ifFalse: [ (contextSegment at: #isError) ifTrue: [ Color red ] ifFalse: [ Color black ] ].
        
        "Crear elemento de texto - CORREGIDO"
        textElement := BlTextElement new
            text: (contextSegment at: #text) asRopedText;
            relocate: ((x - 10) + margin) @ currentY;  "Sin desplazamiento de centro"
            yourself.
        
        "Aplicar formato especial al segmento seleccionado"
        isSelected ifTrue: [
            textElement text 
                foreground: Color blue;
                bold.
            selectedElement := textElement.
            
            "Agregar indicador visual - CORREGIDO"
            indicator := BlElement new
                size: (layerWidth - (margin * 2)) @ 15;
                border: (BlBorder paint: Color blue width: 1);
                background: Color transparent;
                relocate: ((x - 10) + margin) @ currentY;  "Sin desplazamiento de centro"
                yourself.
            container addChild: indicator.
            boxes add: indicator.
        ].
        
        "Almacenar usando userData"
        textElement userData at: #contextSegment put: contextSegment.
        
        container addChild: textElement.
        textElements add: textElement.
        boxes add: textElement.
        
        currentY := currentY + (isSelected ifTrue: [ 20 ] ifFalse: [ 15 ]).
    ].
    
    "Agregar información del segmento seleccionado al final - CORREGIDO"
    infoElement := BlTextElement new
        text: ('Selected: Segment ', segmentIndex asString, String cr,
               'Type: ', ((segment at: #isError) ifTrue: ['ERROR'] ifFalse: ['INFO']), String cr,
               'Context: ±3 segments around selection') asRopedText;
        relocate: ((x - 10) + margin) @ currentY;  "Sin desplazamiento de centro"
        yourself.
    
    container addChild: infoElement.
    boxes add: infoElement.
    
    "Crear conexión hacia el elemento seleccionado específicamente"
    selectedElement ifNotNil: [
        connection := self createConnection: parentBox 
                           to: selectedElement 
                           connectionType: #microprintToDetail
                           fromLayer: 5
                           toLayer: 6.
                           
        container addChild: connection.
        connections add: connection.
    ].
    
    layerBoxes at: 6 put: boxes.
    
    "Crear borde para este layer"
    "self addLayerBorderForBoxes: container boxes: boxes atX: (x - 10) layerName: 'Log Detail' layerNumber: 6 layerBorders: layerBorders."
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> parseLogIntoSegments: logText [
    "Parsear el log en segmentos clasificándolos por tipo"
    | segments lines |
    
    segments := OrderedCollection new.
    lines := logText lines.
    
    lines do: [ :line |
        | segment isError |
        
        "Determinar si la línea es un error basándose en patrones comunes"
        isError := self isErrorLine: line.
        
        "Crear objeto segmento"
        segment := Dictionary new
            at: #text put: line;
            at: #isError put: isError;
            yourself.
        
        segments add: segment.
    ].
    
    ^ segments
]

{ #category : #'as yet unclassified' }
GHRunnersCollection >> runners [
    ^ runners
]
