//Samuel Fletcher
//Date: 2021-04-15
//Poker Assignment: Rust

use std::collections::HashMap;

pub fn deal(perm: [u32; 9]) -> Vec<String>{
    // Your code goes here
    let hand1 = vec![
        perm[0], perm[2], perm[4], perm[5], perm[6], perm[7], perm[8],
    ];
    let hand2 = vec![
        perm[1], perm[3], perm[4], perm[5], perm[6], perm[7], perm[8],
    ];

    let p1_hand = f_hand(hand1);
    let p2_hand = f_hand(hand2);
    let x = combine(is_rflush(p1_hand.clone()).0);
    let y = combine(is_rflush(p2_hand.clone()).0);
    if is_rflush(p1_hand).1 > is_rflush(p2_hand).1{
        return x;
    }
    else{
        return y;
    }
}

fn combine(perm: Vec<(u32, char)>) -> Vec<String>{
    let mut result = Vec::new();
    for i in perm{
        result.push([(i.0.to_string()), (i.1.to_string())].join(""))
    }
    return result;
}

fn f_hand(start: Vec<u32>) -> Vec<(u32, char)> {
    let mut rank = Vec::new();
    for elem in start.clone() {
        if (elem % 13) == 0 {
            rank.push(13)
        } else {
            rank.push(elem % 13);
        }
    }
    let mut suit = Vec::new();
    for elem in start.clone() {
        if elem > 39 {
            suit.push('S');
        } else if elem > 26 {
            suit.push('H');
        } else if elem > 13 {
            suit.push('D');
        } else {
            suit.push('C')
        }
    }
    let mut hand = Vec::new();
    for elem in 0..7 {
        hand.push((rank[elem], suit[elem]));
    }
    return hand;
}

fn is_rflush(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    for j in 0..perm2.len() {
        if perm2[j].0 == 1 {
            perm2[j] = (14, perm2[j].1);
        }
    }
    perm2.sort();
    perm2.sort_by_key(|x| x.1);

    if perm2[2].0 == 10 && perm2[6].0 == 14 && perm2[2].1 == perm2[6].1 {
        let mut perm2 = perm2.split_off(2);
        perm2[4].0 = 1;
        return (perm2,1000);
    }
    return sflush(perm);
}

fn frequency_suits(perm: Vec<(u32, char)>) -> HashMap<char, usize> {
    let mut map = HashMap::new();

    for n in perm {
        *map.entry(n.1).or_insert(0) += 1;
    }
    map
}

fn sflush(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    perm2.sort();
    perm2.sort_by_key(|x| x.1);
    let mut result = Vec::new();

    for i in 1..perm2.len() {
        if perm2[i - 1].0 + 1 == perm2[i].0 {
            result.push(perm2[i]);
        }
    }

    if perm2[0].0 + 1 == perm2[1].0 {
        result.insert(0, perm2[0]);
    }

    while result.len() > 5 {
        result.remove(0);
    }
    let x = frequency_suits(result.clone());
    for &val in x.values() {
        if val == 5 as usize {
            return (result.clone(),900+result[result.len()-1].0 as i32);
        }
    }

    return fourofkind(perm);
}

fn frequency_map(perm: Vec<(u32, char)>) -> HashMap<u32, usize> {
    let mut map = HashMap::new();

    for n in perm {
        *map.entry(n.0).or_insert(0) += 1;
    }
    map
}

fn fourofkind(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    perm2.sort();

    let x = frequency_map(perm2.clone());
    for (&key, &val) in x.iter() {
        if val == 4 as usize {
            for i in 0..perm2.len() - 1 {
                if perm2[i].0 != key {
                    perm2.remove(i);
                }
            }
            if perm2.last_mut().unwrap().0 != key {
                perm2.remove(perm2.len() - 1);
            }
        }
    }
    if perm2.len() == 4 {
        return (perm2.clone(),800+perm2[perm2.len()-1].0 as i32);
    }
    return fullhouse(perm);
}

fn fullhouse(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    for j in 0..perm2.len() {
        if perm2[j].0 == 1 {
            perm2[j] = (14, perm2[j].1);
        }
    }
    let x = frequency_map(perm2.clone());
    let mut result = Vec::new();

    for (&key, &val) in x.iter() {
        if val == 2 {
            for i in 0..perm2.len() {
                if perm2[i].0 == key {
                    result.push(perm[i])
                }
            }
        }
    }
    result.sort();
    if result.len() == 4 {
        let result = result.split_off(2);
    }

    for (&key, &val) in x.iter() {
        if val == 3 {
            for i in 0..perm2.len() {
                if perm2[i].0 == key {
                    result.push(perm[i])
                }
            }
        }
    }
    if result.len() == 5 {
        for k in 0..result.len() {
            if result[k].0 == 14 {
                result[k] = (1, result[k].1);
            }
        }
        return (result.clone(),700+result[result.len()-1].0 as i32);
    }
    return flush(perm);
}

