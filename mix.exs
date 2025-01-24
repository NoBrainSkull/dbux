defmodule DBux.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dbux,
     version: "1.1.0",
     elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
     deps: deps()
     ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:connection, "~> 1.1"},
     ]
  end

end

