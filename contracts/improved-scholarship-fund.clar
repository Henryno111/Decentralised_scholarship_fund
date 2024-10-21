;; Constants
(define-constant err-not-owner (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-applied (err u102))
(define-constant err-insufficient-funds (err u103))
(define-constant err-application-closed (err u104))
(define-constant err-arithmetic-error (err u105))
(define-constant err-invalid-amount (err u106))
(define-constant err-invalid-reason (err u107))
(define-constant err-invalid-principal (err u108))
(define-constant err-invalid-category (err u109))
(define-constant err-invalid-date (err u110))
(define-constant err-past-deadline (err u111))
(define-constant err-invalid-score (err u112))
(define-constant err-invalid-round (err u113))
(define-constant err-student-not-applied (err u114))

;; Variables
(define-data-var current-round-id uint u0)
(define-data-var owner principal tx-sender)

;; Data Maps
(define-map scholarship-rounds 
  { round-id: uint } 
  { 
    start-date: uint, 
    end-date: uint, 
    total-fund: uint, 
    status: (string-ascii 10) 
  }
)
(define-map application-scores 
  { round-id: uint, student: principal } 
  { score: uint }
)
(define-map applicants 
  { student: principal } 
  { 
    status: (string-ascii 10), 
    amount-requested: uint, 
    reason: (string-utf8 500) 
  }
)

;; Private Functions
(define-private (is-owner)
  (is-eq tx-sender (var-get owner))
)

(define-private (is-valid-round (round-id uint))
  (is-some (map-get? scholarship-rounds { round-id: round-id }))
)

(define-private (has-student-applied (student principal))
  (is-some (map-get? applicants { student: student }))
)

(define-public (create-scholarship-round (start-date uint) (end-date uint) (initial-fund uint))
  (begin
    (asserts! (is-owner) err-not-owner)
    (asserts! (and (> start-date block-height) (> end-date start-date)) err-invalid-date)
    (asserts! (> initial-fund u0) err-invalid-amount)
    (let
      (
        (new-round-id (+ (var-get current-round-id) u1))
      )
      (try! (stx-transfer? initial-fund tx-sender (as-contract tx-sender)))
      
      (map-set scholarship-rounds
        { round-id: new-round-id }
        { start-date: start-date, end-date: end-date, total-fund: initial-fund, status: "active" }
      )
      (var-set current-round-id new-round-id)
      (ok new-round-id)
    )
  )
)