#lang racket

(define (separator? val)
  (cond ((eqv? val #\space) #t)
        ((eqv? val #\tab) #t)
        ((eqv? val #\newline) #t)
        (else #f))
  )

(define (cpy str)
  (define (iter str out)
  
    (if (separator? (car str))
        out
        (if (eqv? out '())
            (iter (cdr str) (list (car str)))
            (iter (cdr str) (append out (list (car str))) ))
            )
        )
  (iter str '())
  )

(define (drop str)
  (if (separator? (car str))
      (cdr str)
      (drop (cdr str))
      )
  )


(define (same? str1 str2)
  (if (equal? (cpy str1) str2)
      #t
      #f
      )
  )

(define (replace str1 str2 str3)
  (define (iter str1 str2 str3 out)

    (if (null? str1)
        out
        (if (equal? (list (car str1)) str2)
            (if (separator? (cadr str1))
                (if (eqv? out '())
                    (iter (cdr str1) str2 str3 str3)
                    (iter (cdr str1) str2 str3 (append  out str3))
                    )
                (iter (cdr str1) str2 str3 (append  out (list (car str1))))
                )
            (iter (cdr str1) str2 str3 (append  out (list (car str1))))
            )
        )
    )
  
  (iter str1 str2 str3 '())
  )
      
      

      
     
  

      
      
      
      


    
  
