// Copyright (c) 2025 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../controls"
import "../components"

RowLayout {
    id: root

    property int selectedIndex: 1
    property string selectedLabel: feeModel.get(root.selectedIndex).feeLabel

    signal feeChanged(int target)

    height: 40

    CoreText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 15
        text: qsTr("Fee")
    }

    Button {
        id: dropDownButton
        text: root.selectedLabel
        font.pixelSize: 15

        hoverEnabled: true

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }

        onPressed: feePopup.open()

        contentItem: RowLayout {
            spacing: 5

            CoreText {
                id: value
                text: root.selectedLabel
                font.pixelSize: 15

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Icon {
                id: caret
                source: "image://images/caret-down-medium-filled"
                Layout.preferredWidth: 30
                size: 30
                color: dropDownButton.enabled ? Theme.color.orange : Theme.color.neutral4

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        background: Rectangle {
            id: dropDownButtonBg
            color: Theme.color.background
            radius: 6
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        states: [
            State {
                name: "CHECKED"; when: dropDownButton.checked
                PropertyChanges { target: icon; color: activeColor }
            },
            State {
                name: "HOVER"; when: dropDownButton.hovered
                PropertyChanges { target: dropDownButtonBg; color: Theme.color.neutral2 }
            },
            State {
                name: "DISABLED"; when: !dropDownButton.enabled
                PropertyChanges { target: dropDownButtonBg; color: Theme.color.background }
            }
        ]
    }

    Popup {
        id: feePopup
        modal: true
        dim: false

        background: Rectangle {
            color: Theme.color.background
            radius: 6
            border.color: Theme.color.neutral3
        }

        width: 260
        height: Math.min(feeModel.count * 40 + 20, 300)
        x: feePopup.parent.width - feePopup.width
        y: feePopup.parent.height

        contentItem: ListView {
            id: feeList
            model: feeModel
            interactive: false
            width: 260
            height: contentHeight
            delegate: ItemDelegate {
                id: delegate
                required property string feeLabel
                required property int index
                required property int target

                width: ListView.view.width
                height: 40

                background: Item {
                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Theme.color.neutral3
                        visible: delegate.hovered
                    }
                    Separator {
                        width: parent.width
                        anchors.top: parent.top
                        color: Theme.color.neutral2
                        visible: delegate.index > 0
                    }
                }

                contentItem: RowLayout {
                    spacing: 10

                    CoreText {
                        text: feeLabel
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                        font.pixelSize: 15
                    }

                    Icon {
                        visible: delegate.index === root.selectedIndex
                        source: "image://images/check"
                        color: Theme.color.orange
                        size: 20
                    }
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                onClicked: {
                    root.selectedIndex = delegate.index
                    root.selectedLabel = feeLabel
                    root.feeChanged(target)
                    feePopup.close()
                }
            }
        }
    }

    ListModel {
        id: feeModel
        ListElement { feeLabel: qsTr("High (~10 mins)"); target: 1 }
        ListElement { feeLabel: qsTr("Default (~60 mins)"); target: 6 }
        ListElement { feeLabel: qsTr("Low (~24 hrs)"); target: 144 }
    }
}
