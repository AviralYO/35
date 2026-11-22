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

; print-all-traversals emits inorder, preorder, then postorder.
(define (print-all-traversals tree)
  (print-inorder tree)
  (display (traversal-values tree 'preorder))
  (newline)
  (display (traversal-values tree 'postorder))
  (newline))

; tree-statistics tracks (node depth) tasks, maximum depth, and visited leaves.
(define (tree-statistics tree)
  (let walk ((pending (list (list tree 1))) (height 0) (leaves 0))
    (if (null? pending)
        (list height leaves)
        (let* ((task (car pending))
               (node (car task))
               (depth (cadr task))
               (rest (cdr pending)))
          (if (null? node)
              (walk rest height leaves)
              (let ((left (cadr node)) (right (caddr node)))
                (walk (cons (list left (+ depth 1))
                            (cons (list right (+ depth 1)) rest))
                      (max height depth)
                      (if (and (null? left) (null? right))
                          (+ leaves 1)
                          leaves))))))))

; print-height-and-leaves emits (height leaf-count), including (0 0) for empty.
(define (print-height-and-leaves tree)
  (display (tree-statistics tree))
  (newline))
