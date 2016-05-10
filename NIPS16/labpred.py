''' Checks whether a set of constraints makes the objective
    observable.
    
    Let p(i,j,k) = P( y^1=i, y^2 = j, y = k ).
    The program below checks whether a set of constraints
    makes gamma = P( y^1\ne y ) - P( y^2 \ne y ) 
    = p(1,0,0)-p(0,1,0) + p(0,1,1) - p(1,0,1)
    observable.
    
    The constraints are:
    (new) y^2 = 0 ==> y^1 = 0, i.e., p(1,0,0)= p(1,0,1) = 0
    (dominance) y^1 = y ==> Y^2 = y, i.e., p(0,1,0)=p(1,0,1)=0
    
    Observed quantities: p( i,j, 0 ) + p(i,j, 1 ), for 0<=i,j<=1
    
    As it turns out the new constraint renders gamma unobservable,
    while the dominance constraint renders it observable.
'''
import numpy as np

def ix( i,j,k ):
   return k+2*j+4*i

nvar = ix(1,1,1)+1
A = np.zeros( (0, nvar ) )

# probabilities sum to one
newrow = np.ones( (1,nvar) )
A = np.vstack( [A, newrow] )

# observed probabilities
for i in range(2):
   for j in range(2):
      newrow = np.zeros( (1,nvar) )
      newrow[0,ix(i,j,0)] = 1
      newrow[0,ix(i,j,1)] = 1
      A = np.vstack( [A, newrow] )

# constraints
cond = 1 # type of constraints; possible values 0 (new cond) or 1 (dominance)
newrow = np.zeros( (1,nvar) )
if cond==0:
   newrow[0, ix(1,0,0) ] = 1
else:
   newrow[0, ix(0,1,0) ] = 1
A = np.vstack( [A, newrow] )

newrow = np.zeros( (1,nvar) )
if cond==0:
   newrow[0, ix(1,0,1) ] = 1
else:
   newrow[0, ix(1,0,1) ] = 1
A = np.vstack( [A, newrow] )


# symmetric noise?
symm = True
if symm:
    newrow = np.zeros( (1,nvar) )
    # P( y^1 \ne y | y=0 ) = P( y^1 \ne y | y=1 )
    # <==>
    # P( y^1 \ne y, y=0 ) P( y=1 ) = P( y^1 \ne y, y=1 ) P( y=0 )
    # <==>
    # P( y^1=1, y=0 ) P( y=1 ) = P( y^1=0, y=1 ) P( y=0 )
    # hmm, nonlinear constraint..
    pass

# gamma
c = np.zeros( (nvar,1) )

c[ ix(0,1,0),0 ] = -1
c[ ix(1,0,1),0 ] = -1

c[ ix(1,0,0),0 ] = 1
c[ ix(0,1,1),0 ] = 1

print(A)

print( np.shape(np.dot(A,A.T)) )
print( np.shape(c) )

x,r,rank,s = np.linalg.lstsq( np.dot(A,A.T), A.dot(c) )

print("rank",rank)

print( "x", x) 
res =  np.linalg.norm(A.T.dot( x )-c)
print( "soln-residual", res )

print( "Condition: "
       "New condition" if cond==0 else "Dominance condition" )
if res<=1E-10:
   print( "System identifiable" )
else:
   print( "System unidentifiable" )
