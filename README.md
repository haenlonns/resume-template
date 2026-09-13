# Resume template

A Typst resume template built around three layers:

1. [`template.typ`](template.typ) owns the visual design and reusable renderers.
2. A profile JSON file holds the complete set of resume facts.
3. A resume `.typ` file curates that profile: it chooses sections, their order,
   and (for entry sections) which entries to include.

The [`example`](example) directory is a copyable starting point.

## Keep your profile private

Keep personal profiles and tailored resumes in a separate private repository
checked out at `private/`. That directory is deliberately ignored by this
public template repository, so it is never committed or shipped to people who
clone the template.

```text
resume-template/
  template.typ
  example/
  private/              # separate private Git repository
    profile.json
    software.typ
```

The private entrypoint can import the public template with a relative path:

```typst
#import "../template.typ": resume
```

Clone the private overlay into `private/` after cloning the public template.
It is intentionally not a Git submodule: the public template and your private
resume history can be committed and updated independently.

## Create a resume

Load one profile and use the renderers that match the shapes you want to show:

```typst
#import "../template.typ": resume

#let data = json("profile.json")
#let r = resume(data)
#show: r.setup

#r.header
#(r.groups)(data.sections.at("skills"))
#(r.entries)(data.sections.at("work"), ids: ("acme", "previous-role"))
#(r.entries)(data.sections.at("education"))
```

Omit a renderer call to omit the section. Move calls to change section order.
`ids` is optional: without it, every entry in the JSON object's declared order
is rendered. With it, the tuple controls both selection and display order.

Typst stores functions in dictionaries, which is why reusable renderers use the
`#(r.entries)(...)` call syntax. `#r.header` remains plain content.

If compiling from the command line, invoke Typst from the repository root:

```bash
typst compile --root . example/example.typ example/example.pdf
```

## Profile format

The top level contains a header and arbitrary named sections. The name is for
you; the resume entrypoint selects its renderer, so `research`, `volunteering`,
or `open-source` can use the same shape as `work`.

```json
{
  "header": {
    "author": "Jane Doe",
    "subtext": "Optional subtitle",
    "contacts": [
      { "text": "jane@example.com", "url": "mailto:jane@example.com" }
    ]
  },
  "sections": {
    "work": {
      "title": "Work Experience",
      "entries": {
        "acme": {
          "title": "Acme Corp.",
          "right": "Jan 2025 – Present",
          "subtitle": "Software Engineer",
          "subright": "Toronto, ON",
          "items": ["Built *an important feature*."]
        }
      }
    },
    "skills": {
      "title": "Skills",
      "groups": {
        "Languages": ["Python", "Rust", "TypeScript"]
      }
    }
  }
}
```

`entries` is the two-column, bullet-list shape used for work, projects,
leadership, and education. `title` and `right` are its first row; `subtitle`
and `subright` are optional second-row fields. `url` is optional and may be a
full URL or a bare domain. `groups` is the label-and-comma-separated-list shape
used for skills and awards.

An absent or empty `subtext`, `contacts`, `entries`, or `groups` value renders
nothing. Section titles are required for sections you render.

Bullet strings are evaluated as Typst markup, which allows emphasis such as
`*40%*`. Keep profile files trusted: do not feed unreviewed third-party strings
into `items`.
