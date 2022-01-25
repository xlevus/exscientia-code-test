# Codegen

## What?

Hate SDKs for Web APIs that are nothing more than a glorified shim around a HTTP client?
Want type hints and concrete types when dealing with APIs?
Find writing functional and meaningful SDKs for your APIs a bore and a nightmare to maintain? 

Have a machine write your SDKs for you!

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
5. Create a new library
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
9. Fetch the API data
    ```
    $ python3
    >>> from foo.codetest_data import Endpoint
    >>> Endpoint.list()
    Compounds(ALogP=4.686, assay_res....
    ```


## Caveats

1. Does not fully conform to the jsonschema spec
2. While nested dataclasses are defined by the code-generator, the JSON data is not cast to them.
3. Don't do this. There's so many reasons why.