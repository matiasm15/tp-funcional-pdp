
type Partido = (Fecha, Fase, Equipo, Goles, Equipo, Goles)
type Fecha = Int
type Fase = [Char]
type Equipo = [Char]
type Goles = Int

listaEquipos :: [Equipo]
listaEquipos = ["Uruguay", "Italia", "Argentina", "Brasil", "Hungria", "Alemania", "Corea del Sur", "Holanda", "Costa Rica"]

listaPartidos :: [Partido]
listaPartidos = [(1954, "Primera Ronda", "Hungria", 9, "Corea del Sur", 0),
                 (1954, "Primera Ronda", "Hungria", 8, "Alemania", 3),
                 (1994, "Final", "Italia", 0, "Brasil", 0),
                 (1978, "Final", "Argentina", 3, "Holanda", 1),
                 (2014, "Semifinal", "Alemania", 7, "Brasil", 1),
                 (2014, "Final", "Argentina", 2, "Alemania", 0)
                ]

equiposQueCumplenTalCondicion :: (Equipo -> Bool) -> [Equipo]
equiposQueCumplenTalCondicion condicion = filter condicion listaEquipos

partidosJugadosPorUnEquipo :: Equipo -> [Partido]
partidosJugadosPorUnEquipo equipo = filter (loJugo equipo) listaPartidos

darFecha :: Partido -> Int
darFecha (fecha, _, _, _, _, _) = fecha

--1)
--a)
loGano :: Equipo -> Partido -> Bool
loGano equipo partido = (elem equipo listaEquipos) && (equipo == darGanador partido)

darGanador (_, _, primerEquipo, primerGoles, segundoEquipo, segundoGoles) | (primerGoles > segundoGoles) = primerEquipo
                                                                          | (segundoGoles > primerGoles) = segundoEquipo
                                                                          | otherwise = "Empate" 

--b)
loJugo :: Equipo -> Partido -> Bool
loJugo equipoComparado partido = elem equipoComparado (darJugadores partido)

darJugadores (_, _, primerEquipo, _, segundoEquipo, _) = [primerEquipo, segundoEquipo]

--c)
fueGoleada :: Partido -> Bool
fueGoleada partido = (darDiferencia partido) > 3

darDiferencia (_, _, _, primerGoles, _, segundoGoles) = abs(primerGoles - segundoGoles)

--2)
nuncaGanaron :: Int
nuncaGanaron = length (equiposQueCumplenTalCondicion nuncaGano)

nuncaGano equipo = all (noLoGano equipo) listaPartidos

noLoGano equipo = not . (loGano equipo)

--3)
--a)
ganaronAlgunPartido :: [Equipo]
ganaronAlgunPartido = equiposQueCumplenTalCondicion ganoAlgunPartido

ganoAlgunPartido = not . nuncaGano

--b)
recibieron7oMas :: [Equipo]
recibieron7oMas = equiposQueCumplenTalCondicion (recibioMasDe 7)

recibioMasDe cantidad equipo = any (>= cantidad) (map (darGolesRecibidos equipo) (partidosJugadosPorUnEquipo equipo))

darGolesRecibidos equipo (_, _, primerEquipo, primerGoles, segundoEquipo, segundoGoles) | (equipo == primerEquipo) = segundoGoles
                                                                                        | (equipo == segundoEquipo) = primerGoles

--c)
jugaronElMundialDel78 :: [Equipo]
jugaronElMundialDel78 = equiposQueCumplenTalCondicion (jugoElMundialDel 1978)

jugoElMundialDel fecha equipo = any (loJugo equipo) (partidosJugadosEnElMundialDel fecha)

partidosJugadosEnElMundialDel fecha = filter ((== fecha) . darFecha) listaPartidos

--d)
jugaronFinalSinGoles :: [Equipo]
jugaronFinalSinGoles = equiposQueCumplenTalCondicion (jugoFinalConTantosGoles 0)

jugoFinalConTantosGoles cantidadGoles equipo = any ((== cantidadGoles) . tuvoTantosGoles) (finalesJugadas equipo)

finalesJugadas equipo = filter fueFinal (partidosJugadosPorUnEquipo equipo)

fueFinal (_, fase, _, _, _, _) = fase == "Final"

tuvoTantosGoles (_, _, _, primerGoles, _, segundoGoles) = primerGoles + segundoGoles

--4)
-- No cambiarian mientras la cantidad de partidos fuera limitada, ya que Haskell utiliza busqueda perezosa.

-- Pruebas:

-- Main> map (loJugo "Argentina") listaPartidos
-- [False,False,False,True,False,True]

-- Main> map (loJugo "Hungria") listaPartidos
-- [True,True,False,False,False,False]

-- Main> map (loJugo "Alemania") listaPartidos
-- [False,True,False,False,True,True]

-- Main> map (loGano "Alemania") listaPartidos
-- [False,False,False,False,True,False]

-- Main> map fueGoleada listaPartidos
-- [True,True,False,False,True,False]

-- Main> nuncaGanaron
-- 6

-- Main> jugaronElMundialDel78
-- ["Argentina","Holanda"]

-- Main> jugaronFinalSinGoles
-- ["Italia","Brasil"]

-- Main> recibieron7oMas
-- ["Brasil","Alemania","Corea del Sur"]

-- Main> ganaronAlgunPartido
-- ["Argentina","Hungria","Alemania"]
