defmodule FreddieClient.Scheme do
  use Protobuf, from: Path.wildcard(Path.expand("./definitions/**/*.proto", __DIR__))
end
