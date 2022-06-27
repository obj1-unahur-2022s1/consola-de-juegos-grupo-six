import wollok.game.* 
import juego.*

object consola {
	const juegos = [
		new Juego(indice = 1, titulo = "Amarillo"),
		new Juego(indice = 2, titulo = "Verde", velocidadDeAutos = 200),
		new Juego(indice = 3, titulo = "Rojo", velocidadDeAutos = 200, vehiculosPorPunto = 4),
		new Juego(indice = 4, titulo = "Azul", maximoDeAutos = 20, velocidadDeAutos = 150, vehiculosPorPunto = 4),
		new Juego(indice = 5, titulo = "Naranja", maximoDeAutos = 20, velocidadDeAutos = 150, vehiculosPorPunto = 6),
		new Juego(indice = 6, titulo = "Violeta", maximoDeAutos = 25, velocidadDeAutos = 110, vehiculosPorPunto = 8)
	]
	var menu 

	method initialize(){
		game.title("Consola de juegos")
		game.height(alto)
		game.width(ancho)
		game.ground("ground.png")
		game.boardGround("scene.png")
	}

	method iniciar(){
		menu = new MenuIconos(posicionInicial = game.center().left(2))	
		game.addVisual(menu)
		juegos.forEach{juego=>menu.agregarItem(juego)}
		menu.dibujar()
		keyboard.enter().onPressDo{self.hacerIniciar(menu.itemSeleccionado())}
	}
	method hacerIniciar(juego){	
		game.clear()
		keyboard.q().onPressDo{self.hacerTerminar(juego)}
		juego.iniciar()
	}
	method hacerTerminar(juego){
		juego.terminar()
		game.clear()
		self.iniciar()
	}
}


class MenuIconos{
	var seleccionado = 1
	const ancho = 3
	const espaciado = 2
	const items = new Dictionary() 
	var posicionInicial

	method initialize(){
		keyboard.up().onPressDo{self.arriba()}
		keyboard.down().onPressDo{self.abajo()}
		keyboard.right().onPressDo{self.derecha()}
		keyboard.left().onPressDo{self.izquierda()}
	}

	method agregarItem(item){
		items.put(items.size()+1, item)
	}

	method dibujar(){
		items.forEach{indice,visual => 
			visual.position(self.posicionDe(indice))
			game.addVisual(visual)
		}
	}

	method horizontal(indice) = (indice-1) % ancho * espaciado
	method vertical(indice) = (indice-1).div(ancho) * espaciado

	method posicionDe(indice) =
		posicionInicial
			.up(self.vertical(indice))
			.right(self.horizontal(indice))

	method itemSeleccionado() = items.get(seleccionado)
	method image() = "cursor.png"
	method position() = self.posicionDe(seleccionado)

	method abajo(){
		if(seleccionado > ancho) seleccionado = seleccionado - ancho	
	}
	method arriba(){
		if(seleccionado + ancho <= items.size()) seleccionado = seleccionado + ancho	
	}
	method derecha(){
		seleccionado = (seleccionado + 1).min(items.size())
	}
	method izquierda(){
		seleccionado = (seleccionado - 1).max(1)
	}
}




