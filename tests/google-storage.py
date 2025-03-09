from google.cloud import storage

def test_gcs_connection():
    try:
        # Se usa la autenticación predeterminada en el pod
        client = storage.Client()

        # Listar los buckets accesibles
        buckets = list(client.list_buckets())

        if not buckets:
            print("No hay buckets disponibles.")
        else:
            print("Buckets disponibles:")
            for bucket in buckets:
                print(f"- {bucket.name}")

    except Exception as e:
        print(f"Error al conectar con Google Cloud Storage: {e}")


def upload_dummy_file(bucket_name, destination_blob_name):
    try:
        # Se usa la autenticación predeterminada del pod
        client = storage.Client()

        # Crear un archivo dummy
        dummy_content = "Este es un archivo de prueba en Google Cloud Storage."
        local_file_path = "/tmp/dummy_file.txt"

        with open(local_file_path, "w") as file:
            file.write(dummy_content)

        # Obtener el bucket
        bucket = client.bucket(bucket_name)

        # Subir el archivo
        blob = bucket.blob(destination_blob_name)
        blob.upload_from_filename(local_file_path)

        print(f"Archivo subido exitosamente a gs://{bucket_name}/{destination_blob_name}")

    except Exception as e:
        print(f"Error al subir el archivo: {e}")

if __name__ == "__main__":
    test_gcs_connection()
    bucket_name = "synthaud-dev-app-bucket"  # Cambia esto por tu bucket
    destination_blob_name = "dummy_file.txt"  # Nombre con el que se guardará en GCS
    upload_dummy_file(bucket_name, destination_blob_name)
