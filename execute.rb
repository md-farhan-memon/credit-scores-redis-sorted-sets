# frozen_string_literal: true

require_relative 'models/user.rb'
require 'awesome_print'
require 'redis-objects'

Redis::Objects.redis = Redis.new(host: '127.0.0.1', port: 6379)

$score_board = Redis::SortedSet.new(SecureRandom.hex.to_s)

options = {
  '1' => 'Show list',
  '2' => 'Generate 10 random users',
  '3' => 'Get top 3 users',
  '4' => 'Get bottom 3 users',
  '5' => 'Find rank of a user',
  '6' => 'Find user by rank',
  '9' => 'Exit'
}.freeze

@users = []

def generate_10_random_profiles
  10.times do
    name = "#{SecureRandom.alphanumeric(8).capitalize} #{SecureRandom.alphanumeric(5).capitalize}"
    user = User.new(name)
    user.generate_credit_score!
    @users << user
  end
  puts "\nGenerated 10 profiles."
end

def print_top_3
  ids = get_from_range(0, 2)
  ap(ids.map { |id| find_by_id(id).hashified(:id, :name, :credit_score) })
end

def print_bottom_3
  ids = get_from_range(-3, -1)
  ap(ids.map { |id| find_by_id(id).hashified(:id, :name, :credit_score) })
end

def print_rank_of_user
  print "\nUser ID to be searched:"

  id = gets.chomp.to_s
  rank = $score_board.revrank(id)

  if rank.nil?
    puts "\nInvalid User ID."
  else
    puts "\nRank: #{rank + 1}"
  end
end

def print_user_by_rank
  print "\nRank to be searched (Should be greater than 0): "

  rank = gets.chomp.to_i
  if rank.zero?
    puts "\nInvalid Rank"
  else
    rank -= 1
    id = get_from_range(rank, rank).first

    if id.nil?
      puts "\nRank not found"
    else
      ap(find_by_id(id).hashified(:id, :name, :credit_score))
    end
  end
end

def filtered_users(ids)
  @users.select { |user| ids.include?(user.id) }
end

def find_by_id(id)
  @users.each { |user| return user if user.id == id }
  nil
end

def get_from_range(min, max)
  $score_board.revrange(min, max)
end

loop do
  puts(options.map { |k, v| "#{k}. #{v}" })

  print "\nYour selection number: "

  case gets.chomp.to_i
  when 1
    ap @users.map(&:hashified)
  when 2
    generate_10_random_profiles
  when 3
    print_top_3
  when 4
    print_bottom_3
  when 5
    print_rank_of_user
  when 6
    print_user_by_rank
  when 9
    puts "\n#okBye"
    return
  else
    puts "\nInvalid Input"
  end

  puts "\n"
end
