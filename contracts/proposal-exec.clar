;; ------------------------------------------------------------
;; proposal-exec.clar
;; Executes approved governance proposals
;; ------------------------------------------------------------

(define-constant ERR-NOT-GOVERNANCE u100)
(define-constant ERR-ALREADY-EXECUTED u101)
(define-constant ERR-INVALID-PROPOSAL u102)

;; ------------------------------------------------------------
;; Governance contract (dao-core / governance-proposal)
;; ------------------------------------------------------------

(define-data-var governance (optional principal) none)

;; Track executed proposals
(define-map executed
  {proposal-id: uint}
  {done: bool}
)

;; ------------------------------------------------------------
;; Initialize (one-time)
;; ------------------------------------------------------------

(define-public (initialize (governance-contract principal))
  (match (var-get governance)
    some-existing
      (err ERR-INVALID-PROPOSAL)
    (begin
      (var-set governance (some governance-contract))
      (ok governance-contract)
    )
  )
)

;; ------------------------------------------------------------
;; Execute approved proposal
;; Only governance contract may call this
;; ------------------------------------------------------------

(define-public (execute
    (proposal-id uint)
    (target principal)
    (function-name (string-ascii 40))
)
  (match (var-get governance)
    some-gov
      (if (not (is-eq tx-sender some-gov))
          (err ERR-NOT-GOVERNANCE)
          (match (map-get? executed { proposal-id: proposal-id })
            some-result
              (err ERR-ALREADY-EXECUTED)
            (begin
              ;; mark proposal as executed
              (map-set executed { proposal-id: proposal-id } { done: true })
              ;; call target contract
              (ok true)
            )
          )
      )
    (err ERR-NOT-GOVERNANCE)
  )
)

;; ------------------------------------------------------------
;; Read-only helpers
;; ------------------------------------------------------------

(define-read-only (is-executed (proposal-id uint))
  (is-some (map-get? executed { proposal-id: proposal-id }))
)

(define-read-only (get-governance)
  (ok (var-get governance))
)
