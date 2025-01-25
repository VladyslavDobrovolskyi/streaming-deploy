-- Таблица для пользователей
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставка примерных данных для пользователей
INSERT INTO users (username, password, email) VALUES
('john_doe', 'password123', 'john.doe@example.com'),
('jane_smith', 'securepass', 'jane.smith@example.com'),
('alex_jones', 'mypassword', 'alex.jones@example.com');

-- Таблица для фильмов (теперь только один фильм)
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставка данных для фильма
INSERT INTO movies (title, description, release_year) VALUES
('Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology is given the task of planting an idea into the mind of a CEO.', 2010);

-- Таблица для голосований
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies(id),
    user_id INT REFERENCES users(id),
    vote INT CHECK (vote >= 1 AND vote <= 5),  -- Оценка фильма от 1 до 5
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставка данных для голосований
INSERT INTO votes (movie_id, user_id, vote) VALUES
(1, 1, 5),  -- john_doe голосует за Inception (5)
(1, 2, 4),  -- jane_smith голосует за Inception (4)
(1, 3, 5);  -- alex_jones голосует за Inception (5)

-- Таблица для комнат (все комнаты привязаны к одному фильму)
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    capacity INT CHECK (capacity >= 2 AND capacity <= 5),  -- Размер комнаты (2-5 человек)
    available_seats INT CHECK (available_seats >= 0),  -- Свободные места в комнате
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставка данных для комнат (все комнаты для фильма Inception)
INSERT INTO rooms (capacity, available_seats) VALUES
(2, 2),  -- Комната для 2 человек
(2, 2),  -- Комната для 2 человек
(3, 3),  -- Комната для 3 человек
(3, 3),  -- Комната для 3 человек
(4, 4),  -- Комната для 4 человек
(4, 4),  -- Комната для 4 человек
(5, 5);  -- Комната для 5 человек

-- Таблица для резервации комнат
CREATE TABLE room_reservations (
    id SERIAL PRIMARY KEY,
    room_id INT REFERENCES rooms(id),
    user_id INT REFERENCES users(id),
    reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);

-- Вставка данных для резерваций комнат
INSERT INTO room_reservations (room_id, user_id) VALUES
(1, 1),  -- john_doe резервирует комнату для 2 человек
(3, 2),  -- jane_smith резервирует комнату для 3 человек
(6, 3);  -- alex_jones резервирует комнату для 4 человек