fn flush(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let perm2 = perm.clone();
    let mut result = Vec::new();
    let x = frequency_suits(perm2.clone());

    for (&key, &val) in x.iter() {
        if val == 5 {
            for i in 0..perm2.len() {
                if perm2[i].1 == key {
                    result.push(perm[i]);
                }
            }
        }
    }
    if result.len() > 5 {
        result.sort();
        while result.len() != 5 {
            result.remove(0);
        }
    }
    if result.len() == 5 {
        return (result.clone(),600+result[result.len()-1].0 as i32);
    }
    return straight(perm);
}

fn straight(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    perm2.sort();
    let mut result = Vec::new();

    for i in 1..perm2.len() {
        if perm2[i - 1].0 + 1 == perm2[i].0 {
            result.push(perm2[i-1]);
        }
    }
    if perm2[0].0 + 1 == perm2[1].0 {
        result.insert(0, perm2[0]);
    }
    for j in result.clone(){
        if j.0 == 12 && perm2[perm2.len()-1].0 == 13{
            result.push(perm2[perm2.len()-1]);
        }
    }
    while result.len() > 5 {
        result.remove(0);
    }
    if result.len() == 5{
        return (result.clone(),500+result[result.len()-1].0 as i32)
    }
    return threeofkind(perm);
}

fn threeofkind(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    for k in 0..perm2.len() {
        if perm2[k].0 == 1 {
            perm2[k] = (14, perm2[k].1);
        }
    }
    let x = frequency_map(perm2.clone());
    let mut result = Vec::new();

    for (&key, &val) in x.iter() {
        if val == 3 {
            for i in 0..perm2.len() {
                if perm2[i].0 == key {
                    result.push(perm[i]);
                }
            }
        }
    }
    if result.len() > 3 {
        result.sort();
        let result = result.split_off(3);
    }
    for k in 0..result.len() {
        if result[k].0 == 14 {
            result[k] = (1, result[k].1);
        }
    }
    if result.len() == 3 {
        return (result.clone(),400+result[result.len()-1].0 as i32);
    }
    return twopair(perm);
}

fn twopair(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    for k in 0..perm2.len() {
        if perm2[k].0 == 1 {
            perm2[k] = (14, perm2[k].1);
        }
    }
    let x = frequency_map(perm2.clone());
    let mut result = Vec::new();

    for (&key, &val) in x.iter() {
        if val == 2 {
            for i in 0..perm2.len() {
                if perm2[i].0 == key {
                    result.push(perm[i]);
                }
            }
        }
    }
    if result.len() > 4 {
        result.sort();
        let result = result.split_off(4);
    }
    for k in 0..result.len() {
        if result[k].0 == 14 {
            result[k] = (1, result[k].1);
        }
    }
    if result.len() == 4 {
        return (result.clone(),300+result[result.len()-1].0 as i32);
    }
    return pair(perm);
}

fn pair(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    for k in 0..perm2.len() {
        if perm2[k].0 == 1 {
            perm2[k] = (14, perm2[k].1);
        }
    }
    let x = frequency_map(perm2.clone());
    let mut result = Vec::new();

    for (&key, &val) in x.iter() {
        if val == 2 {
            for i in 0..perm2.len() {
                if perm2[i].0 == key {
                    result.push(perm[i]);
                }
            }
        }
    }
    if result.len() > 2 {
        result.sort();
        let mut result = result.split_off(2);
        if result.len() > 2 {
            let _result = result.split_off(2);
        }
    }
    for k in 0..result.len() {
        if result[k].0 == 14 {
            result[k] = (1, result[k].1);
        }
    }
    if result.len() == 2 {
        if result[result.len()-1].0 == 1{
            return (result.clone(),200+14 as i32);
        }
        return (result.clone(),200+result[result.len()-1].0 as i32);
    }
    return hc(perm);
}
fn hc(perm: Vec<(u32, char)>) -> (Vec<(u32, char)>,i32) {
    let mut perm2 = perm.clone();
    let mut result = Vec::new();
    for k in 0..perm2.len() {
        if perm2[k].0 == 1 {
            perm2[k] = (14, perm2[k].1);
        }
    }
    perm2.sort();
    result.push(perm2[perm2.len() - 1]);
    return (result.clone(),100+result[result.len()-1].0 as i32);
}
