(define srcdir "src")
(define objdir "obj")
(define libdir "lib")
(define bindir "bin")

(define cc "g++")
(define ar "ar")
(define cflags "-I. -std=c++11 -fPIC")

(define libglfw
  (read-cmd "pkg-config --static --libs glfw3"))
(define libglew
  (read-cmd "pkg-config --static --libs glew"))
(define libs
  (string-join (lset-union equal?
			   (string-split libglfw #\space)
			   (string-split libglew #\space))
	       " "))

(define ldflags
  (string-append
   "-std=c++11 "
   libs))

(define (srcfile? path)
  (and (string-match ".cpp$" path) #t))
(define (header? path)
  (and (string-match ".h$" path) #t))
(define (objfile? path)
  (and (string-match ".o$" path) #t))

(define (compile srcfile outname)
  (define cmd (string-append cc " " cflags " -c " srcfile " -o " outname))
  (run-cmd cmd))

(define (link-lib srcfiles outname)
  (define cmd (string-append ar " rcs " outname " " (string-join srcfiles " ")))
  (run-cmd cmd))

(define (link-bin srcfiles outname)
  (define cmd (string-append cc " " (string-join srcfiles " ") " " ldflags " -o " outname))
  (run-cmd cmd))
