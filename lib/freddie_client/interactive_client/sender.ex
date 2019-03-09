defmodule FreddieClient.InteractiveClient.Sender do
  def send(session, payload, opts \\ []) do
    case packet_2_command(payload) do
      {:ok, command} ->
        req = FreddieClient.Message.pack_msg(command, payload, session.aes_key, opts)
        FreddieClient.Transport.send(session.socket, req)
        IO.puts("Send to Server command: #{command}, payload: #{inspect(payload)}")

      other ->
        IO.puts("#{inspect(other)}")
    end
  end

  def pack_msg(command, payload, aes_key \\ 0, opts \\ []) do
    packet = Freddie.Scheme.Common.new_message_dummy(command, payload, aes_key, opts)
    packet
  end

  defp packet_2_command(packet) do
    packet_type = packet.__struct__
    key = Module.concat(FreddieClient.Packets.Types, packet_type)

    result =
      try do
        packet_num = FreddieClient.Packets.Types.value(key)
        {:ok, packet_num}
      rescue
        e -> {:error, {:command_2_packet_type, :invalid_packet}}
      end

    result
  end
end
