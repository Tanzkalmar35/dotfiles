;; extends

((multiline_comment) @injection.content
  (#match? @injection.content "^/\\*\\*")
  (#set! injection.language "markdown_inline"))
