import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property color 

	method iniciar(){
		gameDirector.iniciar()
   //     game.addVisual(object{method position()= game.center() method text() = "Juego "+color + " - <q> para salir"})		
	}

	method terminar(){
		gameDirector.terminar()
	}
	method image() = "juego" + color + ".png"


}

const alto = 10
const ancho = 20


object gameDirector{
	const vehiculos = [
		//new Vehiculo(),
		new Vehiculo()
	]
	var property vidas
	
	method initialize(){
		// Configuracion de console
		game.height(alto)
		game.width(ancho)
		game.ground("ground.png")
		game.boardGround("scene.png")
		
		// Configuracion del juego
		self.reiniciarConfiguracion()
	}
	method reiniciarConfiguracion(){
		vidas = 3
		pollo.puntaje(0)
		pollo.reiniciarPosicion()
		game.onTick(120, "vehicleDrive", { self.conducirTodos() })
		//game.keyboardEvent(reiniciar)
	}
	method iniciar(){
		game.addVisual(score)
		game.addVisualCharacter(pollo)
		game.onCollideDo(pollo,{ obstaculo => obstaculo.colisiona()})
		self.cantidadDeVehiculos().times({ i =>
			game.schedule(i * 80, {self.instanciarVehiculo(i)})
		})
		
		ancho.times({ i =>
			self.instanciarMeta(i)
		})
	}
	method aumentarVehiculos(){
		//3.times({ i =>
		if (vehiculos.size() < 15){
			vehiculos.add(new Vehiculo())
			//self.instanciarVehiculo(vehiculos.size()-1 + i)
			self.instanciarVehiculo(vehiculos.size()-1)
		}
		//})
	}
	method cantidadDeVehiculos(){
		return vehiculos.size()-1
	}
	method instanciarVehiculo(i){
		game.addVisual(vehiculos.get(i))
		vehiculos.get(i).initialize()
	}
	method instanciarMeta(i){
		game.addVisual(new Meta(position = game.at(i-1, 9)))
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
		pollo.puntaje(0)
		pollo.reiniciarPosicion()
	}
}
class Meta{
    const property image = "fizz.png"
    var property position

    method colisiona(){
    	pollo.aumentarPuntaje(1)
    	pollo.position(game.at(10,0))
    	game.addVisual(new Danger(position = position))
        game.removeVisual(self)
        
        3.times({ i =>
        	gameDirector.aumentarVehiculos()
        })
        
        /*
        gameDirector.aumentarVehiculos()
        gameDirector.aumentarVehiculos()
        gameDirector.aumentarVehiculos()
        gameDirector.aumentarVehiculos()
        gameDirector.aumentarVehiculos()
        gameDirector.aumentarVehiculos()
        */
        
        //game.removeVisual(pollo)
        //game.removeTickEvent("vehicleDrive")
        
        //game.addVisual(pollo)
        //game.addVisual(win)
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
		//game.removeVisual(pollo)
        //game.removeTickEvent("vehicleDrive")
        
        //game.addVisual(pollo)
        //game.addVisual(win)
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
			game.removeVisual(self)
			game.addVisual(polloWin)
		}
	}
	method tenerAccidente(){
		game.removeVisual(self)
		game.addVisual(polloWin)
	}
	method reiniciarPosicion() { position = self.posicionInicial() }
	method posicionInicial() = game.at(ancho / 2 ,0)
	method image() = "patoFrente.png"
}
object polloWin{
	var property position = pollo.position()
	
	method image() = "patoFrente.png"
}
object score{
	var property position = game.at(16, 0)
	
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








