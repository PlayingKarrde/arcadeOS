import QtQuick 2.11
import QtGraphicalEffects 1.0
import QtMultimedia 5.9
import "qrc:/qmlutils" as PegasusUtils

Item {
  id: root

  signal menuCloseRequested

  Keys.onLeftPressed: menuCloseRequested()
  Keys.onRightPressed: menuCloseRequested()
  Keys.onUpPressed: gameList.decrementCurrentIndex()
  Keys.onDownPressed: gameList.incrementCurrentIndex()
  //Keys.onUpPressed: api.collections.decrementIndex()
  //Keys.onDownPressed: api.collections.incrementIndex()

  Keys.onPressed: {
      if (event.isAutoRepeat)
          return;

      if (api.keys.isAccept(event.key)) {
          event.accepted = true;
          api.collections.index = gameList.currentIndex
          menuCloseRequested();
          return;
      }
      if (api.keys.isCancel(event.key)) {
            event.accepted = true;
            menuCloseRequested();
            return;
        }
      if (api.keys.isFilters(event.key)) {
          event.accepted = true;
          filtersRequested();
          return;
      }
      if (api.keys.isNextPage(event.key)) {
            event.accepted = true;
            api.collections.incrementIndex();
            return;
        }
        if (api.keys.isPrevPage(event.key)) {
            event.accepted = true;
            api.collections.decrementIndex();
            return;
        }
  }

  property var backgroundcontainer

  width: parent.width
  height: parent.height

  Item {
    id: bgblur
    anchors.fill: parent
    opacity: 0
    Behavior on opacity {
      OpacityAnimator {
        duration: 100;
        easing.type: Easing.InOutQuad;
      }
    }

    ShaderEffectSource {
      id: effectSource
      sourceItem: backgroundcontainer
      anchors.fill: parent
    }

    GaussianBlur {
      id: blur
      anchors.fill: effectSource
      source: effectSource
      radius: 24
      samples: 32
    }

  }

  Image {
    id: menubg
    x: -width
    Behavior on x {
      PropertyAnimation {
        duration: 300;
        easing.type: Easing.OutQuart;
        easing.amplitude: 2.0;
        easing.period: 1.5
      }
    }

    width: vpx(350)
    height: parent.height
    source: "../assets/images/defaultbg.jpg"
    fillMode: Image.PreserveAspectCrop

    PegasusUtils.HorizontalSwipeArea {
        anchors.fill: parent
        onSwipeLeft: menuCloseRequested()
    }

    Rectangle {
      id: menubar
      property real contentWidth: width - vpx(100)

      width: parent.width
      height: parent.height
      color: "#000"
      opacity: 0.5

      }

      Image {
        id: logo

        width: menubar.contentWidth
        height: vpx(60)

        fillMode: Image.PreserveAspectFit
        source: "../assets/images/logos/" + api.currentCollection.shortName + ".svg"
        asynchronous: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: vpx(80)
        opacity: 0.75
      }

      ListView {
        id: gameList
        property var collectionList: api.collections.model
        width: parent.width

        preferredHighlightBegin: vpx(160); preferredHighlightEnd: vpx(160)
        highlightRangeMode: ListView.ApplyRange

        anchors {
          top: logo.bottom; topMargin: vpx(80)
          left: parent.left;
          right: parent.right
          bottom: parent.bottom; bottomMargin: vpx(80)
        }

        model: collectionList

        delegate: collectionListItemDelegate
        currentIndex: api.collections.index
        onCurrentIndexChanged: navSound.play()
      }

      Component {
        id: collectionListItemDelegate

        Rectangle {
          id: menuitem
          readonly property bool selected: ListView.isCurrentItem
          width: menubar.width
          height: vpx(40)

          color: selected ? "#FF9E12" : "transparent"

          Text {
            text: {
              if (modelData.name == "Super Nintendo Entertainment System")
                "Super NES"
              else if (modelData.name == "Nintendo Entertainment System")
                "NES"
              else
                modelData.name
            }

            anchors { left: parent.left; leftMargin: vpx(50)}
            color: selected ? "black" : "white"
            font.pixelSize: vpx(25)
            font.family: globalFonts.sans
            //font.capitalization: Font.AllUppercase
            //font.bold: true
            //width: ListView.view.width
            height: vpx(40)
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            }

            MouseArea {
                anchors.fill: menuitem
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onWheel: {}
                onClicked: {
                  api.collections.index = index
                  menuCloseRequested();
                }
            }
        }
    }
    LinearGradient {
          width: vpx(2)
          height: parent.height
          anchors {
              top: parent.top
              right: parent.right
              bottom: parent.bottom
          }
          /*start: Qt.point(0, 0)
          end: Qt.point(0, height)*/
          gradient: Gradient {
              GradientStop { position: 0.0; color: "#00ffffff" }
              GradientStop { position: 0.5; color: "#ffffffff" }
              GradientStop { position: 1.0; color: "#00ffffff" }
          }
          opacity: 0.2
      }

  }

  MouseArea {
      anchors {
          top: parent.top; left: menubg.right
          bottom: parent.bottom; right: parent.right

      }
      cursorShape: Qt.PointingHandCursor
      onClicked: {toggleMenu()}
      visible: parent.focus
  }

  function intro() {
      bgblur.opacity = 1;
      menubg.x = 0;
      menuIntroSound.play()
  }

  function outro() {
      bgblur.opacity = 0;
      menubg.x = -menubar.width;
      menuIntroSound.play()
  }

}
