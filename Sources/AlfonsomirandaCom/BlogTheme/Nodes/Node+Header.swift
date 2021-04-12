//
//  Node+Header.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot

extension Node where Context == HTML.BodyContext {
    private static var sections: [AlfonsomirandaCom.SectionID] { [AlfonsomirandaCom.SectionID.about] }
    
    static func header(for site: AlfonsomirandaCom) -> Node {
        return .div(
            .div(
                .class("pure-menu pure-menu-horizontal pure-u-1-1 top-header"),
                .ul(
                    .class("pure-menu-list"),
                    .forEach(sections, { section in
                        .li(
                            .class("pure-menu-item"),
                            .a(
                                .class("pure-menu-link"),
                                .text((section.rawValue.capitalized == "About") ? "Sobre mi" : section.rawValue.capitalized),
                                .href(site.path(for: section))
                            )
                        )
                    })
                )
            )
        )
    }
}
