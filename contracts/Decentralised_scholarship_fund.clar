;; Decentralized Scholarship Fund
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

;; Fungible Token for donations
(define-fungible-token scholarship-token)

;; Data Maps
(define-map donors { donor: principal } { total-donated: uint })
(define-map applicants { student: principal } { status: (string-ascii 10), amount-requested: uint, reason: (string-utf8 500) })

;; Variables
(define-data-var total-scholarship-fund uint u0)
(define-data-var owner principal tx-sender)

;; Private Function to Check Owner
(define-private (is-owner)
  (is-eq tx-sender (var-get owner))
)

;; Private Function to Safely Add Uint
(define-private (safe-add (a uint) (b uint))
  (let ((result (+ a b)))
    (if (< result a)
      err-arithmetic-error
      (ok result))
  )
)

;; Private Function to Validate Amount
(define-private (validate-amount (amount uint))
  (> amount u0)
)

;; Private Function to Validate Reason
(define-private (validate-reason (reason (string-utf8 500)))
  (and (> (len reason) u0) (<= (len reason) u500))
)

;; Private Function to Validate Principal
(define-private (validate-principal (principal-input principal))
  ;; Simple check to ensure the principal is valid
  (is-eq principal-input principal-input)
)

;; Public Function: Donate to Scholarship Fund
(define-public (donate (amount uint))
  (begin
    (asserts! (validate-amount amount) err-invalid-amount)
    (try! (ft-transfer? scholarship-token amount tx-sender (var-get owner)))
    (let ((existing-donation (map-get? donors { donor: tx-sender })))
      (if (is-some existing-donation)
        (let (
          (donation-data (unwrap-panic existing-donation))
          (new-total (try! (safe-add (get total-donated donation-data) amount)))
        )
          (map-set donors 
            { donor: tx-sender } 
            { total-donated: new-total }))
        (map-set donors { donor: tx-sender } { total-donated: amount })))
    (let ((new-fund (try! (safe-add (var-get total-scholarship-fund) amount))))
      (var-set total-scholarship-fund new-fund)
      (ok true))
  )
)

;; Public Function: Apply for Scholarship
(define-public (apply-scholarship (amount-requested uint) (reason (string-utf8 500)))
  (begin
    (asserts! (validate-amount amount-requested) err-invalid-amount)
    (asserts! (validate-reason reason) err-invalid-reason)
    ;; Ensure application is not closed
    (asserts! (> (var-get total-scholarship-fund) u0) err-application-closed)
    ;; Check if the applicant has already applied
    (let ((existing-application (map-get? applicants { student: tx-sender })))
      (asserts! (is-none existing-application) err-already-applied)
      ;; Apply for scholarship
      (map-set applicants 
        { student: tx-sender } 
        { status: "pending", amount-requested: amount-requested, reason: reason })
      (ok true)
    )
  )
)