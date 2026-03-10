open Lwt.Syntax

let send_webhook url payload =
  let headers =
    Cohttp.Header.of_list [ ("Content-Type", "application/json") ]
  in
  let body = Yojson.Safe.to_string payload in
  let* resp, body_resp =
    Cohttp_lwt_unix.Client.post ~headers ~body:(`String body)
      (Uri.of_string url)
  in
  let* body_resp_str = Cohttp_lwt.Body.to_string body_resp in
  let status = Cohttp.Response.status resp |> Cohttp.Code.code_of_status in
  if status >= 400 then
    Fmt.epr "Webhook request failed with status %d: %s\n%!" status body_resp_str;
  Lwt.return_unit

let main url markdown =
  let payload =
    `Assoc
      [ ( "blocks"
        , `List
            [ `Assoc
                [ ("type", `String "section")
                ; ( "text"
                  , `Assoc
                      [ ("type", `String "mrkdwn"); ("text", `String markdown) ]
                  )
                ]
            ] )
      ]
  in
  send_webhook url payload

let run url markdown = Lwt_main.run (main url markdown)
