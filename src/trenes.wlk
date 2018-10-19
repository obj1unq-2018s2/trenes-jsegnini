class Formacion {
	var locomotoras //lista de locomotoras
	var vagones //lista de vagones
	
	method arrTotal() = locomotoras.map {locom => locom.arrastreUtil()}.sum()
	method pesoMaxTotalVag() = vagones.map {vagon => vagon.pesoMaximo()}.sum()
	method pesoMaxTotalLoc() = locomotoras.map {locom => locom.peso()}.sum()
	
	
	method pesoTotal() {
		return self.pesoMaxTotalVag() + self.pesoMaxTotalLoc()
	}
	
	method agregarLocomotora(loco) {
		locomotoras.add(loco)
	}
	method vagonMasPesado() {
		return vagones.max ({vagon => vagon.pesoMaximo()})
	}
	
	method vagones() {
		return vagones
	}
	method locomotoras() {
		return locomotoras
	}
	
	method cantVagonesLivianos() {
		return vagones.filter {vagon => vagon.esLiviano()}.size()
	}

	method velMaxima(){
		return locomotoras.map {locom => locom.velMaxima()}.min()
	}
	method eficiente(){
		return locomotoras.all({locom => locom.arrastreUtil() >= locom.peso() * 5})
	}
	method puedeMoverse(){
		return self.arrTotal() >= self.pesoMaxTotalVag()
	}
	method estaBienArmada() {
		return self.puedeMoverse()
	}
	method empujeFaltanteEnKilos() {
		return (self.pesoMaxTotalVag() - self.arrTotal()).max(0)
	}
	method esCompleja(){
		return (vagones.size() + locomotoras.size() > 20)
	}
	
}

class FormacionDeCortaDistancia inherits Formacion {
	override method estaBienArmada() {
		return super() and not self.esCompleja()
	}
	method limVelocidad() {
		return self.velMaxima().min(60)
	}
}

class FormacionDeLargaDistancia inherits Formacion {
	const property interurbanoCiudadesGrandes
	override method estaBienArmada() {
		return super() and vagones.sum({vagon => vagon.cantPasajerosQueTransporta()}) 
		/ vagones.sum({vagon => vagon.cantBanios()}) <= 50
	}
	method limVelocidad() {
		return self.velMaxima().min(if (self.interurbanoCiudadesGrandes()) 200 else 150)
		}
}

class TrenDeAltaVelocidad inherits FormacionDeLargaDistancia {
	override method estaBienArmada(){
		return self.velMaxima() >= 250 and vagones.all ({vagon => vagon.esLiviano()})
	}
	override method limVelocidad() {
		return super().max(400)
	}
}



class Deposito {
	var property formaciones //lista de formaciones
	var property locomotorasSueltas //lista de locomotoras sueltas
	
	method vagonesPesados() {
		return formaciones.map {form => form.vagonMasPesado()}.asSet()
	}
	
	method necesitaConductorExp() {
		return formaciones.any {form => form.esCompleja() or form.pesoTotal() > 10000}
	}
	
	//en este punto el Deposito delega sobre cada Formacion la necesidad de saber si es
	//compleja, y su peso total. A su vez, cada Formacion delega, por la definición del
	//método pesoTotal(), sobre cada Vagon y Locomotora que la componen la tarea de averiguar
	//pesoMaximo() y peso() respectivamente.
	
	
	method agregarLocomotoraAForm(formacion){
		if (not formacion.puedeMoverse() and 
			locomotorasSueltas.any{locom => locom.arrastreUtil() > formacion.empujeFaltanteEnKilos()}
		) {
			formacion.agregarLocomotora
				(locomotorasSueltas.filter {locom => locom.arrastreUtil() > formacion.empujeFaltanteEnKilos()}.first())		}
	}
}

class Vagon {
	method pesoMaximo()
	method esLiviano() {return self.pesoMaximo() < 2500}
}

class VagonPasajeros inherits Vagon {
	const property cantBanios
	const property largo
	const property anchoUtil
	method cantPasajerosQueTransporta() = if (anchoUtil <= 2.5) largo * 8 else largo * 10
	override method pesoMaximo() {return self.cantPasajerosQueTransporta() * 80}
	method cantCargaQueTransporta() {
		return 0
	}
}

class VagonCarga inherits Vagon {
	const property cantBanios = 0
	const cargaMaxima
	override method pesoMaximo() {return cargaMaxima + 160}
	method cantPasajerosQueTransporta() {
		return 0
	}
	method cantCargaQueTransporta() {
		return cargaMaxima
	}
}

class Locomotora {
	const property peso
	const property velMaxima
	const property pesoMaxArrastre
	method arrastreUtil() {
		return pesoMaxArrastre - peso
	}
}