open Lwt
open Cohttp
open Cohttp_lwt_unix

(** make the http request to github api to delete a repo *)
let delete_repo (repo_name: string): string t =
  let token = Sys.getenv "GH_TOKEN" in
  let uri = Uri.of_string ("https://api.github.com/repos/loganlieou/" ^ repo_name) in
  let headers = Header.init ()
    |> fun h -> Header.add h "Authorization" ("Bearer " ^ token)
  in
  Client.call ~headers `DELETE uri >>= fun (_resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body -> body

(** populate *)
let repo_list: string list = []

(** delete all repos in the repo list *)
let () =
  List.iter (fun name -> 
    let resp = Lwt_main.run @@ delete_repo name in
    print_endline resp
  ) repo_list
