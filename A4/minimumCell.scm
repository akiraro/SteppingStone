#lang racket

; GREEDY ALGORITHM
(define (greedyAlgo data listCost)
  (define (iter data listCost)

    ;defining all required variables
    (define lengthX (+ (getLengthX data) 1))
    (define lengthY (+ (getLengthY data) 1))
    (define xCoord (list-ref (car listCost) 1))
    (define yCoord (list-ref (car listCost) 2))
    (define supply (getData data lengthX (list-ref (car listCost) 2)))
    (define demand (getData data (list-ref (car listCost) 1) lengthY))
    ;
    (display "\niterate \n")
    (display "listCost is ") (display listCost)
    (newline)
    (display "xCoord is ") (display xCoord)
    (newline)
    (display "yCoord is ") (display yCoord)
    (newline)
    (display "supply is ") (display supply)
    (newline)
    (display "demand is ") (display demand)
    (newline)
    (display data)
    
    (if (or (= 0 (getData data lengthX yCoord)) (= 0 (getData data xCoord lengthY))) ; Check if supply or demand == 0
      (if (null? (cdr listCost)) ; check if listCost ? null
        (begin (display "\n\nGreedy Algorithm Done") (modifyData data xCoord yCoord '-))
        (iter (modifyData data xCoord yCoord '-) (cdr listCost))
       )

        (if (<= supply demand) ; check if supply < demand
          (if (null? (cdr listCost))
            (begin 
              (display "\n\n listCost is now null, ending .. \n \n") 
              (modifyData data xCoord yCoord supply))
            (begin (display "true")
              (iter (modifyData (modifySupDem data xCoord yCoord supply) xCoord yCoord supply) (cdr listCost)))
          )
          (if (null? (cdr listCost))
            (begin (display "\n\n listCost is now null, ending .. \n \n") (modifyData data xCoord yCoord demand))
            (begin (display "false")
              (iter (modifyData (modifySupDem data xCoord yCoord demand) xCoord yCoord demand) (cdr listCost))))
          )
        )
    )
  (recData data (iter data listCost))
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

; RECOVER SUPPLY DEMAND VALUE
(define (recData original modified)

  (define (iter original modified length counter)
    (if (< counter length)
      (iter original (modifyData modified (+ (getLengthX modified) 1) counter (getData original (+ (getLengthX original) 1) counter)) length (+ counter 1))
      modified
    )
  )

  (iter original modified (+ (getLengthY original) 1) 1)
  (list-set 
    (iter original modified (+ (getLengthY original) 1) 1)
    (+ (getLengthY original) 1) 
    (list-ref original (+ (getLengthY original) 1))
    )
)

; MODIFY DATA AT GIVEN COORDINATE
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

; MODIFY SUPPLY AND DEMAND
(define (modifySupDem data xCoord yCoord val)
  (define xLength (+ (getLengthX data) 1))
  (define yLength (+ (getLengthY data) 1))
  (define (iterGetter data yCoord yCounter)
    (if (= yCoord yCounter)
        (car data)
        (iterGetter (cdr data) yCoord (+ yCounter 1))
        )
    )
  (list-set (list-set data yLength (list-set (iterGetter data yLength 0) xCoord (- (getData data xCoord yLength) val))) yCoord (list-set (iterGetter data yCoord 0) xLength (- (getData data xLength yCoord) val)))

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


(define (writeTableau tb fileOut)
  (if (eqv? tb '())
      #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))
                        

; ------ MAIN FUNCTION GOES HERE --------

(define dataInitial (readTableau "4by4_inputdata.txt"))

(define (main)
  (define dataInitial (readTableau "4by4_inputdata.txt"))
  (display "xLength : ") (display (getLengthX dataInitial)) (display "\n")
  (display "yLength : ") (display (getLengthY dataInitial)) (display "\n")
  (display "Cost List : ")
  (display (costList dataInitial (getLengthX dataInitial) (getLengthY  dataInitial))) (display "\n")
  (display "Sorted List : ")
  (display (bubble-set-up (costList dataInitial (getLengthX  dataInitial) (getLengthY  dataInitial))))
  ; (greedyAlgo dataInitial (bubble-set-up (costList dataInitial (getLengthX  dataInitial) (getLengthY  dataInitial))))
  (writeTableau (greedyAlgo dataInitial (bubble-set-up (costList dataInitial (getLengthX  dataInitial) (getLengthY  dataInitial)))) "intialSolution.txt")
  )

(main)