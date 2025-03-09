import redis

# Configura la conexión con Memorystore
REDIS_HOST = "redis.internal.synthaud.app"  # Reemplaza con la IP privada de Memorystore
REDIS_PORT = 6379  # Puerto por defecto de Redis

def test_redis_connection():
    try:
        # Crear la conexión (usando `Redis` en lugar de `StrictRedis`)
        client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

        # Probar si Redis está disponible
        pong = client.ping()
        if pong:
            print("✅ Conexión exitosa a Redis en Memorystore")

        # Guardar un valor de prueba
        client.set("test_key", "Hola desde Kubernetes!")

        # Recuperar el valor
        value = client.get("test_key")
        print(f"🔹 Valor obtenido desde Redis: {value}")

    except Exception as e:
        print(f"❌ Error al conectar con Redis: {e}")

if __name__ == "__main__":
    test_redis_connection()