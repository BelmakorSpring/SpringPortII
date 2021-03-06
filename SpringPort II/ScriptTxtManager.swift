//
//  ScriptTxtManager.swift
//  SpringPort II
//
//  Created by MasterBel2 on 9/9/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol ScriptTxtManagerDelegate: class {
    func present(error errorMessage: String)
}

class ScriptTxtManager {
    let fileManager = FileManager.default
    let ip: String
    let port: String
    let username: String
    let scriptPassword: String
    let game: SinglePlayerGame? // Please rename this better
	
    let replay: Replay?
	
    weak var delegate: ScriptTxtManagerDelegate?

	let dir = "\(NSHomeDirectory())/.spring/"
    let filePath = "\(NSHomeDirectory())/.spring/script.txt"
    let fileName = "script.txt"
    var writingText = ""
	
	func setFile(at location: String, with contents: [String]) {
		guard let contentsData = contents.joined(separator: "\n").data(using: String.Encoding.utf8) else { fatalError("Fatal Error: cannot convert file contents from String to Data") }
		fileManager.createFile(atPath: filePath, contents: contentsData, attributes: nil)
    }
	
    init(ip: String, port: String, username: String, scriptPassword: String) {
        self.ip = ip
        self.port = port
        self.username = username
        self.scriptPassword = scriptPassword
        self.replay = nil
        self.game = nil
    }
    init(_ replay: Replay) {
        self.ip = "N/A"
        self.port = "N/A"
        self.username = "N/A"
        self.scriptPassword = "N/A"
        self.replay = replay
        self.game = nil
    }
    init(_ game: SinglePlayerGame) {
        self.ip = "N/A"
        self.port = "N/A"
        self.username = "N/A"
        self.scriptPassword = "N/A"
        self.game = game
        self.replay = nil
    }
		
    func prepareForLaunchOfReplay() {
        guard let replay = replay else { return }
        var contents: [String] = []
        // [GAME]
        let gameTag = "[GAME]"
        let openBrace = "{"
        //        let demoFile = "\tDemoFile=~/.config/spring/demos/\(self.replay.fileName);"
        let demoFile: String = "\tDemoFile=\(NSHomeDirectory())/.config/spring/demos/\(replay.fileName);"
        let closeBrace = "}"
		
        contents.append(contentsOf: [gameTag, openBrace, demoFile, closeBrace])
        setFile(at: filePath, with: contents)
    }
		
    func prepareForLaunchOfSinglePlayerGame() {
		// TODO: -- Shorten this function!!!
        guard let game = game else { return }
        var teamCounter = 0
        let gameTag = "[GAME]"
        let playerTag = "[PLAYER0]"
//        let modOptionsTag = "[MODOPTIONS]"
        let openBrace = "{"
        let closeBrace = "}"
		
        let mapName = "MapName=\(game.mapName);"
        //        /*temp*/let mapHash = "MapHash=4144070437;"
        let gameType = "GameType=\(game.gameType);"
        //        /*temp*/let modHash = "ModHash=1096462279;"
        let startPosType = "StartPosType=\(game.startPosType);"
        let recordDemo = "RecordDemo=1;" // TODO: -- Change this so you can change the value
        let hostIp = "HostIP=;"
        let hostPort = "HostPort=8452;"
        let myPlayerName = "MyPlayerName=\(game.myPlayerName);"
        let isHost = "IsHost=1;"
		
        let name = "Name=\(game.myPlayerName);" // this makes game.username obselete, but who cares right?
        let password = "Password=\(game.password);"
        let team = "Team=\(teamCounter);"
        teamCounter += 1
        let isFromDemo = "IsFromDemo=\(game.isFromDemo);"
        let countryCode = "CountryCode=\(game.countryCode);"
        let rank = "Rank=\(game.rank);"
		
        var aIs: [String] = []
        for i in 0..<game.names.count {
            let tag = "[AI\(i)]"
            let aiName = "Name=\(game.names[i]);"
            let shortName = "ShortName=\(game.shortName);"
            let version = "Version=\(game.version);"
            let team = "Team=\(teamCounter);"
            teamCounter += 1
            let host = "Host=0;"
            aIs.append(contentsOf: [tag, openBrace, aiName, shortName, version, team, host, closeBrace])
        }
		
        var teams: [String] = []
		for i in 0..<game.teams.count {
            let team = game.teams[i]
            let tag = "[TEAM\(i)]"
            let teamLeader = "TeamLeader=\(team.teamLeader);"
            let allyTeam = "AllyTeam=\(team.allyTeamNumber);"
            let rgbColor = "RgbColor=\(team.rgbColor);"
            let side = "Side=\(team.side);"
            let handicap = "Handicap=\(team.handicap);"
            let advantage = "Advantage=\(team.advantage);"
            let incomeMultiplier = "IncomeMultiplier=\(team.incomeMultiplier);"
            teams.append(contentsOf: [tag, openBrace, teamLeader, allyTeam, rgbColor, side, handicap, advantage, incomeMultiplier, closeBrace])
            //            guard game.gameType == "0" else { break }
        }
        var allyTeams: [String] = []
        for i in 0..<game.teams.count {
            let tag = "[ALLYTEAM\(i)]"
            allyTeams.append(contentsOf: [tag, openBrace, closeBrace])
            //            guard game.gameType == "0" else { break }
        }
		
        var modOptions: [String] = []
        for modOption in game.modOptions {
            modOptions.append("\(modOption.name)=\(modOption.value);")
        }
        var contents: [String] = []
        contents.append(contentsOf: [ gameTag,
											openBrace,
											mapName,
			//                              mapHash,
            								gameType,
            //                              modHash,
            								startPosType,
											recordDemo,
											hostIp,
											hostPort,
											myPlayerName,
											isHost,
											playerTag,
											openBrace,
											name,
											password,
											team,
											isFromDemo,
											countryCode,
											rank,
											closeBrace])
        contents.append(contentsOf: aIs)
        contents.append(contentsOf: teams)
        contents.append(contentsOf: allyTeams)
        contents.append(contentsOf: modOptions)
        contents.append(closeBrace)
		setFile(at: filePath, with: contents)
    }
		
    func prepareForLaunchOfSpringAsClient() {
        let scriptPassword = self.scriptPassword
        var contents: [String] = []
        // [GAME]
        let gameTag = "[GAME]"
        let openBrace = "{"
		
        let hostIpLine = "\tHostIP=\(self.ip);"
        let hostPortLine = "\tHostPort=\(self.port);"
		
        let myPlayerNameLine = "\tMyPlayerName=\(self.username);"
        let myPasswdLine = "\tMyPasswd=\(scriptPassword);"
        let isHostLine = "\tIsHost=0;"
		
        let closeBrace = "}"
		
        contents.append(contentsOf: [gameTag, openBrace, hostIpLine, hostPortLine, myPlayerNameLine, myPasswdLine, isHostLine, closeBrace])
        setFile(at: filePath, with: contents)
    }
}

