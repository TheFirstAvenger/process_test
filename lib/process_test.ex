defmodule ProcessTest do
  def test do
    path = :os.find_executable('goon')
    if !Porcelain.Driver.Goon.check_goon_version(path) do
      raise "Goon not found. Download: https://github.com/alco/goon/releases"
    end
    proc = Porcelain.spawn("/bin/bash", ["-c","sleep 15"], [out: IO.stream(:stdout, :line)])
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
          IO.puts "Porcelain reports 'stop' killed process, but check ps -aux | grep sleep to verify."
        else
          IO.puts "Process is still alive after stop"          
        end
      end
    end
  end
  def test2 do
    proc = Porcelain.spawn("/bin/bash", ["-c","sleep 15"], [out: IO.stream(:stdout, :line)])
    do_monitor(proc)
  end

  defp do_monitor(proc) do
    if (Porcelain.Process.alive?(proc))
      IO.puts "It's Alive"
      :timer.sleep(2000)
      do_monitor(proc)
    else
      IO.puts "It's Dead"
    end
  end

end
