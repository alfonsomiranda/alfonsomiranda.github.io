//
//  File.swift
//  
//
//  Created by Alfonso Miranda Castro on 11/4/21.
//

import Foundation

struct SocialMediaLink {
    let title: String
    let url: String
    let icon: String
}

extension SocialMediaLink {
    static var linkedIn: SocialMediaLink {
        return SocialMediaLink(
            title: "LinkedIn",
            url: "https://www.linkedin.com/in/alfonsomirandacastro/",
            icon: "fab fa-linkedin"
        )
    }
    
    static var github: SocialMediaLink {
        return SocialMediaLink(
            title: "GitHub",
            url: "https://github.com/alfonsomiranda",
            icon: "fab fa-github-square"
        )
    }
    
    static var twitter: SocialMediaLink {
        return SocialMediaLink(
            title: "Twitter",
            url: "https://twitter.com/alfonsobeta",
            icon: "fab fa-twitter-square"
        )
    }
    
    static var twitch: SocialMediaLink {
        return SocialMediaLink(
            title: "Twitch", url: "https://www.twitch.tv/alfonsomiranda", icon: "fab fa-twitch"
        )
    }
}
