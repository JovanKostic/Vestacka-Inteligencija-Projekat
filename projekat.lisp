(setq tabla '())
(setq listaslova '((1 A) (2 B) (3 C) (4 D) (5 E) (6 F) (7 G) (8 H) (9 I) (10 J)))
(defun napravi(dim)
    (if (>= dim 0) (napraviPoljeSaElementima dim (napravi (- dim 1)) tabla))
)
(defun napraviPoljeSaElementima(n tabla &optional(napravi))
    (cond 
        ((/= n 0) (append tabla (list (append (slovo n listaslova) (list (reverse (napraviPolje n)))))))
    )
)
(defun napraviPolje(n &optional(lista)(brojac dimenzije))
    (if (>= brojac 1) (napraviPolje n (append lista (list (append (list brojac) (list (poljePopuna1 n brojac))))) (- brojac 1)) lista)
)
;; (defun poljePopuna2(i j)
;;     (if 
;;         (and (eq (mod j 2) 0) (eq (mod i 2) 1)) '(("   ") ("   ") ("   ")) '((---)(---)(--x))
;;     ) 
;; )
(defun poljePopuna2(i j)
    (if (eq (mod j 2) 0) 
        (if (eq (mod i 2) 0) 
            (if (= i dimenzije) '(- - - - - - - - -) '(- - - - - - - - X)) 
        )
    '(" " " " " " " " " " " " " " " " " ")
    )
)

(defun poljePopuna1(i j) 
    (if (eq (mod i 2) 1) (if (eq (mod j 2) 1) (if (= i 1) '(- - - - - - - - -) '(- - - - - - - - O)) '(" " " " " " " " " " " " " " " " " "))
     (poljePopuna2 i j)
    )
)
(defstruct struktura
    tabla
    dimenzije
)
(defun generisiInterfejs()
    (unosdimenzija)
    (setq moja-struktura (make-struktura :tabla (napravi dimenzije) :dimenzije dimenzije))
            (format t "~%       ") (crtajBrojeve (struktura-dimenzije moja-struktura))
            (crtajInterfejs (struktura-tabla moja-struktura) dimenzije)
            (if (y-or-n-p "Da li zelite da igrate prvi? ") (setq moja-struktura (make-struktura :tabla (potezcovek (read) (read) (struktura-tabla moja-struktura)))))
            (crtajInterfejs (struktura-tabla moja-struktura) (struktura-dimenzije moja-struktura))
)
(defun potezcovek(slovo broj tabla &optional(novatabla))
    (if (not (eq tabla nil)) (if (not (eq (caar tabla) slovo)) (potezcovek slovo broj (cdr tabla) (append novatabla (list (car tabla)))) (append (append novatabla (list (append (list (caar tabla)) (list (nadjiPolje (car (cdr (car tabla))) broj tabla))))) (cdr tabla))))
)

(defun nadjiPolje(listapolja broj tabla &optional(novalistapolja))
    (if (not (eq listapolja nil)) (if (not (eq (caar listapolja) broj)) (nadjiPolje (cdr listapolja) broj tabla (append novalistapolja (list (car listapolja)))) (append (append novalistapolja  (list (append (list (caar listapolja)) (list (obradipolje (cdr (car listapolja)) broj tabla))))) (cdr listapolja))))
)
(defun obradipolje(polje broj tabla)
    (fja (car polje))
    ;; (if (equal (caar polje) '(- - -)) (obradipolje (cdr (car polje)) broj tabla) (print polje))
)
(defun fja(polje)
    (insert 'X 'O (removeAt '1 '1 polje))
)
(defun insert (insertion border list)
    (cond
        ((null list) '())    
        ((equal border (car list))(append (list insertion border) (insert  insertion border (cdr list)) ))        
        ((listp (car list))
            (cons (insert insertion border (car list))(insert insertion border (cdr list) ))
        )  
        (t (cons (car list)(insert insertion border (cdr list))))
    )
)
(defun removeAt (temp index list) 
    (cond
        ((null list) '())
        ((equalp temp index)(removeAt (1+ temp) index (cdr list)) )
        ((listp (car list)) (cons (removeAt 0 index (car list)) (removeAt (1+ temp) index (cdr list)) ) )
        (t (cons (car list) (removeAt (1+ temp) index (cdr list) )))
    )
)
(defun obradipodpolje(podpolje broj tabla)
    (if (eq (car podpolje) '-) (obradipodpolje (cdr podpolje) broj tabla) (cons novopodpolje 'O))
)    
(defun vratiutabelu(slovo broj tabla)

)

(defun crtajBrojeve(dimenzije &optional(br 1))
    (cond 
        ((>= dimenzije 1) (format t " ~a            " br) (crtajBrojeve (- dimenzije 1) (+ br 1)))
    )
)

(defun crtajInterfejs(tabla dimenzije)
    (cond 
        ((not (eq tabla nil)) (crtajVrstu (car tabla) dimenzije) (crtajInterfejs (cdr tabla) dimenzije))
    )
)
(defun crtajVrstu(vrsta dimenzije)
    (cond 
        ((not (eq vrsta nil)) (format t "~% ~%     ")(crtajRed1 (car (cdr vrsta)) dimenzije) (format t "~% ~a   "(car vrsta)) (crtajRed2 (car (cdr vrsta)) dimenzije) (format t "~%     ")(crtajRed3 (car (cdr vrsta)) dimenzije))
    )
)
(defun crtajRed1(vr dimenzije)
    (cond 
        ((not (eq vr '())) (format t "~a       " (crtajPolje1 (car (cdr (car vr))))) (crtajRed1 (cdr vr) dimenzije))
    )
)
(defun crtajRed2(vr dimenzije)
    (cond 
        ((not (eq vr '())) (format t "~a       " (crtajPolje2  (cdr (cdr (cdr (car (cdr (car vr)))))))) (crtajRed2 (cdr vr) dimenzije))
    )
)
(defun crtajRed3(vr dimenzije)
    (cond 
        ((not (eq vr '())) (format t "~a       " (crtajPolje3 (cdr (cdr (cdr (cdr (cdr (cdr (car (cdr (car vr))))))))))) (crtajRed3 (cdr vr) dimenzije))
    )
)
(defun crtajPolje1(polje)
    (if (eq (length polje) 9) (append (append (list (car polje)) (list (car (cdr polje)))) (list (car (cdr (cdr polje))))) (print "  "))
)
(defun crtajPolje2(polje)
    (if (eq (length polje) 6) (append (append (list (car polje)) (list (car (cdr polje)))) (list (car (cdr (cdr polje))))) (print "  "))
)
(defun crtajPolje3(polje)
    (if (eq (length polje) 3) polje (print "  "))
)
;; (defun crtajPolje1(polje &optional(br 1))
;;     (cond 
;;         (< br 3) (cons '() (car polje)) (crtajPolje1 )
;;     )
;; )
;; (trace crtajRed)
(defun unosdimenzija ()
(format t "Unesite dimenziju: ~%")
(setq dimenzije (read))
    (if (not (= dimenzije 8)) (if (not (= dimenzije 10)) (unosdimenzija) (format t "validne dimenzije!")) (format t "validne dimenzije!")))
    

(defun slovo(n lista &optional(m 1))
    (if (not (= n m)) (slovo n (cdr lista) (+ m 1)) (cdr (car lista)))
)
(defun crtajMatricu(size i j)
    (terpri)
    (do ((i 0 (1+ i)))
        ((>= i size))      ;; exit condition
        (do ((j 0 (1+ j)))
            ((>= j size))  ;; exit condition
            
            (format t "~0,5F " '-)
        )
        (terpri)
    )
)
;; (trace napravi)
;; (trace napraviPoljeSaElementima)
;; (unosdimenzija)
;; (print (napravi dimenzije))
;; (play)
(generisiInterfejs)