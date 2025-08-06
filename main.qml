import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import QtMultimedia 5.0
import unik.UnikQProcess 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: c1
    property int fs: Screen.width*0.02
    property color c1: 'black'
    property color c2: 'white'
    property real volume: 1.0

    Audio{
        id: audio1
        source: unik?unik.currentFolderPath()+"/sounds/beep.wav":''
        //autoPlay: true
        autoLoad: true
        volume: app.volume
    }
    Audio{
        id: audio2
        source: unik?unik.currentFolderPath()+"/sounds/final.mp3":''
        //autoPlay: true
        autoLoad: true
        volume: app.volume
    }
    Audio{
        id: audio3
        source: unik?unik.currentFolderPath()+"/sounds/terminando.mp3":''
        //autoPlay: true
        autoLoad: true
        volume: app.volume
    }
    Audio{
        id: audio4
        source: unik?unik.currentFolderPath()+"/sounds/valida.mp3":''
        //autoPlay: true
        autoLoad: true
        volume: app.volume
    }
    Audio{
        id: audio5
        source: unik?unik.currentFolderPath()+"/sounds/no-valida.mp3":''
        //autoPlay: true
        autoLoad: true
        volume: app.volume
    }
    Item{
        id: xApp
        anchors.fill: parent
      Row{
          spacing: app.fs
          anchors.centerIn: parent
          Crono{id: crono}
        Column{
            spacing: app.fs
            //anchors.centerIn: parent
            Text{
                text: 'Validar Palabras'
                color: app.c2
                font.pixelSize: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                spacing: app.fs
                height: app.fs*2
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: '<b>Palabra:</b>'
                    color: app.c2
                    font.pixelSize: app.fs*2
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextInput{
                    id: tiPalabra
                    width: app.fs*20
                    height: app.fs*2
                    color: app.c2
                    font.pixelSize: app.fs*2
                    anchors.verticalCenter: parent.verticalCenter
                    onTextChanged: ta.text=''
                    Keys.onSpacePressed: {
                        focus=false
                        crono.iniciarPausar()
                    }
                    Keys.onReturnPressed: buscar(tiPalabra.text)
                    Keys.onEnterPressed: buscar(tiPalabra.text)
                    Rectangle{
                        width: parent.width+app.fs*0.5
                        height: parent.height+app.fs*0.5
                        color: 'transparent'
                        border.color: app.c2
                        border.width: 2
                        z: parent.z-1
                        anchors.centerIn: parent
                    }
                }
                Button{
                    text: 'Buscar'
                    onClicked: buscar(tiPalabra.text)
                }
            }
            Rectangle{
                width: parent.width
                height: app.fs*16
                color: app.c1
                border.width: 2
                border.color: app.c2
                clip: true
                Flickable{
                    contentWidth: parent.width
                    contentHeight: ta.contentHeight+app.fs
                    anchors.fill: parent
                    TextArea{
                        id: ta
                        width: parent.width
                        height: parent.height//contentHeight
                        color: app.c2
                        font.pixelSize: app.fs*2
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        }
    }
    UnikQProcess{
        id: uqpBuscar
        onLogDataChanged: {
            if(logData.indexOf('NORAE')>=0){
                ta.clear()
                ta.text+='Esta palabra NO EXISTE!!!\n\n'
                audio5.play()
                return
            }
            audio4.play()
            ta.clear()
            let j=JSON.parse(logData.replace(/\n/g, ''))
            //let senses=j.data.senses
            let meanings=j.data.meanings
            let cantRaws=meanings[0].senses.length
            for(var i=0;i<cantRaws;i++){
                let raw=meanings[0].senses[i].raw
                let des=meanings[0].senses[i].description
                if(raw)ta.text+='Se usa como: '+raw+'\n\n'
                if(des)ta.text+='Descripción: '+des+'\n\n'
                //ta.text+=JSON.stringify(meanings[0].senses[i], null, 2)+'\n'
            }

        }
    }
    Item{
        id: xuqp
    }
    Component.onCompleted: {
        //tiPalabra.focus=true
        //tiPalabra.text="Hola"
        //buscar()
    }
    Shortcut{
        sequence: 'Space'
        onActivated: crono.iniciarPausar()
    }
    Shortcut{
        sequence: 'f'
        onActivated: {
            if(app.visibility==='FullScreen'){
                app.visibility='Maximized'
            }else{
                app.visibility='FullScreen'
            }
        }
    }
    Shortcut{
        sequence: '0'
        onActivated: crono.reIniciar()
    }
    Shortcut{
        sequence: '1'
        onActivated: {
            tiPalabra.focus=true
            tiPalabra.selectAll()
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(app.volume<1.0){
                app.volume+=0.1
                audio1.play()
            }
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(app.volume>0.1){
                app.volume-=0.1
                audio1.play()
            }
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            unik.restartApp('-folder='+unik.currentFolderPath())
        }
    }
    function buscar(palabra) {
      // Reemplazamos 'palabra' en la URL por la palabra que se busca
      const url = 'https://rae-api.com/api/words/'+palabra;

      const xhr = new XMLHttpRequest();
      xhr.open('GET', url, true);

      xhr.onreadystatechange = function () {
        // Si la solicitud está completa (readyState 4) y la respuesta es exitosa (status 200)
        if (xhr.readyState === 4 && xhr.status === 200) {
            console.log('JSON: '+xhr.responseText)
            revData(xhr.responseText)
          /*try {
            const data = JSON.parse(xhr.responseText);

            // La API devuelve un objeto con la propiedad 'error' si la palabra no existe
            if (data.hasOwnProperty('error')) {
              console.log('No existe esta palabra');
            } else {
              // Si la palabra existe, se pueden procesar los datos
              console.log('La palabra existe. Datos obtenidos:');
              console.log(data);
               revData(data)
              // Aquí puedes añadir más lógica para usar los datos
            }
          } catch (e) {
            console.error('Error al parsear el JSON:', e);
          }*/
        } else if (xhr.readyState === 4 && xhr.status !== 200) {
          //console.error('Error en la solicitud. Estado:', xhr.status);
            revData('NORAE')
        }
      };

      xhr.send();
    }
    function revData(logData) {
        if(logData.indexOf('NORAE')>=0){
            ta.clear()
            ta.text+='Esta palabra NO EXISTE!!!\n\n'
            audio5.play()
            return
        }
        audio4.play()
        ta.clear()
        let j=JSON.parse(logData.replace(/\n/g, ''))
        //let senses=j.data.senses
        let meanings=j.data.meanings
        let cantRaws=meanings[0].senses.length
        for(var i=0;i<cantRaws;i++){
            let raw=meanings[0].senses[i].raw
            let des=meanings[0].senses[i].description
            if(raw)ta.text+='Se usa como: '+raw+'\n\n'
            if(des)ta.text+='Descripción: '+des+'\n\n'
            //ta.text+=JSON.stringify(meanings[0].senses[i], null, 2)+'\n'
        }

    }

}
