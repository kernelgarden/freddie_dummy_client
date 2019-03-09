defmodule FreddieClient.PerfTest do
  def perf_test do
    session_num = Application.get_env(:freddie_client, :session_num)
    time = Application.get_env(:freddie_client, :time)

    GenServer.start_link(FreddieClient.PerfCollector, session_num: session_num, time: time * 1000)

    # Enum.map(tasks, &Task.await(&1, 25 * 1000)/2)
    # |> IO.inspect

    # clients = Enum.map(1..session_num, fn _ -> GenServer.start_link(FreddieClient, []) end)

    # Process.sleep(time * 1000)

    # total_bytes = Enum.reduce(clients, fn pid, total_bytes -> total_bytes + GenServer.call(pid, {:stop}) end)
    # IO.puts("total_bytes: #{total_bytes} in #{time}secs")
  end
end
