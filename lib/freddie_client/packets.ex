defmodule FreddieClient.Packets do
  use EnumType

  defenum Types do
    value FreddieClient.Scheme.ConnectionInfo, -1
    value FreddieClient.Scheme.ConnectionInfoReply, -2
    value FreddieClient.Scheme.CS_Echo, 1
    value FreddieClient.Scheme.SC_Echo, 2
  end

end
