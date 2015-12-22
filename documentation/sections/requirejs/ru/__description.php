<h2 class="item1">Интеграция с Require.js</h2>

<h5>
    Скрипт имеет встроенную поддержку AMD экспорта для интеграции с Require.js. Весь процесс интеграции все также
    сводится к нескольким простым шагам.
</h5>

<h3>
    Скачайте скрипт из Git'a
</h3>

<p>
    Для начала необходимо скачать данный скрипт из нашего публичного репозитория:
    <a href="http://products.git.devoffice.com/coding-development/rd-parallax">Кликабельно</a>
</p>


<h3>
    Добавьте необходимую разметку
</h3>

<p>
    HTML разметка по умолчанию для создания параллакса выглядит следующим образом.
</p>

<code>
<pre>
&lt;input type="date" class="form-input" name="date"/&gt;
</pre>
</code>

<p>
    <strong>Обратите внимание:</strong> класс может быть совершенно любым. Данном примере используется form-input, так как
                                        инициализация скрипта выполняется по данному классу.
</p>


<h3>
    Подключите стили
</h3>

<p>
    Подключите файл стилей rd-datepicker.css в секции &lt;head/&gt; целевой страницы.
</p>

<code>
<pre>
&lt;link rel="stylesheet" href="path/to/css/rd-datepicker.css"&gt;
</pre>
</code>

<h3>
    Обновите конфигурацию require.js
</h3>

<p>
    Прежде всего вам нобходимо убедиться в правильности настройки конфигурации путей в require.js. Обязательно необходимо
    определить алиасы jquery и jquery.rd-datepicker. В большинстве случаев, данная конфигурация определяется в главном скрипте
    приложения, путь к которому определяется в дата атрибуте data-main при подключении require.js
</p>

<code>
<pre>
&lt;script data-main="js/main" src="js/require.js"&gt;&lt;/script&gt;
</pre>
</code>

<p>
    Сама конфигурация должна содержать следующие алиасы для путей
</p>

<code>
<pre>
requirejs.config({
  paths: {
    "jquery": "path/to/jquery"
    "jquery.rd-datepicker": "path/to/jquery.rd-datepicker.min.js"
  }
});
</pre>
</code>

<h3>
    Выполните инициализацию скрипта
</h3>

<p>
    Для инициализации скрипта достаточно воспользоваться следующим кодом.
</p>

<code>
<pre>
requirejs(["jquery", "jquery.rd-datepicker"], function($, parallax) {
  var o = $(".rd-datepicker");
  o.RDDatePicker();
});
</pre>
</code>

