# Ha! for ios

[![Travis CI](https://travis-ci.org/atjoneswang/haforios.svg?branch=master)](https://travis-ci.org/atjoneswang/haforios)
[![Language](https://img.shields.io/badge/language-swift%203.0-green.svg)](https://developer.apple.com/swift)


![hachat](https://github.com/atjoneswang/hachatios/raw/master/hachat/Assets.xcassets/AppIcon.appiconset/Icon-60%402x.png)

使用WebSocket開發具備除了傳Ha還可以打點其他東西的即時通訊app  

利用WebSocket跟 Ha! server溝通，傳送即時資料。將資料利用protocol buffers打包後經由WebSocket傳送到server端。

# Requirement
 - iOS 10
 - Xcode 8
 - swift 3
 - 
   
# New feature
- Like button: 送人家一個讚


# Library

* [Starscream](https://github.com/daltoniam/Starscream)
* [Protocol Buffers](https://developers.google.com/protocol-buffers/)
* [protobuf-swift](https://github.com/alexeyxo/protobuf-swift)   

# WebSocket名詞解釋
WebSocket 是獨立的、建立在 TCP 上的協定，和 HTTP 的唯一關聯是使用 HTTP 協定的101狀態碼進行協定切換，使用的 TCP 埠是80，可以用於繞過大多數防火牆的限制。
WebSocket 使得用戶端和伺服器之間的資料交換變得更加簡單，允許伺服端直接向用戶端推播資料而不需要用戶端進行請求，在 WebSocket API 中，瀏覽器和伺服器只需要完成一次交握，兩者之間就直接可以建立永續性的連線，並允許資料進行雙向傳送。
目前常見的瀏覽器如 Chrome、IE、Firefox、Safari、Opera 等都支援 WebSocket，同時需要伺服端程式支援 WebSocket。
[wiki資料](https://zh.wikipedia.org/wiki/WebSocket)
  

# Reference 其他相關類似
* [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)
* [SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket)
* [SwiftPhoenixClient](https://github.com/davidstump/SwiftPhoenixClient)
