defmodule FreddieClient.InteractiveClient.PacketHandler.Signin do

  alias FreddieClient.Scheme

  def handle({_command, meta, payload}, session) do
    response = Scheme.SC_Signin.decode(payload)

    IO.puts("[Signin Handler] Received : #{inspect(response)}")

  end

end
