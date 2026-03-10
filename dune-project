(lang dune 3.22)

(name sigh)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name sigh)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  cohttp
  cohttp-lwt-unix
  cmdliner
  ocaml
  lwt
  yojson
  (ocamlformat :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup))
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
