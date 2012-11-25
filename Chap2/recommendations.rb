#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Recommendations
  def self.critics
    {
      'Lisa Rose' => {
        'Lady in the Water' => 2.5,
        'Snakes on a Plane' => 3.5,
        'Just My Luck' => 3.0,
        'Superman Returns' => 3.5,
        'You, Me and Dupree' => 2.5,
        'The Night Listener' => 3.0
      },
      'Gene Seymour' => {
        'Lady in the Water' => 3.0,
        'Snakes on a Plane' => 3.5,
        'Just My Luck' => 1.5,
        'Superman Returns' => 5.0,
        'The Night Listener' => 3.0,
        'You, Me and Dupree' => 3.5
      },
      'Michel Phillips' => {
        'Lady in the Water' => 2.5,
        'Snakes on a Plane' => 3.5,
        'Superman Returns' => 3.5,
        'The Night Listener' => 4.0
      },
      'Cluadia Puig' => {
        'Snakes on a Plane' => 3.5,
        'Just My Luck' => 3.0,
        'The Night Listener' => 4.5,
        'Superman Returns' => 4.0,
        'You, Me and Dupree' => 2.5
      },
      'Mick LaSalle' => {
        'Lady in the Water' => 3.0,
        'Snakes on a Plane' => 4.0,
        'Just My Luck' => 2.0,
        'Superman Returns' => 3.0,
        'The Night Listener' => 3.0,
        'You, Me and Dupree' => 2.0
      },
      'Jack Matthews' => {
        'Lady in the Water' => 3.0,
        'Snakes on a Plane' => 4.0,
        'The Night Listener' => 3.0,
        'Superman Returns' => 5.0,
        'You, Me and Dupree' => 3.5
      },
      'Toby' => {
        'Snakes on a Plane' => 4.5,
        'You, Me and Dupree' => 1.0,
        'Superman Returns' => 4.0
      }
    }
  end

  def self.sim_distance(prefs, person1, person2)
    si = prefs[person1].keys & prefs[person2].keys
    return 0 if si.empty?

    sum_of_squares = si.inject(0) do |sum, key|
      sum += (prefs[person1][key] - prefs[person2][key]) ** 2
    end
    1 / (1 + sum_of_squares)
  end

  # p1 と p2 のピアソン係数を返す
  def self.sim_pearson(prefs, p1, p2)
    si = prefs[p1].keys & prefs[p2].keys

    sum1 = si.inject(0.0) {|sum, item| sum += prefs[p1][item] }
    sum2 = si.inject(0.0) {|sum, item| sum += prefs[p2][item] }

    sum1Sq = si.inject(0.0) {|sum, item| sum += prefs[p1][item]**2 }
    sum2Sq = si.inject(0.0) {|sum, item| sum += prefs[p2][item]**2 }

    pSum = si.inject(0.0) {|sum, item| sum += prefs[p1][item]*prefs[p2][item] }

    n = si.size()
    num = pSum - ((sum1 * sum2) / n)
    den = Math.sqrt((sum1Sq-(sum1**2)/n) * (sum2Sq - ((sum2**2)/n)))

    return 0 if den == 0
    num / den
  end

  def self.top_matches(prefs, person, n = 5, &similarity)
    scores = (prefs.keys - [person]).map do |other|
      [similarity[prefs, person, other], other]
    end.sort.reverse[0, n]
  end

  def self.get_recommendations(prefs, person, &similarity)
    totals = Hash.new(0.0)
    simSums = Hash.new(0.0)
    (prefs.keys - [person]).map do |other|
      sim = similarity[prefs, person, other]
      next if sim <= 0
      (prefs[other].keys - prefs[person].keys).map do |item|
        totals[item] += prefs[other][item] * sim
        simSums[item] += sim
      end
    end
    totals.map do |item, total|
      [(total/simSums[item]), item]
    end.sort.reverse
  end
end

