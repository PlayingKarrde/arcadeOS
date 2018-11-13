import QtQuick 2.11
import QtGraphicalEffects 1.0

Item {
  id: root
  property var gameData: api.currentGame
  property var collection: api.currentCollection


  property string bgSource: gameData ? gameData.assets.background || gameData.assets.screenshots[0] || "../assets/images/defaultbg.jpg" : ""
  property string bgImage1
  property string bgImage2
  property bool firstBG: true

  onBgSourceChanged: swapImage(bgSource)



  Item {
    id: bg

    anchors.fill: parent

    states: [
        State { // this will fade in rect2 and fade out rect
            name: "fadeInRect2"
            PropertyChanges { target: rect; opacity: 0}
            PropertyChanges { target: rect2; opacity: 1}
        },
        State   { // this will fade in rect and fade out rect2
            name:"fadeOutRect2"
            PropertyChanges { target: rect;opacity:1}
            PropertyChanges { target: rect2;opacity:0}
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 300  }
        }
    ]

    Image {
        id: rect2
        anchors.fill: parent
        visible: gameData
        asynchronous: true
        source: bgImage1
        sourceSize { width: 1920; height: 1080 }
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    Image {
        id: rect
        anchors.fill: parent
        visible: gameData
        asynchronous: true
        source: bgImage2
        sourceSize { width: 1920; height: 1080 }
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    state: "fadeInRect2"

  }

  function swapImage(newSource) {
    if (firstBG) {
      // Go to second image
      if (newSource)
        bgImage2 = newSource

      firstBG = false
    } else {
      // Go to first image
      if (newSource)
        bgImage1 = newSource

      firstBG = true
    }
    bg.state = bg.state == "fadeInRect2" ? "fadeOutRect2" : "fadeInRect2"
  }

  LinearGradient {
        z: parent.z + 1
        width: parent.width
        height: parent.height
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        start: Qt.point(0, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#88000000" }
            GradientStop { position: 0.6; color: "#ff000000" }
        }
    }
    opacity:0.9

}
