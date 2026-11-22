#lang racket/base

; my-length counts top-level elements; nested lists each contribute one.
(define (my-length lst)
  (let count ((rest lst) (size 0))
    (if (null? rest)
        size
        (count (cdr rest) (+ size 1)))))