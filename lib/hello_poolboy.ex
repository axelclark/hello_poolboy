defmodule HelloPoolboy do
  @timeout 60000

  def start_pdf() do
    1..200
    |> Enum.map(fn i -> async_call_print_pdf(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  def async_call_print_pdf(i) do
    Task.async(fn ->
      # Prints a local HTML file to PDF.
      ChromicPDF.print_to_pdf({:url, "https://example.net"}, output: "output/example_#{i}.pdf")
    end)
  end

  defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()

  def start_pdf_with_poolboy() do
    1..200
    |> Enum.map(fn i -> async_call_print_pdf_poolboy(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp async_call_print_pdf_poolboy(i) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid ->
          # Let's wrap the genserver call in a try - catch block. This allows us to trap any exceptions
          # that might be thrown and return the worker back to poolboy in a clean manner. It also allows
          # the programmer to retrieve the error and potentially fix it.
          try do
            HelloPoolboy.Worker.print_to_pdf(pid, i)
          catch
            e, r ->
              IO.inspect("poolboy transaction caught error: #{inspect(e)}, #{inspect(r)}")
              :ok
          end
        end,
        @timeout
      )
    end)
  end

  def start_pdf_with_opq() do
    1..200
    |> Enum.map(fn i -> async_call_print_pdf_opq(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp async_call_print_pdf_opq(i) do
    Task.async(fn ->
      OPQ.enqueue(:pdf, fn ->
        # Prints a local HTML file to PDF.
        IO.puts("process #{inspect(self())} printing number #{i}")
        ChromicPDF.print_to_pdf({:url, "https://example.net"}, output: "output/example_#{i}.pdf")
      end)
    end)
  end
end
