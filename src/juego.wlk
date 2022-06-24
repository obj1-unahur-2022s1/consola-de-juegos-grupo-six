import wollok.game.*
import consola.*

class Juego {
	const property nivel
	var property position = null
	var tiempoRestante = 59
	
	method iniciar(){
		game.boardGround("nivel" + nivel.toString() + "-bg.png")
    	game.addVisual(valve)
    	game.onTick(1000, "contador",{ self.actualizarContador() })
    	self.agregarTablero()
        //game.boardGround("nivelRojo.png")	
	}
	method actualizarContador(){
		game.say(gotty, tiempoRestante.toString())
		tiempoRestante-=1
		if(tiempoRestante == 0){
			game.removeTickEvent("contador")
			game.say(gotty, "Se acabó el tiempo!")
			//abrirValvula()
		}
	}
	method agregarTablero(){
		//altura = 8, ancho = 10
		
		
		
		/*for y in range(0,8)
			for x in range(0,12)
			 	tuberia.at(x,y)
		 		game.addVisual(tuberia)
		*/
	}
	method terminar(){
		selector.reiniciarPosicion()
	}
	method image() = "nivel" + nivel.toString() + ".png"
}
object gotty{
	method image() = "gotty.png"
	method position() = game.at(12,8)
}
object selector{
	var property position = game.origin()
	
	method image() = "cursor.png"
	method reiniciarPosicion(){
		position = game.at(0,8)
	}
}
object valve{
	
	
	method position() = game.at(0,-2) 
	method image() = "valve.png"
	
	//method text()= "Control: "+ color + " - <q> para salir"
}
object agua{
	method image() = "dino.png"
	method posicion() = game.at(0,0)
}

/* 
class Plumber{
	
	const objetivo = game.at(0,0)
	
	override method iniciar(){
		//super()
		//game.addVisualIn(agua,game.at(0,0))
		game.addVisualIn(tuberia,game.center().down(3))
	}
}
 
class Tablero{
	const ancho
	const alto
	
	//method initialize(){
	//	alto.forEach({ y =>
	//		ancho.forEach({ x =>game.addVisualIn(new Tuberia(image="tbr.png"),game.at(x, y))})
	//	})
		
	//}
}



//agua.posicion( tuberia.siguienteDireccion(agua.posicion()) )


class Tuberia{
	const direcciones = ["norte", "sur", "este", "oeste"]
	var property image
	const property dir = direcciones.anyOne()
	//(3,3)
	
	method siguienteDireccion(posicion){
		//(4,3) -X
		if(self.dirHorizontal()){
			const newX = self.posicion().x() - posicion.x() // -1
			return posicion.rigth(newX*2)//(-2,0)
		}
		const newY = self.posicion().y() - posicion.y()
		return posicion.up(newY*2)
	}
	
	method dirHorizontal(){
		return dir == "este" || dir == "oeste"
	}
	
	method posicion() = game.at(0,0)
}

class TuberiaL inherits Tuberia{
	
	//override method guiarAgua(){}
}

class TuberiaCruz inherits Tuberia{
	
	//override method guiarAgua(){}
	
}

*/



















