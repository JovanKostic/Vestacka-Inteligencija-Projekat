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

(defun poljePopuna2(i j)
    (if (eq (mod j 2) 0) 
        (if (eq (mod i 2) 0) 
            (if (= i dimenzije) (reverse '(- - - - - - - - -)) (reverse '(X O - - - - - - -))) 
        )
    '(" " " " " " " " " " " " " " " " " ")
    )
)

(defun poljePopuna1(i j) 
    (if (eq (mod i 2) 1) (if (eq (mod j 2) 1) (if (= i 1) (reverse '(- - - - - - - - -)) (reverse '(O O O O O O O O -))) '(" " " " " " " " " " " " " " " " " "))
     (poljePopuna2 i j)
    )
)
(defstruct struktura
    tabla
    dimenzije
)
(defstruct igrac
    XiliO
    brojstekova
)
(defun generisiInterfejs()
    (unosdimenzija)
    (setq moja-struktura (make-struktura :tabla (napravi dimenzije) :dimenzije dimenzije))
            (format t "~%       ") (crtajBrojeve (struktura-dimenzije moja-struktura))
            (crtajInterfejs (struktura-tabla moja-struktura) dimenzije)
            (if (y-or-n-p "Da li zelite da igrate prvi? ~%") (prviigra T) (drugiigra T))
            ;; (crtajInterfejs (struktura-tabla moja-struktura) (struktura-dimenzije moja-struktura))
)
(defun prviigra(provera)
    (setq igracX (make-igrac :XiliO 'X :brojstekova 0))
    (format t "~%Vi ste igrac ~a!~%" (igrac-XiliO igracX))
    (setq igracO (make-igrac :XiliO 'O :brojstekova 0))
    ;; (print (validacija1 (validacijapoteza (read) (read) (struktura-tabla moja-struktura)) (read) *igracX*))
    (trazenjevrsta (struktura-tabla moja-struktura))
    (cond ((and (eq dimenzije 8) (eq (igrac-brojstekova igracX) 2)) (print "Vi ste pobednik"))
            ((and (eq dimenzije 10) (eq (igrac-brojstekova igracX) 3)) (print "Vi ste pobednik")))
    (cond ((eq provera T) (validacija (igrac-XiliO igracX) (read) (read) (read) (read) (read) (struktura-tabla moja-struktura)) (drugiigra provera)))
)
(defun drugiigra(provera)
    (setq igracO (make-igrac :XiliO 'O :brojstekova 0))
    (format t "~%Vi ste igrac ~a!~%" (igrac-XiliO igracO))
    (setq igracX (make-igrac :XiliO 'X :brojstekova 0))
    (trazenjevrsta (struktura-tabla moja-struktura))
    (cond ((and (eq dimenzije 8) (eq (igrac-brojstekova igracO) 2)) (print "Vi ste pobednik"))
            ((and (eq dimenzije 10) (eq (igrac-brojstekova igracO) 3)) (print "Vi ste pobednik")))
    (cond ((eq provera T) (validacija (igrac-XiliO igracO) (read) (read) (read) (read) (read) (struktura-tabla moja-struktura)) (prviigra provera)))
)
(defun trazenjevrsta(tabla)
    (cond 
        ((not (eq tabla nil)) (trazenjepolja (car (cdr (car tabla))) (caar tabla)) (trazenjevrsta (cdr tabla)))
    )
)
(defun trazenjepolja(vrsta slovo)
    (cond
        ((not (eq vrsta nil)) (proverasteka (reverse (car (cdr (car vrsta)))) slovo (caar vrsta)) (trazenjepolja (cdr vrsta) slovo))
    )
)
(defun proverasteka(polje slovo broj &optional(n 0))
    (if (not (eq n 7)) 
        (proverasteka (cdr polje) slovo broj (+ n 1)) 
        (if (eq (car polje) 'X) 
            (obrisiX slovo broj) 
            (if (eq (car polje) 'O) 
                (obrisiO slovo broj)
                nil
            )
    ))
)
(defun obrisiX(slovo broj)
    (setq igracX (make-igrac :XiliO 'X :brojstekova (+ (igrac-brojstekova igracX) 1)))
    (setq moja-struktura (make-struktura :tabla (obrisipunstek slovo broj (struktura-tabla moja-struktura)) :dimenzije dimenzije))
)
(defun obrisiO(slovo broj)
    (setq igracO (make-igrac :XiliO 'O :brojstekova (+ (igrac-brojstekova igracO) 1)))
    (setq moja-struktura (make-struktura :tabla (obrisipunstek slovo broj (struktura-tabla moja-struktura)) :dimenzije dimenzije))

)
(defun obrisipunstek(slovo broj tabla &optional(novatabla))
    (if (not (eq tabla nil)) 
        (if (not (eq (caar tabla) slovo)) 
            (obrisipunstek slovo broj (cdr tabla) (append novatabla (list (car tabla)))) 
            (append (append novatabla (list (append (list (caar tabla)) (list (nadjistek (car (cdr (car tabla))) broj tabla))))) (cdr tabla))
        )
    )
)
(defun nadjistek(listapolja broj tabla &optional(novalistapolja))
    (if (not (eq listapolja nil)) 
        (if (not (eq (caar listapolja) broj)) 
            (nadjistek (cdr listapolja) broj tabla (append novalistapolja (list (car listapolja)))) 
            (append (append novalistapolja  (list (append (list (caar listapolja)) (list '(- - - - - - - - -))))) (cdr listapolja))
        )
    )
)
(defun validacija1(polje visina igrac)
    (if (not (eq (car polje) '-)) (if (not (eq visina 0)) (validacija1 (cdr polje) (- visina 1) igrac) (if (eq (car polje) igrac) T nil)))
)
(defun vratibroj(slovo &optional(lista '((1 A) (2 B) (3 C) (4 D) (5 E) (6 F) (7 G) (8 H) (9 I) (10 J))))
    (if (not (eq lista nil)) (if (eq (car (cdr (car lista))) slovo) (caar lista) (vratibroj slovo (cdr lista))))
)
(defun validacija (igrac slovo1 broj1 slovo2 broj2 visina tabla)
    (format t "Unesite potez: ~%")
        (if (validacija1 (validacijapoteza slovo1 broj1 tabla) visina igrac) 
            (if (not (or (< (struktura-dimenzije moja-struktura) broj1) (< (struktura-dimenzije moja-struktura) broj2)))
                (if (or (eq broj1 (+ broj2 1)) (eq broj1 (- broj2 1))) 
                    (if (or (eq (vratibroj slovo1) (- (vratibroj slovo2) 1)) (eq (vratibroj slovo1) (+ (vratibroj slovo2) 1)))
                        (if (validacija_poteza (validacijapoteza slovo1 broj1 tabla) (validacijapoteza slovo2 broj2 tabla) visina)  
                            (potez slovo1 broj1 slovo2 broj2 visina tabla) 
                            (validacija igrac (read) (read) (read) (read) (read) (struktura-tabla moja-struktura))
                    ) 
                    (validacija igrac (read) (read) (read) (read) (read) (struktura-tabla moja-struktura))
                ) 
                (validacija igrac (read) (read) (read) (read) (read) (struktura-tabla moja-struktura))
            ) 
            (validacija igrac (read) (read) (read) (read) (read) (struktura-tabla moja-struktura))
        ) 
        (validacija igrac (read) (read) (read) (read) (read) (struktura-tabla moja-struktura))
    )
)
(defun potez (slovo1 broj1 slovo2 broj2 visina tabla)
    (setq moja-struktura (make-struktura :tabla (potezcovek slovo1 broj1 visina tabla) :dimenzije dimenzije))
    ;; (setq moja-struktura (make-struktura :tabla (potezcovek1 slovo2 broj2 visina (struktura-tabla moja-struktura)) :dimenzije dimenzije))
    (setq moja-struktura (make-struktura :tabla (struktura-tabla moja-struktura)  :dimenzije dimenzije))
    (format t "~%       ") (crtajBrojeve (struktura-dimenzije moja-struktura))
    (setq moja-struktura (make-struktura :tabla (potezcovek1 slovo2 broj2 visina (struktura-tabla moja-struktura)) :dimenzije dimenzije))

    (crtajInterfejs (struktura-tabla moja-struktura) (struktura-dimenzije moja-struktura))
)
(defstruct pompolje
    lista
)
(defun validacija_poteza(polje1 polje2 visina)
    (if (not (equalp (car polje1) " ")) (if (not (equalp (car polje2) " ")) (if (<= (+ (val_polje1 polje1 visina) (val_polje2 polje2)) 8) T nil) nil) nil)
)
(defun val_polje2(polje &optional(brojac 0))
    (if (not (eq (car polje) '-)) (val_polje2 (cdr polje) (+ brojac 1)) brojac)
)
(defun val_polje1 (polje visina)
    (if (not (eq (car polje) '-)) (if (not (eq visina 0)) (val_polje1 (cdr polje) (- visina 1)) (val_polje2 polje)))
)
(defun validacijapoteza(slovo broj tabla)
    (if (not (eq tabla nil)) (if (not (eq (caar tabla) slovo)) (validacijapoteza slovo broj (cdr tabla)) (validacijapolja (car (cdr (car tabla))) broj tabla)) nil)
)
(defun validacijapolja(listapolja broj tabla)
    (if (not (eq listapolja nil)) 
        (if (not (eq (caar listapolja) broj)) 
            (validacijapolja (cdr listapolja) broj tabla) 
            (slanjepolja (cdr (car listapolja)) broj tabla)
        ) 
        nil
    )
)
(defun slanjepolja(polje broj tabla)
    (if (not (eq polje nil)) (reverse (car polje)) nil)
)
(defun potezcovek(slovo broj visina tabla &optional(novatabla))
    (if (not (eq tabla nil)) 
        (if (not (eq (caar tabla) slovo)) 
            (potezcovek slovo broj visina (cdr tabla) (append novatabla (list (car tabla)))) 
            (append (append novatabla (list (append (list (caar tabla)) (list (nadjiPolje (car (cdr (car tabla))) broj tabla visina))))) (cdr tabla))
        )
    )
)
(defun potezcovek1(slovo broj visina tabla &optional(novatabla))
    (if (not (eq tabla nil)) 
        (if (not (eq (caar tabla) slovo)) 
            (potezcovek1 slovo broj visina (cdr tabla) (append novatabla (list (car tabla)))) 
            (append (append novatabla (list (append (list (caar tabla)) (list (nadjiPolje1 (car (cdr (car tabla))) broj tabla visina))))) (cdr tabla))
        )
    )
)
(defun nadjiPolje(listapolja broj tabla visina &optional(novalistapolja))
    (if (not (eq listapolja nil)) 
        (if (not (eq (caar listapolja) broj)) 
            (nadjiPolje (cdr listapolja) broj tabla visina (append novalistapolja (list (car listapolja)))) 
            (append (append novalistapolja  (list (append (list (caar listapolja)) (list (obradipolje (cdr (car listapolja)) broj visina tabla))))) (cdr listapolja))
        )
    )
)
(defun nadjiPolje1(listapolja broj tabla visina &optional(novalistapolja))
    (if (not (eq listapolja nil)) 
        (if (not (eq (caar listapolja) broj)) 
            (nadjiPolje1 (cdr listapolja) broj tabla visina (append novalistapolja (list (car listapolja)))) 
            (append (append novalistapolja  (list (append (list (caar listapolja)) (list (obradipolje1 (cdr (car listapolja)) broj visina tabla))))) (cdr listapolja))
        )
    )
)
(defun obradipolje(polje broj visina tabla)
    (fja (reverse (car polje)) visina)
)
(defun obradipolje1(polje broj visina tabla)
    (fja1 (reverse (car polje)) (fj (pompolje-lista pom)) visina)
)
(defun fja(polje visina &optional(ls)(ls1))
    (if (not (eq (car polje) '-)) 
        (if (not (eq visina -1)) 
            (f (cdr (fja (append (cdr polje) (list '-)) (- visina 1) (append ls (list (car polje))) (setq pom (make-pompolje :lista polje)))))  
            (reverse ls)
        ) 
        (f (reverse (reverse (cdr (reverse ls)))))
    )
)
(defun f(polje &optional(n (length polje))(ls '()))
    (if (not (eq n 9)) (f polje (+ n 1) (append ls (list '-))) (append ls polje))
)

(defun fja1(polje poljezaumetanje visina &optional(ls '()))
    (if (eq (car polje) '-) (f (append (reverse poljezaumetanje) (reverse ls))) (fja1 (cdr polje) poljezaumetanje visina (append ls (list (car polje)))))
)

(defun fj(polje &optional(ls '()))
    (if
        (not (eq (car polje) '-)) (fj (cdr polje) (append ls (list (car polje)))) ls
    )
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

(defun unosdimenzija ()
(format t "Unesite dimenziju: ~%")
(setq dimenzije (read))
    (if (not (= dimenzije 8)) (if (not (= dimenzije 10)) (unosdimenzija) (format t "validne dimenzije!")) (format t "validne dimenzije!")))
    

(defun slovo(n lista &optional(m 1))
    (if (not (= n m)) (slovo n (cdr lista) (+ m 1)) (cdr (car lista)))
)

(generisiInterfejs)