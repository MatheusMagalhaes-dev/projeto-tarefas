
from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session

from database import SessionLocal
from models import QuadroDB, ListaDB, TarefaDB
from schemas import (
    QuadroCreate,
    QuadroResponse,
    QuadroComListasResponse,
    ListaCreate,
    ListaResponse,
    TarefaCreate,
    TarefaUpdate,
    TarefaResponse,
    TarefaCriadaResponse,
    ListaTarefasResponse,
    MensagemResponse,
)


app = FastAPI(
    title="API de Tarefas",
    description="API para gerenciamento de quadros, listas e tarefas",
    version="2.0.0",
)


# =========================
# BANCO DE DADOS
# =========================

def obter_banco():
    banco = SessionLocal()

    try:
        yield banco
    finally:
        banco.close()


# =========================
# HOME
# =========================

@app.get("/", response_model=MensagemResponse)
def home():
    return {
        "mensagem": "Nossa API está funcionando!"
    }


# =========================
# QUADROS
# =========================

@app.post(
    "/boards",
    response_model=QuadroResponse,
    status_code=status.HTTP_201_CREATED,
)
def criar_quadro(
    quadro: QuadroCreate,
    banco: Session = Depends(obter_banco),
):
    try:
        # 1. Criar o quadro
        novo_quadro = QuadroDB(
            nome=quadro.nome,
            tipo=quadro.tipo,
        )

        banco.add(novo_quadro)

        # 2. Gerar o ID do quadro
        banco.flush()

        # 3. Criar listas padrão somente para quadros de tarefas
        if quadro.tipo == "tarefas":
            listas_padrao = [
                ListaDB(
                    nome="Tarefas",
                    quadro_id=novo_quadro.id,
                    ordem=0,
                ),
                ListaDB(
                    nome="Em andamento",
                    quadro_id=novo_quadro.id,
                    ordem=1,
                ),
                ListaDB(
                    nome="Concluído",
                    quadro_id=novo_quadro.id,
                    ordem=2,
                ),
            ]

            banco.add_all(listas_padrao)

        # 4. Salvar tudo no banco
        banco.commit()
        banco.refresh(novo_quadro)

        return novo_quadro

    except Exception:
        banco.rollback()
        raise

@app.get(
    "/boards",
    response_model=list[QuadroResponse],
)
def listar_quadros(
    banco: Session = Depends(obter_banco),
):
    quadros = (
        banco.query(QuadroDB)
        .order_by(QuadroDB.id)
        .all()
    )

    return quadros


@app.get(
    "/boards/{board_id}",
    response_model=QuadroComListasResponse,
)
def obter_quadro(
    board_id: int,
    banco: Session = Depends(obter_banco),
):
    quadro = banco.get(QuadroDB, board_id)

    if quadro is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quadro não encontrado",
        )

    return quadro


@app.delete(
    "/boards/{board_id}",
    response_model=MensagemResponse,
)
def excluir_quadro(
    board_id: int,
    banco: Session = Depends(obter_banco),
):
    quadro = banco.get(QuadroDB, board_id)

    if quadro is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quadro não encontrado",
        )

    banco.delete(quadro)
    banco.commit()

    return {
        "mensagem": "Quadro excluído com sucesso!"
    }


# =========================
# LISTAS
# =========================

@app.post(
    "/lists",
    response_model=ListaResponse,
    status_code=status.HTTP_201_CREATED,
)
def criar_lista(
    lista: ListaCreate,
    banco: Session = Depends(obter_banco),
):
    quadro = banco.get(QuadroDB, lista.quadro_id)

    if quadro is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quadro não encontrado",
        )

    # Encontrar a última ordem utilizada no quadro
    ultima_lista = (
        banco.query(ListaDB)
        .filter(ListaDB.quadro_id == lista.quadro_id)
        .order_by(
            ListaDB.ordem.desc(),
            ListaDB.id.desc(),
        )
        .first()
    )

    nova_ordem = (
        ultima_lista.ordem + 1
        if ultima_lista is not None
        else 0
    )

    nova_lista = ListaDB(
        nome=lista.nome,
        quadro_id=lista.quadro_id,
        ordem=nova_ordem,
    )

    banco.add(nova_lista)
    banco.commit()
    banco.refresh(nova_lista)

    return nova_lista


