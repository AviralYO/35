#lang racket/base

; traversal-values processes pending trees/values and accumulates output backwards.
; Scheduling always visits a left subtree before its corresponding right subtree.
(define (traversal-values tree order)
  (let walk ((pending (list tree)) (backwards '()))
    (cond
      ((null? pending)
       (let restore ((rest backwards) (forward '()))
         (if (null? rest)
             forward
             (restore (cdr rest) (cons (car rest) forward)))))
      ((null? (car pending))
       (walk (cdr pending) backwards))
      ((pair? (car pending))
       (let* ((node (car pending))
              (value (car node))
              (left (cadr node))
              (right (caddr node))
              (rest (cdr pending)))
         (cond
           ((eq? order 'inorder)
            (walk (cons left (cons value (cons right rest))) backwards))
           ((eq? order 'preorder)
            (walk (cons value (cons left (cons right rest))) backwards))
           (else
            (walk (cons left (cons right (cons value rest))) backwards)))))
      (else
       (walk (cdr pending) (cons (car pending) backwards))))))

; print-inorder emits the left-node-right value list on one line.
(define (print-inorder tree)
  (display (traversal-values tree 'inorder))
  (newline))