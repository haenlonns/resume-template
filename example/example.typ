#import "../template.typ": resume

#let data = json("./example.json")
#let r = resume(data)
#show: r.setup

#r.header
#(r.groups)(data.sections.at("skills"))
#(r.entries)(data.sections.at("work"))
#(r.entries)(data.sections.at("projects"))
#(r.entries)(data.sections.at("leadership"))
#(r.entries)(data.sections.at("education"))
