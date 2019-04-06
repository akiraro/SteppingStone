#lang racket


; GREEDY ALGORITHM
(define (greedyAlgo data listCost)
  (define (iter data listCost output)
    (if (null? listCost)
        output
        (if (and (eqv? 0 (get
        (iter (modifyData data (list-ref (car listCost) 1) (list-ref (car listCost) 2)))
        )
    )
  (iter data listCost '())
  
  )

; GET DATA AT GIVEN COORDINATE
(define (getData data xCoord yCoord)
  
  (define (iterY data yCoord yCounter)
    (if (= yCoord yCounter)
        (car data)
        (iterY (cdr data) yCoord (+ yCounter 1))
        )
    )

  (define (iterX data xCoord xCounter)
    (if (= xCoord xCounter)
        (car data)
        (iterX (cdr data) xCoord (+ xCounter 1))
        )
    )

  (iterX (iterY data yCoord 0) xCoord 0)

  )

; MODIFY DATA AT GIVE COORDINATE

(define (modifyData data xCoord yCoord val)
 (define (iterGetter data yCoord yCounter)
   (if (= yCoord yCounter)
       (car data)
       (iterGetter (cdr data) yCoord (+ yCounter 1))
       )
   )
  (iterGetter data yCoord 0)
  (list-set data yCoord (list-set (iterGetter data yCoord 0) xCoord val))
  )

; GET LENGTH OF X
(define (getLengthX data)

  (define (iter data counter)
    (if (null? data)
        counter
        (iter (cdr data) (+ counter 1))
        )
    )
  (- (iter (car data) 0) 2)
  )

; GET LENGTH OF Y
(define (getLengthY data)
  (define (iter data counter)
    (if (null? data)
        counter
        (iter (cdr data) (+ counter 1))
        )
    )
  (- (iter data 0) 2 )
  )


; --- MAKE LIST OF DATA AND SORT ---
; Output of list : ((COST XCOORD YCOORD) ...)

(define (costList data xLength yLength)
  (define (iter data xLength yLength xCounter yCounter out)
    (if (> xCounter xLength)
        (if (>= yCounter yLength)
            out
            (iter data xLength yLength 1 (+ yCounter 1) out)
            )
        (if (eqv? out '())
            (iter data xLength yLength (+ xCounter 1) yCounter (list (list (getData data xCounter yCounter) xCounter yCounter)))
            (iter data xLength yLength (+ xCounter 1) yCounter (append out  (list (list (getData data xCounter yCounter) xCounter yCounter))))
            )
        )
    )
  (iter data xLength yLength 1 1 '())
  )
  


(define (bubble L)
  (if (null? (cdr L))
      L    
      (if (< (car (car L)) (car (cadr L)))   
          (cons (car L)
                (bubble (cdr L)))
          (cons (cadr L)
                (bubble (cons (car L) (cddr L)))))))

(define (bubble-sort N L)    
  (cond ((= N 1) (bubble L))   
        (else
         (bubble-sort (- N 1) (bubble L)))))

(define (bubble-set-up L) 
  (bubble-sort (length L) L))




; -------------





(define (readTableau fileIn)  
  (let ((sL (map (lambda s (string-split (car s))) (file->lines fileIn))))
    (map (lambda (L)
           (map (lambda (s)
                  (if (eqv? (string->number s) #f)
                      s
                      (string->number s))) L)) sL)))




(define tb (readTableau "3by4_inputdata.txt"))

(define (writeTableau tb fileOut)
  (if (eqv? tb '())
      #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))
                             
; (display-lines-to-file (readTableau "3by3_inputdata.txt") "test.txt")
; (writeTableau tb "test.txt")




; ------ MAIN FUNCTION GOES HERE --------

(define (main)
  (define dataInitial (readTableau "3by3_inputdata.txt"))
  (display "xLength : ") (display (getLengthX dataInitial)) (display "\n")
  (display "yLength : ") (display (getLengthY dataInitial)) (display "\n")
  (display "Cost List : ")
  (display (costList dataInitial (getLengthX dataInitial) (getLengthY  dataInitial))) (display "\n")
  (display "Sorted List : ")
  (display (bubble-set-up (costList dataInitial (getLengthX  dataInitial) (getLengthY  dataInitial))))
  (modifyData (readTableau "3by3_inputdata.txt") 0 2 'helloo)
  )

(main)