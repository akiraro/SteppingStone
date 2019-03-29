#lang racket

(define TOL 1e-6)


(define (newtonRhap x f fx)

  (if (<=  (abs (/ (f x) (fx x))) TOL)
      x
      (newtonRhap (- x (/ (f x) (fx x))) f fx)
      )
  )
  