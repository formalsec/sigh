let commands =
  let open Cmdliner in
  let open Cmdliner.Term.Syntax in
  let cmd_notify =
    let info =
      let doc = "Send a webhook notification" in
      Cmd.info "notify" ~doc
    in
    let term =
      let+ url =
        let doc = "The webhook URL to send the notification to." in
        Arg.(required & pos 0 (some string) None & info [] ~docv:"URL" ~doc)
      and+ markdown =
        let doc = "The markdown content of the notification." in
        Arg.(value & pos 1 (some string) None & info [] ~docv:"MARKDOWN" ~doc)
      in
      let markdown =
        match markdown with
        | Some md -> md
        | None ->
          let rec read_stdin acc =
            try
              let line = input_line stdin in
              read_stdin (acc ^ line ^ "\n")
            with End_of_file -> acc
          in
          read_stdin ""
      in
      Sigh.Notify.run url markdown
    in
    Cmd.v info term
  in

  let info = Cmd.info "sigh" in
  Cmd.group info [ cmd_notify ]

let returncode =
  match Cmdliner.Cmd.eval_value commands with
  | Ok (`Help | `Version | `Ok ()) -> Cmdliner.Cmd.Exit.ok
  | Error e -> (
    match e with
    | `Term -> Cmdliner.Cmd.Exit.some_error
    | `Parse -> Cmdliner.Cmd.Exit.cli_error
    | `Exn -> Cmdliner.Cmd.Exit.internal_error )

let () = exit returncode
