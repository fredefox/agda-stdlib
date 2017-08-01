------------------------------------------------------------------------
-- The Agda standard library
--
-- Environments (heterogeneous collections)
------------------------------------------------------------------------

{-# OPTIONS --safe #-}


module Safe.Data.Star.Environment (Ty : Set) where

open import Safe.Data.Star
open import Safe.Data.Star.List
open import Safe.Data.Star.Decoration
open import Safe.Data.Star.Pointer as Pointer hiding (lookup)
open import Safe.Data.Unit
open import Safe.Relation.Binary.PropositionalEquality

-- Contexts, listing the types of all the elements in an environment.

Ctxt : Set
Ctxt = List Ty

-- Variables (de Bruijn indices); pointers into environments.

infix 4 _∋_

_∋_ : Ctxt → Ty → Set
Γ ∋ σ = Any (λ _ → ⊤) (_≡_ σ) Γ

vz : ∀ {Γ σ} → Γ ▻ σ ∋ σ
vz = this refl

vs : ∀ {Γ σ τ} → Γ ∋ τ → Γ ▻ σ ∋ τ
vs = that tt

-- Environments. The T function maps types to element types.

Env : (Ty → Set) → Ctxt → Set
Env T Γ = All T Γ

-- A safe lookup function for environments.

lookup : ∀ {Γ σ} {T : Ty → Set} → Γ ∋ σ → Env T Γ → T σ
lookup i ρ with Pointer.lookup i ρ
... | result refl x = x
