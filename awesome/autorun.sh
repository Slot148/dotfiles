#!/usr/bin/env bash
#
# Roda o Awesome dentro de um Xephyr e recarrega a configuração (SIGHUP)
# a cada alteração nos arquivos deste diretório.
#
# Uso: ./autorun.sh [numero_do_display] [resolucao]
#      ./autorun.sh 1 1366x768
#
# O diretório observado é o diretório deste script, então pode ser chamado de
# qualquer lugar.

set -u

PASTA="$(cd "$(dirname "$0")" && pwd)"
RC="$PASTA/rc.lua"

DISPLAY_NUM="${1:-1}"
RES="${2:-1366x768}"
DISPLAY_NAME=":$DISPLAY_NUM"

for bin in Xephyr awesome inotifywait; do
	if ! command -v "$bin" >/dev/null 2>&1; then
		echo "Erro: '$bin' não encontrado no PATH." >&2
		exit 1
	fi
done

# Xephyr falha se o display já estiver em uso, e o awesome seguinte acabaria
# conectando na sessão real.
if [ -S "/tmp/.X11-unix/X$DISPLAY_NUM" ]; then
	echo "Erro: o display $DISPLAY_NAME já está em uso. Use outro número." >&2
	exit 1
fi

XEPHYR_PID=""
AWESOME_PID=""

cleanup() {
	echo
	echo ">>> Encerrando..."
	[ -n "$AWESOME_PID" ] && kill "$AWESOME_PID" 2>/dev/null
	[ -n "$XEPHYR_PID" ] && kill "$XEPHYR_PID" 2>/dev/null
	wait 2>/dev/null
}

trap cleanup EXIT INT TERM

echo ">>> Xephyr em $DISPLAY_NAME (${RES})"
Xephyr -br -ac -noreset -screen "$RES" "$DISPLAY_NAME" &
XEPHYR_PID=$!

# Espera o servidor X subir de verdade (em vez de um sleep fixo).
for _ in $(seq 1 50); do
	if [ -S "/tmp/.X11-unix/X$DISPLAY_NUM" ]; then
		break
	fi

	if ! kill -0 "$XEPHYR_PID" 2>/dev/null; then
		echo "Erro: o Xephyr terminou antes de criar o display." >&2
		exit 1
	fi

	sleep 0.1
done

start_awesome() {
	echo ">>> Awesome usando $RC"
	# -s garante que require("core") funcione mesmo com outro diretório atual.
	DISPLAY="$DISPLAY_NAME" awesome -s "$PASTA" -c "$RC" &
	AWESOME_PID=$!
}

start_awesome

echo "Monitorando: $PASTA"
echo "Pressione Ctrl+C para sair"
echo "---"

while true; do
	inotifywait -r -q \
		-e modify,create,delete,move \
		--exclude '(^|/)(\.git|\.hg|\.svn)(/|$)|\.swp$|~$' \
		"$PASTA" >/dev/null

	# Só limpa a tela quando a saída é um terminal.
	[ -t 1 ] && reset

	echo "[$(date '+%H:%M:%S')] Alteração detectada, recarregando..."

	if [ -n "$AWESOME_PID" ] && kill -0 "$AWESOME_PID" 2>/dev/null; then
		kill -HUP "$AWESOME_PID"
		echo "SIGHUP enviado para o Awesome (PID $AWESOME_PID)"
	else
		echo "Awesome não está rodando — iniciando de novo."
		start_awesome
	fi

	echo "---"
done
