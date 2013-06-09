#!/usr/bin/ruby -w
# coding: utf-8

def data_input(filename)
    lines = File.open(filename, "r").readlines
    $n_physical_node = Integer(lines[0])
    $m_virtual_node = Integer(lines[1])
    $c_capicity = Array.new($n_physical_node) {|i| lines[i+2].split().collect {|s| Integer(s)}}
    $d_demands = lines[2+$n_physical_node].split().collect {|s| Integer(s)}
end

def bits_count(bitstring)
    sum = 0
    bitstring.size.times {|i| sum += 1 if bitstring[i].chr=='1'}
    return sum
end

def demands_satisfied(bitstring)
    satisfied = Array.new($m_virtual_node) {0}
    $n_physical_node.times do |i|
        $m_virtual_node.times {|j| satisfied[j] += $c_capicity[i][j]} if bitstring[i].chr == '1'
    end
    return satisfied
end

def evaluate(bitstring)
    delta = 0
    satisfied = demands_satisfied(bitstring)
    $d_demands.each_with_index do |di, i|
        satisfied[i] = di - satisfied[i]
        #delta += satisfied[i]**2 if satisfied[i] > 0
        delta += satisfied[i]*1.0/di if satisfied[i] > 0
    end
    return (delta == 0) ? ($n_physical_node - bits_count(bitstring)) : (-delta)
end

def random_bitstring(num_bits)
    return (0...num_bits).inject(""){|s,i| s<<((rand<0.5) ? "1" : "0")}
end

def binary_tournament(pop)
    i, j = rand(pop.size), rand(pop.size)
    j = rand(pop.size) while j==i
    return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
end

def point_mutation(bitstring, rate=1.0/bitstring.size)
    child = ""
    bitstring.size.times do |i|
        bit = bitstring[i].chr
        child << ((rand()<rate) ? ((bit=='1') ? "0" : "1") : bit)
    end
    return child
end

def crossover(parent1, parent2, rate)
    return ""+parent1 if rand()>=rate
    point = 1 + rand(parent1.size-2)
    return parent1[0...point]+parent2[point...(parent1.size)]
end

def reproduce(selected, pop_size, p_cross, p_mutation)
    children = []
    selected.each_with_index do |p1, i|
        if i == selected.size-1 then
            p2 = selected[0]
        else
            p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
        end
        child = {}
        child[:bitstring] = crossover(p1[:bitstring], p2[:bitstring], p_cross)
        child[:bitstring] = point_mutation(child[:bitstring], p_mutation)
        children << child
        break if children.size >= pop_size
    end
    return children
end

def greedy_compare(a, b)
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

def greedy_bitstring(num_bits)
    capicity = $c_capicity.clone
    demands = $d_demands.clone
    result = Array.new()
    while !capicity.empty? do
        capicity.sort! {|a, b| greedy_compare(a, b)}
        selected = capicity.shift
        result << selected
        mark = true
        selected.each_with_index {|ci, i| demands[i] -= ci}
        demands.each_with_index do |di, i|
            if di > 0 then
                mark = false
                break
                elsif di < 0 then
                demands[i] = 0
            end
        end
        break if mark
    end
    if mark then
        result.collect! {|s| $c_capicity.index(s)}
        bitstring = (0...num_bits).inject(""){|s,i| s<<((result.include?(i))?"1":"0")}
    else
        bitstring = ("1"*num_bits)
    end
    return bitstring
end

def search(max_gens, num_bits, pop_size, p_crossover, p_mutation, p_greedy)
    greedy = greedy_bitstring(num_bits)
    population = Array.new(pop_size) do |i|
        (rand()<p_greedy) ? {:bitstring=>greedy} : {:bitstring=>random_bitstring(num_bits)}
    end
    population.each{|c| c[:fitness] = evaluate(c[:bitstring])}
    best = population.sort{|x,y| y[:fitness] <=> x[:fitness]}.first
    max_gens.times do |gen|
        selected = Array.new(pop_size){|i| binary_tournament(population)}
        children = reproduce(selected, pop_size, p_crossover, p_mutation)    
        children.each{|c| c[:fitness] = evaluate(c[:bitstring])}
        children.sort!{|x,y| y[:fitness] <=> x[:fitness]}
        best = children.first if children.first[:fitness] >= best[:fitness]
        population = children
        #puts " > gen #{gen}, best: #{best[:fitness]}, #{best[:bitstring]}, nodes: #{bits_count(best[:bitstring])}"
        #break if best[:fitness] == num_bits
    end
    return best
end

if __FILE__ == $0
    data_input("input.txt")
    
    num_bits = $n_physical_node
    max_gens = $n_physical_node * 20
    pop_size = $n_physical_node * 50
    p_crossover = 0.98
    p_mutation = 1.0/num_bits
    p_greedy = 0.3
    # execute the algorithm
    best = search(max_gens, num_bits, pop_size, p_crossover, p_mutation, p_greedy)
    
    is_satisfied = true
    satisfied = demands_satisfied(best[:bitstring])
    $d_demands.each_with_index {|di, i| is_satisfied = false if satisfied[i] < di}

    if is_satisfied then
        result = Array.new()
        bitstring = best[:bitstring]
        bitstring.size.times {|i| result << i if bitstring[i].chr=='1'}
        result.each {|x| print x, ' '}
        print "\ncount = %d\n" % result.length
    else
        print "no solution\n" 
    end
end
