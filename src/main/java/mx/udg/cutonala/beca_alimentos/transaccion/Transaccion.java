package mx.udg.cutonala.beca_alimentos.transaccion;

import java.time.OffsetDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import mx.udg.cutonala.beca_alimentos.beca.Beca;
import mx.udg.cutonala.beca_alimentos.usuario.Usuario;

@Getter @Setter
@NoArgsConstructor
@Entity
@Table(name = "transaccion")
public class Transaccion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "beca_id", nullable = false)
    private Beca beca;

    @ManyToOne
    @JoinColumn(name = "cajero_id", nullable = false)
    private Usuario cajero;

    @Column(name = "fecha_hora", nullable = false)
    private OffsetDateTime fechaHora;

    private String nota;

    @PrePersist
    protected void onCreate() {
        this.fechaHora = OffsetDateTime.now();
    }
}
