## Linear Algebra

[elm-community/linear-algebra](http://package.elm-lang.org/packages/elm-community/linear-algebra/latest)

Note:


---

### Vectors

<div class="group">
    <figure>
    ![](images/vectors.png)
    </figure>
    <figure>
    \\[ \bar{v} = \begin{pmatrix} \color{pink}x \\\\ \color{lightgreen}y \\\\ \color{lightblue}z \\\\ \color{violet}1 \end{pmatrix} \\]
    </figure>
</div>

```elm
type Vec4
-- Four dimensional vector type

vec4 : Float -> Float -> Float -> Float -> Vec4
-- Creates a new 4-element vector with the given x, y, z, and w values.
```

Note:


---

### Matrices

<div class="group">
    <figure>
    \\[ S = \begin{bmatrix} \color{pink}{S_1} & \color{pink}0 & \color{pink}0 & \color{pink}0 \\\\ \color{lightgreen}0 & \color{lightgreen}{S_2} & \color{lightgreen}0 & \color{lightgreen}0 \\\\ \color{lightblue}0 & \color{lightblue}0 & \color{lightblue}{S_3} & \color{lightblue}0 \\\\ \color{violet}0 & \color{violet}0 & \color{violet}0 & \color{violet}1 \end{bmatrix} \\]
    </figure>
</div>

```elm
type Mat4
-- 4x4 matrix type

makeFromList : List Float -> Maybe Mat4
-- Creates a matrix from a list of elements. Returns Nothing if the length of the list is not exactly 16 (4x4).
```

Note:


---

### Transformations

<div class="group">
    <figure>
    \\[\begin{bmatrix} \color{pink}{S_1} & \color{pink}0 & \color{pink}0 & \color{pink}0 \\\\ \color{lightgreen}0 & \color{lightgreen}{S_2} & \color{lightgreen}0 & \color{lightgreen}0 \\\\ \color{lightblue}0 & \color{lightblue}0 & \color{lightblue}{S_3} & \color{lightblue}0 \\\\ \color{violet}0 & \color{violet}0 & \color{violet}0 & \color{violet}1 \end{bmatrix}
    \cdot \begin{pmatrix} x \\\\ y \\\\ z \\\\ 1 \end{pmatrix}
    = \begin{pmatrix} \color{pink}{S_1} \cdot x \\\\ \color{lightgreen}{S_2} \cdot y \\\\ \color{lightblue}{S_3} \cdot z \\\\ 1 \end{pmatrix}\\]
    </figure>
</div>

```elm
makePerspective : Float -> Float -> Float -> Float -> Mat4
-- Creates a matrix for a perspective projection with fov-y, aspect, z-near, z-far

makeRotate : Float -> Vec3 -> Mat4
-- Creates a matrix for rotation in radians about the 3-element vector axis.

makeScale : Vec3 -> Mat4
-- Creates a matrix for scaling each of the x, y, and z axes.

makeTranslate : Vec3 -> Mat4
-- Creates a matrix for translating each of the x, y, and z axes.
```

Note:

Remember the right-hand rule


---

### Coordinate Systems

<figure class="stretch inset lighten">
![](images/coordinatesystems.png)
</figure>

Note:
