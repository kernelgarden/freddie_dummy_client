defmodule FreddieClient.InteractiveClient.Session do
  alias __MODULE__

  defstruct socket: nil, is_active: false, buffer: <<>>, aes_key: <<>>

  def new(socket), do: %Session{socket: socket, is_active: true}

  def update(session, key, value) do
    new_session = Map.put(session, key, value)
  end

  def update(session, update_list) when is_list(update_list) do
    new_session =
      update_list
      |> Enum.reduce(session, fn {key, value}, old_session ->
        Map.put(old_session, key, value)
      end)

    new_session
  end
end
