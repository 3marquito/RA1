#!/usr/bin/env bash
# RA1 - Grupo 7 | Tienda Bodeguita
# Crea el repositorio, el proyecto (tablero) y 1 issue por requisito funcional.
# Antes:  1) instalar GitHub CLI (https://cli.github.com)
#         2) gh auth login
#         3) gh auth refresh -s project
# Uso:    bash setup_github_bodeguita.sh
set -e

# ====== EDITA SOLO ESTO ======
REPO="RA1-Bodeguita-Ventas-Inventario"
OWNER="$(gh api user -q .login)"
PROYECTO="RA1 - Bodeguita"
# Usuarios de GitHub de los 4 integrantes (se reparten los issues en rotacion)
EQUIPO=("usuario1" "usuario2" "usuario3" "usuario4")
# =============================

echo ">> Creando repositorio"
gh repo create "$OWNER/$REPO" --public --add-readme \
  --description "TPA RA1 - Aplicacion multiplataforma de ventas, inventario y atencion en caja (Bodeguita)"

echo ">> Creando proyecto"
NUM=$(gh project create --owner "$OWNER" --title "$PROYECTO" --format json -q .number)
gh project link "$NUM" --owner "$OWNER" --repo "$OWNER/$REPO"

gh label create "requisito-funcional" --color 0E8A16 --repo "$OWNER/$REPO" --force
gh label create "prioridad-alta"      --color D93F0B --repo "$OWNER/$REPO" --force
gh label create "prioridad-media"     --color FBCA04 --repo "$OWNER/$REPO" --force

i=0
issue () {   # $1 titulo | $2 prioridad | $3 cuerpo
  gh issue create --repo "$OWNER/$REPO" --title "$1" --body "$3" \
    --label "requisito-funcional" --label "$2" \
    --assignee "${EQUIPO[$((i % ${#EQUIPO[@]}))]}" --project "$PROYECTO"
  i=$((i+1))
}

echo ">> Creando issues (uno por requisito funcional)"

issue "RF01 - Registrar cliente" "prioridad-alta" "**HU-01** | Como cajero quiero registrar un cliente para asociarle sus compras.

**Criterios de aceptación**
- [ ] Permite ingresar nombre, apellido, DNI y teléfono
- [ ] Valida que los campos no estén vacíos
- [ ] Valida DNI de 8 dígitos y teléfono de 9 dígitos
- [ ] Valida que el DNI no esté repetido
- [ ] Confirma el registro

**Estructura:** arreglo de objetos cliente."

issue "RF02 - Buscar cliente" "prioridad-alta" "**HU-02** | Como cajero quiero buscar un cliente para atenderlo rápidamente en caja.

**Criterios de aceptación**
- [ ] Permite escribir el DNI a buscar
- [ ] Muestra los datos del cliente encontrado
- [ ] Muestra mensaje si no existe

**Algoritmo:** búsqueda lineal, O(n)."

issue "RF03 - Registrar producto" "prioridad-alta" "**HU-03** | Como administrador de tienda quiero registrar productos para tener el catálogo disponible para la venta.

**Criterios de aceptación**
- [ ] Permite ingresar nombre, precio y stock
- [ ] Precio mayor a 0 y stock no negativo
- [ ] Confirma el registro

**Estructura:** arreglo de objetos producto."

issue "RF04 - Listar y actualizar producto" "prioridad-media" "**HU-04** | Como administrador de tienda quiero ver y modificar los productos para mantener precios y stock actualizados.

**Criterios de aceptación**
- [ ] Muestra la lista de productos
- [ ] Permite editar precio y stock
- [ ] Rechaza valores inválidos"

issue "RF05 - Eliminar producto" "prioridad-media" "**HU-05** | Como administrador de tienda quiero eliminar productos descontinuados para mantener el catálogo ordenado.

**Criterios de aceptación**
- [ ] Pide confirmación antes de eliminar
- [ ] Muestra error si el producto no existe
- [ ] No permite eliminar si hay pedidos pendientes en la cola"

issue "RF06 - Registrar venta" "prioridad-alta" "**HU-06** | Como cajero quiero registrar una venta para descontar el stock y guardar la compra del cliente.

**Criterios de aceptación**
- [ ] Verifica que el cliente y el producto existan
- [ ] Valida stock disponible (stock - reservado en la cola)
- [ ] Envía el pedido a la cola de atención
- [ ] El stock se descuenta al confirmar el pedido"

issue "RF07 - Cola de atención en caja" "prioridad-alta" "**HU-07** | Como cajero quiero atender a los clientes en orden de llegada para que la atención sea justa y ordenada.

**Criterios de aceptación**
- [ ] Agrega el pedido al final de la cola
- [ ] Atiende primero al que llegó primero (FIFO)
- [ ] Permite confirmar o rechazar el pedido
- [ ] Avisa cuando la cola está vacía

**Estructura:** Cola (ColaCajaBodeguita)."

issue "RF08 - Historial de ventas" "prioridad-media" "**HU-08** | Como administrador de tienda quiero ver primero las últimas ventas para controlar la actividad reciente del turno.

**Criterios de aceptación**
- [ ] Guarda cada venta resuelta en el historial
- [ ] Muestra primero la venta más reciente (LIFO)
- [ ] Permite ver el historial completo

**Estructura:** Pila (PilaHistorialVentas)."

echo ">> Listo: https://github.com/users/$OWNER/projects/$NUM"
echo ">> Falta (en la web): renombrar las columnas de Status y subir tu codigo."
