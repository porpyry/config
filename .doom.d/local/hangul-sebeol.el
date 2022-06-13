;;; hangul-sebeol.el --- Korean Hangul input method

;; Customized By: porpyry@gmail.com
;; Original Author: Taegil Bae <esrevinu@gmail.com>
;; Original Link: https://github.com/demokritos/hangul-s3p2
;; Keywords: multilingual, input method, Korean, Hangul, Shin Se-beol P2

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; 1. removed symbols
;; 2. changed special characters
;; 3. changed jung, jong keys
;; 4. changed double cho, jung, jong keys
;; 5. removed pureosseugi

;;; Code:

(require 'hangul "quail/hangul")

;; ! " # $ % & ' ( ) * + , - . /
;; 0 1 2 3 4 5 6 7 8 9
;; : ; < = > ? @
;; A B C D E F G H I J K L M N O P
;; Q R S T U V W X Y Z
;; [ \ ] ^ _ `
;; a b c d e f g h i j k l m n o p
;; q r s t u v w x y z
;; { | } ~
(defconst hangul-sebeol-basic-keymap
  [ ?! ?/ ?# ?$ ?% ?& ?ㅌ ?\( ?\) ?* ?+ ?, ?- ?. ?ㅋ
    ?0 ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9
    ?: ?ㅂ ?< ?= ?> ?? ?@
    ?ㅑ ?ㅜ ?ㅔ ?ㅣ ?ㅕ ?ㅏ ?ㅡ ?※ ?↑ ?' ?\" ?· ?〉 ?〈 ?→ ?\;
    ?ㅒ ?ㅐ ?ㅢ ?ㅓ ?↓ ?ㅗ ?ㅖ ?ㅛ ?← ?ㅠ
    ?\[ ?\\ ?\] ?^ ?_ ?`
    [?ㄹ ?ㅑ] [?ㅋ ?ㅜ] [?ㅁ ?ㅔ] [?ㅇ ?ㅣ] [?ㅂ ?ㅕ] [?ㅌ ?ㅏ] [?ㄷ ?ㅡ] ?ㄴ ?ㅁ ?ㅇ ?ㄱ ?ㅈ ?ㅎ ?ㅅ ?ㅊ ?ㅍ
    [?ㅅ ?ㅒ] [?ㅈ ?ㅐ] [?ㄴ ?ㅢ] [?ㅍ ?ㅓ] ?ㄷ [?ㅊ ?ㅗ] [?ㅆ ?ㅖ] [?ㄱ ?ㅛ] ?ㄹ [?ㅎ ?ㅠ]
    ?{ ?| ?} ?~ ])

(defvar hangul-gyeob-mo nil)

;; 1  2  3  4  5  6  7  8  9  10
;; ㄱ ㄲ  ㄳ ㄴ  ㄵ ㄶ  ㄷ ㄸ  ㄹ ㄺ
;; ㄻ ㄼ  ㄽ ㄾ  ㄿ ㅀ  ㅁ ㅂ  ㅃ ㅄ
;; ㅅ ㅆ  ㅇ ㅈ  ㅉ ㅊ  ㅋ ㅌ  ㅍ ㅎ
(defconst hangul-djamo-table
  '((cho . ((1 . [23])   ; ㄱ) ㅇ-ㄲ
            (7 . [17])   ; ㄷ) ㅁ-ㄸ
            (18 . [24])  ; ㅂ) ㅈ-ㅃ
            (21 . [1])   ; ㅅ) ㄱ-ㅆ
            (24 . [1]))) ; ㅈ) ㄱ-ㅉ
    (jung . ((39 . [31 32 51])
             (44 . [35 36 51])
             (49 . [51])
             (93 . [35 44 51 93]))) ; arae-a + eo, u, i, arae-a
    (jong . ((1 . [30 17])               ; ㄱ) ㅎ-ㄲ ㅁ-ㄳ
             (4 . [24 9])                ; ㄴ) ㅈ-ㄵ ㄹ-ㄶ
             (9 . [4 23 18 24 28 29 22]) ; ㄹ) ㄴ-ㄺ ㅇ-ㄻ ㅂ-ㄼ ㅈ-ㄽ ㅌ-ㄾ ㅍ-ㄿ ㅆ-ㅀ
             (18 . [-1 22])              ; ㅂ) X-ㅃ ㅆ-ㅄ
             (21 . [-1])))))             ; ㅅ) X-ㅆ

