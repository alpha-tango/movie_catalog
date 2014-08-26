Movie Catalog

Challenge

Build a movie catalog backed by the movies database. The catalog should support the following routes:

    Visiting /actors will show a list of actors, sorted alphabetically by name. Each actor name is a link to the details page for that actor.

    Visiting /actors/:id will show the details for a given actor. This page should contain a list of movies that the actor has starred in and what their role was. Each movie should link to the details page for that movie.

    Visiting /movies will show a table of movies, sorted alphabetically by title. The table includes the movie title, the year it was released, the rating, the genre, and the studio that produced it. Each movie title is a link to the details page for that movie.

    Visiting /movies/:id will show the details for the movie. This page should contain information about the movie (including genre and studio) as well as a list of all of the actors and their roles. Each actor name is a link to the details page for that actor.

Non-Core Requirements

    Allow different orderings for the /movies page. The user should be able to sort by year released or rating by visiting /movies?order=year or /movies?order=rating.

    Paginate the /movies and /actors page using the LIMIT and OFFSET clauses in PostgreSQL. Each page should show up to 20 entries at a time. Visiting /movies?page=2 should show the next 20 movies.

    Add a search feature for /movies. Visiting /movies?query=troll+2 will only show moviers that have the phrase troll 2 in the title or synopsis. This can be accomplished using the LIKE and ILIKE operators in PostgreSQL. For an additional challenge, use the full-text search feature available in PostgreSQL:

SELECT * FROM movies WHERE to_tsvector(title) @@ plainto_tsquery('some query here')

    Add a search feature for /actors that searches through the actor name as well as their roles that they played (found in the cast_members table).

    Show the number of movies that each actor has starred in on the /actors page. This can be accomplished by using an aggregate query with the GROUP BY clause and the COUNT(*) function.
