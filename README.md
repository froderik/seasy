seasy
=====

Seasy is a library that makes search easy. 


Usage
-----

    # updating the index
    index = Index::default
    index.add 'Fredrik Rubenssons blog', 'http://www.highlevelbits.com'
    
    # searching the index
    index.search "Ruben" # will return {'http://www.highlevelbits.com' => 1}


Configuration
-------------

Seasy got a built-in memory storage that is used default. If you need to do something else it can be configured:

    include Seasy
    configure do |config|
      config.storage = YourOwnFancyStorage
    end

A storage needs to answer to the following methods.
* an empty constructor
* a save method with three arguments: a target, a string that will be indexed and a options hash
* a search method that accepts a query string
* a remove method that accepts a source that is to be removed (see below for source and target definitions)
* a clear method for test purposes

If several indices will be used the storage needs to support a name= method that sets the name of the index. There will be one or moer instances of the storage per index.

The storage also needs to understand the difference between targets and sources. A target is where you want to end when doing a search. A source is the item that contains the text that leads to the source. (Example ffrom whan I needed it: you have a database of persons with payments and want to search for persons based on details in the payments but when a payment is removed those search items should be removed but not the persons own search items.) To enable this the save method accepts source in the options hash and the remove method should remove all items matching the argument source.



Copyright
---------

Copyright (c) 2011-2012 Fredrik Rubensson. See LICENSE.txt for further details.

