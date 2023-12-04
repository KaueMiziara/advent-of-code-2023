(ns Day4.part1)

; The input has a set of cards containing winning numbers and chosen numbers.
; Each card is worth 2^(n-1), when "n" is the number of winning numbers in the chosen set.
; The answer is the sum of all cards values.

(require 'clojure.java.io)
(require 'clojure.string)
(require 'clojure.set)

(defn read-input
  [file-name]
  (with-open [rdr (clojure.java.io/reader file-name)]
  (reduce
    (fn [acc line] (conj acc line))
    []
    (line-seq rdr))))


(defn print-array
  [arr]
  (doseq [element arr]
    (println element)))


(defn split-array-by
  [arr delimiter]
  (let [[left right] (clojure.string/split arr delimiter)]
    [left right]))


(defn string-to-array
  [s]
  (->> (clojure.string/split s #"\s+")
    (remove empty?)
    (map #(Integer. %))))


(defn find-intersection
  [arr1 arr2]
  (-> (set arr1)
    (clojure.set/intersection (set arr2))
    (into [])))


(defn calculate-card-worth
  [arr]
  (if (empty? arr) 0
    (Math/pow 2 (dec (count arr)))))


(defn sum-array
  [arr]
  (reduce + 0 arr))


(defn main
  []
  (let [input (read-input "./input.txt")
    card-worths (atom [])]
  (doseq [line input]
    (let [[_ numbers] (split-array-by line #":\ ")
      [win elf] (split-array-by numbers #"\ \|\ ")
      win-n (string-to-array win)
      elf-n (string-to-array elf)
      inter (find-intersection win-n elf-n)
      card-worth (calculate-card-worth inter)]
      (swap! card-worths conj card-worth)))
  (let [total-card-worth (sum-array @card-worths)]
    (println "Answer: " total-card-worth))))


(main)
