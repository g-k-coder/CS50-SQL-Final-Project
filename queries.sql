-- Find all artwork from certain category
SELECT *
FROM art 
WHERE category_id = (
    SELECT category_id 
    FROM artists
    WHERE first_name = 'Holly'
    AND last_name = 'Ashley'
);

-- Find all artworks from an artist
SELECT *
FROM art
WHERE artist_id = (
    SELECT id 
    FROM artists
    WHERE first_name = 'Jason'
    AND last_name = 'Davis'
);

-- Find all transactions including owner by username
SELECT *
FROM transactions
WHERE owner_id = (
    SELECT id 
    FROM owners
    WHERE username = 'RobertParker4890'
);

-- Add a new artist
INSERT INTO artists (first_name, last_name, dob, category_id)
VALUES ('Alfred', 'Krupa', '1971-06-14', 9);

-- Add a new owner
INSERT INTO owners (first_name, last_name, username)
VALUES ('Gabriel Alfred', 'Krupa', 'krupgabrielalfred');

-- Add a new category
INSERT INTO categories (domain, subdomain, genre)
VALUES('Media Arts', 'Digital Arts', 'Video games');

-- Add a new art
INSERT INTO art ("name", year, artist_id, category_id)
VALUES ('Destiny 2', 2017, 5001, 145);

-- Update rating
UPDATE ratings SET rating = 10 WHERE id = 10;

-- Delete an owner
DELETE FROM owners WHERE id = 150;
