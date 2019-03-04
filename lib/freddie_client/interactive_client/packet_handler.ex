defmodule FreddieClient.InteractiveClient.PacketHandler do

  alias FreddieClient.InteractiveClient.PacketHandler

  alias FreddieClient.Packets.Types.FreddieClient.Scheme

  def handle({command, meta, payload} = packet, session) do
    packet_type =
      try do
        FreddieClient.Packets.Types.from(command)
      rescue
        e -> :none
      end

    case packet_type do
      Scheme.ConnectionInfo ->
        PacketHandler.ConnectionInfo.handle(packet, session)

      Scheme.SC_Echo ->
        nil

      Scheme.SC_EncryptPong ->
        PacketHandler.EncryptPong.handle(packet, session)

      Scheme.SC_Login ->
        nil

      _-> :noop
    end
  end
end
