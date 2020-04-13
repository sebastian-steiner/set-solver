function except(arr, i)
    return [arr[1:(i - 1)]; arr[(i + 1):end]]
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

function main()
    
end

main()