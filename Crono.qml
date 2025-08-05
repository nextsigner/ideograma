import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: r
    width: timerText.contentWidth+app.fs
    height: 200
    visible: true

    // La lógica del temporizador
    // ---
    property int totalSeconds: 3 * 60 // 3 minutos * 60 segundos
    property int secondsRemaining: totalSeconds
    property bool running: false


    // Formatea el tiempo restante a "MM:SS"
    function formatTime(seconds) {
        let minutes = Math.floor(seconds / 60);
        let remainingSeconds = seconds % 60;
        let formattedMinutes = (minutes < 10 ? "0" : "") + minutes;
        let formattedSeconds = (remainingSeconds < 10 ? "0" : "") + remainingSeconds;
        return formattedMinutes + ":" + formattedSeconds;
    }

    // El objeto Timer es clave para la cuenta regresiva
    Timer {
        id: countdownTimer
        interval: 1000 // 1 segundo
        repeat: true
        running: parent.running // Se activa si la propiedad 'running' es verdadera

        onTriggered: {
            if (secondsRemaining > 0) {
                secondsRemaining--;
            } else {
                r.running = false; // Detiene el temporizador cuando llega a 0
                console.log("¡Tiempo terminado!");
                audio2.play()
            }
            if(secondsRemaining===r.totalSeconds-120){
                audio3.play()
            }
            if(secondsRemaining===5 || secondsRemaining===10  || secondsRemaining===15){
                audio1.play()
            }
        }

    }

    // La interfaz de usuario
    // ---
    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: timerText
            text: formatTime(secondsRemaining)
            color: app.c2
            font.pixelSize: app.fs*6
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Row {
            spacing: 10

            Button {
                text: running ? "Pausar" : "Iniciar"
                onClicked: {
                    iniciarPausar()
                }
            }

            Button {
                text: "Reiniciar"
                onClicked: {
                    reIniciar()
                }
            }
        }
    }
    function iniciarPausar(){
        if(secondsRemaining===0){
            secondsRemaining=totalSeconds
            running = true
            audio1.play()
        }else{
            running = !running;
            if(running){
                audio1.play()
            }else{
                audio3.play()
            }
        }
    }
    function reIniciar(){
        secondsRemaining = totalSeconds;
        running = false; // Detiene el temporizador al reiniciar
        audio3.play()
    }
}
