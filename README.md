# Codegen

## What?

Hate SDKs for Web APIs that are nothing more than a glorified shim around a HTTP client?
Want type hints and concrete types when dealing with APIs?
Find writing functional and meaningful SDKs for your APIs a bore and a nightmare to maintain? 

Have a machine write your SDKs for you!

### What What?

There are two services:
- `src/python/dataserv` - Our API that serves the contents of `data.json` and `schema.json`.
  It's the least amount of code and dependencies possible to serve the JSON over HTTP. 
- `src/elixir/codegen` - A Webservice that takes a URI for an REST API, and a Schema for that 
  API, then spits out SDK in the form of a python wheel that allows you to talk to said API 
  from python. A fully type-hinted SDK, letting your IDE autocomplete for you. Woo.

## Why?

- Because bad ideas always (usually) start with the best intentions
- See: "What?"

## How?

1. Do whatever you need to do to install:
  - Docker
  - Python3 (and the `wheel` package)
  - Elixir
  - `mix`
  - `mix deps.get`
2. Start the dependent services
  ```
  $ docker-compose up
  ```

3. Run the server
  ```
  $ mix phx.server
  ```

4. Go to http://localhost:4000/library

5. Create a new library "CodeTest"

6. Pretend you're a CI server, and submit a new/updated resource
  ```
  $ curl -X POST http://localhost:4000/api/library/<LIBRARY_ID>/resource \
      -H "Content-Type: application/json" \
      -d '{"resource": {"uri": "http://localhost:8080/", "schema_uri": "http://localhost:8080/schema.json", "name": "compounds"}}'
  ```
7. Download the wheel 

8. Install the wheel 
    ```
    python3 -m venv VENV
    source VENV/bin/activate
    pip3 install foo-1.0.0-py3-none-any.whl
    ```

9. Fetch the API data
    ```
    $ python3
    >>> from code_test.compounds import Endpoint
    >>> Endpoint.list()
    Compounds(ALogP=4.686, assay_res....
    ```


## Caveats

1. First time w/ Elixir. Which in hindsight I feel has made this a poor demonstrator of 'me'.
2. While nested dataclasses are defined by the code-generator, the JSON data is not cast to them.
3. Don't do this. There's so many reasons why.
4. It's missing:
  - SDK versioning.
  - Authentication. Both with the webservice, and with the SDK's API resources.
  - Support for different 'styles' of APIs.
  - Support for the full JSONSchema spec.
  - Lots more.


## (A brutally honest) Post-Mortem

The parts of the that didn't touch Phoenix were enjoyable (if not leaving me wishing I was playing
with Clojure again). Re-surfacing the functional mindset took a little while, but it's still there
and once the functional juices were flowing, I often found myself going back over things and
refactoring them to read better. I suspect given another week full-time in Elixir this project and
post-mortem would be entirely different.

If I was to redo this, I would have spent more time making the SDK generation better and more 
functional. Spending less (see: zero) time trying to work out Phoenix. Maybe Phoenix would make 
more sense if you're coming from Rails (i don't know, I've never touched rails), but I still don't 
'get' it.

If this was a real-world project, I wouldn't have gone anywhere near Elixir. It brings nothing
to the table and only downsides (hiring, immaturity, complexity, mismatch between 
target-language to name a few).

If someone asked me to fix or extend in an Elixir project, I'm now pretty confident I could do it.
With more real-world examples to lean on and learn from it would be a breeze. 

If someone asked me to start a new Elixir project, I would be wary. I've still not seen the full
breadth of Elixir's strengths and weaknesses. But for a basic Web service and API, the ecosystems 
and maturity of other languages would make Elixir a hard sell. Maybe with a bit more immersion my
tone would change. It's hard to tell.


### tl;dr

- First time with elixir
- It's not a bad language, but...
  - `use` is a crime. Import and run code in the global scope? This is a great idea!
  - Why are there multiple syntaxes for nearly everything? Pick one and commit to it!
    - `foo(bar,baz)` vs `foo bar, baz`
    - `[{:foo 1}, {:bar 2}]` vs `[foo: 1 bar: 2]`
    - `:true` vs `true`
    - `if foo do: stuff` vs `if foo do stuff end`
    - `[:a, :b, :c] ++ [1, 2, 3]` vs `"abc" <> "123"`
    - `%{"foo" => :bar}` vs `%{foo: "bar"}`
  - Frustrating having /everything/ documented on hexdocs, with /everything/ having the same
    favicon. Then there's Projects (e.g. Phoenix) split up into multiple documentation scopes,
    so not even all of the Phoenix project can be searched under the Phoenix banner.
  - Sort of feels like A Ruby developer wanted to learn Clojure, but couldn't get past it being
    a lisp. But then it also feels like Elixir is missing a bunch of things that I feel make
    Clojure (well, lisps) great.

- Phoenix is ... not great.
  - At the very start of the project, `phx.gen` had pushed the SLOC well past 2k lines.
  - Generated code didn't really do anything. Sure it looked pretty, but the stuff it did do, 
    it did poorly.
  - Still have no idea how some parts work. 
    - e.g. `render(conn, "index.json", ...)`. Somehow gets linked to the view, but the view just
      returns a map. 
        - Where's the magical bit that converts the data into an actual JSON response? 
        - What ties the Controller to the View?