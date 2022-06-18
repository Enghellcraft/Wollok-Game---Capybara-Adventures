import wollok.game.* 
import objects.*
import capybara.*
import enemies.* 
import randomizer.*
import generador.*
import sonido.*

object inicio {
	var property image = "start.png"
	method iniciar() {	
		game.schedule(2000, {pantallaInicial1.iniciar()})
	}
}
class PantallaInicial {
	var property image
	var property pista
	var property siguiente
	method enterParaJugar() {
		keyboard.enter().onPressDo({ self.finalizar() })
	}
	method finalizar() {
		game.clear() 
		self.siguiente().iniciar()
	}
	method iniciar() {
		game.addVisualIn(self, game.at(0,0))
		musicConfig.musicaOnOff(self.pista())
		self.enterParaJugar()
	}
}
object pantallaInicial1 inherits PantallaInicial 
	(image = "comandos.png", pista = pistaInicial, siguiente = pantallaInicial2) {
	override method iniciar() {
		super()
		self.pista().play()
		self.enterParaJugar()
	}
}
object pantallaInicial2 inherits PantallaInicial
	(image = "amigosenemigos.jpg", pista = pistaInicial, siguiente = pantalla1){
	override method finalizar() {
		super()
		self.pista().stop()
	}
}
class PantallaFinal {
	var property image
	var property pista
	method enterParaFin(){
		keyboard.enter().onPressDo({ game.stop()}) }
	method prefinal() {
		game.clear()
		game.addVisual(fade)
		game.onTick(1000, "CONTEOINVERSO" , {fade.countBackwards()})
		game.schedule(2000,{self.final()})	
	}
	method final() {
		game.addVisualIn(self, game.at(0, 0))
		self.enterParaFin()
		game.schedule(10000, {game.stop()})	
	}
	method finalizar(){
		self.pista().play()
		self.final()
		//self.pista().stop()
	}
}
object pantallaGanar inherits PantallaFinal (image = "ganaste.png",pista = sonidoGanar){
}
object pantallaPerder inherits PantallaFinal (image = "perdiste.png",pista = sonidoPerder){
}
class PantallaNivel {
	var property image
	method iniciar() {
		game.clear()
		game.addVisualIn(self, game.at(0,0))
	}	
}
object pantalla1 inherits PantallaNivel (image = "nivel1.png") {
	override method iniciar() {
		super()
		game.schedule(1000, { game.clear()
			nivel1.cargar()
		})	
	}
}
object pantalla2 inherits PantallaNivel (image = "nivel2.png"){
	override method iniciar() {
		super()
		game.schedule(1000, { game.clear()
			nivel2.cargar()
		})	
	}
}
object pantalla3 inherits PantallaNivel (image = "nivel3.png"){
	override method iniciar() {
		super()
		game.schedule(1000, { game.clear()
			nivel3.cargar()
		})	
	}
}
class Nivel inherits DefaultObjects {
	var property nivel
	var property enCurso = false
	var property pista
	var property image
	var property imagenInicioNivel
//	var property initTimeGenerator
//	var property initTimeGravity
	const property generators = #{}
	const property exit
	method showExit(){
		const exitImage = new Exit()
		const exitInvisible = new InvisibleExit()
		exitImage.show()
		exitInvisible.show()
	}
	method initTimeGenerator()
	method initTimeGravity()
	method acelerar(timeUp){
//		console.println("Up timeGravity en Nivel " + nivel.toString())
//		humanGenerator.upTimeGravity(timeUp)
		generators.forEach( { gen => gen.upTimeGravity(timeUp) } )
	}
	method desacelerar(timeDown){
//		console.println("Down timeGravity en Nivel " + nivel.toString())
//		humanGenerator.downTimeGravity(timeDown)
		generators.forEach( { gen => gen.downTimeGravity(timeDown) } )

	}	
//	method exitImagePosition(){
//		return game.at(game.width() - 1,0)
//	}
	method addGenerators(){
		generators.addAll(#{bottleGenerator,obstacleGenerator,keyGenerator})
	} 
	method initVisualsGenerators(){
		generators.clear()
		self.addGenerators()		
		generators.forEach( { gen => gen.show() } )
	}
	method terminar() {
		game.removeVisual(time)
		game.removeVisual(hp)
		game.removeVisual(keychain)
		self.pista().stop()	
//		if (nivel3.enCurso())
//			game.say(capybara, "GANASTE!!!")	
//		else
//			game.say(capybara, "PASASTE DE NIVEL!!!")	
		enCurso = false
	}
	method cargar() {
		enCurso = true
		game.clear()
		game.addVisualIn(self, game.at(0,0))
		game.addVisual(capybara)
		game.errorReporter(capybara)	
		game.addVisual(hp)
		time.resetCounter()
		game.addVisual(time)
		game.addVisual(keychain)
		capybara.resetKeys()
		keyboard.left().onPressDo(  { capybara.mover(izquierda) } )
		keyboard.right().onPressDo(  { capybara.mover(derecha) } )	
		keyboard.up().onPressDo( { capybara.mover(arriba) } )
		keyboard.down().onPressDo( { capybara.mover(abajo) } )
		self.pista().play()
		musicConfig.musicaOnOff(self.pista())
		game.onCollideDo(capybara, { someone => someone.crash(capybara) } )
		game.schedule(60000, { capybara.timeOver() })
		game.onTick(1000, "CONTEOINVERSO" , {time.countBackwards()})
		self.initVisualsGenerators()
//		game.addVisual(display)
//		game.addVisual(display)
//		game.addVisual(display2)
//		game.addVisual(display3)
//		display.write(capybara.life().toString())
//		display2.write(capybara.keyscount().toString())	// solo para pruebas			
//		display3.write(nivelActual.is().toString())
	}	
	method iniciar () {
		game.addVisualIn(imagenInicioNivel, game.at(0,0))
		game.schedule(1000, { game.clear()
			self.cargar()
		})
	}
}
object nivel1 inherits Nivel(image ="fondo_nivel1.jpg", nivel = 1, pista = musicaNivel1, 
						     imagenInicioNivel  = "nivel1.png", exit = "wallcrack.png") {
//	var property initTimeHumanGenerator = 2000 
//	var property initTimeHumanGravity = 700
	
	override method cargar() {
		capybara.keysForWin(2)	//configurar antes de entrega	
		super()
	}
	override method terminar(){
		super()
		pantalla2.iniciar()
		game.schedule(3000, { nivel2.cargar()})
	}	
	
	override method initTimeGenerator() = 2000
	override method initTimeGravity() = 700
	override method addGenerators(){
		super()
		generators.add(humanGenerator)
	} 		
}		
object nivel2 inherits Nivel (image ="fondo_nivel2.jpg",nivel = 2, pista = musicaNivel2, 
							  imagenInicioNivel = "nivel2.png", exit = "fencecrack.png"){
	
	override method cargar() {
		capybara.keysForWin(2) //configurar antes de entrega
		super()
	}	
	override method terminar(){
		super()
		pantalla3.iniciar()
		game.schedule(3000, { nivel3.cargar()})
	}	
	override method addGenerators(){
		super()
		generators.add(animalControlGenerator)
	} 		
	override method initTimeGenerator() = 1800
	override method initTimeGravity() = 600	
}
object nivel3 inherits Nivel (image ="fondo_nivel3.jpg",nivel = 3, pista = musicaNivel3, 
					          imagenInicioNivel = "nivel3.png", exit = "burrow.png"){
	override method cargar() {
		super()
		capybara.keysForWin(2) //configurar antes de entrega
	}
	override method terminar() {}	
	override method initTimeGenerator() = 1600
	override method initTimeGravity() = 500	
	override method addGenerators(){
		super()
		generators.addAll(#{predatorGenerator,swimmerGenerator})
	} 	
}

object nivelActual {
	const suf3 = [1,2,3]
	const suf2 = [1,2]	
	
	method random() = randomizer.emptyPosition()

	method obstacles() =
		if (nivel1.enCurso()) 
			new Wall(position=self.random())
		else
		if (nivel2.enCurso()) 
			new Fence(sufijo=suf2.anyOne(),position=self.random())
		else  
			new Stump(sufijo=suf3.anyOne(),position=self.random())

		

	method is() =
		if (nivel1.enCurso()) 
			nivel1
		else
		if (nivel2.enCurso()) 
			nivel2
		else  
			nivel3	

			
}

