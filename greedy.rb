#!/usr/bin/ruby -w
# coding: utf-8

require "input"

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

puts "result"
count = 0
while !$c_capicity.empty? do
    $c_capicity.sort! {|a, b| compare(a, b)}
    selected = $c_capicity.shift
    count += 1
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
    
    selected.each {|c| print "[%d]" % c}
    puts ""
    if mark then
        print "count = %d\n" % count
        exit
    end
end
print "no result\n"
