import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property titulo
	const indice = 0 // Indice de imagen en consola
	const maximoDeAutos = 15
	const velocidadDeAutos = 300 // Tiempo entre pasos para vehiculos
	const vehiculosPorPunto = 3

	method iniciar(){
		vestimenta.vestimentaActual(titulo) // Establece la vestimenta antes de iniciar
		gameDirector.iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto)
	}
	method terminar(){
		gameDirector.terminar()
	}
	method image() = "items/" + indice.toString() + ".png"
}

const alto = 10 // 10 x 50 500
const ancho = 20 // 20 x 50 1000

object gameDirector{
	const vehiculos = []
	var maximoAutos = 0
	var property vidas
	var property incrementoDeVehiculos
	
	method initialize(){
		self.reiniciarConfiguracion()
	}
	method reiniciarConfiguracion(){
		vidas = 3
		pato.puntaje(0)
		pato.reiniciarPosicion()
		score.reiniciarPosicion()
		vehiculos.clear()
	}
	method iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto){
		vestimenta.actualizarVestimentas()
		
		// Agrega visuales principales
		game.addVisual(fondo)
		game.addVisual(score)
		game.addVisualCharacter(pato)
		
		// Configura colisiones y corutinas
		game.onCollideDo(pato,{ obstaculo => obstaculo.colisiona()})
		game.onTick(velocidadDeAutos, "vehicleDrive", { self.conducirTodos() })
		
		// Se agregan los vehiculos iniciales
		maximoAutos = maximoDeAutos
		incrementoDeVehiculos = vehiculosPorPunto
		incrementoDeVehiculos.times({ i=>
			self.aumentarVehiculos()
		})
		
		// Se agregan los objetivos a recolectar
		ancho.times({ i =>
			self.instanciarMeta(i, vehiculosPorPunto)
		})
	}
	method aumentarVehiculos(){
		if (vehiculos.size() < maximoAutos){ // Se valida que no se exceda el limite
			vehiculos.add(new Vehiculo())
			self.instanciarVehiculo(vehiculos.size()-1)
		}
	}
	method cantidadDeVehiculos(){
		return vehiculos.size()-1
	}
	method instanciarVehiculo(i){
		game.addVisual(vehiculos.get(i))
		vehiculos.get(i).initialize()
	}
	method instanciarMeta(i, vehiculosPorPunto){
		game.addVisual(new Meta(position = game.at(i-1, 9), vehiculosAGenerar = vehiculosPorPunto))
	}
	method conducirTodos(){
		vehiculos.forEach({ v=>
			v.conducir()
		})
	}
	method perderVida(){
		vidas -= 1
		if (vidas == 0) self.perder() 
		vidas = vidas.max(0) // Se evita que baje de 0 en caso de suceder (aunque no deberia)
		pato.reiniciarPosicion()
	}
	method perder(){
		game.removeTickEvent("vehicleDrive") // Se pausan los vehiculos
		pato.tenerAccidente()
		game.sound("gameOver.mp3").play()
	}
	method terminar(){
		self.reiniciarConfiguracion() // Se reestablece todo
	}
}

object vestimenta{
    var property vestimentaActual = ""

	method meta() = vestimentaActual + "/meta.png" // Objetivo del pato
	method danger() = vestimentaActual + "/danger.png" // Objetivo del pato
	method pato() = "pato.png"
	method patoMorido() = "patoMorido.png"
	
	method vehiculo(i) = vestimentaActual + "/" + i.toString() + "vehiculo.png" // Auto - 1vehiculo.png
	method vehiculoFlip(i) = vestimentaActual + "/" + i.toString() + "vehiculoFlip.png" // Auto invertido - 1vehiculoFlip.png
	
	method fondo() = vestimentaActual + "/fondo.png" // Fondo del escenario
	
	method actualizarVestimentas(){
		fondo.actualizarFondo()
		patoFail.actualizarFondo()
	}
}
object vida{ // Aun sin terminar
	var property image = "3vidas.png"
	var property position = game.at(0, 0)
	method text() = "VIDAS"
}

class Meta{
    const property image = vestimenta.meta()
    const vehiculosAGenerar = 0
    var property position

