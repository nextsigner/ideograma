import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import QtMultimedia 5.0
import unik.UnikQProcess 1.0

import Qt.labs.settings 1.1

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: c1
    property int fs: Screen.width*0.02
    property color c1: 'black'
    property color c2: 'white'
    property real volume: 1.0

    property string uPal: '?'
    property int uPun: 0

    Settings{
        id: apps
        property string cPartido: 'PartidoPrueba'
        property string cPart: 'RiPrueba'
        property int cCantJugadores: 0
    }

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
        Column{
            spacing: app.fs*0.25
            Row{
                spacing: app.fs*0.5
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: '<b>Partido: </b>'+apps.cPartido
                    color: app.c2
                    font.pixelSize: app.fs
                }
            }
            Row{
                spacing: app.fs*0.25
                anchors.horizontalCenter: parent.horizontalCenter
                Column{
                    width: xApp.width*0.5-app.fs*0.25
                    spacing: app.fs*0.25
                    Rectangle{
                        id: xTabla
                        width: parent.width
                        height: app.fs*6
                        color: app.c1
                        border.width: 2
                        border.color: app.c2
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        ListView{
                            id: lv
                            width: parent.width
                            height: parent.height
                            model: lm
                            delegate: compItemPalabras
                            anchors.horizontalCenter: parent.horizontalCenter
                            ListModel{
                                id: lm
                                function add(id, par, pal, pts){
                                    return{
                                        _id: id,
                                        participante: par,
                                        palabra: pal,
                                        puntos: pts
                                    }
                                }
                            }
                            Component{
                                id: compItemPalabras
                                Rectangle{
                                    width: lv.width
                                    height: app.fs*1.2
                                    Row{
                                        anchors.centerIn: parent
                                        Cell{
                                            width: lv.width*0.2
                                            dato: participante
                                        }
                                        Cell{
                                            width: lv.width*0.6
                                            dato: palabra
                                        }
                                        Cell{
                                            width: lv.width*0.2
                                            dato: puntos
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Crono{
                        id: crono
                        width: parent.width
                    }
                }
                Column{
                    width: xApp.width*0.5-app.fs*0.25
                    spacing: app.fs*0.5
                    Rectangle{
                        id: xTablaPos
                        width: parent.width
                        height: app.fs*6
                        color: app.c1
                        border.width: 2
                        border.color: app.c2
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        ListView{
                            id: lvPos
                            width: parent.width
                            height: parent.height
                            model: lmPos
                            delegate: compItemPalabras
                            anchors.horizontalCenter: parent.horizontalCenter
                            ListModel{
                                id: lmPos
                                function add(par, pts){
                                    return{
                                        participante: par,
                                        puntos: pts
                                    }
                                }
                            }
                            Component{
                                id: compItemPos
                                Rectangle{
                                    width: lvPos.width
                                    height: app.fs*1.2
                                    Row{
                                        anchors.centerIn: parent
                                        Cell{
                                            width: lv.width*0.2
                                            dato: participante
                                        }
                                        Cell{
                                            width: lv.width*0.6
                                            dato: palabra
                                        }
                                        Cell{
                                            width: lv.width*0.2
                                            dato: puntos
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Row{
                        spacing: app.fs*0.5
                        height: app.fs*2
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text{
                            id: labelPal
                            text: '<b>Palabra:</b>'
                            color: app.c2
                            font.pixelSize: app.fs*2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        TextInput{
                            id: tiPalabra
                            width: parent.parent.width-labelPal.contentWidth-botBuscar.width-app.fs
                            height: app.fs*2
                            color: app.c2
                            font.pixelSize: app.fs*2
                            anchors.verticalCenter: parent.verticalCenter
                            onTextChanged: {
                                ta.text=''
                                app.uPal=text
                                app.uPun=calcularPuntos(text)
                            }
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
                            id: botBuscar
                            text: 'Buscar'
                            onClicked: buscar(tiPalabra.text)
                        }
                    }
                    Row{
                        Text{
                            text: '<b>Vale: </b> '+app.uPun+' pts.'
                            color: app.c2
                            font.pixelSize: app.fs*2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Rectangle{
                        width: parent.parent.width-app.fs
                        height: app.fs*12
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
    }
    SetNewPart{id: snp}
    Item{
        id: xuqp
    }
    Component.onCompleted: {
        initSqlite()
    }
    Shortcut{
        sequence: 'Space'
        onActivated: crono.iniciarPausar()
    }
    Shortcut{
        sequence: 'Ctrl+Tab'
        onActivated: {
            if(snp.visible){
                snp.toTab()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Return'
        onActivated: {
            if(snp.visible){
                snp.toEnter()
                return
            }
            let ins=insertarJugada(apps.cPart, tiPalabra.text, app.uPun, apps.cPartido)
            ta.text+='ins:'+ins+'\n'
            updateListPart()
        }
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
            if(snp.visible){
                snp.visible=false
                return
            }
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
            if(snp.visible){
                snp.toDown()
                return
            }
            unik.restartApp('-folder='+unik.currentFolderPath())
        }
    }
    function buscar(palabra) {
        // Reemplazamos 'palabra' en la URL por la palabra que se busca
        const url = 'https://rae-api.com/api/words/'+palabra ;

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

    function calcularPuntos(palabra) {
        let pal=(''+palabra).replace(/\n/g, '').replace(/ /g, '').replace(/_/g, '').replace(/-/g, '').replace(/\./g, '')
        pal=pal.toLowerCase()
        let p=0
        let letras=['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'ñ', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
        let puntos=[1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 4, 3, 4, 2, 3, 1, 3, 10, 3, 2, 2, 1, 4, 0, 10, 6, 10]
        let mPal=pal.split('')
        for(var i=0;i<mPal.length;i++){
            p+=puntos[letras.indexOf(mPal[i])]
        }
        return p
    }

    // Ejemplos de uso:

    /*let ideogramaJapones = "愛"; // 'ai' - amor
    let puntos1 = calcularPuntos(ideogramaJapones);
    console.log(`La palabra "${ideogramaJapones}" tiene ${puntos1} punto(s).`); // Salida: La palabra "愛" tiene 1 punto(s).

    let ideogramaChino = "你好"; // 'nǐ hǎo' - hola
    let puntos2 = calcularPuntos(ideogramaChino);
    console.log(`La palabra "${ideogramaChino}" tiene ${puntos2} punto(s).`); // Salida: La palabra "你好" tiene 2 punto(s).

    let palabraNormal = "hola";
    let puntos3 = calcularPuntos(palabraNormal);
    console.log(`La palabra "${palabraNormal}" tiene ${puntos3} punto(s).`); // Salida: La palabra "hola" tiene 4 punto(s).
    */

    function initSqlite(){
        let sqliteFile=unik.currentFolderPath()+'/ejemplo.sqlite'
        unik.sqliteInit(sqliteFile)

        //CREAR TABLA PARTIDOS
        let tableName = "partidos";
        let sql = '
                CREATE TABLE IF NOT EXISTS '+tableName+' (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nom TEXT NOT NULL,
                    par1 TEXT NOT NULL,
                    par2 TEXT NOT NULL,
                    par3 TEXT NOT NULL,
                    par4 TEXT NOT NULL
                );
            '
        let q = unik.sqlQuery(sql)
        console.log('Creando tabla '+tableName+': '+q)

        //CREAR TABLA JUGADAS
        tableName = "jugadas";
        sql = '
                CREATE TABLE IF NOT EXISTS '+tableName+' (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    part TEXT NOT NULL,
                    palabra TEXT NOT NULL,
                    puntos INTEGER NOT NULL,
                    partido TEXT NOT NULL
                );
            '
        q = unik.sqlQuery(sql)
        console.log('Creando tabla '+tableName+': '+q)
    }
    function insertarJugada(part, pal, pun, partido){
        let tableName = "jugadas";
        let sql = '
                    INSERT INTO '+tableName+' (part, palabra, puntos, partido)
                    VALUES (\''+part+'\', \''+pal+'\', '+pun+', \''+partido+'\');
                '
        return unik.sqlQuery(sql)
    }
    function updateListPart(){
        let orden='DESC'
        let tableName = "jugadas";
        let o='ORDER BY id '+orden+''

        let sql = 'SELECT * FROM '+tableName+' '+o
        let filas = unik.getSqlData(sql);

        for(var i=0;i<filas.length;i++){
            let row=[]
            for(var i2=0;i2<filas[i].col.length;i2++){
                row.push(filas[i].col[i2])
            }
            lm.append(lm.add(row[0], row[1], row[2], row[3]))
            //ta.text+=row.toString()+'\n'
        }
    }
}
