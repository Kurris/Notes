# JavaScript 知识点

## ES6

- **let**

  - 使用 let,将自变量则为**块级作用域**
  - var 会将自变量**提前**声明,并且为**全局作用域**
    <br>

- **const** 自变量编译时确定,不可修改
  <br>

- **箭头函数 (参数)=>{}** Lambda

  - 在此函数中的 `this` 会指向 **<u>最近一层代码</u>** 中,存在 `this` 对象的引用
    <br>

- **对象内方法的变化**

  ```js
  methods: {
      <!-- ES5 -->
      GetValue:function(){
          return '';
      },

      <!-- ES6 -->
      GetValue(){
           return '';
      }
  }
  ```

- **Promise** 解决回调地狱

  - 基本使用
    ```js
    new Promise((resolve, reject) => {
    	// resolve('成功的数据');
    	reject('错误的数据');
    })
    	.then(Result => {
    		console.log(Result);
    	})
    	.catch(error => {
    		console.log(error);
    	});
    ```
    <br>
  - 三种状态和其他写法

    ```js
    new Promise((resolve, reject) => {
      <!-- 状态:异步执行中 -->
      // resolve('成功的数据');
      reject('错误的数据');
    }).then(
      <!-- 状态:成功 -->
      Success => {
        console.log(Success);
      },

      <!-- 状态:失败 -->
      <!-- 在then中第二个参数为失败时执行的方法 -->
      error => {
        console.log(error);
      }
    );
    ```

    <br>

  - 链式调用

    ```js
    new Promise((resolve, reject) => {
    	resolve('1');
    })
    	.then(res => {
    		return new Promise(resolve => {
    			resolve(res + '2');
    		});
    	})
    	.then(res => {
    		return res + '3';
    	})
    	.then(res => {
    		console.log(res + '4');
    	})
    	.catch(err => {
    		console.log(err);
    	});
    ```

    <br>

  - PromiseAll 多任务同时完成,参数为数组的形式,类型为 Promise

    ```js
    Promise.all([
    	new Promise((s, e) => {
    		setTimeout(() => {
    			s('异步操作1');
    		}, 3000);
    	}),
    	new Promise((s, e) => {
    		setTimeout(() => {
    			s('异步操作2');
    		}, 1000);
    	}),
    ]).then(o => {
    	console.log(o);
    });
    ```
