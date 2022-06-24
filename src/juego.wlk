import wollok.game.*
import consola.*

class Juego {
	var property position = null
	var property color = null
	
	method iniciar(){
        game.addVisual(object{method position()= game.at(9,9) method text() = "Juego "+ color + " - <q> para salir"})		
	}
	
	method terminar(){

	}
	method image() = "juego" + color + ".png"
	

}

class Plumber inherits Juego{
	const tuberia = new Tuberia(image="tbr.png")
	
	
	
	override method iniciar(){
		super()
		game.addVisualIn(tuberia,game.center().down(3))
	}
}


class Tuberia{
	var property image 
	
	method guiarAgua(){}
}

class TuberiaL inherits Tuberia{
	
	override method guiarAgua(){}
}

class TuberiaCruz inherits Tuberia{
	
	override method guiarAgua(){}
	
}





















