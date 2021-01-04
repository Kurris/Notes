[toc]

# Vue 知识点

### 基础语法

- **初始化 Vue 对象**

  - `html` 中使用 `Mustache` 语法获取 Vue 对象属性 `data` 的值;
  - `el`挂载要管理的元素;
  - `data`定义数据;

  ```html
  <div id="app">{{msg}}</div>
  ```

  ```js
  const app = new Vue({
  	el: '#app',
  	data: {
  		msg: 'Vue初体验',
  		count: 0,
  	},
  });
  ```

- **循环**
  - 基本使用 `v-for="item in 数组名称"` , `v-for="val,index in 数组名称"`
  - 必须绑定 **key**
- **声明周期函数(Vue 对象从诞生到销毁)**
- **Mustache 语法(插值语法)**
  - 一般使用 {{msg}} ,结果:Vue 初体验;
  - 其他用法,使用简单运算 {{count+1}} ,结果:1;
  - v-once 只会渲染一次,没有表达式;
    - ```html
      <div v-once id="app">{{msg}},个数{{count+1}}</div>
      ```
  - v-html,将`html`字符串解析;
  - v-text="属性名" 等同于`Mustache`语法
  - v-pre,不解析`Mustache`语法
  - v-cloak,配合样式使用,当 `Vue` 对象没有初始化,将会使用该样式
    ```css
    [v-cloak] {
    	display: none;
    }
    ```
- **动态绑定属性 v-bind(简写使用 '<u>:</u>' )**

  - 基本使用 `v-bind:src`,`v-bind:img`;
  - `v-bind:class`,动态改变样式

    - 对象语法
      ```html
      v-bind: class= "{active:true,key:value}";
      ```
    - 数组语法

      ```html
      v-bind: class= "[样式名称A,样式名称B]";
      ```

  - `v-bind:style`,动态改变样式与上述一样

- **计算属性**
  > 内部实现 getter(),get 和 setter(),set 方法,会有缓存
  ```js
  computed: {
    fullName(){
        //逻辑处理,返回结果
        return xxxx;
    }
  }
  ```
- **事件监听**

  - 基本使用 `v-on:click` 或者 `@click`
  - 参数传递
    - 无参数,方法不需要括号,默认传递点击事件对象`MouseEvent`
    - 有参数,但是同时需要`MouseEvent`对象,方法执行时,必须使用`$event`表示`MouseEvent`对象;
  - 修饰符
    - .stop 阻止冒泡
    - .once 只触发一次
    - .prevent 阻止默认事件
    - .enter/.a/.b 某个按键触发

- **逻辑判断 v-if/v-elseif/v-else**

  - `Vue`在满足条件时增减代码
  - v-show `Vue`在满足条件时,对样式代码处理
  - 使用`key`,取消`Vue`内部的算法复用

- **数组中能够触发响应式的方法**

  ```js
  this.arr.push(2);
  this.arr.pop(); //删除尾元素;
  this.arr.shift(); //删除头元素
  this.arr.unshift(5); //添加头元素
  this.arr.splice(start, count, 元素); //删除/添加/替换
  this.arr.sort(); //排序
  this.arr.reverse(); //反转
  Vue.set(obj,,,)
  ```

- **过滤器 filter**

  ```html
  <td>{{item.price|showfinal}}</td>
  ```

  ```js
  filters: {
          showfinal(price) {
              return "¥" + price.toFixed(2);
          }
      }
  ```

- **双向绑定**
  > 原理是内部使用了@input 和:value
  - 基本使用 `v-model=""`,会自动绑定属性`Value`
  - v-model:radio 绑定同一个属性,实现单选(原生是区分 `name` 属性)
  - v-model:checkbox
    - 场景:统一协议
    - 多个选择,v-model 绑定数组
  - v-model:select
    - 单选,绑定一个属性即可
    - 多选 `select` 标记`multiple`属性,绑定数组
  - 修饰符
    - lazy 在回车和失去焦点时才获取数据
    - trim 将空格去掉
    - number/string 数据类型转换

### 组件化

- 基本使用

  ```html
  <div id="app">
  	<cpn></cpn>
  </div>
  ```

  ```js
  // 定义一个组件
  const cpn = Vue.extend({
  	template: `
        <div>
            <input type="text">
        </div>
        `,
  });
  // 注册全局组件
  Vue.component('cpn', cpn);

  //创建Vue对象,作用域是id为app的div
  var a = new Vue({
  	el: '#app ',
  	data: {
  		msg: 'AAA',
  		age: 0,
  	},
  });
  ```

- 全局组件和局部组件

  > 全局组件:直接在全局 Vue 对象注册
  > 局部组件:在某一个 Vue 的对象中注册
  > 在哪里注册,在哪里使用!!!!

- 组件分离
  > 使用<template id="app">标签定一个组件内容
  > 注册
- 组件 component 中的 data 属性必须是一个方法,因为组件涉及到复用,而方法返回的对象引用单独区分

