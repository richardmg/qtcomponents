/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

ApplicationWindow {
    id: window

    width: 800
    height: 480
    visible: true

    toolBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.margins: window.spacing
            CheckBox {
                id: selectBox
                text: "SelectByMouse"
                checked: true
            }
            CheckBox {
                id: handleBox
                text: "Handles"
                checked: true
                enabled: selectBox.checked
            }
            CheckBox {
                id: outlineBox
                text: "Outlines"
                checked: false
                enabled: handleBox.enabled && handleBox.checked
            }
            Item { width: 1; height: 1; Layout.fillWidth: true }
            CheckBox {
                id: wrapBox
                text: "Wrap"
                checked: true
            }
        }
    }

    property int spacing: edit.font.pixelSize / 2

    property string loremIpsum: "Lorem ipsum dolor sit amet, <a href='http://qt.digia.com'>consectetur</a> adipiscing elit. " +
                                "Morbi varius a lorem ac blandit. Donec eu nisl eu nisi consectetur commodo. " +
                                "Vestibulum tincidunt <img src='http://qt.digia.com/Static/Images/QtLogo.png'>ornare</img> tempor. " +
                                "Nulla dolor dui, vehicula quis tempor quis, ullamcorper vel dui. " +
                                "Integer semper suscipit ante, et luctus magna malesuada sed. " +
                                "Sed ipsum velit, pellentesque non aliquam eu, bibendum ac magna. " +
                                "Donec et luctus dolor. Nulla semper quis neque vitae cursus. " +
                                "Etiam auctor, ipsum vel varius tincidunt, erat lacus pulvinar sem, eu egestas leo nulla non felis. " +
                                "Maecenas hendrerit commodo turpis, ac convallis leo congue id. " +
                                "Donec et egestas ante, a dictum sapien."

    ColumnLayout {
        spacing: window.spacing
        anchors.margins: window.spacing
        anchors.fill: parent

        TextField {
            id: field
            z: 1
            text: loremIpsum
            Layout.fillWidth: true
            selectByMouse: selectBox.checked

            style: TextFieldStyle {
                cursorHandle: handleBox.checked ? textFileIosSelectionStyle.cursorDelegateComponent : null
                selectionHandle: handleBox.checked ? textFileIosSelectionStyle.selectionDelegateComponent : null

                IosSelectionStyle {
                    id: textFileIosSelectionStyle
                }
            }
        }

        SpinBox {
            id: spinbox
            z: 1
            decimals: 2
            value: 500000
            maximumValue: 1000000
            Layout.fillWidth: true
            selectByMouse: selectBox.checked
            horizontalAlignment: Qt.AlignHCenter

            style: SpinBoxStyle {
                cursorHandle: handleBox.checked ? spinBoxIosSelectionStyle.cursorDelegateComponent : null
                selectionHandle: handleBox.checked ? spinBoxIosSelectionStyle.selectionDelegateComponent : null

                IosSelectionStyle {
                    id: spinBoxIosSelectionStyle
                }
            }
        }

        ComboBox {
            id: combobox
            z: 1
            editable: true
            currentIndex: 1
            Layout.fillWidth: true
            selectByMouse: selectBox.checked
            model: ListModel {
                id: combomodel
                ListElement { text: "Apple" }
                ListElement { text: "Banana" }
                ListElement { text: "Coconut" }
                ListElement { text: "Orange" }
            }
            onAccepted: {
                if (find(currentText) === -1) {
                    combomodel.append({text: editText})
                    currentIndex = find(editText)
                }
            }

            style: ComboBoxStyle {
                cursorHandle: handleBox.checked ? comboboxIosSelectionStyle.cursorDelegateComponent : null
                selectionHandle: handleBox.checked ? comboboxIosSelectionStyle.selectionDelegateComponent : null

                IosSelectionStyle {
                    id: comboboxIosSelectionStyle
                }
            }
        }

        TextArea {
            id: edit
            Layout.fillWidth: true
            Layout.fillHeight: true

            textFormat: Qt.RichText
            selectByMouse: selectBox.checked
            wrapMode: wrapBox.checked ? Text.Wrap : Text.NoWrap
            text: loremIpsum + "<p>" + loremIpsum + "<p>" + loremIpsum + "<p>" + loremIpsum

            style: TextAreaStyle {
                cursorHandle: handleBox.checked ? textareaIosSelectionStyle.cursorDelegateComponent : null
                selectionHandle: handleBox.checked ? textareaIosSelectionStyle.selectionDelegateComponent : null

                IosSelectionStyle {
                    id: textareaIosSelectionStyle
                }
            }
        }
    }

}
