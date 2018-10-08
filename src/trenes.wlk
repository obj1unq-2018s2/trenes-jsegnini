class Formacion {
	var property locomotoras //lista de locomotoras
	var property vagonesPasajeros //lista de vagones de pasajeros
	var property vagonesCarga //lista de vagones de carga
	method totalVagones() {
		return vagonesPasajeros + vagonesCarga
	}
	
	method cantVagonesLivianos() {
		return totalVagones().map {vagon => vagon.pesoMaximo() > 2500}.sum()
	}
	method velMaxima(){
		return locomotoras.map {locom => locom.velMaxima()}.min
	}
	method eficiente(){
		return locomotoras.all({locom.arrastreUtil() >= locom.peso() * 5})
	}
	method puedeMoverse(){
		var arrTotal = locomotoras.map {locom => locom.arrastreUtil()}.sum()
		var pesoMaxTotal = totalVagones().map {vagon => vagon.pesoMaximo()}.sum()
		return arrTotal >= pesoMaxTotal
	}
	
}

class Deposito {
	var property formaciones //lista de formaciones
	var property locomotorasSueltas //lista de locomotoras sueltas
}

class VagonPasajeros {
	const property largo
	const property anchoUtil
	method pesoMaximo() {return cantPasajerosQueTransporta() * 80}
	method cantPasajerosQueTransporta() = if (anchoUtil <= 2.5) largo * 8 else largo * 10
	method cantCargaQueTransporta() {
		return 0
	}
}

class VagonCarga {
	const property cargaMaxima
	method pesoMaximo() {return cargaMaxima + 160}
	method cantPasajerosQueTransporta() {
		return 0
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