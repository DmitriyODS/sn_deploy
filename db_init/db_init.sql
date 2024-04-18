BEGIN;

-- Включаем криптографические функции
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Добавим функцию тгла лайков
CREATE OR REPLACE FUNCTION toggle_like(user_id INTEGER, post_id INTEGER) RETURNS VOID AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM likes l WHERE l.user_id = toggle_like.user_id AND l.post_id = toggle_like.post_id) THEN
        DELETE FROM likes l WHERE l.user_id = toggle_like.user_id AND l.post_id = toggle_like.post_id;
    ELSE
        INSERT INTO likes (user_id, post_id) VALUES (toggle_like.user_id, toggle_like.post_id);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Таблица хранения user'ов
CREATE TABLE IF NOT EXISTS users
(
    id       SERIAL PRIMARY KEY,
    login    TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);

-- Заполнение таблицы данными
INSERT INTO users (id, login, password)
VALUES (1, 'admin', crypt('admin', gen_salt('bf')))
ON CONFLICT (id) DO UPDATE SET id=excluded.id,
                               login=excluded.login,
                               password=excluded.password;


-- Настройка последовательности
SELECT setval('users_id_seq', (SELECT max(id) FROM users));


-- Таблица хранения Post'ов
CREATE TABLE IF NOT EXISTS posts
(
    id           SERIAL PRIMARY KEY,
    title        TEXT    NOT NULL,
    text         TEXT      DEFAULT '',
    user_id      INTEGER NOT NULL,
    created_date TIMESTAMP DEFAULT current_timestamp,
    CONSTRAINT fk_users_to_posts_by_user_id FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Таблица хранения Like'ов
CREATE TABLE IF NOT EXISTS likes
(
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,

    CONSTRAINT pk_likes PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_users_to_likes_by_user_id FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_posts_to_likes_by_post_id FOREIGN KEY (post_id) REFERENCES posts (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

COMMIT;
