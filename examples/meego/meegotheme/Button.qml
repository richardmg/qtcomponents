import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.Button {
    //leftMargin:12
    //rightMargin:1
    //minimumWidth:100
    minimumHeight: 40

    background: BorderImage {
        source: pressed ? "image://theme/meegotouch-button-background-pressed" :
                "image://theme/meegotouch-button-background"
        border.top: 12
        border.bottom: 12
        border.left: 12
        border.right: 12
    }
}
