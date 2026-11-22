#lang racket/base

; my-length counts top-level elements; nested lists each contribute one.
(define (my-length lst)
  (let count ((rest lst) (size 0))
    (if (null? rest)
        size
        (count (cdr rest) (+ size 1)))))

; my-map applies f once per element, left first, and restores original order.
(define (my-map f lst)
  (let collect ((rest lst) (backwards '()))
    (if (null? rest)
        (let restore ((remaining backwards) (forward '()))
          (if (null? remaining)
              forward
              (restore (cdr remaining) (cons (car remaining) forward))))
        (collect (cdr rest) (cons (f (car rest)) backwards)))))

; make-inserter closes over x and len-ok?; only original children are visited.
(define (make-inserter x len-ok?)
  (letrec ((insert-list
            (lambda (original)
              (let* ((insert? (len-ok? (my-length original)))
                     (children
                      (my-map (lambda (element)
                                (if (or (null? element) (pair? element))
                                    (insert-list element)
                                    element))
                              original)))
                (if insert? (cons x children) children)))))
    insert-list))