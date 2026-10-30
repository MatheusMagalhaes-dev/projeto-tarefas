from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()


class QuadroDB(Base):
    __tablename__ = "quadros"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(255), nullable=False)

    listas = relationship(
        "ListaDB",
        back_populates="quadro",
        cascade="all, delete-orphan",
    )


class ListaDB(Base):
    __tablename__ = "listas"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(255), nullable=False)
    quadro_id = Column(
        Integer,
        ForeignKey("quadros.id", ondelete="CASCADE"),
        nullable=False,
    )

    quadro = relationship(
        "QuadroDB",
        back_populates="listas",
    )

    tarefas = relationship(
        "TarefaDB",
        back_populates="lista",
        cascade="all, delete-orphan",
    )


class TarefaDB(Base):
    __tablename__ = "tarefas"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(255), nullable=False)
    descricao = Column(Text, nullable=True)
    concluida = Column(Boolean, default=False)

    lista_id = Column(
        Integer,
        ForeignKey("listas.id", ondelete="CASCADE"),
        nullable=True,
    )

    lista = relationship(
        "ListaDB",
        back_populates="tarefas",
    )