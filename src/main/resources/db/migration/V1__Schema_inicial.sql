CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS usuario (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_udg     VARCHAR(20) NOT NULL UNIQUE,
    contra_hash    VARCHAR(255) NULL,
    rol            VARCHAR(20) NOT NULL,
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_usuario_rol CHECK (rol IN ('ESTUDIANTE', 'CAJERO', 'ADMIN')),
    CONSTRAINT chk_contra_rol CHECK (
        (rol = 'ESTUDIANTE' AND contra_hash IS NULL) OR
        (rol IN ('CAJERO', 'ADMIN') AND contra_hash IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS beca (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id     UUID NOT NULL REFERENCES Usuario(id),
    semestre       VARCHAR(20) NOT NULL,
    comidas_totales SMALLINT NOT NULL DEFAULT 60,
    comidas_usadas SMALLINT NOT NULL DEFAULT 0,
    fecha_inicio   DATE NOT NULL,
    fecha_fin      DATE NOT NULL,
    estado         VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_beca_estado          CHECK (estado IN ('ACTIVA', 'AGOTADA', 'VENCIDA')),
    CONSTRAINT chk_comidas_usadas       CHECK (comidas_usadas >= 0),
    CONSTRAINT chk_comidas_totales      CHECK (comidas_totales > 0),
    CONSTRAINT chk_comidas_rango        CHECK (comidas_usadas <= comidas_totales),
    CONSTRAINT uq_beca_usuario_semestre UNIQUE (usuario_id, semestre)
);

CREATE TABLE IF NOT EXISTS transaccion (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    beca_id    UUID NOT NULL REFERENCES beca(id),
    cajero_id  UUID NOT NULL REFERENCES usuario(id),
    fecha_hora TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nota       TEXT NULL
);

CREATE TABLE IF NOT EXISTS notificacion (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id  UUID NOT NULL REFERENCES usuario(id),
    mensaje     TEXT NOT NULL,
    leida       BOOLEAN NOT NULL DEFAULT FALSE,
    fecha       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_beca_usuario_id      ON beca(usuario_id);
CREATE INDEX idx_beca_estado          ON beca(estado);
CREATE INDEX idx_transaccion_beca     ON transaccion(beca_id);
CREATE INDEX idx_transaccion_cajero   ON transaccion(cajero_id);
CREATE INDEX idx_notificacion_usuario ON notificacion(usuario_id);
CREATE INDEX idx_notificacion_leida   ON notificacion(leida);