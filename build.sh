# Especificamos las versiones que se utilizarán de Spark, Hadoop y JupyterLab
SPARK_VERSION="3.4.0"
HADOOP_VERSION="3.3.5"
JUPYTERLAB_VERSION="3.6.3"

# Creación de la imagen de Docker spark-master
docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  -f spark-master.Dockerfile \
  -t spark-master .

# Creación de la imagen de Docker spark-worker
docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  -f spark-worker.Dockerfile \
  -t spark-worker .

# Creación de la imagen de Docker jupyterlab
docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
  -f jupyterlab.Dockerfile \
  -t jupyterlab .
