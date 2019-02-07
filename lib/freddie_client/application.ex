defmodule FreddieClient.Application do
  use Application

  def start(_, _) do
    session_num = Application.
    Supervisor.start_link([
      FreddieClient
    ], strategy: :one_for_one)
  end

end
