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
      in
      Sigh.Notify.run url
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
      | `Exn -> Cmdliner.Cmd.Exit.internal_error)

let () = exit returncode
