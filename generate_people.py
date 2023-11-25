import csv
import faker
from random import randint
from datetime import datetime

fake = faker.Faker()

# Generate artists
artists = [(i, fake.first_name(), fake.last_name(), f"{randint(750, 2005)}-{randint(1,12):02d}-{randint(1,28):02d}", datetime.timestamp(datetime.now()), randint(0,144)) for i in range(5000)]

with open('people.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['id', 'first_name', 'last_name', 'dob', 'join_date', 'category_id'])
    writer.writerows(artists)

print("CSV file 'people.csv' has been created with 5000 random names.")

# Generate art
art = [(i, fake.first_name(), randint(765, 2023), randint(0, 5000), randint(0, 144)) for i in range(25000)]

with open('artwork.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['id', 'name', 'year', 'artist_id', 'category_id'])
    writer.writerows(art)

print("CSV file 'artwork.csv' has been created with 25000 random artworks.")