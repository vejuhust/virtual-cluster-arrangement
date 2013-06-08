#!/usr/bin/ruby -w
# coding: utf-8

def data_input(filename)
    lines = File.open(filename, "r").readlines
    $n_physical_node = Integer(lines[0])
    $m_virtual_node = Integer(lines[1])
    $c_capicity = Array.new($n_physical_node) {|i| lines[i+2].split().collect {|s| Integer(s)}}
    $d_demands = lines[2+$n_physical_node].split().collect {|s| Integer(s)}
end

def compare(a, b)
    sum_a, sum_b = 0, 0
    $d_demands.each_with_index do |di, i|
        sum_a += [a[i], di].min * di
        sum_b += [b[i], di].min * di
    end
    return sum_b <=> sum_a if sum_a != sum_b

    sum_a, sum_b = 0, 0
    $d_demands.each_with_index do |di, i|
        sum_a += a[i] * di
        sum_b += b[i] * di
    end
    return sum_b <=> sum_a
end

def search()
    result = Array.new()
    while !$c_capicity.empty? do
        $c_capicity.sort! {|a, b| compare(a, b)}
        selected = $c_capicity.shift
        result << selected
        mark = true
        selected.each_with_index {|ci, i| $d_demands[i] -= ci}
        $d_demands.each_with_index do |di, i|
            if di > 0 then
               mark = false
               break
            elsif di < 0 then
               $d_demands[i] = 0
            end
        end
        break if mark
    end
    return mark ? result : []
end
    
if __FILE__ == $0
    data_input("input.txt")
    
    $c_capicity_clone = $c_capicity.clone
    result = search()
    if result.empty? then
        print "no solution\n"
    else
        result.collect! {|selected| $c_capicity_clone.index(selected)}
        result.sort!
        result.each {|x| print x, ' '}
        print "\ncount = %d\n" % result.length
    end
end