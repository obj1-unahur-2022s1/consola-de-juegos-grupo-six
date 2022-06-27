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
		gameDirector.iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto)
	}

	method terminar(){
		gameDirector.terminar()
	}
	method image() = "items/" + indice.toString() + ".png"
	//method text() = titulo.toString()
}

const alto = 10
const ancho = 20

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
		pollo.puntaje(0)
		pollo.reiniciarPosicion()
		score.reiniciarPosicion()
		vehiculos.clear()
		//game.keyboardEvent(reiniciar)
	}
	method iniciar(maximoDeAutos, velocidadDeAutos, vehiculosPorPunto){
		game.addVisual(score)
		game.addVisualCharacter(pollo)
		game.onCollideDo(pollo,{ obstaculo => obstaculo.colisiona()})
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
		pollo.reiniciarPosicion()
	}
	method perder(){
		game.removeTickEvent("vehicleDrive")
		pollo.tenerAccidente()
	}
	method terminar(){
		self.reiniciarConfiguracion()
	}
}
class Meta{
    const property image = "fizz.png"
    const vehiculosAGenerar = 0
    var property position

    method colisiona(){
    	pollo.aumentarPuntaje(1)
    	pollo.position(game.at(10,0))
    	game.addVisual(new Danger(position = position))
        game.removeVisual(self)
        
        vehiculosAGenerar.times({ i =>
        	gameDirector.aumentarVehiculos()
        })
    }
}
class Vehiculo{
	var property viaDerecha = true
	var property position = game.at(-10.randomUpTo(30).roundUp(), 1.randomUpTo(8).roundUp())//self.posicionInicial()
	var property velocidad = 1//(0.05).randomUpTo(0.5)
	
	method conducir(){
		position = position.left( self.direccion() )
		if(viaDerecha && position.x() < 1) self.reiniciarPosicion()
		if(not viaDerecha && position.x() > ancho - 1) self.reiniciarPosicion()
	}
	method direccion(){
		if (viaDerecha) return 1 * velocidad
		return -1 * velocidad
	}
	method reiniciarPosicion(){
		position.y()
		viaDerecha = position.y() % 2 == 0
		position = self.posicionInicial()
	}
	method posicionInicial(){
		const yPos = 1.randomUpTo(8).roundUp()
		viaDerecha = (yPos % 2 == 0)
		
		if(viaDerecha){
			return game.at(ancho.randomUpTo(ancho*2).roundUp(),yPos /* 100*/)
		}
		return game.at(-ancho.randomUpTo(0).roundUp(), yPos /* 100*/)
	}
	method colisiona(){
		game.say(self, "COLISION!")
		gameDirector.perderVida()
		//game.removeTickEvent("vehicleDrive")
	}
	method image() = "coco1.png"
	//method text() = position.y().toString()
}
class Danger{
    const property image = "muerte2.png"
    var property position

    method colisiona(){
    	gameDirector.perderVida()
    }
}
object pollo{
	var property position = self.posicionInicial()
	var property puntaje = 0
	
	method aumentarPuntaje(puntos){
		puntaje += puntos
		if(puntaje == 20){
			game.removeTickEvent("vehicleDrive")
			score.position(game.center())
			polloWin.posicionarAlPollo()
			game.removeVisual(self)
			game.addVisual(polloWin)
		}
	}
	method tenerAccidente(){
		polloFail.posicionarAlPollo()
		game.removeVisual(self)
		game.addVisual(polloFail)
	}
	method reiniciarPosicion() { position = self.posicionInicial() }
	method posicionInicial() = game.at(ancho / 2 ,0)
	method image() = "patoFrente.png"
}
object polloWin{
	var property position = pollo.position()
	
	method image() = "patoFrente.png"
	method posicionarAlPollo(){
		position = pollo.position()
	}
}
object polloFail{
	var property position = pollo.position()
	
	method image() = "patoFail.png"
	method posicionarAlPollo(){
		position = pollo.position()
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
	method text() = "PUNTOS: " + pollo.puntaje().toString() + "VIDAS: " + gameDirector.vidas().toString()
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








