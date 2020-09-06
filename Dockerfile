# alpine系は実行速度が遅いので、debian系列のdistributionを使用推奨
# busterの中でも比較的軽量なslim-busterを選択
FROM python:3.8.5-slim-buster
ENV PYTHONUNBUFFERED 1


RUN apt-get update \
    && apt-get -y install --no-install-recommends nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# pipでインストールしたいパッケージ群の設定
RUN mkdir -p /pip_packages
WORKDIR /pip_packages
# ちょっと気持ち悪いが、requirements.txtだけはworking_directoryとは
# 別で先にコピーしておいて、パッケージをインストールしておく
COPY  ./workspace/requirements.txt /pip_packages/requirements.txt
RUN pip install -r /pip_packages/requirements.txt

# 実際に作業するworking_directoryを作成して移動
RUN mkdir /code
WORKDIR /code

# jupyter labにアクセスさせるport番号8888にする(デフォルトと同じ)
EXPOSE 8888

# jupyter lab起動 tokenは指定なししているので、セキュリティには注意
ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
CMD ["--notebook-dir=/code"]

