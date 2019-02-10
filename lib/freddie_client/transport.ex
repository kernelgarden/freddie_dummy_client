defmodule FreddieClient.Transport do
  def send(socket, data) do
    msg = data
    :ok = :gen_tcp.send(socket, msg)
  end
end
