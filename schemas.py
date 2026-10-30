from pydantic import BaseModel, ConfigDict


# =========================
# QUADROS
# =========================

class QuadroCreate(BaseModel):
    nome: str


class QuadroResponse(BaseModel):
    id: int
    nome: str

    model_config = ConfigDict(from_attributes=True)


class ListaResumoResponse(BaseModel):
    id: int
    nome: str
    quadro_id: int

    model_config = ConfigDict(from_attributes=True)


class QuadroComListasResponse(BaseModel):
    id: int
    nome: str
    listas: list[ListaResumoResponse]

    model_config = ConfigDict(from_attributes=True)


# =========================
# LISTAS
# =========================

class ListaCreate(BaseModel):
    nome: str
    quadro_id: int


class ListaResponse(BaseModel):
    id: int
    nome: str
    quadro_id: int

    model_config = ConfigDict(from_attributes=True)


# =========================
# TAREFAS
# =========================

class TarefaCreate(BaseModel):
    titulo: str
    descricao: str | None = None
    lista_id: int | None = None


class TarefaUpdate(BaseModel):
    titulo: str
    descricao: str | None = None
    concluida: bool
    lista_id: int | None = None


class TarefaResponse(BaseModel):
    id: int
    titulo: str
    descricao: str | None = None
    concluida: bool
    lista_id: int | None = None

    model_config = ConfigDict(from_attributes=True)


class TarefaCriadaResponse(BaseModel):
    mensagem: str
    tarefa: TarefaResponse


class ListaTarefasResponse(BaseModel):
    tarefas: list[TarefaResponse]


# =========================
# RESPOSTAS GERAIS
# =========================

class MensagemResponse(BaseModel):
    mensagem: str
    