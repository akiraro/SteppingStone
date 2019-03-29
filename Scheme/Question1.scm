#lang racket

(define (over X)
  (if (eq? X 0)
      0
      (/ 1 X)
  )
  )

(define (1over List)
  (if (null? List)
      '()
      (map over List)
  )
  )