- 父子组件中的通信

  - 在组件中的属性`props`中定义数据字段,用于获取父组件的信息
  - 子组件使用`this.$emit("方法名称",数据)`发送一个方法给到父组件

    ```html
    <cpn @itemclick="pevent" :gametype="selectedgame"></cpn>
    ```

    ```js
    props: {
        gametype: {
            type: String,
            default: "无",
        },
    },
    data() {
    				return {
    					dgametype: this.gametype,
    				};
    			},
    watch: {
    				dgametype(newval, oldval) {
    					console.log(newval + '  ' + oldval);
    					this.$emit('itemclick', newval);
    				},
    			},
    ```

- 父子组件之间直接访问

  1. this.$children 访问当前所有子组件
  2. this.$refs 访问所有子组件,如果在组件元素中标记 ref="key",可以用过 key 来查找特定子组件
  3. this.$root 访问当前组件的根组件
  4. this.$parent 访问当前的父组件

- 插槽 Slot

  - 基本使用,在组件`template`中使用`<slot>`标签
  - 如果<slot>中可以添加默认样式
  - 使用<slot name="a">标记插槽名称为"a",使用组件的时候<slot name="a"> <h2>Title1</h2></slot>
  - 插槽作用域

    ```html
    <slot name="a" :zheshislotdata="arrlanguage">
    	<ul>
    		<li v-for="item in arrlanguage">{{item}}</li>
    	</ul>
    </slot>

    <div slot="a" slot-scope="dataA">
    	<li>{{dataA.zheshislotdata.join(" ⭐ ")}}</li>
    </div>
    ```

    - 父组件改变子组件的数据展示方式
    - `:zheshislotdata`是创造一个对外开放的属性
    - `slot-scope="dataA"` 返回一个访问子组件开放的属性

### 脚手架

- 安装(全局) `npm install @vue/cli -g`

- 查看版本 `vue --version`

- 初始化脚手架项目

  1.  cli3 `vue create proj-name`

  2.  cli2 `vue init webpack proj-name`

### Router

- 简单使用

  - 安装 `npm intall vue-router --save`
  - 创建文件夹 router,创建 index.js 文件
  - 导入对象,vue 注册全局 router 对象
  - router 增加映射关系,缺省页还有路由模式为 history

    ```js
    import vueRouter from 'vue-router';
    import vue from 'vue';
    import Home from '../components/Home.vue';
    import About from '../components/About.vue';

    //注册router
    vue.use(vueRouter);

    const routes = [
    	{
    		path: '',
    		redirect: '/Home',
    	},
    	{
    		path: '/Home',
    		component: Home,
    	},
    	{
    		path: '/About',
    		component: About,
    	},
    ];
    const router = new vueRouter({
    	routes,
    	mode: 'history',
    	linkActiveClass: 'active',
    });
    export default router;
    ```

  - 要点说明
    - 使用 `router-link to='/Home'`标签属性 重定向到主页
    - 使用 `router-view` 标签 指示显示的位置
    - 使用 `replace` 标签属性指定底层使用 `history.replaceState(path)` 方法
    - 使用 `linkActiveClass: 'active'`的 `vue-router` 属性指定选中样式
    - 使用 `tag` 标签属性指示渲染的样式,例如渲染成 `button`/`li`
    - 使用 `this.$router.push/replace('/Home')`在代码中重定向

- 动态路由

  - 在 `routes` 数组中增加
    ```js
    {
    	path: '/User/:UserId',
    	component: User,
    },
    ```
  - 导入 `User` 组件,并且在上述的数组中注册
  - 在原格式的`/User`后面添加`/:UserId`,其中`UserId` 为占位符
  - 使用 `v-bind` 绑定 `to` 属性
    ```html
    <router-link :to="'/User/'+uid">用户</router-link>
    ```
  - 在子组件 User 中的模板代码`template`中使用`$route.params.UserId`获取
    或者在代码中使用`this.\$route.params.UserId`

- 懒加载路由

  ```js
  import User from '../components/User.vue';
  const User = () => import('../components/User.vue');
  ```

- 嵌套路由

  - 在父路由组件中添加属性` children: []`,增加路由
  - 子路由不需要前缀"/"
  - 在使用时需要把父路由和子路由拼接一起

- 路由传递参数

  - 通过占位符的参数方式 `/User/:UserId`,`$route.params.UserId`
  - 通过 query 的方式, `$route.query.参数名`

- 路由守卫

  > 组件之间的"中间件"

  - 在`routes`数组中增加`meta`属性,增加`title`属性标记当前组件的标题,
    在路由中使用:

    ```js
    // 这里是路由守卫,属于"全局路由入口"
    router.beforeEach((to, from, next) => {
    	//修改标题,这里使用matched[0]是因为可能存在嵌套路由
    	document.title = to.matched[0].meta.title;
    	//没有next就不会进行下一步,类似于中间件
    	next();
    });
    ```

  - 在`routes`数组中的组件注册路由时,实现`beforeEnter`方法

    ```js
    beforeEnter: (to, from, next) => {
    	console.log('这里是About局部路由守卫');
    	next();
    },
    ```

  - 在组件自身实现`beforeRouteEnter`方法
    ```js
    beforeRouteEnter(to, from, next) {
    console.log("Home的组件路由守卫");
    next();
    },
    ```

