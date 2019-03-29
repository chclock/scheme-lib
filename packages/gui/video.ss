;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;作者:evilbinary on 11/19/16.
;;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(library (gui video)
  (export
   video-new
   video-render
   video-destroy
   video-get-fps
   video-set-pause
   video-get-duration
   video-get-current-duration
   )

  (import (scheme) (utils libutil) (cffi cffi) (gles gles2) )
  (load-librarys "libvideo")

  (def-function video-new "video_new" (void* float float) void*)
  (def-function video-render "video_render" (void* float float float float) void)
  (def-function video-destroy "video_destroy" (void*) void)
  (def-function video-get-fps "video_get_fps" (void*) int)
  (def-function video-set-pause "video_set_pause" (void* int) void)
  (def-function video-get-duration "video_get_duration" (void*) double)
  (def-function video-get-current-duration "video_get_current_duration" (void*) double)

  


  )
