defmodule FreddieClient.Transport do
  def send(socket, data) do
    msg = data
    :gen_tcp.send(socket, msg)
  end
end
