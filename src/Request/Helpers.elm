module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl str =
    "https://swapi.co/api" ++ str
