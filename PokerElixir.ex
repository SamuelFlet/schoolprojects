defmodule Poker do
  def deal(list) do
    pool = Enum.drop(list, 4)
    p1 = [Enum.at(list, 0), Enum.at(list, 2) | pool]
    p2 = [Enum.at(list, 1), Enum.at(list, 3) | pool]

    p1_rank = for n <- p1, do: if(rem(n, 13) == 0, do: 13, else: rem(n, 13))
    p1_suit =for n <- p1,do: if(n > 39, do: 'S', else: if(n > 26, do: 'H', else: if(n > 13, do: 'D', else: 'C')))
    p1_hand = Enum.zip(p1_rank, p1_suit)

    p2_rank = for n <- p2, do: if(rem(n, 13) == 0, do: 13, else: rem(n, 13))
    p2_suit = for n <- p2,do: if(n > 39, do: 'S', else: if(n > 26, do: 'H', else: if(n > 13, do: 'D', else: 'C')))
    p2_hand = Enum.zip(p2_rank, p2_suit)

    winninghand=
      cond do
        isRFlush(p1_hand) == 1 and isRFlush(p2_hand) == 1 ->
          handEval(p1_hand,p2_hand)
        isRFlush(p1_hand) != 1 and isRFlush(p2_hand) == 1 ->
          isRFlush(p1_hand)
        isRFlush(p1_hand) == 1 and isRFlush(p2_hand) != 1 ->
          isRFlush(p2_hand)
      end
    IO.inspect(winninghand)
  end

  defp isRFlush(hand) do
    hand=Enum.sort_by(hand, &{Kernel.elem(&1,1), Kernel.elem(&1,0)})
    hand=Enum.drop(tl(hand),2) ++ [hd(hand)]
    test=[]
    cond do
      Enum.count(hand)==5 and (Kernel.elem(Enum.at(hand,0),0) == 10 and Kernel.elem(Enum.at(hand,4),0) == 1) ->
        for x <- hand do
          test++Enum.join(Tuple.to_list(x))
        end
      Kernel.elem(Enum.at(hand,0),0) != 10 or Kernel.elem(Enum.at(hand,4),0) != 1 ->
        1
    end
  end

  defp isSFlush(hand) do
    hand=Enum.sort(Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,1), Kernel.elem(&1,0)}), &(Kernel.elem(&1,1))))
    hand=Enum.uniq_by(Enum.at(hand,0), &(Kernel.elem(&1,0)))
    test=[]
    cond do
      Enum.count(hand)<5 ->
        1
      Enum.count(hand)==5->
        if Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 do
          hand=Enum.take(hand,5)
          for x <- hand do
            test++Enum.join(Tuple.to_list(x))
          end
        else
          1
        end
      Enum.count(hand)==6->
        cond do
          Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and  Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 ->
            hand=Enum.take(tl(hand)++hd(hand),5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 ->
            hand=Enum.take(hand,5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
        end
      Enum.count(hand)==7->
        cond do
          Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and  Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 and Kernel.elem(Enum.at(hand,5),0) == Kernel.elem(Enum.at(hand,6),0)-1 ->
            hand=Enum.drop(hand,2)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and  Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 ->
            hand=Enum.take(tl(hand)++hd(hand),5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 ->
            hand=Enum.take(hand,5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
        end
      true->
        1
    end
  end

  defp is4ofKind(hand) do
    hand=Enum.sort(Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0))))
    test=[]
    cond do
      Enum.count(Enum.at(hand,0)) == 4 ->
        for x <- Enum.at(hand,0) do
            test++Enum.join(Tuple.to_list(x))
        end
      Enum.count(Enum.at(hand,0))<5 ->
        1
    end
  end

  defp isFullHouse(hand) do
    hand=Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0)))
    hand=Enum.sort_by(hand,&{Enum.count(&1)},:desc)
    test=[]
    cond do
      Enum.count(Enum.at(hand,0)) == 3 and Enum.count(Enum.at(hand,1)) == 2 ->
        hand=Enum.at(hand,0)++Enum.at(hand,1)

        for x <- hand do
          test++Enum.join(Tuple.to_list(x))
        end
      true->
        1
    end
  end

  defp isFlush(hand) do
    hand=Enum.sort(Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,1), Kernel.elem(&1,0)}), &(Kernel.elem(&1,1))))
    test=[]
    cond do
        Enum.count(Enum.at(hand,0)) >= 5 ->
          for x <- Enum.at(hand,0) do
              test++Enum.join(Tuple.to_list(x))
          end
        Enum.count(Enum.at(hand,0))<5 ->
          1
      end
  end

  defp isStraight(hand) do
    hand=Enum.uniq_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0)))
    test=[]
    cond do
      Enum.count(hand)<5 ->
        1
      Enum.count(hand)==5->
        if Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 do
          hand=Enum.take(hand,5)
          for x <- hand do
            test++Enum.join(Tuple.to_list(x))
          end
        else
          1
        end
      Enum.count(hand)==6->
        cond do
          Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and  Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 ->
            hand=Enum.take(tl(hand)++hd(hand),5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 ->
            hand=Enum.take(hand,5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          true->
            1
        end
      Enum.count(hand)==7->
        cond do
          Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and  Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 and Kernel.elem(Enum.at(hand,5),0) == Kernel.elem(Enum.at(hand,6),0)-1 ->
            hand=Enum.drop(hand,2)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and  Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 and Kernel.elem(Enum.at(hand,4),0) == Kernel.elem(Enum.at(hand,5),0)-1 ->
            hand=Enum.take(tl(hand)++hd(hand),5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
          Kernel.elem(Enum.at(hand,0),0) == Kernel.elem(Enum.at(hand,1),0)-1 and Kernel.elem(Enum.at(hand,1),0) == Kernel.elem(Enum.at(hand,2),0)-1 and  Kernel.elem(Enum.at(hand,2),0) == Kernel.elem(Enum.at(hand,3),0)-1 and Kernel.elem(Enum.at(hand,3),0) == Kernel.elem(Enum.at(hand,4),0)-1 ->
            hand=Enum.take(hand,5)
            for x <- hand do
              test++Enum.join(Tuple.to_list(x))
            end
        end
      true->
        1
    end
  end

  defp is3(hand) do
    hand=Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0)))
    hand=Enum.sort_by(hand,&{Enum.count(&1)},:desc)
    test=[]
    cond do
      Enum.count(Enum.at(hand,0)) == 3 ->
        for x <- Enum.at(hand,0) do
            test++Enum.join(Tuple.to_list(x))
        end
      Enum.count(Enum.at(hand,0))!=3 ->
        1
    end
  end

  defp is2pair(hand) do
    hand=Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0)))
    hand=Enum.sort_by(hand,&{Enum.count(&1)},:desc)
    test=[]
    cond do
      Enum.count(Enum.at(hand,0)) == 2 and Enum.count(Enum.at(hand,1)) == 2->
        for x <- Enum.at(hand,0)++Enum.at(hand,1) do
            test++Enum.join(Tuple.to_list(x))
        end
      Enum.count(Enum.at(hand,0))!=3 ->
        1
    end
  end

  defp isPair(hand) do
    hand=Enum.chunk_by(Enum.sort_by(hand, &{Kernel.elem(&1,0)}), &(Kernel.elem(&1,0)))
    hand=Enum.sort_by(hand,&{Enum.count(&1)},:desc)
    test=[]
    cond do
      Enum.count(Enum.at(hand,0)) == 2 ->
        for x <- Enum.at(hand,0)do
            test++Enum.join(Tuple.to_list(x))
        end
      Enum.count(Enum.at(hand,0))!=3 ->
        1
    end
  end

  defp isHC(hand) do
    hand=Enum.sort_by(hand, &(Kernel.elem(&1,0)), :desc)
    test=[]
    test++Enum.join(Tuple.to_list(Enum.at(hand,0)))
  end

  defp handEval(p1_hand,p2_hand) do
    cond do
      isSFlush(p1_hand) == 1 and isSFlush(p2_hand) == 1 ->
        #####################################
        cond do
          is4ofKind(p1_hand) == 1 and is4ofKind(p2_hand) == 1 ->
            ##########################################
            cond do
              isFullHouse(p1_hand) == 1 and isFullHouse(p2_hand) == 1 ->
                ############################################
                cond do
                  isFlush(p1_hand) == 1 and isFlush(p2_hand) == 1 ->
                    ###########################################
                    cond do
                      isStraight(p1_hand) == 1 and isStraight(p2_hand) == 1 ->
                        ###########################################
                        cond do
                          is3(p1_hand) == 1 and is3(p2_hand) == 1 ->
                            ###########################################
                            cond do
                              is2pair(p1_hand) == 1 and is2pair(p2_hand) == 1 ->
                                ###########################################
                                cond do
                                  isPair(p1_hand) == 1 and isPair(p2_hand) == 1 ->
                                    ###########################################
                                    cond do
                                      isHC(p1_hand) != 1 and isHC(p2_hand) == 1 ->
                                        isHC(p1_hand)
                                      isHC(p1_hand) == 1 and isHC(p2_hand) != 1 ->
                                        isHC(p2_hand)
                                      isHC(p1_hand) != 1 and isHC(p2_hand) != 1 ->
                                        cond do
                                          String.at(Enum.at(isHC(p1_hand),-1),0) >= String.at(Enum.at(isHC(p2_hand),-1),0) ->
                                            isHC(p1_hand)
                                          String.at(Enum.at(isHC(p1_hand),-1),0) < String.at(Enum.at(isHC(p2_hand),-1),0) ->
                                            isHC(p2_hand)
                                        end
                                    end
                                    ##################################################
                                    isPair(p1_hand) != 1 and isPair(p2_hand) == 1 ->
                                      isPair(p1_hand)
                                    isPair(p1_hand) == 1 and is2pair(p2_hand) != 1 ->
                                      isPair(p2_hand)
                                    isPair(p1_hand) != 1 and isPair(p2_hand) != 1 ->
                                    cond do
                                      String.at(Enum.at(isPair(p1_hand),-1),0) >= String.at(Enum.at(isPair(p2_hand),-1),0) ->
                                        isPair(p1_hand)
                                      String.at(Enum.at(isPair(p1_hand),-1),0) < String.at(Enum.at(isPair(p2_hand),-1),0) ->
                                        isPair(p2_hand)
                                    end
                                end
                                ##################################################
                                is2pair(p1_hand) != 1 and is2pair(p2_hand) == 1 ->
                                  is2pair(p1_hand)
                                is2pair(p1_hand) == 1 and is2pair(p2_hand) != 1 ->
                                  is2pair(p2_hand)
                                is2pair(p1_hand) != 1 and is2pair(p2_hand) != 1 ->
                                cond do
                                  String.at(Enum.at(is2pair(p1_hand),-1),0) >= String.at(Enum.at(is2pair(p2_hand),-1),0) ->
                                    is2pair(p1_hand)
                                  String.at(Enum.at(is2pair(p1_hand),-1),0) < String.at(Enum.at(is2pair(p2_hand),-1),0) ->
                                    is2pair(p2_hand)
                                end
                            end
                            ##################################################
                            is3(p1_hand) != 1 and is3(p2_hand) == 1 ->
                              is3(p1_hand)
                            is3(p1_hand) == 1 and is3(p2_hand) != 1 ->
                              is3(p2_hand)
                            is3(p1_hand) != 1 and is3(p2_hand) != 1 ->
                            cond do
                              String.at(Enum.at(is3(p1_hand),-1),0) >= String.at(Enum.at(is3(p2_hand),-1),0) ->
                                is3(p1_hand)
                              String.at(Enum.at(is3(p1_hand),-1),0) < String.at(Enum.at(is3(p2_hand),-1),0) ->
                                is3(p2_hand)
                            end
                        end
                        ##################################################
                        isStraight(p1_hand) != 1 and isStraight(p2_hand) == 1 ->
                          isStraight(p1_hand)
                        isStraight(p1_hand) == 1 and isStraight(p2_hand) != 1 ->
                          isStraight(p2_hand)
                        isStraight(p1_hand) != 1 and isStraight(p2_hand) != 1 ->
                        cond do
                          String.at(Enum.at(isStraight(p1_hand),-1),0) >= String.at(Enum.at(isStraight(p2_hand),-1),0) ->
                            isStraight(p1_hand)
                          String.at(Enum.at(isStraight(p1_hand),-1),0) < String.at(Enum.at(isStraight(p2_hand),-1),0) ->
                            isStraight(p2_hand)
                        end
                    end
                    ##################################################
                    isFlush(p1_hand) != 1 and isFlush(p2_hand) == 1 ->
                      isFlush(p1_hand)
                    isFlush(p1_hand) == 1 and isFlush(p2_hand) != 1 ->
                      isFlush(p2_hand)
                    isFlush(p1_hand) != 1 and isFlush(p2_hand) != 1 ->
                    cond do
                      String.at(Enum.at(isFlush(p1_hand),-1),0) >= String.at(Enum.at(isFlush(p2_hand),-1),0) ->
                        isFlush(p1_hand)
                      String.at(Enum.at(isFlush(p1_hand),-1),0) < String.at(Enum.at(isFlush(p2_hand),-1),0) ->
                        isFlush(p2_hand)
                    end
                end
                ###################################################
              isFullHouse(p1_hand) != 1 and isFullHouse(p2_hand) == 1 ->
                isFullHouse(p1_hand)
              isFullHouse(p1_hand) == 1 and isFullHouse(p2_hand) != 1 ->
                isFullHouse(p2_hand)
              isFullHouse(p1_hand) != 1 and isFullHouse(p2_hand) != 1 ->
                cond do
                  String.length(Enum.at(isFullHouse(p1_hand),-1)) > String.length(Enum.at(isFullHouse(p2_hand),-1)) ->
                    isFullHouse(p1_hand)
                  String.length(Enum.at(isFullHouse(p1_hand),-1)) < String.length(Enum.at(isFullHouse(p2_hand),-1)) ->
                    isFullHouse(p2_hand)
                  true->
                    cond do
                      String.at(Enum.at(isFullHouse(p1_hand),-1),0) >= String.at(Enum.at(isFullHouse(p2_hand),-1),0) ->
                        isFullHouse(p1_hand)
                      String.at(Enum.at(isFullHouse(p1_hand),-1),0) < String.at(Enum.at(isFullHouse(p2_hand),-1),0) ->
                        isFullHouse(p2_hand)
                    end
                end
            end
            ##############################################
          is4ofKind(p1_hand) != 1 and is4ofKind(p2_hand) == 1 ->
            is4ofKind(p1_hand)
          is4ofKind(p1_hand) == 1 and is4ofKind(p2_hand) != 1 ->
            is4ofKind(p2_hand)
          is4ofKind(p1_hand) != 1 and is4ofKind(p2_hand) != 1 ->
            cond do
              String.at(Enum.at(is4ofKind(p1_hand),-1),0) >= String.at(Enum.at(is4ofKind(p2_hand),-1),0) ->
                is4ofKind(p1_hand)
              String.at(Enum.at(is4ofKind(p1_hand),-1),0) < String.at(Enum.at(is4ofKind(p2_hand),-1),0) ->
                is4ofKind(p2_hand)
            end
        end
        ###########################################
        isSFlush(p1_hand) != 1 and isSFlush(p2_hand) == 1 ->
          isSFlush(p1_hand)
        isSFlush(p1_hand) == 1 and isSFlush(p2_hand) != 1 ->
          isFlush(p2_hand)
        isSFlush(p1_hand) != 1 and isSFlush(p2_hand) != 1 ->
        cond do
          String.at(Enum.at(isSFlush(p1_hand),-1),0) >= String.at(Enum.at(isSFlush(p2_hand),-1),0) ->
            isSFlush(p1_hand)
          String.at(Enum.at(isSFlush(p1_hand),-1),0) < String.at(Enum.at(isSFlush(p2_hand),-1),0) ->
            isSFlush(p2_hand)
        end
    end
  end
end
