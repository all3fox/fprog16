module Aufgabe7 where

data Tree a = Nil | Node a Int (Tree a) (Tree a) deriving (Eq,Ord,Show)

type Multiset a = Tree a

data ThreeValuedBool = TT | FF | Invalid deriving (Eq,Show)
data Order           = Up | Down deriving (Eq,Show)

isMultiset :: Ord a => Tree a -> Bool
isMultiset Nil = True
isMultiset (Node x i l r) =
  if i < 0 then False else isMultisetL l x && isMultisetR r x

isMultisetL :: Ord a => Tree a -> a -> Bool
isMultisetL Nil _ = True
isMultisetL (Node x i l r) y
  | i < 0 || x >= y = False
  | otherwise = isMultisetL l x && isMultisetLR r x y

isMultisetR :: Ord a => Tree a -> a -> Bool
isMultisetR Nil _ = True
isMultisetR (Node x i l r) y
  | i < 0 || x <= y = False
  | otherwise = isMultisetRL l x y && isMultisetR r x

isMultisetLR :: Ord a => Tree a -> a -> a -> Bool
isMultisetLR Nil _ _ = True
isMultisetLR (Node x i l r) y z
  | i < 0 || x <= y || x >= z = False
  | otherwise = isMultisetRL l x y && isMultisetR r x

isMultisetRL :: Ord a => Tree a -> a -> a -> Bool
isMultisetRL Nil _ _ = True
isMultisetRL (Node x i l r) y z
  | i < 0 || x >= y || x <= z = False
  | otherwise = isMultisetL l x && isMultisetLR r x y

isCanonicalMultiset :: Ord a => Tree a -> Bool
isCanonicalMultiset Nil = True
isCanonicalMultiset (Node x i l r) =
  if i <= 0 then False else isCanonicalMultisetL l x && isCanonicalMultisetR r x

isCanonicalMultisetL :: Ord a => Tree a -> a -> Bool
isCanonicalMultisetL Nil _ = True
isCanonicalMultisetL (Node x i l r) y
  | i <= 0 || x >= y = False
  | otherwise = isCanonicalMultisetL l x && isCanonicalMultisetLR r x y

isCanonicalMultisetR :: Ord a => Tree a -> a -> Bool
isCanonicalMultisetR Nil _ = True
isCanonicalMultisetR (Node x i l r) y
  | i <= 0 || x <= y = False
  | otherwise = isCanonicalMultisetRL l x y && isCanonicalMultisetR r x

isCanonicalMultisetLR :: Ord a => Tree a -> a -> a -> Bool
isCanonicalMultisetLR Nil _ _ = True
isCanonicalMultisetLR (Node x i l r) y z
  | i <= 0 || x <= y || x >= z = False
  | otherwise = isCanonicalMultisetRL l x y && isCanonicalMultisetR r x

isCanonicalMultisetRL :: Ord a => Tree a -> a -> a -> Bool
isCanonicalMultisetRL Nil _ _ = True
isCanonicalMultisetRL (Node x i l r) y z
  | i <= 0 || x >= y || x <= z = False
  | otherwise = isCanonicalMultisetL l x && isCanonicalMultisetLR r x y

insert :: Ord a => Multiset a -> a -> Int -> Multiset a
insert Nil x i = Node x i Nil Nil
insert (Node x i l r) y j
  | y == x    = Node x (i + j) l              r
  | y <  x    = Node x i       (insert l y j) r
  | y >  x    = Node x i       l              (insert r y j)
  | otherwise = error "Fix insert"

captox :: (Ord a, Show a) => Int -> Multiset a -> Multiset a
captox x Nil = Nil
captox x (Node v i l r) = if i < x
  then Node v x (captox x l) (captox x r)
  else Node v i (captox x l) (captox x r)

mkMultiset :: (Ord a, Show a) => Tree a -> Multiset a
mkMultiset tree = captox 0 $ mkMultiset' tree Nil

mkMultiset' :: (Ord a, Show a) => Tree a -> Multiset a -> Multiset a
mkMultiset' Nil mset = mset
mkMultiset' (Node x i l r) mset =
  let lset = mkMultiset' l mset in
    let rset = mkMultiset' r lset in
      insert rset x i

mkCanonicalMultiset :: (Ord a, Show a) => Tree a -> Multiset a
mkCanonicalMultiset tree = captox 1 $ mkMultiset' tree Nil

bigtree0 :: Tree Integer
bigtree0 = (
  Node 128 1 (
      Node 32 1 (Node 16 1 Nil Nil) (Node 64 1 Nil Nil)
      ) (
      Node 512 1 (Node 256 1 Nil Nil) (Node 1024 1 Nil Nil)
      )
  )

bigtree1 :: Tree Integer
bigtree1 = (Node 2048 (-1) bigtree0 bigtree0)
