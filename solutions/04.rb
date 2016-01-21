class Card
  SUITES = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  BELOTE_RANKS = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  def rank
    @rank
  end
  def rank_to_i
    RANKS.each.with_index { |rate, index| return index if rank == rate }
  end
  def belote_rank_to_i
    BELOTE_RANKS.each.with_index { |rate, index| return index if rank == rate }
  end
  def suit
    @suit
  end
  def suit_to_i
    SUITES.each.with_index { |set, index| return index if suit == set }
  end
  def to_s
    return "#{rank.capitalize} of #{suit.capitalize}" if rank.is_a? Symbol
    return "#{rank} of #{suit.capitalize}"
  end
  def ==(other_card)
    rank == other_card.rank and suit == other_card.suit ? true : false
  end
  def <=>(other_card)
    return 1 if suit_to_i < other_card.suit_to_i
    return -1 if suit_to_i > other_card.suit_to_i
    return 1 if rank_to_i < other_card.rank_to_i
    return -1 if rank_to_i > other_card.rank_to_i
    return 0
  end
  def %(other_card)
    return 1 if suit_to_i < other_card.suit_to_i
    return -1 if suit_to_i > other_card.suit_to_i
    return 1 if belote_rank_to_i < other_card.belote_rank_to_i
    return -1 if belote_rank_to_i > other_card.belote_rank_to_i
    return 0
  end
  def next
    target_rank = belote_rank_to_i - 1
    Card.new(BELOTE_RANKS[target_rank], suit)
  end
end

class Deck
  include Enumerable
  SUITES = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  def initialize(card_array = [])
    card_array.empty? ? @card_array = complete_deck : @card_array = card_array
  end
  def each
    0.upto(@card_array.size - 1).map { |card| yield @card_array[card] }
  end
  def size
    @card_array.size
  end
  def draw_top_card
    @card_array.shift
  end
  def draw_bottom_card
    @card_array.pop
  end
  def top_card
    @card_array.first
  end
  def bottom_card
    @card_array.last
  end
  def shuffle
    @card_array.shuffle!
  end
  def sort
    @card_array.sort!.reverse!
  end
  def belote_sort
    @card_array.sort! { |a, b| a % b }.reverse!
  end
  def to_s
    @card_array.map { |card| card.to_s }.join("\n")
  end
  def complete_deck
    SUITES.product(RANKS).map { |card| Card.new(*card.reverse) }
  end
end

class WarDeck < Deck
  SUITES = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  def initialize(card_array = [])
    card_array.empty? ? @card_array = complete_deck : @card_array = card_array
  end
  def deal
    WarDeck.new(1.upto(26).map { draw_top_card })
  end
  def complete_deck
    SUITES.product(RANKS).map { |card| Card.new(*card.reverse) }
  end
  def play_card
    @card_array.delete(@card_array.sample)
  end
  def allow_face_up?
    return true if @card_array.size <= 3
    false
  end
end

class BeloteDeck < Deck
  SUITES = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
  def initialize(card_array = [])
    card_array.empty? ? @card_array = complete_deck : @card_array = card_array
  end
  def deal
    BeloteDeck.new(1.upto(8).map { draw_top_card })
  end
  def complete_deck
    SUITES.product(RANKS).map { |card| Card.new(*card.reverse) }
  end
  def sort
    belote_sort
  end
  def highest_of_suit(suit)
    self.belote_sort.find { |card| card.suit == suit }
  end
  def belote?
    SUITES.each do |set|
      king, queen = Card.new(:king, set), Card.new(:queen, set)
      return true if @card_array.member?(king) and @card_array.member?(queen)
    end
    false
  end
  def tierce?
    self.belote_sort.each_cons(3) do |cards|
      return true if cards[0] == cards[1].next and cards[1] == cards[2].next
    end
    false
  end
  def quarte?
    self.belote_sort.each_cons(4) do |cards|
      tierce_deck = BeloteDeck.new(cards[1..3])
      return true if tierce_deck.tierce? and cards[0] == cards[1].next
    end
    false
  end
  def quint?
    self.belote_sort.each_cons(5) do |cards|
      quarte_deck = BeloteDeck.new(cards[1..4])
      return true if quarte_deck.quarte? and cards[0] == cards[1].next
    end
    false
  end
  def carre_of_jacks?
    @card_array.count { |card| card.rank == :jack } == 4 ? true : false
  end
  def carre_of_nines?
    @card_array.count { |card| card.rank == 9 } == 4 ? true : false
  end
  def carre_of_aces?
    @card_array.count { |card| card.rank == :ace } == 4 ? true : false
  end
end

class SixtySixDeck < Deck
  SUITES = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [:ace, :king, :queen, :jack, 10, 9]
  def initialize(card_array = [])
    card_array.empty? ? @card_array = complete_deck : @card_array = card_array
  end
  def deal
    SixtySixDeck.new(1.upto(6).map { draw_top_card })
  end
  def complete_deck
    SUITES.product(RANKS).map { |card| Card.new(*card.reverse) }
  end
  def twenty?(trump_suit)
    not_trump = SUITES - [trump_suit]
    not_trump.each do |set|
      king, queen = Card.new(:king, set), Card.new(:queen, set)
      return true if @card_array.member?(king) and @card_array.member?(queen)
    end
    false
  end
  def forty?(trump_suit)
    king, queen = Card.new(:king, trump_suit), Card.new(:queen, trump_suit)
    return true if @card_array.member?(king) and @card_array.member?(queen)
    false
  end
end