defmodule ProcessTest do
  def test do
    path = :os.find_executable('goon')
    if !Porcelain.Driver.Goon.check_goon_version(path) do
      raise "Goon not found. Download: https://github.com/alco/goon/releases"
    end
    proc = Porcelain.spawn("/bin/bash", ["-c","sleep 15"])
    Porcelain.Process.signal(proc, :int)
    if !Porcelain.Process.alive?(proc) do
      IO.puts "sigint killed process"
    else
      IO.puts "Process is still alive after sigint"
      Porcelain.Process.signal(proc, :kill)
      if !Porcelain.Process.alive?(proc) do
        IO.puts "sigkill killed process"
      else
        IO.puts "Process is still alive after sigkill"
        Porcelain.Process.stop(proc)
        if !Porcelain.Process.alive?(proc) do
          IO.puts "stop killed process"
        else
          IO.puts "Process is still alive after stop"          
        end
      end
    end
  end
end
