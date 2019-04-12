defmodule FreddieClient.Packets do
  use EnumType

  defenum Types do
    value(FreddieClient.Scheme.ConnectionInfo, -1)
    value(FreddieClient.Scheme.ConnectionInfoReply, -2)
    value(FreddieClient.Scheme.CS_Echo, 1)
    value(FreddieClient.Scheme.SC_Echo, 2)
    value(FreddieClient.Scheme.CS_EncryptPing, 3)
    value(FreddieClient.Scheme.SC_EncryptPong, 4)
    value(FreddieClient.Scheme.CS_Login, 5)
    value(FreddieClient.Scheme.SC_Login, 6)
    # sign up
    value(FreddieClient.Scheme.CS_Signup, 7)
    value(FreddieClient.Scheme.SC_Signup, 8)

    # sign in
    value(FreddieClient.Scheme.CS_Signin, 9)
    value(FreddieClient.Scheme.SC_Signin, 10)
  end
end
