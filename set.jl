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

function check_game(table::Array{NTuple{4,Int},1}, reserve::Array{NTuple{4,Int},1})::Bool
    if length(table) == 0
        return true
    end
    if length(reserve) == 0
        sets = find_sets(table)
        if length(sets) == 0
            return false
        end
        for set in sets
            if (!check_game(except_inds(table, set[1], set[2], set[3]), reserve[4:end]))
                return false
            end
        end
    else
        sets = find_sets(table)
        if length(sets) == 0
            return false
        end
        for set in sets
            if (!check_game([except_inds(table, set[1], set[2], set[3]);reserve[1:3]], reserve[4:end]))
                return false
            end
        end
    end
    return true
end

function main()
    all = gen_cards()
    table = all[59:69]
    reserve = all[70:81]
    check_game(table, reserve) # liefert false
    #cards = [(0,0,0,0),(0,0,0,1),(0,0,1,2)]
    #check_game(cards,Array{NTuple{4,Int},1}(undef,0))
    #cards = gen_cards()
    #println(check_game(cards[70:81],Array{NTuple{4,Int},1}(undef, 0)))
end

main()