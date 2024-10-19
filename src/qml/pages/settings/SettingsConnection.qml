// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Item {
    id: root
    signal back
    property bool onboarding: false
    SwipeView {
        id: connectionSwipe
        property bool onboarding: false
        anchors.fill: parent
        interactive: false
        orientation: Qt.Horizontal
        InformationPage {
            id: connection_settings
            background: null
            clip: true
            bannerActive: false
            bold: true
            showHeader: root.onboarding
            headerText: qsTr("Connection settings")
            headerMargin: 0
            detailActive: true
            detailItem: ConnectionSettings {
                onNext: connectionSwipe.incrementCurrentIndex()
            }

            states: [
                State {
                    when: root.onboarding
                    PropertyChanges {
                        target: connection_settings
                        navLeftDetail: null
                        navMiddleDetail: null
                        navRightDetail: doneButton
                    }
                },
                State {
                    when: !root.onboarding
                    PropertyChanges {
                        target: connection_settings
                        navLeftDetail: backButton
                        navMiddleDetail: header
                        navRightDetail: null
                    }
                }
            ]

            Component {
                id: backButton
                NavButton {
                    iconSource: "image://images/caret-left"
                    text: qsTr("Back")
                    onClicked: root.back()
                }
            }
            Component {
                id: header
                Header {
                    headerBold: true
                    headerSize: 18
                    header: qsTr("Connection settings")
                }
            }

            Component {
                id: doneButton
                NavButton {
                    text: qsTr("Done")
                    onClicked: root.back()
                }
            }
        }
        SettingsProxy {
            onBackClicked: {
                connectionSwipe.decrementCurrentIndex()
            }
        }
    }
}