(defconst hangul-yed-jamo-table
  (let ((table (make-char-table 'trans-yojeum-yed 0))
        (cho [ ?ㄱ ?ㄲ ?ㄴ ?ㄷ ?ㄸ ?ㄹ ?ㅁ ?ㅂ ?ㅃ ?ㅅ ?ㅆ
                   ?ㅇ ?ㅈ ?ㅉ ?ㅊ ?ㅋ ?ㅌ ?ㅍ ?ㅎ ])
        (jong [ ?ㄱ ?ㄲ ?ㄳ ?ㄴ ?ㄵ ?ㄶ ?ㄷ ?ㄹ ?ㄺ ?ㄻ ?ㄼ ?ㄽ ?ㄾ ?ㄿ ?ㅀ
                    ?ㅁ ?ㅂ ?ㅄ ?ㅅ ?ㅆ ?ㅇ ?ㅈ ?ㅊ ?ㅋ ?ㅌ ?ㅍ ?ㅎ ])
        (i 0))
    (while (< i (length cho))
      (aset table (aref cho i) (+ #x1100 i))
      (setq i (1+ i)))
    (setq i 0)
    (while (< i 21)
      (aset table (+ ?ㅏ i) (+ #x1161 i))
      (setq i (1+ i)))
    (setq i 0)
    (while (< i 5)
      (aset table (+ ?ㆍ i) (+ #x119E i))
      (setq i (1+ i)))
    (setq i 0)
    (while (< i (length jong))
      (aset table (+ #x100 (aref jong i)) (+ #x11A8 i))
      (setq i (1+ i)))
    table))

(defsubst jamo-offset (char)
  (- char ?ㄱ -1))

(defun yed-hangul-character (cho jung jong)
  (if (and (> cho #x3130) (<= cho ?ㅎ))
      (setq cho (aref hangul-yed-jamo-table cho)))
  (if (and (> jung #x3130) (<= jung (+ ?ㆍ 4)))
      (setq jung (aref hangul-yed-jamo-table jung)))
  (if (and (> jong #x3130) (<= jong ?ㅎ))
      (setq jong (aref hangul-yed-jamo-table (+ #x100 jong))))
  (if (and (/= cho 0) (/= jung 0))
      (if (= jong 0)
          (string cho jung)
        (string cho jung jong))
    (if (/= cho 0)
        (if (= jong 0)
            (string cho #x1160)
          (string cho #x1160 jong))
      (if (/= jung 0)
          (if (= jong 0)
              (string #x115F jung)
            (string #x115F jung jong))
        (if (/= jong 0)
            (string #x115F #x1160 jong)
          "")))))

(defun compose-hangul-character (queue)
  (let ((cho (+ (aref queue 0) (hangul-djamo 'cho (aref queue 0) (aref queue 1))))
        (jung (+ (aref queue 2) (hangul-djamo 'jung (aref queue 2) (aref queue 3))))
        (jong (+ (aref queue 4) (hangul-djamo 'jong (aref queue 4) (aref queue 5)))))
    (if (and (= (aref queue 2) (jamo-offset ?ㆍ))
             (or (notzerop (aref queue 0)) (notzerop (aref queue 4))
                 (notzerop (aref queue 3))))
        (yed-hangul-character (if (= cho 0) cho (+ #x3130 cho))
                              (if (= jung 0) jung (+ #x3130 jung))
                              (if (= jong 0) jong (+ #x3130 jong)))
      (let ((syllable (hangul-character cho jung jong)))
        (if (eq syllable "")
            ""
          (string syllable))))))

(defun hangul-insert-character (&rest queues)
  (if (and mark-active transient-mark-mode)
      (progn
        (delete-region (region-beginning) (region-end))
        (deactivate-mark)))
  (quail-delete-region)
  (let* ((first (car queues))
         (syllables (compose-hangul-character first))
         (move (length syllables)))
    (insert syllables)
    (move-overlay quail-overlay (overlay-start quail-overlay) (point))
    (dolist (queue (cdr queues))
      (setq syllables (compose-hangul-character queue))
      (insert syllables)
      (move-overlay quail-overlay
                    (+ (overlay-start quail-overlay) move) (point))
      (setq move (length syllables)))))

(defun hangul-sebeol-input-method-internal (key)
  (let ((char (aref hangul-sebeol-basic-keymap (- key 33))))
    (if (vectorp char)
        (let ((jaeum (aref char 0)) (moeum (aref char 1)))
          (if (or (and hangul-gyeob-mo
                       (notzerop (aref hangul-queue 2))
                       (zerop (aref hangul-queue 3))
                       (notzerop (hangul-djamo 'jung
                                               (aref hangul-queue 2)
                                               (jamo-offset moeum))))
                  (and (notzerop (aref hangul-queue 0))
                       (zerop (aref hangul-queue 2))))
              (progn
                (if (zerop (aref hangul-queue 2))
                    (setq hangul-gyeob-mo nil))
                (hangul3-input-method-jung (jamo-offset moeum)))
            (hangul3-input-method-jong (jamo-offset jaeum))))
      (if (or (and (>= char ?ㅏ) (<= char ?ㅣ)) (= char ?ㆍ))
          (progn
            (if (zerop (aref hangul-queue 2))
                (setq hangul-gyeob-mo nil))
            (hangul3-input-method-jung (jamo-offset char)))
        (if (and (>= char ?ㄱ) (<= char ?ㅎ))
            (if (and (notzerop (aref hangul-queue 0))
                       (zerop (aref hangul-queue 2))
                       (setq hangul-gyeob-mo (cdr (assq char '((?ㅂ . ?ㅗ) (?ㅊ . ?ㅜ) ; ㅗ1, ㅜ1
                                                               (?ㅎ . ?ㅗ) (?ㄷ . ?ㅜ) ; ㅗ2, ㅜ2
                                                              )))))
                  (hangul3-input-method-jung (jamo-offset hangul-gyeob-mo))
                (setq hangul-gyeob-mo nil)
                (hangul3-input-method-cho (jamo-offset char)))
          (setq hangul-queue (make-vector 6 0))
          (setq hangul-gyeob-mo nil)
          (insert (decode-char 'ucs char))
          (move-overlay quail-overlay (point) (point)))))))

(defun hangul-sebeol-input-method (key)
  (if (or buffer-read-only (< key 33) (>= key 127))
      (list key)
    (quail-setup-overlays nil)
    (let ((input-method-function nil)
          (echo-keystrokes 0)
          (help-char nil))
      (setq hangul-queue (make-vector 6 0))
      (hangul-sebeol-input-method-internal key)
      (unwind-protect
          (catch 'exit-input-loop
            (while t
              (let* ((seq (read-key-sequence nil))
                     (cmd (lookup-key hangul-im-keymap seq))
                     key)
                (cond ((and (stringp seq)
                            (= 1 (length seq))
                            (setq key (aref seq 0))
                            (and (>= key 33) (< key 127)))
                       (hangul-sebeol-input-method-internal key))
                      ((commandp cmd)
                       (call-interactively cmd))
                      (t
                       (setq hangul-gyeob-mo nil)
                       (setq unread-command-events
                             (nconc (listify-key-sequence seq)
                                    unread-command-events))
                       (throw 'exit-input-loop nil))))))
        (quail-delete-overlays)))))

(defsubst symbol+ (&rest syms)
  (intern (mapconcat 'symbol-name syms "")))

(defmacro hangul-register-input-method (package-name language input-method-func
                                                     package-title package-description
                                                     package-help)
  (let ((activate-func (symbol+ input-method-func '-activate))
        (inactivate-func (symbol+ input-method-func '-inactivate))
        (help-func (symbol+ input-method-func '-help)))
    `(progn
       (defun ,activate-func (&optional arg)
         (if (and arg
                  (< (prefix-numeric-value arg) 0))
             (unwind-protect
                 (progn
                   (quail-hide-guidance)
                   (quail-delete-overlays)
                   (setq describe-current-input-method-function nil))
               (kill-local-variable 'input-method-function))
           (setq inactivate-current-input-method-function ',inactivate-func)
           (setq describe-current-input-method-function ',help-func)
           (quail-delete-overlays)
           (if (eq (selected-window) (minibuffer-window))
               (add-hook 'minibuffer-exit-hook 'quail-exit-from-minibuffer))
           (set (make-local-variable 'input-method-function)
                ',input-method-func)))
       (defun ,inactivate-func ()
         (interactive)
         (,activate-func -1))
       (defun ,help-func ()
         (interactive)
         (with-output-to-temp-buffer "*Help*"
           (princ ,package-help)))
       (register-input-method ,package-name
                              ,language
                              ',activate-func
                              ,package-title
                              ,package-description))))

(hangul-register-input-method
 "korean-hangul-sebeol"
 "UTF-8"
 hangul-sebeol-input-method
 "Korean"
 "Hangul Custom Shin-Sebeol Input Method"
 "Input method: korean-hangul-sebeol (mode line indicator:Korean)\n\nHangul Custom Shin-Sebeol Input Method")

(provide 'hangul-sebeol)

;;; hangul-sebeol.el ends here
