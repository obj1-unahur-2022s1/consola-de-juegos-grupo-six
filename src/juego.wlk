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
const direcciones = ["norte", "sur", "este", "oeste"]
class Plumber inherits Juego{
	const objetivo = game.at(0,0)
	const tablero = new Tablero(ancho = 6, alto=4)
	
	override method iniciar(){
		//super()
		//game.addVisualIn(agua,game.at(0,0))
		//game.addVisualIn(tuberia,game.center().down(3))
	}
}
class Tablero{
	const ancho
	const alto
	
	method initialize(){
		alto.forEach({ y =>
			ancho.forEach({ x =>
				game.addVisualIn(new Tuberia(image="tbr.png"),game.at(x, y))
			})
		})
		
	}
}

object agua{
	
	
	method posicion() = game.at(0,0)
}

//agua.posicion( tuberia.siguienteDireccion(agua.posicion()) )


class Tuberia{
	var property image
	const property dir = direcciones.anyOne()
	//(3,3)
	
	method siguienteDireccion(posicion){
		//(4,3) -X
		if(self.dirHorizontal()){
			const newX = self.posicion().x - posicion.x // -1
			return posicion.rigth(newX*2)//(-2,0)
		}
		const newY = self.posicion().y - posicion.y
		return posicion.up(newY*2)
	}
	
	method dirHorizontal(){
		return dir == "este" || dir == "oeste"
	}
	
	method posicion() = game.at(0,0)
}

class TuberiaL inherits Tuberia{
	
	override method guiarAgua(){}
}

class TuberiaCruz inherits Tuberia{
	
	override method guiarAgua(){}
	
}





















