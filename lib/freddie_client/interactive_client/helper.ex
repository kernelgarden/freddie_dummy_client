defmodule FreddieClient.InteractiveClient.Helper do

  alias FreddieClient.Scheme
  alias FreddieClient.InteractiveClient

  def login(request_id) do
    request = Scheme.CS_Login.new(id: request_id)
    InteractiveClient.command(request)
  end

end
