import QtQuick 1.0
import "../components"
import "content"

Window {
    title: "parent window"

    width: gallery.width
    height: gallery.height
    maximumHeight: gallery.height
    minimumHeight: gallery.height
    maximumWidth: gallery.width
    minimumWidth: gallery.width

    MenuBarBase {
        Menu {
            text: "Hello"
            MenuItem {
                text: "Open"
                shortcut: "Ctrl+O"
                onTriggered: console.log("we should display a file open dialog")
            }
            MenuItem {
                text: "Close"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            text: "World"
            MenuItem {
                text: "Copy"
            }
            MenuItem {
                text: "Paste"
            }
        }
    }

    Component.onCompleted: visible = true

    Gallery {
        id: gallery
    }

}
