;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import  (scheme)
	 (glfw glfw)
	 (gui graphic)
	 (gui duck)
	 (gui stb)
	 (gles gles1)
	 (gui window)
	 (gui layout)
	 (gui widget)
	 (cffi cffi)
	 (gui video)
	 (utils libutil) (utils macro) )


(define window '() )
(define width 800)
(define height 700)
;;(cffi-log #t)

(define para "如果我们将我们所有的物体导入到程序当中，
它们有可能会全挤在世界的原点(0, 0, 0)上，这并不是我们想要的结果
。我们想为每一个物体定义一个位置，从而能在更大的世界当中放置它们。
世界空间中的坐标正如其名：是指顶点相对于（游戏）世界的坐标。
如果你希望将物体分散在世界上摆放（特别是非常真实的那样）
，这就是你希望物体变换到的空间。物体的坐标将会从局部变换到世界空间；
该变换是由模型矩阵(Model Matrix)实现的。")


(define (test-multi-dialog)
  (let loop ((i 0))
    (if (< i 20)
	(begin
	  (let ((p (dialog 100.0 80.0 300.0 200.0 "3windows"))
		(button1 (button 120.0 30.0 "button"))
		(button2 (button 120.0 30.0 "button2"))
		(button3 (button 120.0 30.0 "button3"))
		(button4 (button 120.0 30.0 "button4"))
		)
	    (widget-set-margin button1 10.0 20.0 0.0 20.0)
	    (widget-set-margin button2 10.0 20.0 0.0 20.0)
	    (widget-set-margin button3 10.0 20.0 0.0 20.0)
	    
	    (widget-add p button1)
	    (widget-add p button2)
	    (widget-add p button3)
	    (widget-add p button4)

	    (widget-add p (button 120.0 30.0 "button5")))
	  
	  (loop (+ i 1)))
	)))


(define (test-mutil-widget)
 (let loop ((i 0))
    (if (< i 20)
	(begin
	  (dialog  (+ i  100.0) (+ i 100.0) 300.0 200.0 (format "dialog~a" i) )
	  (loop (+ i 1)))
	)))

(define (test-video)
 (let ((d (dialog 20.0 80.0 680.0 450.0 "测试视频"))
       (play (button 120.0 30.0 "播放"))
       (stop (button 120.0 30.0 "暂停"))

	;;(v (video 280.0 250.0  "/Users/evil/Downloads/WeChatSight513.mp4"))
       ;;(v (video (/ 540.0 2.0) (/ 960.0 2.0) "/Users/evil/Downloads/0E40154524ECB7665EF37D8505DC857A.mp4"))
       (v (video (/ 640.0 1.0) (/ 360.0 1.0) "/Users/evil/Downloads/bigbuckbunny.m4v"))
	)
   (widget-add-draw
    v
    (lambda (widget parent)
      (let ((fps (video-get-fps (widget-get-attrs widget 'video)))
      	    (gx  (+ (vector-ref parent %gx) (vector-ref widget %x)))
      	    (gy   (+ (vector-ref parent %gy) (vector-ref widget %y))))
      	  (draw-text (+ gx )
      		     (+ gy)
      		     (format "fps ~a" fps)
      	  ))

      (window-post-empty-event)
      '()
      ))
   
   ;;(widget-add p v)
   (widget-add d v)
   (widget-set-margin play 10.0 10.0 10.0 10.0)
   (widget-set-margin stop 10.0 10.0 10.0 10.0)

   (widget-set-events
	   play
	   'click
	   (lambda (widget p type data)
	     ;;(printf "click play\n")
	     (video-set-pause (widget-get-attrs v 'video) 0)

	     ))
   
    (widget-set-events
	   stop
	   'click
	   (lambda (widget p type data)
	     (video-set-pause (widget-get-attrs v 'video) 1)
	     ;;(printf "click stop\n")
	    
	     ))
   
   (widget-add d play)
   (widget-add d stop)

   ))

(define (test-online-video)
 (let ((d (dialog 20.0 80.0 (* 340.0 2) (* 240.0 2) "测试在线视频播放"))
       ;;(v (video (/ 640.0 1) (/ 360.0 1) "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"))
       ;;https://media.w3.org/2010/05/sintel/trailer.mp4
       ;;(v (video (/ 640.0 1) (/ 360.0 1) "https://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4"))
       (v (video (/ 640.0 1) (/ 360.0 1) "http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4"))
       ;;(v (video (/ 640.0 1) (/ 360.0 1) "http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8"))
	)
   (widget-add-draw
    v
    (lambda (widget parent)
      (let ((fps (video-get-fps (widget-get-attrs widget 'video)))
      	    (gx  (+ (vector-ref parent %gx) (vector-ref widget %x)))
      	    (gy   (+ (vector-ref parent %gy) (vector-ref widget %y))))
	(draw-text (+ gx )
		   (+ gy)
		   (format "fps ~a" fps)
		   ))
      (window-post-empty-event)
      ;;(sleep (make-time 'time-duration 30000000 0))

      '()
      ))
   ;;(widget-add p v)
   
   (widget-add d v)
   ))
   
(define (test-scroll)
  ;;test scroll
  (let ((d (dialog 20.0 80.0 300.0 400.0 "测试scroll~"))
	(p (scroll 280.0 360.0))
	;;(v (video 280.0 250.0  "/Users/evil/Downloads/WeChatSight513.mp4"))
	)
    ;; (widget-add-draw
    ;;  v
    ;;  (lambda (w p)
    ;;    (glfw-post-empty-event)
    ;;    ))
    
    ;; (widget-add-event
    ;;  p
    ;;  (lambda (w p t d)
    ;;    (printf "scroll event type ~a ~a\n" t d)))
    
    ;;(widget-add p v)
    (widget-add p (image 180.0 180.0 "test1.jpg"))
    (widget-add p (image 180.0 180.0 "gaga.jpg"))
    (widget-add p (image 180.0 180.0 "duck.png"))
    (widget-add p (image 180.0 180.0 "face.png"))
    (widget-add p (button 120.0 30.0 "按钮"))

    (widget-add p (edit 260.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/ 
QQ群：Lisp兴趣小组239401374 啊哈哈"))
    
    (widget-add d p)
    ;;(widget-add dialog)
    ))

(define (test-mobile-ui)
  (let ((mobile-pic (load-texture "mobile.png"))
	(button1 (button 120.0 30.0 "按钮1"))
	(p (scroll 244.0 420.0))
	(img (image 180.0 180.0 "./duck.png"))
	(icon (load-texture "face.png"))
	(e (edit 260.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/ 
QQ群：Lisp兴趣小组239401374 啊哈哈"))
	(d (dialog 40.0 40.0 300.0 600.0 "窗体啦啦~")))
    (widget-set-draw
     d
     (lambda (widget p)
       (let ((x  (vector-ref  widget %x))
	     (y  (vector-ref widget %y))
	     (w  (vector-ref  widget %w))
	     (h  (vector-ref  widget %h))
	     (draw (widget-get-draw widget))
	     )
       ;;(draw-image (+ 6.0 x) (+ y 6.0) w h mobile-pic)
       (graphic-draw-solid-quad (+ x 20.0) (+ y 40.0 ) (+ x w -20.0) (+ y h -40.0) 255.0 255.0 255.0 1.0)
       (graphic-draw-texture-quad
	x y
	(+ x w) (+ y h)
	0.0 0.0 (/ 787 2370.0) 1.0 mobile-pic)

       ;;(draw-widget-rect widget)
       (vector-set! widget %gx x)
       (vector-set! widget %gy y)
       
       (let loop ((child (widget-get-child widget)))
	 (if (pair? child)
	     (begin
	       ((widget-get-draw (car child)) (car child)  widget)
	       (loop (cdr child)))
	     ))
	 
       )))
    (widget-set-edit-font e 40.0 255.0 0.0 0.0 1.0)
    
    (widget-set-padding d 30.0 30.0 90.0 40.0)

    (widget-add d p)
    (widget-add p img)
    (widget-add p button1)

    (widget-add p (image 180.0 180.0 "test1.jpg"))
    (widget-add p (image 180.0 180.0 "gaga.jpg"))
    (widget-add p (image 180.0 180.0 "duck.png"))
    (widget-add p (image 180.0 180.0 "face.png"))
    (widget-add p (button 120.0 30.0 "按钮"))
    (widget-add p e)
  ))

(define (test-multi-widget)

    (let ((p (dialog 400.0 0.0 300.0 400.0 "窗体啦啦~"))
  	(button1 (button 120.0 30.0 "窗体调大"))
  	(button2 (button 120.0 30.0 "窗体调小"))
  	(button3 (button 120.0 30.0 "按钮3"))
  	(button4 (button 120.0 30.0 "按钮"))
  	(img (image 80.0 80.0 "./duck.png"))
	(icon (load-texture "face.png"))
  	)
    (widget-set-margin button1 10.0 20.0 0.0 20.0)
    (widget-set-margin button2 10.0 20.0 0.0 20.0)
    (widget-set-margin button3 10.0 20.0 0.0 20.0)
    (widget-set-margin img 10.0 10.0 10.0 20.0)
    (widget-add-event
     button1
     (lambda (w p t d)
       (if (= t %event-mouse-button)
	   (widget-resize p (+ (vector-ref p %w) 10) (+ (vector-ref p %h) 10)))
       ;;(printf "button1 event type ~a ~a\n" t d)
       ))

     (widget-add-event
      button2
      (lambda (w p t d)
	(if (= t %event-mouse-button)
	    (widget-resize p (- (vector-ref p %w) 10) (- (vector-ref p %h) 10)))
	;;(printf "button2 event type ~a ~a\n" t d)
	))

    
     (widget-add-draw
      button1
      (lambda (w p)
	(let ((x (vector-ref w %gx))
	      (y (vector-ref w %gy)))
	  (draw-image (+ 6.0 x) (+ y 6.0) 20.0 20.0 icon))))
     
    (widget-add p button1)
    (widget-add p button2)
    (widget-add p button3)
    (widget-add p button4)
    (widget-add p img)
   
    (widget-add p (button 120.0 30.0 "button5"))
    (widget-add p (text 120.0 30.0 "总结:喜欢很大很大的"))
    (widget-add p (edit 280.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/
QQ群：Lisp兴趣小组239401374 啊哈哈"))
    
    ))

(define (test-editor)
  (let ((p (scroll 280.0 360.0))
	(editor (edit 200.0 400.0
		      "hello，world
a
b
")))
    (widget-add p)
    (widget-add p editor))
  )

(define (test-tab)
  (let ((p (dialog 40.0 20.0 500.0 400.0 "tab窗体啦啦~"))
	(t (tab 450.0 300.0 (list "标签1" "标签2" "标签3" )))
	(tab1 (scroll 400.0 280.0)))

    (let ((button1 (button 120.0 30.0 "窗体调大"))
	  (button2 (button 120.0 30.0 "窗体调小"))
	  (button3 (button 120.0 30.0 "按钮3"))
	  (button4 (button 120.0 30.0 "按钮"))
	  (img (image 180.0 180.0 "./duck.png"))
	  (icon (image 180.0 180.0 "face.png")))

      (widget-add-event
       button1
       (lambda (w p t d)
	 (widget-resize p (+ (vector-ref p %w) 10) (+ (vector-ref p %h) 10))
	 (printf "button1 event type ~a ~a\n" t d)
	 ))

     
       (widget-add tab1 img)
       (widget-add tab1 icon)
       (widget-add tab1 button1)
       (widget-add tab1 button2)
       (widget-add tab1 button3)
       (widget-add tab1 button4)
       (widget-add tab1 (text 140.0 30.0 "文本内容"))
      )
    
    (widget-add t (edit 280.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/ 
 ;;QQ群：Lisp兴趣小组239401374 啊哈哈"))
		
    ;;(widget-add t (text 20.0 30.0 "标签2:我是内容哈啦啦啦啦"))
    (widget-add t (text 20.0 30.0 "标签3:金发拉数据大幅标"))
    (widget-add t  tab1)

    (widget-add p t)
    ))

(define (test-calc)
  (let ((d (dialog 40.0 20.0 250.0 360.0 "计算器"))
	(result (button 224.0 60.0 ""))
	(num7  (button 50.0 50.0 "7"))
	(num8  (button 50.0 50.0 "8"))
	(num9  (button 50.0 50.0 "9"))
	(num6  (button 50.0 50.0 "6"))
	(num5  (button 50.0 50.0 "5"))
	(num4  (button 50.0 50.0 "4"))
	(num3  (button 50.0 50.0 "3"))
	(num2  (button 50.0 50.0 "2"))
	(num1  (button 50.0 50.0 "1"))
	(num0  (button 110.0 50.0 "0"))
	(mul  (button 50.0 50.0 "x"))
	(sub  (button 50.0 50.0 "-"))
	(add  (button 50.0 50.0 "+"))
	(ret  (button 50.0 50.0 "="))
	(dot  (button 50.0 50.0 "."))
	)
    (let loop ((btn (list result num7 num8 num9 mul
			  num4  num5 num6 sub
			  num1 num2  num3 add
			  num0  dot ret)))
      (if (pair? btn)
	  (begin
	    (widget-set-margin (car btn) 4.0 4.0 4.0 4.0)
	    (widget-set-text-font-size (car btn) 40.0)
	    (widget-set-text-font-color (car btn) 200.0 0.0 0.0 0.8)
	    (widget-add d (car btn))
	    (loop (cdr btn))
	    )))

    )
  )

(define (test-tree)
  (let ((d (dialog 40.0 20.0 250.0 560.0 "树形控件"))
	(t (tree 200.0 2500.0 "根节点")))
    (let loop ((i 0))
      (if (< i 8)
	  (let ((v (tree  200.0 200.0  (format "节点~a\n" i)) ))
	    (widget-set-margin v 4.0 4.0 4.0 4.0)
	    (widget-add t v)
	    (let loop2 ((j 0))
	      (if (< j 3)
		  (let ((vv (tree  120.0 40.0 (format " 节点~a ~a\n" i j))))
		    ;;(widget-add v (view 120.0 40.0 (format "text ~a ~a\n" i j)))
		     (widget-add v vv)
		    (let loop3 ((k 0))
		      (if (< k 4)
			  (let ((vvv (tree  120.0 40.0 (format "  节点~a ~a ~a\n" i j k))))
			    (widget-add vv vvv )
			    (let loop4 ((l 0))
			      (if (< l 4 )
				  (let ()
				    (widget-add vvv (tree 120.0 40.0 (format "   ~a ~a ~a ~a\n" i j k l)))
				    ;;(widget-add vvv (view 0.0 40.0 (format "text ~a ~a ~a ~a\n" i j k l )))
				    ;;(widget-add vvv (button 120.0 40.0 (format "text ~a ~a ~a ~a\n" i j k l )))
				    
				    (loop4 (+ l 1)))
				    ))
			    (loop3 (+ k 1))
			    )))
		    (loop2 (+ j 1))
		    )))
	      
	    
	    (loop (+ i 1))
	    )
	  ))
    (widget-add d t)
    ))


(define (test-menu)
  (let ((d (dialog 40.0 20.0 550.0 560.0 "pop控件"))
	(t (pop 100.0 40.0 "根节点")))
    (widget-set-attrs t 'root #t)
    ;;(printf "get root status ~a\n" (widget-get-attr t %status))
    (let loop ((i 0))
      (if (< i 8)
	  (let ((v (pop  100.0 40.0  (format "节点~a\n" i)) ))
	    ;;(widget-set-margin v 4.0 4.0 4.0 4.0)
	    (widget-add t v)
	    (let loop2 ((j 0))
	      (if (< j 3)
		  (let ((vv (pop  120.0 40.0 (format " 节点~a ~a\n" i j))))
		    ;;(widget-add v (view 120.0 40.0 (format "text ~a ~a\n" i j)))
		     (widget-add v vv)
		    (let loop3 ((k 0))
		      (if (< k 4)
			  (let ((vvv (pop  120.0 40.0 (format "  节点~a ~a ~a\n" i j k))))
			    (widget-add vv vvv )
			    (let loop4 ((l 0))
			      (if (< l 4 )
				  (let ()
				    (widget-add vvv (pop 120.0 40.0 (format "   ~a ~a ~a ~a\n" i j k l)))
				    ;;(widget-add vvv (view 0.0 40.0 (format "text ~a ~a ~a ~a\n" i j k l )))
				    ;;(widget-add vvv (button 120.0 40.0 (format "text ~a ~a ~a ~a\n" i j k l )))
				    
				    (loop4 (+ l 1)))
				    ))
			    (loop3 (+ k 1))
			    )))
		    (loop2 (+ j 1))
		    )))
	      
	    
	    (loop (+ i 1))
	    )
	  ))
    (widget-add d t)
    (widget-add  t)
    ))

(define (test-draw-string)
  (let ((font (graphic-get-font "Roboto-Regular.ttf"))
	)
    (graphic-draw-string font 40.0 #xffff0000 200.0 100.0 "鸭子gui")
  ))


;;(load-librarys "foo")
;;(def-function print-array "print_array" (void* int) void)

(define (render-color-string colored)
  (let ((font (graphic-get-font "Roboto-Regular.ttf"))
	(col (car colored))
	(count (cadr colored)))
    ;;(printf "#######>>>>~a\n\n\n" colored)
    (graphic-draw-string-prepare font)
    (let loop ((i 0)
	       (it (vector-ref col 0))
	       (x 10.0)
	       (y 10.0))
      (if (< i count)
	  (let ((ret (graphic-draw-string font 40.0 (cdr it)  x y (car it) ) )) ;;
	    ;;(printf "==>~a ~a\n" ret (car it))
	    ;;(printf "==>~a\n" (cdr it))
	    (set! x (car ret))
	    (if (or (> x 600.0) (string=? (car it) "\r") )
	    	(begin
	    	  (set! x 10.0)
	    	  (set! y (+ y 40.0))))
	    (loop (+ i 1) (vector-ref col (+ i 1))  x y ))
	  )
      )
    (graphic-draw-string-end font)
    ))


(define (render-gui-view2 text)
  (let ((colored (parse-syntax (cffi-alloc (* 64 (string-length text))) text))
	(font (graphic-get-font "Roboto-Regular.ttf"))
	(panel (view %match-parent %match-parent))
	  )
    (printf "parse end\n")
    ;;(printf "addr ~x\n" colored)
    ;;(print-array colored (string-length text))

    ;;(printf "~a\n" colored)
      ;;(render-color-string colored)
      (widget-add-draw
       panel
       (lambda (w p)
      	 ;; (let ((font (graphic-get-font "Roboto-Regular.ttf")))
      	 ;;   ;;(printf "render\n")
	 (graphic-draw-string-prepare font)
      	 (graphic-draw-string-colors font 38.0  10.0 10.0 text colored  800.0)
	 (graphic-draw-string-end font)
       ))
      (widget-add panel)
      ;;(cffi-free colored)
      ))


(define (render-gui-view text)
   (let ((colored (parse-syntax2 text))
	  (panel (view %match-parent %match-parent))
	  )
      (printf "parse end\n")
    ;;(printf "~a\n" colored)
      ;;(render-color-string colored)
      (widget-add-draw
       panel
       (lambda (w p)
      	 ;; (let ((font (graphic-get-font "Roboto-Regular.ttf")))
      	 ;;   ;;(printf "render\n")
      	 ;;   (graphic-draw-string font 38.0 #xffff0000 200.0 100.0 text))
      	 (render-color-string colored)
       ))
      (widget-add panel)
      
      ))

(define (test-parser)
  (init-syntax)
  (let ((text (readlines "http-test.ss")));;
    ;;(let ((text (readlines "/Users/evil/dev/ChezScheme/s/cpnanopass.ss"))) ;;cp0
    ;;(printf "~a\n" text)
    (printf  "read end\n")
    (render-gui-view2 text)
    
    (time (parse-syntax2 text))
    (printf "parse end\n")

    ))

(define (duck-test)
  (set! window (window-create width height "鸭子gui"))
  (window-set-fps-pos 750.0 0.0)
  ;;(window-set-fps-pos  0.0  0.0)
  (window-show-fps #t)
  
  ;;widget add here
  ;;(test-scroll)
  ;;(test-multi-dialog)
  (test-multi-widget)
  (test-video)
  ;;(test-online-video)
  
  ;;(test-editor)

  ;;(test-tab)
  ;;(test-calc)
  ;;(test-tree)
  ;;(test-menu)
  ;;(test-mobile-ui)

  ;;(window-add-loop
  ;;(lambda ()
  ;;(test-draw-string)
  ;;   ))
  
  ;;run
  (window-loop window)
  (window-destroy window)
  )

(duck-test)


