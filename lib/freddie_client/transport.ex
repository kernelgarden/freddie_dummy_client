defmodule FreddieClient.Transport do
  def send(socket, data) do
    msg = Freddie.Utils.pack_message(data)
    :ok = :gen_tcp.send(socket, msg)
  end
end
