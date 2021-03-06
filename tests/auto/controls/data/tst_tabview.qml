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
import QtTest 1.0

Item {
    id: container
    width: 300
    height: 300

TestCase {
    id: testCase
    name: "Tests_TabView"
    when:windowShown
    width:400
    height:400

    function test_createTabView() {
        var tabView = Qt.createQmlObject('import QtQuick.Controls 1.0; TabView {}', testCase, '');
        tabView.destroy()
    }

    function test_repeater() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { Repeater { model: 3; Tab { } } }', testCase, '');
        compare(tabView.count, 3)
        tabView.destroy()
    }

    Component {
        id: newTab
        Item {}
    }

    function test_changeIndex() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { Repeater { model: 3; Tab { Text { text: index } } } }', testCase, '');
        compare(tabView.count, 3)
        verify(tabView.tabAt(1).item == undefined)
        tabView.currentIndex = 1
        verify(tabView.tabAt(1).item !== undefined)
        verify(tabView.tabAt(2).item == undefined)
        tabView.currentIndex = 1
        verify(tabView.tabAt(2).item !== undefined)
        tabView.destroy()
    }


    function test_addRemoveTab() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { }', testCase, '');
        compare(tabView.count, 0)
        tabView.addTab("title 1", newTab)
        compare(tabView.count, 1)
        tabView.addTab("title 2", newTab)
        compare(tabView.count, 2)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 2")

        tabView.insertTab(1, "title 3")
        compare(tabView.count, 3)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 3")
        compare(tabView.tabAt(2).title, "title 2")

        tabView.insertTab(0, "title 4")
        compare(tabView.count, 4)
        compare(tabView.tabAt(0).title, "title 4")
        compare(tabView.tabAt(1).title, "title 1")
        compare(tabView.tabAt(2).title, "title 3")
        compare(tabView.tabAt(3).title, "title 2")

        tabView.removeTab(0)
        compare(tabView.count, 3)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 3")
        compare(tabView.tabAt(2).title, "title 2")

        tabView.removeTab(1)
        compare(tabView.count, 2)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 2")

        tabView.removeTab(1)
        compare(tabView.count, 1)
        compare(tabView.tabAt(0).title, "title 1")

        tabView.removeTab(0)
        compare(tabView.count, 0)
        tabView.destroy()
    }

    function test_moveTab_data() {
        return [
            {tag:"0->1 (0)", from: 0, to: 1, currentBefore: 0, currentAfter: 1},
            {tag:"0->1 (1)", from: 0, to: 1, currentBefore: 1, currentAfter: 0},
            {tag:"0->1 (2)", from: 0, to: 1, currentBefore: 2, currentAfter: 2},

            {tag:"0->2 (0)", from: 0, to: 2, currentBefore: 0, currentAfter: 2},
            {tag:"0->2 (1)", from: 0, to: 2, currentBefore: 1, currentAfter: 0},
            {tag:"0->2 (2)", from: 0, to: 2, currentBefore: 2, currentAfter: 1},

            {tag:"1->0 (0)", from: 1, to: 0, currentBefore: 0, currentAfter: 1},
            {tag:"1->0 (1)", from: 1, to: 0, currentBefore: 1, currentAfter: 0},
            {tag:"1->0 (2)", from: 1, to: 0, currentBefore: 2, currentAfter: 2},

            {tag:"1->2 (0)", from: 1, to: 2, currentBefore: 0, currentAfter: 0},
            {tag:"1->2 (1)", from: 1, to: 2, currentBefore: 1, currentAfter: 2},
            {tag:"1->2 (2)", from: 1, to: 2, currentBefore: 2, currentAfter: 1},

            {tag:"2->0 (0)", from: 2, to: 0, currentBefore: 0, currentAfter: 1},
            {tag:"2->0 (1)", from: 2, to: 0, currentBefore: 1, currentAfter: 2},
            {tag:"2->0 (2)", from: 2, to: 0, currentBefore: 2, currentAfter: 0},

            {tag:"2->1 (0)", from: 2, to: 1, currentBefore: 0, currentAfter: 0},
            {tag:"2->1 (1)", from: 2, to: 1, currentBefore: 1, currentAfter: 2},
            {tag:"2->1 (2)", from: 2, to: 1, currentBefore: 2, currentAfter: 1},

            {tag:"0->0", from: 0, to: 0, currentBefore: 0, currentAfter: 0},
            {tag:"-1->0", from: 0, to: 0, currentBefore: 1, currentAfter: 1},
            {tag:"0->-1", from: 0, to: 0, currentBefore: 2, currentAfter: 2},
            {tag:"1->10", from: 0, to: 0, currentBefore: 0, currentAfter: 0},
            {tag:"10->2", from: 0, to: 0, currentBefore: 1, currentAfter: 1},
            {tag:"10->-1", from: 0, to: 0, currentBefore: 2, currentAfter: 2}
        ]
    }

    function test_moveTab(data) {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { }', testCase, '');
        compare(tabView.count, 0)

        var titles = ["title 1", "title 2", "title 3"]

        var i = 0;
        for (i = 0; i < titles.length; ++i)
            tabView.addTab(titles[i], newTab)

        compare(tabView.count, titles.length)
        for (i = 0; i < tabView.count; ++i)
            compare(tabView.tabAt(i).title, titles[i])

        tabView.currentIndex = data.currentBefore
        tabView.moveTab(data.from, data.to)

        compare(tabView.count, titles.length)
        compare(tabView.currentIndex, data.currentAfter)

        var title = titles[data.from]
        titles.splice(data.from, 1)
        titles.splice(data.to, 0, title)

        compare(tabView.count, titles.length)
        for (i = 0; i < tabView.count; ++i)
            compare(tabView.tabAt(i).title, titles[i])

        tabView.destroy()
    }

    function test_dynamicTabs() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { property Component tabComponent: Component { Tab { } } }', testCase, '');
        compare(tabView.count, 0)
        var tab1 = tabView.tabComponent.createObject(tabView)
        compare(tabView.count, 1)
        var tab2 = tabView.tabComponent.createObject(tabView)
        compare(tabView.count, 2)
        tab1.destroy()
        wait(0)
        compare(tabView.count, 1)
        tab2.destroy()
        wait(0)
        compare(tabView.count, 0)
    }

    function test_mousePressOnTabBar() {
        var test_tabView = 'import QtQuick 2.1;             \
        import QtQuick.Controls 1.0;                        \
        TabView {                                           \
            width: 200; height: 100;                        \
            property alias tab1: _tab1;                     \
            property alias tab2: _tab2;                     \
            Tab {                                           \
                id: _tab1;                                  \
                title: "Tab1";                              \
                active: true;                               \
                Column {                                    \
                    objectName: "column1";                  \
                    property alias button1: _button1;       \
                    property alias button2: _button2;       \
                    anchors.fill: parent;                   \
                    Button {                                \
                        id: _button1;                       \
                        text: "button 1 in Tab1";           \
                    }                                       \
                    Button {                                \
                        id: _button2;                       \
                        text: "button 2 in Tab1";           \
                    }                                       \
                }                                           \
            }                                               \
            Tab {                                           \
                id: _tab2;                                  \
                title: "Tab2";                              \
                active: true;                               \
                Column {                                    \
                    objectName: "column2";                  \
                    property alias button3: _button3;       \
                    property alias button4: _button4;       \
                    anchors.fill: parent;                   \
                    Button {                                \
                        id: _button3;                       \
                        text: "button 1 in Tab2";           \
                    }                                       \
                    Button {                                \
                        id: _button4;                       \
                        text: "button 2 in Tab2";           \
                    }                                       \
                }                                           \
            }                                               \
        }                                                   '

        var tabView = Qt.createQmlObject(test_tabView, container, '')
        compare(tabView.count, 2)
        verify(tabView.tab1.status === Loader.Ready)
        verify(tabView.tab2.status === Loader.Ready)

        var column1 = getColumnItem(tabView.tab1, "column1")
        verify(column1 !== null)
        var column2 = getColumnItem(tabView.tab2, "column2")
        verify(column2 !== null)

        var button1 = column1.button1
        verify(button1 !== null)
        var button3 = column2.button3
        verify(button3 !== null)

        var tabbarItem = getTabBarItem(tabView)
        verify(tabbarItem !== null)

        var tabrowItem = getTabRowItem(tabbarItem)
        verify(tabrowItem !== null)

        var mouseareas = populateMouseAreaItems(tabrowItem)
        verify(mouseareas.length, 2)

        var tab1 = mouseareas[0].parent
        verify(tab1 !== null)
        //printGeometry(tab1)

        waitForRendering(tab1)
        mouseClick(tab1, tab1.width/2, tab1.height/2)
        verify(button1.activeFocus)

        var tab2 = mouseareas[1].parent
        verify(tab2 !== null)
        //printGeometry(tab2)

        waitForRendering(tab2)
        mouseClick(tab2, tab2.width/2, tab2.height/2)
        verify(button3.activeFocus)

        waitForRendering(tab1)
        mouseClick(tab1, tab1.width/2, tab1.height/2)
        verify(button1.activeFocus)

        waitForRendering(tab2)
        mouseClick(tab2, tab2.width/2, tab2.height/2)
        verify(button3.activeFocus)

        tabView.destroy()
    }

    function printGeometry(control) {
        console.log("printGeometry:" + control)
        console.log("x=" + control.x + ",y=" + control.y + ",w=" + control.width + ",h=" + control.height)
        var g = control.mapToItem(null, control.x, control.y, control.width, control.height)
        console.log("x=" + g.x + ",y=" + g.y + ",w=" + g.width + ",h=" + g.height)
    }

    function getTabBarItem(control) {
        for (var i = 0; i < control.children.length; i++) {
            if (control.children[i].objectName === 'tabbar')
                return control.children[i]
        }
        return null
    }

    function getTabRowItem(control) {
        for (var i = 0; i < control.children.length; i++) {
            if (control.children[i].objectName === 'tabrow')
                return control.children[i]
        }
        return null
    }

    function getColumnItem(control, name) {
        for (var i = 0; i < control.children.length; i++) {
            if (control.children[i].objectName === name)
                return control.children[i]
        }
        return null
    }

    function populateMouseAreaItems(control) {
        var value = new Array()
        for (var i = 0; i < control.children.length; i++) {
            var sub = control.children[i]
            for (var j = 0; j < sub.children.length; j++) {
                var ssub = sub.children[j]
                if (ssub.objectName === "mousearea")
                    value.push(ssub)
            }
        }
        return value
    }
}
}
