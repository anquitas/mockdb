

#### OBJECT MUTATION

as database stores object instances inside its `MockRecord` it is actually a reference to the object, 
so when *DB* retuns result data it returns access to data inside the database's `MockRecord` class

in use it should interact w sources and api models,
or maybe `MockRecord` itself is api model for *MockDB* 
so maybe that would mean already its objects ll renew at repository level
but still not consistant with database logic and makes the mutation methods like `update` redundant

solution might be
either pivot to a data store rather than database
or maybe create a mechanism to hand over coppies of objects that maybe frozen or immutable 
that might be more inline w database principles

or add a flag to switch between

or maybe seperate project into too

also this data store idea can be converted to handle appwide state


#### CRUD METHODS
`create`
`findById`, `find`
`updateById`, `updateOne`, `updateMany`
`deleteById`, `deleteOne`, `deleteMany`
