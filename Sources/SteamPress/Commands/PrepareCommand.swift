//
//  PrepareCommand.swift
//  starwars
//
//  Created by Micah Walles on 6/18/17.
//
//

/// A command that can be used to perpare the database for
/// an application.
///
/// Use from CLI with:
/// vapor run routes
///
/// Use in Xcode with:
/// Droplet(arguments: ["vapor", "prepare"])

import Vapor
import Console
import FluentProvider

public enum PrepareCommandErrors: Error {
	case NoDatabase
}

public final class PrepareCommand: Command {
	public let id = "prepare"
	public let help = ["This perpares the database"]
	public let console: ConsoleProtocol

	public init(console: ConsoleProtocol) {
		self.console = console
	}

	public func run(arguments: [String]) throws {

		// FIXME: need to pull this from the config files
		guard let database = Database.default else {
			throw PrepareCommandErrors.NoDatabase
		}

		BlogUser.database = database
		BlogPost.database = database
		BlogTag.database = database
		Pivot<BlogPost, BlogTag>.database = database
		try BlogUser.prepare(database)
		try BlogPost.prepare(database)
		try BlogTag.prepare(database)
		try BlogPostDraft.prepare(database)
		try BlogUserExtraInformation.prepare(database)
		try Pivot<BlogPost, BlogTag>.prepare(database)

	}
}

extension PrepareCommand: ConfigInitializable {
	public convenience init(config: Config) throws {
		let console = try config.resolveConsole()
		self.init(console: console)
	}
}
