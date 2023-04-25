## Seleccionam la imatge base
# Especificam com a imatge base una imatge Debian llleuger amb Java 8 JRE
FROM openjdk:8-jre-slim


## Descarregam e instal·lam les dependències
# Definim les variables del Dockerfile
ARG hdfs_simulat=/opt/workspace #directori compartit on simulam HDFS
ARG spark_version=3.4.0
ARG hadoop_version=3.3.5
ARG spark_master_web=8080 # port per a la interfície web del node master

# Definim les variables d'entorn amb el directori que simula HDFS
ENV HDFS_SIMULAT=${hdfs_simulat}

# Instal·lam la darrera versió estable de Python3
RUN mkdir -p ${hdfs_simulado} && \
    apt-get update -y && \
    apt-get install -y python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install gdown numpy matplotlib scipy scikit-learn

# Instal·lam Apache Spark
RUN apt-get update -y && \
    apt-get install -y curl && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz

# Definim les variables d'entorn de Spark
ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master #nom del servidor que fa de mestre
ENV SPARK_MASTER_PORT 7077 #port on s'executa el Apache Master
ENV PYSPARK_PYTHON python3

# Exposam el port perquè els nodes worker es puguin connectar al node master
EXPOSE ${SPARK_MASTER_PORT}
# Exposam el port per accedir a la interfície web del master
EXPOSE ${spark_master_web}


## Executam les ordres en arrencar el contenidor
# Montam el HDFS simulat en una carpeta amb dades persistents
VOLUME ${hdfs_simulat}
CMD ["bash"]

# Especificam la ruta de treball dins del contenidor
WORKDIR ${SPARK_HOME}

# Executam Apache Spark com a node master
CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out
