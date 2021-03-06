Variant feature is auto enabled when virtual_modules is used

  $ dune build --root variants-without-using
  File "dune", line 3, characters 1-25:
  3 |  (virtual_modules foobar))
       ^^^^^^^^^^^^^^^^^^^^^^^^
  Error: 'virtual_modules' is only available since version 0.1 of the experimental variants feature
  [1]

  $ dune build --root variants-using
  Entering directory 'variants-using'

virtual libraries may not implement their virtual modules

  $ dune build --root invalid-virtual-lib
  Entering directory 'invalid-virtual-lib'
  File "dune", line 3, characters 18-21:
  3 |  (virtual_modules foo bar))
                        ^^^
  Error: Module Foo has an implementation, it cannot be listed here
  [1]

  $ cd module-fields && ocaml test.ml
  impl: true. modules_without_implementation: true. virtual_modules: true. private_modules: true
  File "dune", line 3, characters 33-34:
  3 |  (modules_without_implementation m)
                                       ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: true. virtual_modules: false. private_modules: true
  File "dune", line 3, characters 33-34:
  3 |  (modules_without_implementation m)
                                       ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: false. virtual_modules: true. private_modules: true
  File "dune", line 3, characters 18-19:
  3 |  (virtual_modules m)
                        ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: false. virtual_modules: false. private_modules: true
  -------------------------
  impl: false. modules_without_implementation: true. virtual_modules: true. private_modules: true
  File "dune", line 4, characters 18-19:
  4 |  (virtual_modules m)
                        ^
  Error: These modules appear in the virtual_libraries and modules_without_implementation fields: 
  - M
  This is not possible.
  -------------------------
  impl: false. modules_without_implementation: true. virtual_modules: false. private_modules: true
  -------------------------
  impl: false. modules_without_implementation: false. virtual_modules: true. private_modules: true
  File "dune", line 3, characters 18-19:
  3 |  (virtual_modules m)
                        ^
  Error: The following modules are declared as virtual and private: 
  - M
  This is not possible.
  -------------------------
  impl: false. modules_without_implementation: false. virtual_modules: false. private_modules: true
  File "dune", line 1, characters 0-42:
  1 | (library
  2 |  (name foo)
  3 |  (private_modules m))
  Warning: Some modules don't have an implementation.
  You need to add the following field to this stanza:
  
    (modules_without_implementation m)
  
  This will become an error in the future.
  -------------------------
  impl: true. modules_without_implementation: true. virtual_modules: true. private_modules: false
  File "dune", line 3, characters 33-34:
  3 |  (modules_without_implementation m)
                                       ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: true. virtual_modules: false. private_modules: false
  File "dune", line 3, characters 33-34:
  3 |  (modules_without_implementation m))
                                       ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: false. virtual_modules: true. private_modules: false
  File "dune", line 3, characters 18-19:
  3 |  (virtual_modules m))
                        ^
  Error: Module M has an implementation, it cannot be listed here
  -------------------------
  impl: true. modules_without_implementation: false. virtual_modules: false. private_modules: false
  -------------------------
  impl: false. modules_without_implementation: true. virtual_modules: true. private_modules: false
  File "dune", line 4, characters 18-19:
  4 |  (virtual_modules m))
                        ^
  Error: These modules appear in the virtual_libraries and modules_without_implementation fields: 
  - M
  This is not possible.
  -------------------------
  impl: false. modules_without_implementation: true. virtual_modules: false. private_modules: false
  -------------------------
  impl: false. modules_without_implementation: false. virtual_modules: true. private_modules: false
  -------------------------
  impl: false. modules_without_implementation: false. virtual_modules: false. private_modules: false
  File "dune", line 1, characters 0-21:
  1 | (library
  2 |  (name foo))
  Warning: Some modules don't have an implementation.
  You need to add the following field to this stanza:
  
    (modules_without_implementation m)
  
  This will become an error in the future.
  -------------------------

Implementations cannot introduce new modules to the library's interface
  $ dune build --root impl-public-modules
  Entering directory 'impl-public-modules'
  File "impl/dune", line 1, characters 0-44:
  1 | (library
  2 |  (name foo_impl)
  3 |  (implements foo))
  Error: The following modules aren't part of the virtual library's interface:
  - Baz
  They must be marked as private using the (private_modules ..) field
  [1]

They can only introduce private modules:
  $ dune build --root impl-private-modules
  Entering directory 'impl-private-modules'

Virtual library with a single module
  $ dune build --root variants-simple
  Entering directory 'variants-simple'
           foo alias default
  running implementation

Virtual library where a wrapped module is virtual
  $ dune build --root variants-sub-module
  Entering directory 'variants-sub-module'
           run alias default
  Impl's Vmd.run ()

Executable that tries to build against a virtual library without an implementation
  $ dune build --root missing-implementation
  Entering directory 'missing-implementation'
  Error: No implementation found for virtual library "vlib" (_build/default/vlib).
  [1]

Executable that tries to use two implementations for the same virtual lib
  $ dune build --root double-implementation
  Entering directory 'double-implementation'
  Error: Conflicting implementations for virtual library "vlib":
  - "impl1" in _build/default/impl1
     -> required by library "bar" in _build/default
  - "impl2" in _build/default/impl2
  This cannot work.
  [1]

Install files for implemenations and virtual libs have all the artifacts:
  $ dune build --root install-file
  Entering directory 'install-file'
  No rule found for impl/.impl.objs/vlib.cmt
  No rule found for impl/vlib.ml-gen
  [1]
