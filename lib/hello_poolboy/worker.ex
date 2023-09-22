defmodule HelloPoolboy.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def print_to_pdf(pid, number) do
    GenServer.call(pid, {:print_to_pdf, number})
  end

  def handle_call({:print_to_pdf, i}, _from, state) do
    IO.inspect("process #{inspect(self())} printing number #{i}")

    :ok =
      ChromicPDF.print_to_pdf({:url, "https://example.net"},
        output: "/Users/axelclark/workspace/hello_poolboy/output/example_#{i}.pdf"
      )

    {:reply, :ok, state}
  end
end
