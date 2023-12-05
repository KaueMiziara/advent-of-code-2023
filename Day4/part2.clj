(ns Day4.part2)

; The input has a set of cards containing winning numbers and chosen numbers.
; The amount of winning numbers in the chosen set makes you win a copy of the next n cards.
; The answer is the total number of cards.

; arr idx -> +1 (idx + 1 .. idx + n - 1)

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


(defn sum-array
  [arr]
  (reduce + 0 arr))


(defn main
  []
  (let [input (read-input "./sample.txt")
    cards (atom (vec (repeat (count input) 1)))]
  (doseq [line-index (range (count input))]
    (let [line (nth input line-index)
      [_ numbers] (split-array-by line #":\ ")
      [win elf] (split-array-by numbers #"\ \|\ ")
      win-n (string-to-array win)
      elf-n (string-to-array elf)
      inter (find-intersection win-n elf-n)
      inter-length (count inter)
      current-card (nth @cards line-index)
      
      updated-cards (->> cards
        (assoc line-index current-card)
        (apply conj (repeat inter-length (+ current-card))))]
        (println "Updated Cards: " updated-cards)))
    (println "Final cards vector: " @cards)))


(main)

; 1 1 1 1 1 1
; 1 2 2 2 2 1
; 1 2 4 4 2 1
; 1 2 4 8 6 1
; 1 2 4 8 14 1
