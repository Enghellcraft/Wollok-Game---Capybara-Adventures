import wollok.game.* 
import objects.*
import capybara.*
import enemies.* 
import randomizer.*
import generador.*
import sonido.*

object inicio {
	var property image = "start.png"
//	const property pantallaInicio = true
//	const property lvl = false
	method iniciar() {
		game.addVisualIn(self, game.at(0,0))
//		musicaInicial.play()
//		musicConfig.musicaOnOff()		
		game.schedule(2000, {pantallaInicial1.iniciar()})
	}
}
object pantallaInicial1 {
	var property image = "comandos.png"
	var property pista = pistaInicial
//	const pantallaInicio = true
//	const lvl = false
	var property siguiente = pantallaInicial2
	method enterParaJugar() {
		keyboard.enter().onPressDo({ self.finalizar() })
	}
	method finalizar() {
		game.clear() 
		self.siguiente().iniciar()
	}
	method iniciar() {
		game.addVisualIn(self, game.at(0,0))
		self.pista().play()
		musicConfig.musicaOnOff(self.pista())
//		game.schedule(5000, {image="instrucciones.png"})
		self.enterParaJugar()
	}
}
object pantallaInicial2 {
	var property image = "amigosenemigos.png"
	var property pista = pistaInicial
	var property siguiente = nivel1
	method enterParaJugar() {
		keyboard.enter().onPressDo({ self.finalizar() })
	}
	method finalizar() {
		game.clear() 
		self.pista().stop()
		self.siguiente().iniciar()
	}
	method iniciar() {
		game.addVisualIn(self, game.at(0,0))
		musicConfig.musicaOnOff(self.pista())
		self.enterParaJugar()
	}
}
class Nivel inherits DefaultObjects {
	var property nivel = 0
	var property enCurso = false
	var property pista = pistaInicial
	method iniciar() {
	}
	method terminar() {
		self.pista().stop()
//		game.schedule(1000, { game.clear() })
	}
	method cargar() {
//		game.clear()
		game.addVisualIn(self, game.at(0,0))
//		game.boardGround(image.toString())
		game.addVisual(capybara)
		game.errorReporter(capybara)	
		game.addVisual(display)
		game.addVisual(display2)
		game.addVisual(display3)
		display.write(capybara.life().toString())
		display2.write(capybara.keyscount().toString())	// solo para pruebas			
		display3.write(self.nivel().toString())
		keyboard.left().onPressDo(  { capybara.mover(izquierda) } )
		keyboard.right().onPressDo(  { capybara.mover(derecha) } )	
		keyboard.up().onPressDo( { capybara.mover(arriba) } )
		keyboard.down().onPressDo( { capybara.mover(abajo) } )
		game.onCollideDo(capybara, { someone => someone.crash(capybara) })
		game.schedule(60000, { capybara.lose() })
		self.pista().play()
		musicConfig.musicaOnOff(self.pista())
		bottleGenerator.show()
		keyGenerator.show()
	}	
}
object nivel1 inherits Nivel {
	var property initTimeHumanGenerator = 2000 
	var property initTimeHumanGravity = 700
	var property image = "fondo_nivel1.jpg"
	override method iniciar () {
		pantalla1.iniciarpantalla()
	}
	override method cargar() {
		nivel = 1
		enCurso = true
		pista = musicaNivel1
		capybara.keysForWin(2)		
		super()
		humanGenerator.show()
	}
	override method terminar(){
		super()
		enCurso = false
		nivel2.iniciar()
		
	}	
}
object pantalla1 {
	var property image = "nivel1.jpg"
	method iniciarpantalla() {
		game.addVisualIn(self, game.at(0,0))
		game.schedule(1000, { game.clear()
			nivel1.cargar()
		})	
	}
}		
object nivel2 inherits Nivel{
	var property image = "fondo_nivel2.jpg"
	var property imagenInicioNivel = "nivel2.jpg"
	override method iniciar () {
		game.addVisualIn(imagenInicioNivel, game.at(0,0))
		game.schedule(1000, { game.clear()
			self.cargar()
		})
	}
	override method cargar() {
		enCurso = true		
		pista = musicaNivel2	
		nivel = 2
		capybara.keysForWin(4)
		super()
	}	
	override method terminar(){
		super()
		game.schedule(1000, { nivel3.iniciar()})
	}	
}
object pantalla2 {
	var property image = "nivel2.jpg"
	method iniciarpantalla() {
		game.addVisualIn(self, game.at(0,0))
		game.schedule(1000, { game.clear()
			nivel2.cargar()
		})	
	}
}
object nivel3 inherits Nivel{
	var property image = "fondo_nivel3.jpg"
	var property imagenInicioNivel = "nivel3.jpg"
	override method iniciar () {
		game.addVisualIn(imagenInicioNivel, game.at(0,0))
		game.schedule(1000, { game.clear()
			self.cargar()
		})
	}
	override method cargar() {
		enCurso = true		
		pista = musicaNivel2	
		self.nivel(3)
		super()
	}	
}
object pantalla3 {
	var property image = "nivel3.jpg"
	method iniciarpantalla() {
		game.addVisualIn(self, game.at(0,0))
		game.schedule(1000, { game.clear()
			nivel3.cargar()
		})	
	}
}
object pantallaFinal {
	var property image
	method ganar() {
		image = "ganaste.png"
		sonidoGanar.play()
		self.final()
	}
	method perder() {
		image = "perdiste.png"
	    sonidoPerder.play()
		self.final()
	}
	method enterParaFin(){
		keyboard.enter().onPressDo({ game.stop()})
	}
	method final() {
		game.clear()
		game.addVisualIn(self, game.at(0, 0))
		self.enterParaFin()
//		sonidoMusica.stop()
	}
	
}