IO.puts("Initializing...")
IO.puts("Fetching dependencies... Please wait!")
System.cmd("mix", ["deps.get"])
IO.puts("Compiling application... Please wait!")
System.cmd("mix", ["compile"])
IO.puts ~s{Application successfully compiled. Please run "mix run_util" to start the utility}
