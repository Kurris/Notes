# Webpack 知识点

[官方中文文档]("https://www.webpackjs.com/")

## 安装

- **安装全局webpack**  `npm install webpack@版本号 -g`

- **安装本地webpack**

  1. 到项目的根目录中输入    `npm install webpack@版本号 --save-dev`
  2. 其中的 --save-dev指明webpack只在开发中使用,发布中将不再使用

## 打包

- **打包js文件**
    1. 直接在终端输入 `webpack .\src\主要.js .\dist\bundle(打包后).js`
    2. 使用配置的方式
        - 初始化 package.json和package-lock.json文件 `npm init`
        - 在项目根目录中创建webpack.config.js 文件,手动创建,添加一下代码

          ```js
          <!-- 导入node.js的path -->
          const path = require("path");

          <!-- 导出 -->
          module.exports = {

          <!-- 主要文件 -->
          entry: "./src/A.js",

          <!-- 生成的文件路径和名称,"__dirname 是node.js里面的静态变量" -->
          output: {
          path: path.resolve(__dirname, "dist"),
          filename: "bundle.js"
            <!-- } -->
          }
          ```

        - 终端使用`webpack`即可根据配置打包
        - 也可以使用package.json文件中的scripts属性,增加`"build":webpack`
        - 在终端中使用`npm run build` 等同于直接输入 `webpack`

- **打包css文件**
    1. 需要核心loader
    2. 安装css-loader `npm install css-loader@版本号 --save-dev`
    3. 安装style-loader `npm install style-loader@版本号 --save-dev`
    4. webpack.config.js文件中添加以下属性:

        ```js
        module: {
        rules: [{
            test: /\.css$/,
            use: ["style-loader","css-loader"]
          }]
       }
        ```

        - test:是匹配使用正则表达式匹配以.css结尾的文件
        - use: 使用当前的loader,这里是**从右往左**加载loader,要注意

- **打包less文件**
    1. 需要核心loader
    2. 安装less-loader,**less是less-loader的依赖**
       `npm install --save-dev less-loader@版本号 less@版本号`
    3. webpack.config.js文件中的rules添加以下属性:

        ```js
        {
            test: /\.less$/,
            use: [{
                loader: "style-loader" // creates style nodes from JS strings
            }, {
                loader: "css-loader" // translates CSS into CommonJS
            }, {
                loader: "less-loader" // compiles Less to CSS
            }]
        }
        ```

- **打包图片文件**
    1. 需要核心loader
    2. 安装url-loader `npm install  url-loader@版本号 --save-dev`
          file-loader `npm install file-loader@版本号 --save-dev`
    3. webpack.config.js文件中的rules添加以下属性:

        ```js
        {
            test: /\.(png|jpg|gif)$/,
            use: [{
                loader: 'url-loader',
                options: {
                    limit: 8192,
                     <!-- 命名规则 -->
                 name: "img/[name].[hash:8].[ext]"
                }
            }]
        }
        ```

        - limit: 大于这个值,则需要使用file-loader打包到指定文件夹

            ```js
            output: {
            path: path.resolve(__dirname, "dist"),
            filename: "bundle.js",
            <!-- 增加此属性 -->
            publicPath: "dist/"
            },
            ```

            小于的话,会将图片转成base64本地缓存加载

- **打包ES转换**
    1. 需要核心loader`npm install babel-loader babel-core babel-preset-env`
    2. webpack.config.js文件中的rules添加以下属性:

        ```js
        {
            test: /\.js$/,
            exclude: /(node_modules|bower_components)/,
            use: {
                loader: 'babel-loader',
                options: {
                    presets: ['es2015']
                }
            }
        }
        ```

    3. 重新`npm run build` ,生成的最终js文件就会转成es5代码

- **配置Vue**
    1. Vue引用方法
        - 下载vue.js文件直接引用,
        - 引用cdn中的静态vue.js
        - 使用`npm install vue -save`命令安装vue到node_modules文件夹中

    2. 在webpack.config.js文件夹中增加以下属性,让vue直接指向esm版本,否则在html中使用的templete不会被编译

        ```js

        resolve: {
            alias: {
            "vue$": "vue/dist/vue.esm.js"
            }
        }
        ```

    3. 最后就能在js文件中使用 `import Vue from "vue"`

- **在Vue文件中使用组件(使用Vue文件)**
    1. 在webpack.config.js中的resolve增加`extensions: [".vue", ".css", ".js"],`
       用于识别这些类型的文件,导入的时候不需要写后缀名

    2. 在Vue文件中导入`import Cpn from "./Cpn"`,并且添加到组件中
    3. 运行即可

- **webpack的plugin**
    1. BannerPlugin(版权信息,横幅):
        - 在webpack.config.js中导入webpack对象`const webpack = require("webpack");`
        - 在module.exports中增加属性`plugins:[new webpack.BannerPlugin("版权信息内容")]` ;

    2. html-webpack-plugin(打包html代码到dist文件夹中):
        - 安装html-webpack-plugin`npm install html-webpack-plugin@3.2.0`
        - 在webpack.config.js中导入html-webpack-plugin对象`const htmlWebpackPlugin = require("html-webpack-plugin");`
        - 属性`plugins`的数组增加

            ```js
            new htmlWebpackPlugin({
                <!-- 使用根目录的index.html文件为模板,生成的html文件会自动引用bundle.js文件 -->
            template: "index.html"
            })
            ```

        - 将`output`的`publishPath`注释,因为自动生成的index.html文件会自动引用当前目录的bundle.js文件

    3. uglifyjs-webpack-plugin(丑化js代码,压缩):
        - 安装uglifyjs-webpack-plugin`置>npm install uglifyjs-webpack-plugin --save-dev`
        - 在webpack.config.js中导入uglifyjs-webpack-plugin对象`const uglifyjsPlugin = require("uglifyjs-webpack-plugin");`

- **搭建本地服务**
    1. 安装`npm install webpack-dev-server@2.9.1 --save-dev`
    2. 增加属性

        ```js
        devServer:{
            contentBase:"./dist",  //指向index.html文件
            inline:true,           //表示为开启热更新
        }
        ```

    3. package.json文件中的script增加 `"dev":"webpack-dev-server --open"`
    4. 最后使用`npm run dev` 启动,并且做热更新

- **webpack.config.js分离**
    1. 安装`npm install webpack-merge --save-dev`
    2. 抽取共用部分放入base.config.js
       抽取发布部分放入prod.config.js
       抽取开发部分放入dev.config.js
    3. 在prod和dev部分中引入公用部分和webpack-merge对象
        `const baseConfig=require("路径")`
        `const webpackMerge = require("webpack-merge")`

    4. 使用

        ```js
       module.exports=webpackMerge.merge(baseConfig,{

        });

       ```

    5. 修改公用部分的output地址!
