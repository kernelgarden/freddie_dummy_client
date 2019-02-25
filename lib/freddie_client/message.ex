defmodule FreddieClient.Message do

  alias FreddieClient.Scheme
  alias FreddieClient.Packets

  def send_message(socket, command, payload) do
    req = FreddieClient.Message.pack_msg(command, payload)
    FreddieClient.Transport.send(socket, req)
  end

  def pack_msg(command, payload) do
    packet = Freddie.Scheme.Common.new_message_dummy(command, payload)
    packet
  end

  def unpack_msg(socket, msg, aes_key) do
    {command, meta, payload} =
      Freddie.Scheme.Common.decode_message(msg, aes_key)

    case command do
      -1 ->
        connection_info = Scheme.ConnectionInfo.decode(payload)
        client_private_key = Freddie.Security.DiffieHellman.generate_private_key()
        client_public_key = Freddie.Security.DiffieHellman.generate_public_key(client_private_key)
        calculated_secret_key = Freddie.Security.Aes.generate_aes_key(
          Freddie.Security.DiffieHellman.generate_secret_key(connection_info.key_info.pub_key, client_private_key))

        IO.puts("Calculated_secret_key: #{inspect(calculated_secret_key)}")

        connection_info_reply = Scheme.ConnectionInfoReply.new(client_pub_key: client_public_key)

        FreddieClient.Message.send_message(socket, -2, connection_info_reply)
      other ->
        other
    end
  end
end
