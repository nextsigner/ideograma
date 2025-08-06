import QtQuick 2.0

Rectangle{
    id: r
    height: app.fs*1.2
    color: app.c1
    border.width: 1
    border.color: app.c2
    clip: true
    property string dato: '?????????????'
    Text{
        id: txt
        text: r.dato
        //width: r.width
        font.pixelSize: app.fs
        color: app.c2
        wrapMode: Text.WordWrap
        anchors.centerIn: parent
        Timer{
            running: parent.contentWidth>parent.parent.width-app.fs
            repeat: true
            interval: 100
            onTriggered: {
                parent.font.pixelSize-=2
            }
        }
    }
}
