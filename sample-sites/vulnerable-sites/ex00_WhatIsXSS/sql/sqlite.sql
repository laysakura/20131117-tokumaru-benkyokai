drop table if exists users;
create table users (
    uid  VARCHAR(64)  UNIQUE,
    pass VARCHAR(256)       ,  -- XSSのサンプルなのでhash化してません(言い訳)
    sid  VARCHAR(256) UNIQUE   -- セッションIDも各ユーザについて一生同じです
);

-- そもそも uid='sampleuser' なレコードしかありません
insert into users values ('sampleuser', 'samplepass', '0123456789abcdef');
