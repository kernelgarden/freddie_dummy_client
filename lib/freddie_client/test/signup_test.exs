defmodule FreddieClient.Test.SignupTest do

  alias FreddieClient.Scheme
  alias FreddieClient.InteractiveClient, as: Client


  def test() do
    Client.connect()

    Scheme.CS_Signup.new(user_id: "golvee0408", password: "password", name: "kernelgarden")
    |> Client.command(use_encryption: true)
  end

end
