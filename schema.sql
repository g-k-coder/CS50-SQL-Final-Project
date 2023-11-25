-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

CREATE TABLE artists (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    -- YYYY-MM-DD format
    "dob" NUMERIC NOT NULL,
    "join_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "category_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("category_id") REFERENCES categories ("rowid")
);

CREATE TABLE art (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    -- YYYY format
    "year" INTEGER NOT NULL,
    "artist_id" INTEGER,
    -- Art category can differ from artists main category
    "category_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES artists ("id") ON DELETE CASCADE,
    FOREIGN KEY("category_id") REFERENCES categories ("rowid") ON DELETE CASCADE
);

CREATE TABLE categories (
    -- Data integrity of domain and subdomain coulumns could be checked by human, 
    -- or by simply prepopulating the table from a CSV file on creation and add new values later if need be
    -- Eg, Performing Arts, Visual Arts, etc
    "domain" TEXT NOT NULL,
    -- Eg, Music, Painting, etc
    "subdomain" TEXT NOT NULL,
    -- Eg, Pop, New Ink Art, etc
    "genre" TEXT NOT NULL
);

CREATE TABLE owners (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- ratings are made for art, through which then artists rating can be determined
CREATE TABLE ratings (
    "id" INTEGER,
    "owner_id" INTEGER,
    "art_id" INTEGER,
    "timestamp" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    -- rating must be from 1-10, default is 1
    "rating" INTEGER NOT NULL DEFAULT 1 CHECK("rating" BETWEEN 1 AND 10),
    PRIMARY KEY("id"),
    FOREIGN KEY("owner_id") REFERENCES owners("id"),
    FOREIGN KEY("art_id") REFERENCES art("id")
);

CREATE TABLE transactions (
    "id" INTEGER,
    "owner_id" INTEGER,
    "art_id" INTEGER,
    -- Amounts of dollars represented in cents, 1.00 USD = 100 US cents
    "price" INTEGER NOT NULL,
    "action" TEXT NOT NULL CHECK("action" IN ('bought', 'sold', 'gifted', 'created')),
    PRIMARY KEY("id"),
    FOREIGN KEY("owner_id") REFERENCES owners("id"),
    FOREIGN KEY("art_id") REFERENCES art("id")
);

CREATE VIEW "artist_rating" AS
SELECT 
    "artists"."id" AS "Artist ID",
    "artists"."first_name" AS "First Name",
    "artists"."last_name" AS "Last Name",
    ROUND(SUM("ratings"."rating")/COUNT("ratings"."rating"), 2) AS "Rating"
FROM  "artists"
JOIN "art" ON "artists"."id" = "art"."artist_id"
JOIN "ratings" ON "art"."id" = "ratings"."art_id"
GROUP BY "Artist ID"
ORDER BY "Last Name";

CREATE INDEX "artist_idx" ON artists ("id", "last_name", "category");
CREATE INDEX "owner_idx" ON owners ("id", "username");
CREATE INDEX "category_idx" ON categories ("rowid", "domain");
CREATE INDEX "transaction_idx" ON transactions ("id", "owner_id", "art_id");

CREATE TRIGGER new_art_created AFTER INSERT ON art
BEGIN
    -- Set the artist as the owner if it was 'created'
    INSERT OR IGNORE INTO owners(first_name, last_name, username)
    SELECT 
        first_name, 
        last_name, 
        first_name || last_name || id
    FROM artists
    WHERE id = NEW.artist_id;

    INSERT INTO transactions (owner_id, art_id, price, action)
    SELECT id, NEW.id, 0, 'created' FROM owners WHERE username = first_name || last_name || NEW.artist_id
    ORDER BY id LIMIT 1;

    INSERT INTO ratings (owner_id, art_id, rating)
    SELECT id, NEW.id, 1 FROM owners WHERE username = first_name || last_name || NEW.artist_id
    ORDER BY id LIMIT 1;
END;

.import --csv --skip 1 categories.csv categories
.import --csv --skip 1 people.csv artists
.import --csv --skip 1 artwork.csv art