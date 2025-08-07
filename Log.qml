import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: xLog
    color: app.c1
    border.width: 2
    border.color: app.c2
    Flickable{
        contentWidth: r.width
        contentHeight: ta.contentHeight+app.fs
        anchors.fill: parent
        TextArea{
            id: ta
            width: r.width-app.fs*0.5
            color: app.c2
            wrapMode: TextArea.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    function log(t){
        ta.text+=t+'\n'
    }
}

