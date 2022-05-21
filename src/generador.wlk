import enemies.*
import randomizer.*
import wollok.game.* 
import objects.*
import sonido.*
import niveles.*
class Factory {
	method random() = randomizer.emptyPosition()
}
object humanFactory inherits Factory{
	const suf = [1,2,3]
	method buildHuman() = new Human(sufijo=suf.anyOne(),position=self.random())
}
object beerFactory inherits Factory{
	method buildBottle() = new Beer(position=self.random())
}
object tequilaFactory inherits Factory{
	method buildBottle() = new Tequila(position=self.random())
}
object birkirFactory inherits Factory{
	method buildBottle() = new Birkir(position=self.random())
}
class ObjectGenerator {
	var property max = 0
	const objetosGenerados = []
	method borrar(obj) {
		objetosGenerados.remove(obj)
	}
	method hayQuegenerate() = objetosGenerados.size() <= max
	
}
object humanGenerator inherits ObjectGenerator {
	var property timeHumanGravity = 700
	var property timeHumanTickGen = nivel1.initTimeHumanTick()
	method generate() {
		max = 6
		if(self.hayQuegenerate()) {
			const newHuman = humanFactory.buildHuman()
			game.addVisual(newHuman)
			objetosGenerados.add(newHuman)
		}
	}
	method onlyEnemies() =
		game.allVisuals().filter( {visual => visual.isEnemy()} )
	method show(timeTick){
		game.onTick(timeTick, "HUMANS", { self.generate() })
		game.onTick(timeHumanGravity, "HUMANGRAVITY", { 
			self.onlyEnemies()
			.forEach( { enemy => enemy.gravity()} )
		} )		
	}
	method upTimeHumanGravity(n){
		timeHumanGravity = timeHumanGravity - n
//		timeHumanTickGen = timeHumanTickGen - n
		self.refreshGravity()
	}	
	method downTimeHumanGravity(n){
		timeHumanGravity = timeHumanGravity + n
//		timeHumanTickGen = timeHumanTickGen + n		
		self.refreshGravity()
	}
	method refreshGravity(){
		display.write(timeHumanGravity.toString())
		game.removeTickEvent("HUMANGRAVITY")
		game.onTick(timeHumanGravity, "HUMANGRAVITY", { 
			self.onlyEnemies()
			.forEach( { enemy => enemy.gravity()} )
		} )
//		game.removeTickEvent("HUMANS")
//		self.show(timeHumanTickGen)
					
	}
}
object bottleGenerator inherits ObjectGenerator {
	const factories = [beerFactory, tequilaFactory, birkirFactory]
	method newBottle() = factories.anyOne().buildBottle()
	method onlyBottles() = 
		game.allVisuals().filter( {visual => visual.isBottle()} )		
	method generate() {
		max = 3
		if(self.hayQuegenerate()) {
			const newBottle = self.newBottle()
			game.addVisual(newBottle)
			objetosGenerados.add(newBottle)
		}
	}
	method show(){
		game.onTick(5000, "BOTTLES", { self.generate() })
		game.onTick(500, "BOTTLESGRAVITY", { 
			self.onlyBottles()
			.forEach( { bottle => bottle.gravity()} )
		} )		
	}	
}