@app.get(
    "/boards/{board_id}/lists",
    response_model=list[ListaResponse],
)
def listar_listas(
    board_id: int,
    banco: Session = Depends(obter_banco),
):
    quadro = banco.get(QuadroDB, board_id)

    if quadro is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Quadro não encontrado",
        )

    listas = (
        banco.query(ListaDB)
        .filter(ListaDB.quadro_id == board_id)
        .order_by(
            ListaDB.ordem,
            ListaDB.id,
        )
        .all()
    )

    return listas


@app.delete(
    "/lists/{list_id}",
    response_model=MensagemResponse,
)
def excluir_lista(
    list_id: int,
    banco: Session = Depends(obter_banco),
):
    lista = banco.get(ListaDB, list_id)

    if lista is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Lista não encontrada",
        )

    banco.delete(lista)
    banco.commit()

    return {
        "mensagem": "Lista excluída com sucesso!"
    }


# =========================
# TAREFAS
# =========================

@app.post(
    "/tasks",
    response_model=TarefaCriadaResponse,
    status_code=status.HTTP_201_CREATED,
)
def criar_tarefa(
    tarefa: TarefaCreate,
    banco: Session = Depends(obter_banco),
):
    if tarefa.lista_id is not None:
        lista = banco.get(ListaDB, tarefa.lista_id)

        if lista is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Lista não encontrada",
            )

    nova_tarefa = TarefaDB(
        titulo=tarefa.titulo,
        descricao=tarefa.descricao,
        lista_id=tarefa.lista_id,
    )

    banco.add(nova_tarefa)
    banco.commit()
    banco.refresh(nova_tarefa)

    return {
        "mensagem": "Tarefa criada com sucesso!",
        "tarefa": nova_tarefa,
    }


@app.get(
    "/tasks",
    response_model=ListaTarefasResponse,
)
def listar_tarefas(
    banco: Session = Depends(obter_banco),
):
    tarefas = (
        banco.query(TarefaDB)
        .order_by(TarefaDB.id)
        .all()
    )

    return {
        "tarefas": tarefas
    }


@app.get(
    "/lists/{list_id}/tasks",
    response_model=ListaTarefasResponse,
)
def listar_tarefas_da_lista(
    list_id: int,
    banco: Session = Depends(obter_banco),
):
    lista = banco.get(ListaDB, list_id)

    if lista is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Lista não encontrada",
        )

    tarefas = (
        banco.query(TarefaDB)
        .filter(TarefaDB.lista_id == list_id)
        .order_by(TarefaDB.id)
        .all()
    )

    return {
        "tarefas": tarefas
    }


@app.put(
    "/tasks/{task_id}",
    response_model=TarefaCriadaResponse,
)
def atualizar_tarefa(
    task_id: int,
    tarefa: TarefaUpdate,
    banco: Session = Depends(obter_banco),
):
    tarefa_existente = banco.get(TarefaDB, task_id)

    if tarefa_existente is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarefa não encontrada",
        )

    if tarefa.lista_id is not None:
        lista = banco.get(ListaDB, tarefa.lista_id)

        if lista is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Lista não encontrada",
            )

    tarefa_existente.titulo = tarefa.titulo
    tarefa_existente.descricao = tarefa.descricao
    tarefa_existente.concluida = tarefa.concluida
    tarefa_existente.lista_id = tarefa.lista_id

    banco.commit()
    banco.refresh(tarefa_existente)

    return {
        "mensagem": "Tarefa atualizada com sucesso!",
        "tarefa": tarefa_existente,
    }


@app.delete(
    "/tasks/{task_id}",
    response_model=MensagemResponse,
)
def excluir_tarefa(
    task_id: int,
    banco: Session = Depends(obter_banco),
):
    tarefa = banco.get(TarefaDB, task_id)

    if tarefa is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tarefa não encontrada",
        )

    banco.delete(tarefa)
    banco.commit()

    return {
        "mensagem": "Tarefa excluída com sucesso!"
    }
