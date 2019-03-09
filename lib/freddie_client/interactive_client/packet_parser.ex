defmodule FreddieClient.InteractiveClient.PacketParser do
  # header size is unsigned integer of 4 byte
  @header_size 4 * 8

  alias FreddieClient.InteractiveClient.Session
  alias FreddieClient.InteractiveClient.PacketHandler

  def on_read(%Session{} = session) do
    new_session =
      case parse(session.buffer, session) do
        :empty ->
          %Session{session | buffer: <<>>}

        {:not_enough_data, remain} ->
          %Session{session | buffer: remain}
      end

    new_session
  end

  defp parse(<<>>, _session) do
    :empty
  end

  # To maximize optimization, I adopt like this.
  # http://erlang.org/doc/efficiency_guide/binaryhandling.html#matching-binaries
  defp parse(<<length::big-@header_size, data::binary>> = buffer, session) do
    case data do
      <<cur_data::binary-size(length), remain::binary>> ->
        PacketHandler.handle(
          Freddie.Scheme.Common.decode_message(cur_data, session.aes_key),
          session
        )

        parse(remain, session)

      _ ->
        {:not_enough_data, buffer}
    end
  end

  defp parse(buffer, _session) do
    {:not_enough_data, buffer}
  end
end
