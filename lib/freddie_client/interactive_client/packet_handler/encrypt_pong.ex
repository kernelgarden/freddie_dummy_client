defmodule FreddieClient.InteractiveClient.PacketHandler.EncryptPong do

  alias FreddieClient.Scheme

  alias FreddieClient.InteractiveClient.Sender

  def handle({_command, meta, payload}, session) do
    pong = Scheme.SC_EncryptPong.decode(payload)

    case meta.use_encryption do
      true ->
        IO.puts("Recieved encrypt pong from server! msg: #{inspect pong.msg} - #{pong.idx}")
      false ->
        IO.puts("Recieved pong from server! msg: #{inspect pong.msg} - #{pong.idx}")
    end

    request = Scheme.CS_EncryptPing.new(msg: "Ping!", idx: pong.idx + 1)

    case session.aes_key != 0 do
      true ->
        Sender.send(session, request, use_encryption: true)
      false ->
        Sender.send(session, request)
    end
  end

end