- 路由 Keep-alive

  > 将路由保存存活状态,对组件只创建一次并缓存起来

  - 使用`Keep-alive`标签将组件显示的`router-view`包括起来
    ```html
    <keep-alive>
    	<router-view />
    </keep-alive>
    ```
  - 增加组件数据属性`currentPath`赋予默认值,并且在组件中实现 `activated` 方法和 `beforeRouteLeave` 方法,记得将路由中的默认导航注释`redirect`

    - 激活组件时,使用代码指定默认显示

    ```js
    activated() {
    this.$router.push(this.currentPath);
    },
    ```

    - 离开组件时,记录当前值

    ```js
    beforeRouteLeave(to, from, next) {
    this.currentPath = this.$route.path;
    next();
    },
    ```

    - 这样就能实现 Keep-alive 的效果,当然,如果没有 Keep-alive 的标签,
      `activated`和`deactivated`方法并不会实现

   <br>

  - 使用`exclude`/`include`,填入需要排除/包括 KeepAlive 的组件
    - 多个使用逗号隔开,中间不能有空格

### Vuex 状态管理(单例管理对象,可响应式)

- 安装 `npm install vuex --save`
- 创建文件夹``store,创建文件`index.js`

  ```js
  import Vue from 'vue';
  import Vuex from 'vuex';
  Vue.use(Vuex);

  const store = new Vuex.Store({
  	state: {
  		counter: 10,
  	},
  	mutations: {
  		add(state) {
  			state.counter++;
  		},
  		add(state, count) {
  			state.counter + count;
  		},
  		sub(state) {
  			state.counter--;
  		},
  		//此处使用setTimeout会有异步操作,devtools可能追踪不到变化结果
  		testAsync(state) {
  			setTimeout(() => {
  				state.counter++;
  			}, 1000);
  		},
  		testAsyncByAction(state) {
  			state.counter++;
  		},
  	},
  	actions: {
  		atestAsync(context, payload) {
  			return new Promise((resolve, reject) => {
  				setTimeout(() => {
  					context.commit('testAsyncByAction');
  					resolve(payload);
  				}, 2000);
  			});
  		},
  	},
  	getters: {
  		counterAddOne(state) {
  			return state.counter + 1;
  		},
  	},
  	modules: {},
  });
  export default store;
  ```

- 通过在`mutations`中定义方法修改状态(可被跟踪)

  - 在`mutations`中的方法必须为同步方法,否则 devtools 可能追踪不到数据变化
  - 无参数`$store.commit('add')`
  - 带参数`$store.commit('add',5)`
  - 另一种风格: 此时`mutations`的方法接受的参数为对象

    ```js
    $store.commit({
    	type: 'add',
    	count,
    });
    ```

  - 如果`state`中存在数组数据,并且对它进行操作的时候,需要使用响应式方法

    - 改变一个键的值 `Vue.set`
    - 删除一个键 `Vue.delete`

- `getters` 类似于自动属性

  - `this.$store.getters.counterAddOne`

- `actions` 用于使用全局的异步方法

  - 在 Action 中的方法可以接受到一个`context`的上下文对象,在方法中使用异步并且该对象可以用`commit`方法来触发`mutations`的同步方法进行回调修改
  - 此处的异步方法可以被 Promise 包装起来

- `modules`中可以使用与`store`一样的属性

  ```js
  const ModuleA = {
  	state: {
  		name: 'Ligy',
  	},
  	mutations: {
  		showName(state, payload) {
  			console.log(state.name + '  ' + payload);
  		},
  	},
  	getters: {},
  	actions: {},
  };
  ```

  - 使用:

    - `states`
      `$store.state.a.name`
    - `mutations` 用于与`store`中一样,先寻找`store`中的方法,再到`modues`中寻找
      `$store.commit('方法名称')`
    - `getters`
      ```js
      fullName(state, rootGetters, rootState) {
      return state.name + rootGetters.counterAddOne + rootState.counter;
      },
      ```
    - `actions` 与`store`一致

### AXIOS

- 安装 `npm install axios`
- get 请求

  - 普通的请求方法

  ```js
  axios({
  	url: 'http://123.207.32.32:8000/home/multidata',
  }).then(res => {
  	console.log(res);
  });
  ```

  - 带参数的 get 请求

  ```js
  axios({
  	url: 'http://123.207.32.32:8000/home/data',
  	params: {
  		参数名A: '',
  		参数名B: '',
  	},
  }).then(res => {
  	console.log(res);
  });
  ```

  - 显式使用

  ```js
  axios.get({
  	url: 'http://123.207.32.32:8000/home/data',
  });
  ```

- 配置

  - `axios.defaults.属性名=''`

- 实例

  - `axios.create()`

- 拦截器

  ```js
  axios.interceptors.request.use(
  	config => {
  		// 请求前处理,如果不返回,则请求异常
  		return config;
  	},
  	err => {
  		console.log(err);
  	}
  );

  axios.interceptors.response.use(
  	config => {
  		return config.data;
  	},
  	err => {
  		console.log(err);
  	}
  );
  ```
