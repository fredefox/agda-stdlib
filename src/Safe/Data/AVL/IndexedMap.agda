------------------------------------------------------------------------
-- The Agda standard library
--
-- Finite maps with indexed keys and values, based on AVL trees
------------------------------------------------------------------------

{-# OPTIONS --safe #-}



open import Safe.Data.Product as Prod
open import Safe.Relation.Binary
open import Safe.Relation.Binary.PropositionalEquality using (_≡_)
module Safe.Data.AVL.IndexedMap
  {i k v ℓ}
  {Index : Set i} {Key : Index → Set k} (Value : Index → Set v)
  {_<_ : Rel (∃ Key) ℓ}
  (isStrictTotalOrder : IsStrictTotalOrder _≡_ _<_)
  where

import Safe.Data.AVL
open import Safe.Data.Bool
open import Safe.Data.List.Base as List using (List)
open import Safe.Data.Maybe.Base as Maybe
open import Safe.Function
open import Safe.Level

-- Key/value pairs.

KV : Set (i ⊔ k ⊔ v)
KV = ∃ λ i → Key i × Value i

-- Conversions.

private

  fromKV : KV → Σ[ ik ∈ ∃ Key ] Value (proj₁ ik)
  fromKV (i , k , v) = ((i , k) , v)

  toKV : Σ[ ik ∈ ∃ Key ] Value (proj₁ ik) → KV
  toKV ((i , k) , v) = (i , k , v)

-- The map type.

private
  open module AVL =
    Safe.Data.AVL (λ ik → Value (proj₁ ik)) isStrictTotalOrder
    public using () renaming (Tree to Map)

-- Repackaged functions.

empty : Map
empty = AVL.empty

singleton : ∀ {i} → Key i → Value i → Map
singleton k v = AVL.singleton (, k) v

insert : ∀ {i} → Key i → Value i → Map → Map
insert k v = AVL.insert (, k) v

delete : ∀ {i} → Key i → Map → Map
delete k = AVL.delete (, k)

lookup : ∀ {i} → Key i → Map → Maybe (Value i)
lookup k m = AVL.lookup (, k) m

infix 4 _∈?_

_∈?_ : ∀ {i} → Key i → Map → Bool
_∈?_ k = AVL._∈?_ (, k)

headTail : Map → Maybe (KV × Map)
headTail m = Maybe.map (Prod.map toKV id) (AVL.headTail m)

initLast : Map → Maybe (Map × KV)
initLast m = Maybe.map (Prod.map id toKV) (AVL.initLast m)

fromList : List KV → Map
fromList = AVL.fromList ∘ List.map fromKV

toList : Map → List KV
toList = List.map toKV ∘ AVL.toList
