/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import "Styles/Settings.js" as Settings

/*!
    \qmltype ComboBox
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup controls
    \brief ComboBox is a combined button and popup list.

    The popup menu itself is platform native, and cannot by styled from QML code.

    Add menu items to the comboBox by either adding MenuItem children inside the popup, or
    assign it a ListModel (or both).

    The ComboBox contains the following API (in addition to the BasicButton API):

    ListModel model - this model will be used, in addition to MenuItem children, to
      create items inside the popup menu
    int selectedIndex - the index of the selected item in the popup menu.
    string selectedText - the text of the selected menu item.

    Example 1:

    \qml
       ComboBox {
           model: ListModel {
               id: menuItems
               ListElement { text: "Banana"; color: "Yellow" }
               ListElement { text: "Apple"; color: "Green" }
               ListElement { text: "Coconut"; color: "Brown" }
           }
           width: 200
           onSelectedIndexChanged: console.debug(selectedText + ", " + menuItems.get(selectedIndex).color)
       }
    \endqml

    Example 2:

    \qml
       ComboBox {
           width: 200
           MenuItem {
               text: "Pineapple"
               onSelected: console.debug(text)

           }
           MenuItem {
               text: "Grape"
               onSelected: console.debug(text)
           }
       }
    \endqml
*/

Control {
    id: comboBox

    default property alias items: popup.items
    property alias model: popup.model
    property alias textRole: popup.textRole

    property alias selectedIndex: popup.selectedIndex
    readonly property alias selectedText: popup.selectedText

    readonly property bool pressed: mouseArea.pressed && mouseArea.containsMouse || popup.__popupVisible

    /* \internal */
    property alias __containsMouse: mouseArea.containsMouse

    style: Qt.createComponent(Settings.THEME_PATH + "/ComboBoxStyle.qml", comboBox)

    Accessible.role: Accessible.ComboBox

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressedChanged: if (pressed) popup.show()
    }

    ExclusiveGroup { id: eg }

    StyleItem { id: styleItem }

    Component.onCompleted: {
        if (selectedIndex === -1)
            selectedIndex = 0
        if (styleItem.style == "mac") {
            popup.x -= 10
            popup.y += 4
            popup.__font.pointSize = 13
        }
    }

    ContextMenu {
        id: popup

        style: __style.popupStyle

        // 'centerSelectedText' means that the menu will be positioned
        //  so that the selected text' top left corner will be at x, y.
        property bool centerSelectedText: true

        property int x: 0
        property int y: centerSelectedText ? 0 : comboBox.height
        __minimumWidth: comboBox.width
        __visualItem: comboBox

        function finalizeItem(item) {
            item.checkable = true
            item.exclusiveGroup = eg
        }

        function show() {
            if (items[comboBox.selectedIndex])
                items[comboBox.selectedIndex].checked = true
            __currentIndex = comboBox.selectedIndex
            __popup(x, y, centerSelectedText ? comboBox.selectedIndex : 0)
        }
    }

    // The key bindings below will only be in use when popup is
    // not visible. Otherwise, native popup key handling will take place:
    Keys.onSpacePressed: {
        if (!popup.popupVisible)
            popup.show()
    }
    Keys.onUpPressed: { if (selectedIndex > 0) selectedIndex-- }
    Keys.onDownPressed: { if (selectedIndex < model.count - 1) selectedIndex++ }
}