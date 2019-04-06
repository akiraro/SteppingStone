#lang racket

(define TOL 1e-6)

(define (p_cos x)
  (let loop ((counter 1))
    (if (= counter 10000000000000)
        (formula x counter)
        (if (< (abs (- (formula x (+ counter 1)) (formula x counter))) TOL)
            (formula x counter)
            (begin (formula x counter) (loop (+ counter 1)))
            )
        )
    )
  )



(define (formula x n)
  (let loop ((counter n))
    (if (= counter 1)
        (- 1 (/ (* 4 (* x x)) (* (* pi pi) (expt (- (* 2 n) 1 )2))))
        (* (- 1 (/ (* 4 (* x x)) (* (* pi pi) (expt (- (* 2 n) 1 )2)))) (formula x (- counter 1)))
        )
    )
  )



           