import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property titulo
	const indice = 0
	const maximoDeAutos = 15
	const velocidadDeAutos = 300
	const vehiculosPorPunto = 3

	method iniciar(){
		vestimenta.vestimentaActual(titulo)
		gameDirector.iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto)
	}
	method terminar(){
		gameDirector.terminar()
	}
	method image() = "items/" + indice.toString() + ".png"
}

object vestimenta{
    var property vestimentaActual = ""

	method meta() = vestimentaActual + "/meta.png" // Objetivo del pato
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
object vida{
	var property image = "3vidas.png"
	var property position = game.at(0, 0)
	method text() = "VIDAS"
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
		//game.keyboardEvent(reiniciar)
	}
	method iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto){
		vestimenta.actualizarVestimentas()
		game.addVisual(fondo)
		game.addVisual(score)
		game.addVisualCharacter(pato)
		game.onCollideDo(pato,{ obstaculo => obstaculo.colisiona()})
		game.onTick(velocidadDeAutos, "vehicleDrive", { self.conducirTodos() })
		maximoAutos = maximoDeAutos
		incrementoDeVehiculos = vehiculosPorPunto
		
		incrementoDeVehiculos.times({ i=>
			self.aumentarVehiculos()
		})
		ancho.times({ i =>
			self.instanciarMeta(i, vehiculosPorPunto)
		})
	}
	method aumentarVehiculos(){
		if (vehiculos.size() < maximoAutos){
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
		if (vidas == 0){
			self.perder()
		}
		vidas = vidas.max(0)
		pato.reiniciarPosicion()
	}
	method perder(){
		game.removeTickEvent("vehicleDrive")
		pato.tenerAccidente()
		game.sound("gameOver.mp3").play()
	}
	method terminar(){
		self.reiniciarConfiguracion()
	}
}
class Meta{
    const property image = vestimenta.meta()
    const vehiculosAGenerar = 0
    var property position

    method colisiona(){
    	pato.aumentarPuntaje(1)
    	pato.position(game.at(10,0))
    	game.addVisual(new Danger(position = position))
        game.removeVisual(self)
        game.sound("coin.mp3").play()
        
        vehiculosAGenerar.times({ i =>
        	gameDirector.aumentarVehiculos()
        })
    }
}
class Vehiculo{
	var property viaDerecha = true
	var property position = game.at(-10.randomUpTo(30).roundUp(), 1.randomUpTo(8).roundUp())//self.posicionInicial()
	var property velocidad = 1
	var indiceVehiculo = 1.randomUpTo(1).roundUp()
	var property image = vestimenta.vehiculo(indiceVehiculo)
	
	method conducir(){
		self.decirAlgo()
		position = position.left( self.direccion() )
		if(viaDerecha && position.x() < 1) self.reiniciarPosicion()
		if(not viaDerecha && position.x() > ancho - 1) self.reiniciarPosicion()
	}
	method direccion(){
		if (viaDerecha) return 1 * velocidad
		return -1 * velocidad
	}
	method reiniciarPosicion(){
		indiceVehiculo = 1.randomUpTo(1).roundUp()
		position.y()
		viaDerecha = position.y() % 2 == 0
		position = self.posicionInicial()
	}
	method posicionInicial(){
		const yPos = 1.randomUpTo(8).roundUp()
		viaDerecha = (yPos % 2 == 0)
		
		if(viaDerecha){
			image = vestimenta.vehiculoFlip(indiceVehiculo)
			return game.at(ancho.randomUpTo(ancho*2).roundUp(),yPos /* 100*/)
		}
		image = vestimenta.vehiculo(indiceVehiculo)
		return game.at(-ancho.randomUpTo(0).roundUp(), yPos /* 100*/)
	}
	method colisiona(){
		gameDirector.perderVida()
		game.sound("colision.mp3").play()
		//game.removeTickEvent("vehicleDrive")
	}
	method decirAlgo() {
		const frasesRandom = ["TENGO HAMBRE","CUIDAO PATO","2+2=5","CUIDAO POLLO",
								"GRUPO SIX","BIP BIP","ESTOY LOCO","ELLA NO TE AMA"]
		if (1.randomUpTo(25).roundUp() < 3){
			game.say(self,frasesRandom.anyOne())
		}	
	}
	//method text() = position.y().toString()
}
class Danger{
    const property image = "muerte2.png"
    var property position

    method colisiona(){
    	gameDirector.perderVida()
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
			game.removeTickEvent("vehicleDrive")
			score.position(game.center())
			patoWin.posicionarAlpato()
			game.removeVisual(self)
			game.addVisual(patoWin)
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

/*class Vehiculo{
  const posicionInicial = game.at(game.width()-1,suelo.position().y())
  var position = posicionInicial

  method image() = "coco1.png"
  method position() = position
  method iniciar(){
      position = posicionInicial
      game.onTick(velocidad,"moverVehiculo",{self.mover()})
  }

  method mover(){
      position = position.left(1)
      if (position.x() == -1)
      position = posicionInicial
  }
}*/








