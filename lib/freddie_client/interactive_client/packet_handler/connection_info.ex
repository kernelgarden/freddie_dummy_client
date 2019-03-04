defmodule FreddieClient.InteractiveClient.PacketHandler.ConnectionInfo do

  alias Freddie.Security.Aes
  alias Freddie.Security.DiffieHellman

  alias FreddieClient.Scheme

  alias FreddieClient.InteractiveClient
  alias FreddieClient.InteractiveClient.Sender

  def handle({_command, _meta, payload}, session) do
    connection_info = FreddieClient.Scheme.ConnectionInfo.decode(payload)
    client_private_key = DiffieHellman.generate_private_key()
    client_public_key = DiffieHellman.generate_public_key(client_private_key)
    calculated_secret_key = Aes.generate_aes_key(
      DiffieHellman.generate_secret_key(connection_info.key_info.pub_key, client_private_key))

    IO.puts("Calculated_secret_key: #{inspect(calculated_secret_key)}")

    connection_info_reply =
      Scheme.ConnectionInfoReply.new(client_pub_key: client_public_key)

    InteractiveClient.set_aes(calculated_secret_key)
    Sender.send(session, connection_info_reply)
  end

end
