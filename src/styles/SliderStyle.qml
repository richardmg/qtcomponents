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
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0

/*!
    \qmltype SliderStyle
    \internal
    \inqmlmodule QtQuick.Controls.Styles 1.0
*/
Style {
    id: styleitem

    property int leftMargin
    property int rightMargin

    property color backgroundColor: "lightgray"

    property Component handle: Item {
        implicitWidth: 20
        implicitHeight: 18
        BorderImage {
            anchors.fill: parent
            source: "images/button.png"
            border.top: 6
            border.bottom: 6
            border.left: 6
            border.right: 6
            BorderImage {
                anchors.fill: parent
                anchors.margins: -1
                anchors.topMargin: -2
                anchors.rightMargin: 0
                anchors.bottomMargin: 1
                source: "images/focusframe.png"
                visible: control.activeFocus
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
            }
        }
    }

    property Component background: Item {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 100
        implicitHeight: 8
        BorderImage {
            anchors.fill: parent
            source: "images/button_down.png"
            border.top: 3
            border.bottom: 3
            border.left: 6
            border.right: 6
        }
    }

    property Component panel: Item {
        id: root
        property bool horizontal : control.orientation === Qt.Horizontal
        property Control __cref: control
        implicitWidth: horizontal ? backgroundLoader.implicitWidth : Math.max(handleLoader.implicitHeight, backgroundLoader.implicitHeight)
        implicitHeight: horizontal ? Math.max(handleLoader.implicitHeight, backgroundLoader.implicitHeight) : backgroundLoader.implicitWidth
        y: horizontal ? 0 : height
        rotation: horizontal ? 0 : -90
        transformOrigin: Item.TopLeft
        Item {
            anchors.fill: parent
            Loader {
                id: backgroundLoader
                property Control control: __cref
                property Item handle: handleLoader.item
                sourceComponent: background
                width: horizontal ? parent.width : parent.height
                y: Math.round(horizontal ? parent.height/2 : parent.width/2) - backgroundLoader.item.height/2
            }
            Loader {
                id: handleLoader
                property Control control: __cref
                sourceComponent: handle
                anchors.verticalCenter: backgroundLoader.verticalCenter
                x: Math.round(leftMargin + control.value / control.maximumValue * ((horizontal ? root.width : root.height) - leftMargin - rightMargin - item.width))
            }
        }
    }
}
