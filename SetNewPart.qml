import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: r
    anchors.fill: parent
    color: app.c1
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        Rectangle{
            width: r.width*0.6
            height: col.height+app.fs
            color: app.c1
            Column{
                id: col
                spacing: app.fs*0.5
                anchors.centerIn: parent
                Row{
                    spacing: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: '<b>Nombe de Partido: </b>'
                        font.pixelSize: app.fs
                        color: app.c2
                    }
                    TextInput{
                        id: tiNewPart
                        width: parent.parent.width-labelPal.contentWidth-botBuscar.width-app.fs
                        height: app.fs*2
                        color: app.c2
                        font.pixelSize: app.fs*2
                        anchors.verticalCenter: parent.verticalCenter
                        onTextChanged: {

                        }
                        Keys.onReturnPressed: setNewPart()
                        Keys.onEnterPressed: setNewPart()
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
                }
                Row{
                    spacing: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: '<b>Cantidad de Jugadores: </b>'
                        font.pixelSize: app.fs
                        color: app.c2
                    }
                    ComboBox{
                        id: cbCant
                        width: app.fs*20
                        font.pixelSize: app.fs
                        model: ['¿Cuántos jugadores?', '2 Jugadores', '3 Jugadores', '4 Jugadores']
                        onCurrentIndexChanged: {
                            setTiNoms()
                        }
                    }

                }
                Row{
                    spacing: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: '<b>Nombres: </b>'
                        font.pixelSize: app.fs
                        color: app.c2
                    }
                    Row{
                        id: xTiNoms
                        spacing: app.fs
                    }
                }
            }
        }
        Component{
            id: compTiNom
            TextInput{
                id: tiNom
                width: app.fs*8
                height: app.fs*2
                color: app.c2
                font.pixelSize: app.fs*2
                anchors.verticalCenter: parent.verticalCenter
                text: 'Part '+part
                clip: true
                property int part: 0
                onTextChanged: {

                }
                //Keys.onReturnPressed: setNewPart()
                //Keys.onEnterPressed: setNewPart()
                Rectangle{
                    width: parent.width//+app.fs*0.5
                    height: parent.height//+app.fs*0.5
                    color: 'transparent'
                    border.color: !tiNom.focus?app.c2:'red'
                    border.width: 2
                    z: parent.z-1
                    anchors.centerIn: parent
                }
            }
        }

        Log{
            id: log
            width: r.width*0.6
            height: app.fs*10
        }
    }
    function toEnter(){
        setNewPart()
    }
    function toTab(){
        if(cbCant.currentIndex===0){
            cbCant.focus=true
            return
        }
        if(cbCant.currentIndex===1){
            console.log('---->'+xTiNoms.children.length)
            if(xTiNoms.children[0].focus){
                xTiNoms.children[1].focus=true
            }else{
                xTiNoms.children[0].focus=true
            }
            return
        }
        if(cbCant.currentIndex===2){
            console.log('---->'+xTiNoms.children.length)
            if(xTiNoms.children[0].focus){
                xTiNoms.children[1].focus=true
            }else if(xTiNoms.children[1].focus){
                xTiNoms.children[2].focus=true
            }else{
                xTiNoms.children[0].focus=true
            }
            return
        }
        if(cbCant.currentIndex===3){
            console.log('---->'+xTiNoms.children.length)
            if(xTiNoms.children[0].focus){
                xTiNoms.children[1].focus=true
            }else if(xTiNoms.children[1].focus){
                xTiNoms.children[2].focus=true
            }else if(xTiNoms.children[2].focus){
                xTiNoms.children[3].focus=true
            }else{
                xTiNoms.children[0].focus=true
            }
            return
        }
    }
    function setNewPart(){
        let d = new Date(Date.now())
        let npn='part_'+d.getFullYear()+'_'+d.getMonth()+'_'+d.getDate()+'_'+d.getHours()+'_'+d.getMinutes()+'_'+d.getSeconds()+'-'+tiNewPart.text
        apps.cPartido=npn
        log.log('apps.cPartido: '+apps.cPartido)
        //r.visible=false

    }
    function setTiNoms(){
        for(var i=0;i<xTiNoms.children.length;i++){
            xTiNoms.children[i].destroy(0)
        }
        let cantJugadores=0
        if(cbCant.currentIndex==1){
            cantJugadores=2
        }
        if(cbCant.currentIndex==2){
            cantJugadores=3
        }
        if(cbCant.currentIndex==3){
            cantJugadores=4
        }
        if(cantJugadores>=2){
            for(i=0;i<cantJugadores;i++){
                let obj=compTiNom.createObject(xTiNoms, {part: i+1})
            }
        }

    }
    function toDown(){
        if(cbCant.currentIndex<cbCant.count-1){
            cbCant.currentIndex++
        }else{
            cbCant.currentIndex=0
        }
    }
}
