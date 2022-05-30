import wollok.game.* 
import enemies.*
import capybara.*
import randomizer.*
import generador.*
import sonido.*

class DefaultObjects {
	method isObstacle() = false
	method isEnemy() = false
	method isBottle() = false
	method passThrough() = false	
	method isKey() = false
	
}
//VisualObjects seran los que tengan gravedad e iran apareciendo en pantalla aleatoriamente
class VisualObjects inherits DefaultObjects {
	var property position = game.at(0,0)
	method borrar()	
	method gravity() {
		if(position.y() >= 0 ) {
			position = abajo.siguiente(position)
		}
		else{
			game.removeVisual(self)
			self.borrar()
		}
	}	
	method crash(visual)
}
class Llave inherits VisualObjects {
	method image() = "llave.png"	
	override method passThrough() = true
	override method isKey() = true
	override method borrar(){
		keyGenerator.borrar(self)
	}		
	override method crash(visual){
		visual.addKey(self)
		game.removeVisual(self)
		self.borrar()		
	}
}
class Bottle inherits VisualObjects {
	override method isBottle() = true
	override method borrar(){
		bottleGenerator.borrar(self)
	}	
	override method crash(visual){
		visual.drinkBottle(self)
		game.removeVisual(self)
		self.borrar()
	}
	method taken(visual)
}
class Beer inherits Bottle { // desacelera el tiempo osea sube el tiempo de gravedad
	var property timeDown = 200
	method image() = "beer.png"	
	override method taken(visual){
		visual.decelerate(timeDown)
	}	
			
}
class Tequila inherits Bottle { //acelera tiempo osea baja el tiempo de gravedad
	var property timeUp = 200
	method image() = "tequila.png"	
	override method taken(visual){
		visual.acelerate(timeUp)
	}	
}
class Birkir inherits Bottle {
	var property lifeUp = 10
	method image() = "birkir.png"	
	override method taken(visual){
		visual.winLives(lifeUp)
	}		
}
class Obstacles inherits VisualObjects {
	const damage = 10
	override method isObstacle() = true
	override method borrar(){}
//{
//		if(position.y() >= 1 ) {
//			position = abajo.siguiente(position)
//		}
//		else{
//			game.schedule(3000,{game.removeVisual(self)})
//		}
	
//		game.onCollideDo(self,{obstacle => obstacle.game().schedule(5000,{obstacleGenerator.borrar(self)})})
//}
	override method crash(visual){
		visual.loseLives(damage)
		visual.shock()	
	}
} 
class Wall inherits Obstacles {
	method image() = "wall.png"	
}
class Fence inherits Obstacles {
	var sufijo
	method image() = "fence_" + sufijo.toString() + ".png"
}
class Stump inherits Obstacles {
	var sufijo
	method image() = "stump_" + sufijo.toString() + ".png"		
}
object cave inherits DefaultObjects {
	method image() = "cave.png"	
	override method passThrough() = true
	method crash(visual){
		visual.levelUp()
	}
}
object izquierda {
	method siguiente(position) = position.left(1)
}
object derecha {
	method siguiente(position) = position.right(1)		
}
object abajo {
	method siguiente(position) = position.down(1)
}
object arriba {
	method siguiente(position) = position.up(1)
}
object display inherits DefaultObjects {
	var property message = ''
	var property position = game.at(game.width() - 3, game.height() - 1)
	method text() = 'VIDA: '+ '\n' + message
	method write(_message){
		message = _message
		}		
}
object display2 inherits DefaultObjects {
	var property message = ''
	var property position = game.at(game.width() - 5, game.height() - 1)
	method text() = 'LLAVES ' + '\n' + message
	method write(_message){
		message = _message
		}		
}
object display3 inherits DefaultObjects {
	var property message = ''
	var property position = game.at(2, game.height() - 1)
	method text() = 'NIVEL ' + '\n' + message
	method write(_message){
		message = _message
		}		
}
object hp {
	
}
object time {
	
}