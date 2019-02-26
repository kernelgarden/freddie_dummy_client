defmodule FreddieClient.Message do

  alias FreddieClient.Scheme
  alias FreddieClient.Packets

  def send_message(socket, command, payload, aes_key \\ 0, opts \\ []) do
    req = FreddieClient.Message.pack_msg(command, payload, aes_key, opts)
    FreddieClient.Transport.send(socket, req)
    IO.puts("Send to Server command: #{command}, payload: #{inspect payload}")
  end

  def pack_msg(command, payload, aes_key \\ 0, opts \\ []) do
    packet = Freddie.Scheme.Common.new_message_dummy(command, payload, aes_key, opts)
    packet
  end

  def unpack_msg(socket, msg, aes_key) do
    {command, meta, payload} =
      Freddie.Scheme.Common.decode_message(msg, aes_key)

    case command do
      # Connection Info
      -1 ->
        connection_info = Scheme.ConnectionInfo.decode(payload)
        client_private_key = Freddie.Security.DiffieHellman.generate_private_key()
        client_public_key = Freddie.Security.DiffieHellman.generate_public_key(client_private_key)
        calculated_secret_key = Freddie.Security.Aes.generate_aes_key(
          Freddie.Security.DiffieHellman.generate_secret_key(connection_info.key_info.pub_key, client_private_key))

        IO.puts("Calculated_secret_key: #{inspect(calculated_secret_key)}")

        connection_info_reply = Scheme.ConnectionInfoReply.new(client_pub_key: client_public_key)

        FreddieClient.Message.send_message(socket, -2, connection_info_reply)

      # SC_EncryptPong
      4 ->
        pong = Scheme.SC_EncryptPong.decode(payload)

        case meta.use_encryption do
          true ->
            IO.puts("Recieved encrypt pong from server! msg: #{inspect pong.msg} - #{pong.idx}")
          false ->
            IO.puts("Recieved pong from server! msg: #{inspect pong.msg} - #{pong.idx}")
        end

        request = Scheme.CS_EncryptPing.new(msg: "Ping!", idx: pong.idx + 1)

        case aes_key != 0 do
          true ->
            FreddieClient.Message.send_message(socket, 3, request, aes_key, use_encryption: true)
          false ->
            FreddieClient.Message.send_message(socket, 3, request)
        end

      other ->
        other
    end
  end
end
