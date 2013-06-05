#!/usr/bin/ruby -w
# coding: utf-8

def data_input(filename)
    lines = File.open(filename, "r").readlines
    $n_physical_node = Integer(lines[0])
    $m_virtual_node = Integer(lines[1])
    $c_capicity = Array.new($n_physical_node) {|i| lines[i+2].split().collect {|s| Integer(s)}}
    $d_demands = lines[2+$n_physical_node].split().collect {|s| Integer(s)}
end

data_input("input.txt")
