using Random
using Statistics

function except(arr, i)
    return [arr[1:(i - 1)]; arr[(i + 1):end]]
end

function except_inds(arr, fst, snd, thd)
    arr = except(arr, fst)
    arr = except(arr, snd - 1)
    arr = except(arr, thd - 2)
    return arr
end

function is_set(fst, snd, thd)
    for i in 1:4
        if (fst[i] == snd[i] && fst[i] != thd[i]) ||
            (fst[i] == thd[i] && fst[i] != snd[i]) ||
            (snd[i] == thd[i] && fst[i] != snd[i])
            return false
        end
    end
    return true
end

function find_sets(cards::Array{NTuple{4,Int},1})
    sets = Array{NTuple{3,Int}}(undef,1)
    pop!(sets)
    for i in 1:length(cards)
        for j in (i+1):length(cards)
            for k in (j+1):length(cards)
                if is_set(cards[i], cards[j], cards[k])
                    push!(sets, (i, j, k))
                    break
                end
            end
        end
    end
    return sets
end

function gen_cards()
    cards = Array{NTuple{4,Int},1}(undef,1)
    pop!(cards)
    for i in 0:2, j in 0:2, k in 0:2, l in 0:2
        push!(cards, (i,j,k,l))
    end
    return cards
end

function card_to_str(card)
    return string(card[1], card[2], card[3], card[4])
end

function check_game(table::Array{NTuple{4,Int},1}, reserve::Array{NTuple{4,Int},1}, print::Bool)::Bool
    if length(table) == 0
        return true
    end
    if length(reserve) == 0
        sets = find_sets(table)
        if length(sets) == 0
            if print
                println("No more sets: ", table)
            end
            return false
        end
        for set in sets
            if (!check_game(except_inds(table, set[1], set[2], set[3]), reserve[4:end], print))
                if print
                    println(card_to_str(table[set[1]]), ",", card_to_str(table[set[2]]), ",", card_to_str(table[set[3]]))
                end
                return false
            end
        end
    else
        sets = find_sets(table)
        if length(sets) == 0
            if print
                println("No more sets: ", table)
            end
            return false
        end
        for set in sets
            if (!check_game([except_inds(table, set[1], set[2], set[3]);reserve[1:3]], reserve[4:end], print))
                if print
                    println(card_to_str(table[set[1]]), ",", card_to_str(table[set[2]]), ",", card_to_str(table[set[3]]))
                end
                return false
            end
        end
    end
    return true
end

function check(i)
    all = gen_cards()
    table = all[i:11+i]
    reserve = all[i+12:end]
    return check_game(table, reserve, true)
end

function to_card(str)
    return (parse(Int, str[1]), parse(Int, str[2]), parse(Int, str[3]), parse(Int, str[4]))
end

function to_cards(str)
    strs = split(rstrip(str), "\n")
    strs = filter!(e->e≠"",strs)
    cards = Array{NTuple{4,Int},1}(undef,length(strs))
    for i in 1:length(strs)
        cards[i] = to_card(strs[i])
    end
    return cards
end

function find_dups(arr)
    for i in 1:length(arr)
        for j in i+1:length(arr)
            if arr[i] == arr[j]
                println("Duplicates at: ", i, ",", j)
                println("\tDuplicate: ", arr[i])
                return false
            end
        end
    end
    return true
end

function check_str(str)
    cards = to_cards(str)
    if !find_dups(cards)
        return false
    end
    if length(cards) >= 12
        check_game(cards[1:12], cards[13:end], true)
    else
        check_game(cards[1:end], Array{NTuple{4,Int},1}(undef, 0), true)
    end
end

function rng_check()
    all = gen_cards()
    while true
        cards = shuffle(all)
        if check_game(cards[1:12], cards[13:end], false)
            println(cards)
            return
        end
    end
end

function main()
    
end

main()