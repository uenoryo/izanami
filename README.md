![izanami](https://user-images.githubusercontent.com/15713787/50675442-96259c80-1031-11e9-8c00-05510df31407.png)

イザナミさんは、「Dockerイメージ」「ブランチ」「サブドメイン名」の3つをHTTPリクエストで受け付けて、  
Dockerコンテナを起動し、指定されたサブドメインを用いてその環境へのリバースプロキシを提供します。

イザナミさんを動かすには、ruby 2.3以上が必要です。

## 使用例

イザナミさんを使うことによって、「このバージョンで環境を立てて動作確認したい」  
のようなことを手軽に行うことができます。

今回は、Laravelのプロジェクトで試して見ます。

### Dockerイメージをビルドしておく

イザナミさんは、指定されたdockerイメージを `docker run` してコンテナを起動するので、  
環境のセットアップとサーバの起動ができるように Dockerfile を記述します
例)

**Dockerfile**

```text:Dockerfile
FROM laradock/workspace:2.2-7.2

USER root
ENV HOME=/var/www
WORKDIR $HOME

RUN git clone git@github.com:example/laravrl.git
WORKDIR ${HOME}/laravel
RUN composer install

CMD . ./run.sh
```

コンテナには環境変数 `$GIT_BRANCH` にブランチ名が渡されるので  
`docker run` した時にチェックアウトするようにしておきます

**run.sh**

```bash:run.sh
#!/bin/bash

git fetch
git checkout $GIT_BRANCH
git pull origin

composer dump-autoload
php artisan migrate:fresh --seed
php artisan serv --port=$PORT --host=0.0.0.0
```

### イザナミさんを起動する

```sh
git clone git@github.com:uenoryo/izanami.git
bundle install
bundle exec thin -p 80 start
```

### 使い方

イザナミさんにHTTPリクエストを送ると、環境を起動してくれます。  
以下はイザナミさんを laravel-test.com に用意した場合の例です。  
`izanami.laravel-test.com` にリクエストすることによって、イザナミさんが働いてくれます。  
(サブドメイン `*.laravel-test.com` は全てlaravel-test.comを向いていなければなりません)

```
curl -H 'Content-Type:application/json' -d '{"image":"laravel-test","subdomain":"test","branch":"staging"}' http://izanami.laravel-test.com/launch
```

上記のリクエストを送ると、`laravel-test`のイメージから環境を構築し、stagingブランチにチェックアウトし、(`run.sh`)  
`http://test.laravel-test.com/` をコンテナに繋いでくれます。

環境を終了する場合は以下のリクエストを送ります。

```
curl -H 'Content-Type:application/json' -d '{"subdomain":"test"}' http://izanami.laravel-test.com/destroy
```

## 管理画面

管理画面で「サブドメイン」「イメージ」「ブランチ」を指定して  
環境を立てることも可能です

![image](https://user-images.githubusercontent.com/15713787/52175703-27cc2980-27eb-11e9-9e7c-44a5078e521e.png)
