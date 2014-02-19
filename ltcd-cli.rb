#! /usr/bin/env ruby
#
require 'cli_utils'
require 'json'

def generate_command
  c_path = File.join(File.dirname(follow_if_link(__FILE__)), 'src', 'commands.json')
  cu = CliUtils.new(c_path)

  if cu.command
    command = cu.commands[cu.command]
    required = (command['required'] || []).map{|k| cu.required[k]}.join
    #TODO deal with optional args
    "litecoind #{command['long']} #{required}"
  else
    "litecoind #{ARGV.join(' ')}"
  end
end

def follow_if_link(path, depth=5)
  if depth > 0
    path = follow_if_link(File.readlink(path), depth - 1) if File.symlink?(path)
  else
    ($stderr.puts("Symlink depth too great"); exit 1) if File.symlink?(path)
  end

  path
end

#example eval method
def bleep
  puts "bleeeeeeeeeeeeeeeeep"
end

Kernel.exec(generate_command)
