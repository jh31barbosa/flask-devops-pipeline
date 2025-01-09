# Use a imagem oficial do Python
FROM python:3.9-slim

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie os arquivos da pasta web-interface para dentro do container
COPY web-interface/ /app/

# Copie o requirements.txt para o diretório de trabalho
COPY web-interface/requirements.txt /app/

# Instale as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Exponha a porta 5000 para a aplicação Flask e a porta 9090 para o Prometheus
EXPOSE 5000
EXPOSE 9090

# Defina o comando para iniciar a aplicação Flask
CMD ["python", "app.py"]
