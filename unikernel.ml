
open Lwt
open V1_LWT

let resp meat = meat |> Cstruct.of_string

module Main (C  : CONSOLE)
            (S  : STACKV4)
            (KV : KV_RO) =
struct

  module TCP  = S.TCPV4
  module TLS  = Tls_mirage.Make (TCP)
  module X509 = Tls_mirage.X509 (KV) (Clock)

  let reply c tls =
    TLS.write tls @@ resp "## We get signal."

  let rec read tls =
      TLS.read tls >>= function
          | `Error _ -> TLS.close tls
          | `Eof -> TLS.close tls
          | `Ok t -> read tls

  let upgrade c conf tcp =
    TLS.server_of_flow conf tcp >>= function
      | `Error _ ->
          C.log_s c "- upgrade error" >> TCP.close tcp
      | `Eof ->
          C.log_s c "- end of file while upgrading" >> TCP.close tcp
      | `Ok tls  ->
          reply c tls >> read tls

  let port = try int_of_string Sys.argv.(1) with _ -> 4433
  let cert = try `Name Sys.argv.(2) with _ -> `Default

  let start c stack kv =
    lwt cert = X509.certificate kv cert in
    let conf = Tls.Config.server ~certificates:(`Single cert) () in
    S.listen_tcpv4 stack port (upgrade c conf) ;
    S.listen stack

end