    method colisiona(){
    	pato.aumentarPuntaje(1)
    	pato.reiniciarPosicion()
    	//pato.position(game.at(10,0))
    	
    	// Se reemplaza por un Danger
    	game.addVisual(new Danger(position = position))
        game.removeVisual(self)
        
        game.sound("coin.mp3").play()
        vehiculosAGenerar.times({ i =>
        	gameDirector.aumentarVehiculos() // Se agregan algunos vehiculos al recolectar el objetivo
        })
    }
}
class Vehiculo{
	var property viaDerecha = true
	var property position = game.at(-10.randomUpTo(30).roundUp(), 1.randomUpTo(8).roundUp()) // Posicion aleatoria sin normalizar
	var property velocidad = 1
	var indiceVehiculo = self.indiceAleatorioNuevo() // Define cual skin de vehiculo utiliza
	var property image = vestimenta.vehiculo(indiceVehiculo)
	
	method conducir(){
		self.decirAlgo()
		
		//Moverse
		position = position.left( self.direccion() )
		
		// Reposicionar al irse de los limites
		if(viaDerecha && position.x() < 0) self.reiniciarPosicion()
		if(not viaDerecha && position.x() > ancho - 1) self.reiniciarPosicion()
	}
	method indiceAleatorioNuevo(){
		return 0.randomUpTo(3).roundUp()
	}
	method direccion(){
		if (viaDerecha) return 1 * velocidad // Se mueve hacia la derecha
		return -1 * velocidad // Se mueve hacia la izquierda
	}
	method reiniciarPosicion(){
		indiceVehiculo = self.indiceAleatorioNuevo() // Aleatoriza nuevamente su skin
		//position.y()
		viaDerecha = position.y() % 2 == 0 // Define su direccion basado en la paridad del carril
		position = self.posicionInicial()
	}
	method posicionInicial(){
		const yPos = 1.randomUpTo(8).roundUp() // Define algun carril de los 8 disponibles
		viaDerecha = (yPos % 2 == 0)
		
		if(viaDerecha){
			image = vestimenta.vehiculoFlip(indiceVehiculo)
			return game.at(ancho.randomUpTo(ancho*2).roundUp(), yPos)
		}
		image = vestimenta.vehiculo(indiceVehiculo)
		return game.at(-ancho.randomUpTo(0).roundUp(), yPos)
	}
	method colisiona(){
		gameDirector.perderVida()
		game.sound("colision.mp3").play()
	}
	method decirAlgo() {
		const frasesRandom = ["TENGO HAMBRE","CUIDAO PATO","2+2=5","CUIDAO POLLO",
								"GRUPO SIX","BIP BIP","ESTOY LOCO","ELLA NO TE AMA"]
		
		if (1.randomUpTo(30).roundUp() < 3){ // Se define la chance de que diga algo
			game.say(self,frasesRandom.anyOne())
		}	
	}
}
class Danger{
    const property image = vestimenta.danger()
    var property position

    method colisiona(){
    	gameDirector.perderVida()
    	game.sound("colision.mp3").play()
    }
}
object fondo{
	var property image = vestimenta.fondo()
	
	method actualizarFondo(){
		image = vestimenta.fondo()
	}
	method position() = game.origin()
}
object pato{
	var property position = self.posicionInicial()
	var property puntaje = 0
	var property image = vestimenta.pato()
	
	method aumentarPuntaje(puntos){
		puntaje += puntos
		if(puntaje == 20){
			game.removeTickEvent("vehicleDrive") // Detiene los vehiculos
			score.position(game.center()) // Centra el puntaje al ganar
			patoWin.posicionarAlpato() // Reposiciona al pato para que no sea controlable
			
			// Se reemplaza por el pato no controlable
			game.removeVisual(self)
			game.addVisual(patoWin)
			
			// You win :D
			game.sound("win.mp3").play()
		}
	}
	method tenerAccidente(){
		patoFail.posicionarAlpato()
		game.removeVisual(self)
		game.addVisual(patoFail)
	}
	method reiniciarPosicion() { position = self.posicionInicial() }
	method posicionInicial() = game.at(ancho / 2 ,0)
}
object patoWin{
	var property position = pato.position()
	var property image = vestimenta.pato()
	
	method posicionarAlpato(){
		image = vestimenta.pato()
		position = pato.position()
	}
}
object patoFail{
	var property position = pato.position()
	var property image = vestimenta.patoMorido()
	
	method posicionarAlpato(){
		position = pato.position()
	}
	method actualizarFondo(){
		image = vestimenta.patoMorido()
	}
}
object score{
	var property position = self.posicionInicial()
	
	method posicionInicial(){
		return game.at(16, 0)
	}
	method reiniciarPosicion(){
		position = self.posicionInicial()
	}
	method text() = "PUNTOS: " + pato.puntaje().toString() + "VIDAS: " + gameDirector.vidas().toString()
	method colisiona(){}
}