import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct AlfonsomirandaCom: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var excerpt: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://alfonsomiranda.com")!
    var title = "Alfonso Miranda"
    var name = "Alfonso Miranda"
    var description = "Mobile Software Engineer"
    var language: Language { .spanish }
    var imagePath: Path? { nil }
    var socialMediaLinks: [SocialMediaLink] { [.linkedIn, .github, .twitter, .twitch] }
    var favicon: Favicon? { .init(path: Path("images/favicon.ico"), type: "image/x-icon")}
}

// This will generate your website using the built-in Foundation theme:
try AlfonsomirandaCom().publish(
    withTheme: .blog,
    additionalSteps: [.deploy(using: .gitHub("alfonsomiranda/alfonsomiranda.github.io", useSSH: false))],
    plugins: [.splash(withClassPrefix: "")]
)
