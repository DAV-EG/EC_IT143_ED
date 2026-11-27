/*
********************************************************************************
NAME:EC_IT143_W5.2_MovieLens
PURPOSE: Answer four MovieLens community questions using SQL queries.
MODIFICATION LOG:
Ver  Date        Author          Description
---- ----------  --------------  -----------------------------------------------
1.0  11/27/2026  Eguabor David       Created script for IT 143 Assignment 5.2.

RUNTIME:
Varies depending on database size and server performance.

NOTES:
This script answers four questions about the MovieLens database.
It uses Movies, Ratings, and Tags to analyze movie ratings,
movie popularity, and user-submitted tags and genres.
********************************************************************************
*/

USE MYCommuunity;
GO

/*
Q1: What is the average user rating for each movie?
Original Question Author: Your Name

A1: I will join Movies and Ratings using movieId.
I will calculate the average rating for each movie and display
the movie title, average rating, and total number of ratings.
*/

SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS AverageRating,
    COUNT(r.rating) AS TotalRatings
FROM dbo.Movies AS m
LEFT JOIN dbo.Ratings AS r
    ON m.movieId = r.movieId
GROUP BY
    m.movieId,
    m.title
ORDER BY
    AverageRating DESC;
GO


/*
Q2: Which movies have received the greatest number of user ratings?
Original Question Author: Your Name

A2: I will join Movies and Ratings using movieId.
I will count the rating records for each movie and sort
the results from the highest number of ratings to the lowest.
*/

SELECT
    m.movieId,
    m.title,
    COUNT(r.rating) AS RatingCount
FROM dbo.Movies AS m
LEFT JOIN dbo.Ratings AS r
    ON m.movieId = r.movieId
GROUP BY
    m.movieId,
    m.title
ORDER BY
    RatingCount DESC,
    m.title;
GO


/*
Q3: Which movies have the largest number of user-submitted tags?
Original Question Author: Your Name

A3: I will join Movies and Tags using movieId.
I will count the tag records for each movie and display
the movie title and tag count. This will identify movies
that receive the most attention from users.
*/

SELECT
    m.movieId,
    m.title,
    COUNT(t.tag) AS TagCount
FROM dbo.Movies AS m
LEFT JOIN dbo.Tags AS t
    ON m.movieId = t.movieId
GROUP BY
    m.movieId,
    m.title
ORDER BY
    TagCount DESC,
    m.title;
GO


/*
Q4: Which movie genres have the highest average user ratings?
Original Question Author: Your Name

A4: I will combine the genres field in Movies with the rating
field in Ratings using movieId. Since a movie can belong to
multiple genres, I will separate the genre values using
STRING_SPLIT before calculating the average rating for each genre.
*/

WITH MovieGenres AS
(
    SELECT
        m.movieId,
        LTRIM(RTRIM(s.value)) AS Genre
    FROM dbo.Movies AS m
    CROSS APPLY STRING_SPLIT(m.genres, '|') AS s
    WHERE m.genres IS NOT NULL
      AND m.genres <> '(no genres listed)'
)
SELECT
    mg.Genre,
    AVG(r.rating) AS AverageRating,
    COUNT(r.rating) AS RatingCount
FROM MovieGenres AS mg
INNER JOIN dbo.Ratings AS r
    ON mg.movieId = r.movieId
GROUP BY
    mg.Genre
ORDER BY
    AverageRating DESC;
GO
