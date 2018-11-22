//
//  main.swift
//  BillboardBot
//
//  Created by Fitzgerald Afful on 18/11/2018.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import Foundation
import BillboardSwiftLibrary
import SlackKit


class BillboardChartsBot {
	
	let bot: SlackKit
	
	init(token: String) {
		bot = SlackKit()
		bot.addRTMBotWithAPIToken(token)
		bot.addWebAPIAccessWithToken(token)
		bot.notificationForEvent(.message) { [weak self] (event, client) in
			guard
				let message = event.message,
				let id = client?.client?.authenticatedUser?.id,
				message.text?.contains(id) == true
				else {
					return
			}
			self?.handleMessage(message)
		}
	}
	
	init(clientID: String, clientSecret: String) {
		bot = SlackKit()
		let oauthConfig = OAuthConfig(clientID: clientID, clientSecret: clientSecret)
		bot.addServer(oauth: oauthConfig)
		bot.notificationForEvent(.message) { [weak self] (event, client) in
			guard
				let message = event.message,
				let id = client?.client?.authenticatedUser?.id,
				message.text?.contains(id) == true
				else {
					return
			}
			self?.handleMessage(message)
		}
	}
	
	// MARK: Bot logic
	private func handleMessage(_ message: Message) {
		if let text = message.text?.lowercased(), let _ = message.ts, let channel = message.channel {
			
			var chartType: ChartType!
			print(text)
			switch (text.lowercased()){
			case "hot100":
				chartType = ChartType.hot100
			case "billboard200":
				chartType = ChartType.billboard200
			case "artist100":
				chartType = ChartType.artist100
			case "hotrapsongs":
				chartType = ChartType.hotRapSongs
			case "hotrnbsongs":
				chartType = ChartType.hotRnBSongs
			case "digitalalbums":
				chartType = ChartType.digitalAlbums
			case "digitalsongsales":
				chartType = ChartType.digitalSongSales
			case "hotlatin":
				chartType = ChartType.hotLatin
			case "radiosongs":
				chartType = ChartType.radioSongs
			case "streamingsongs":
				chartType = ChartType.streamingSongs
			case "topalbumsales":
				chartType = ChartType.topAlbumSales
			default:
				bot.webAPI?.sendMessage(channel: channel, text: "Please choose one of the following charts: hot100, artist100, billboard200, hotRapSongs, hotRnBSongs, digitalAlbums, digitalSongSales, hotLatin, radioSongs, streamingSongs, topAlbumSales", success: nil, failure: nil)
				return
			}
			
			let manager = BillboardManager()
			manager.getChart(chartType: chartType) { (entries, error) in
				if(error != nil){
					self.bot.webAPI?.sendMessage(channel: channel, text: "Could not return chart. Please try again later.", success: nil, failure: nil)
					return
				}
				var chartToReturn: String = "* Today's " + text + "*\n"
				for item in entries! {
					chartToReturn.append("\(item.rank) \(item.artist) - \(item.title) - \(item.weeks) weeks\n")
				}
				self.bot.webAPI?.sendMessage(channel: channel, text: chartToReturn, success: nil, failure: nil)
				
			}
			return
		}
	}
}

let slackbot = BillboardChartsBot(token: "xoxb-114860851761-485106335745-AQv1xmIqJpTmB5qwBuAXNyfF")
RunLoop.main.run()

