애플리케이션은 성능을 위해 멀티 스레드를 많이 활용하지만, UI를 업데이트하는 데는 단일 스레드 모델이 적용된다. 멀티 스레드로 UI를 업데이트하면 동일한 UI 자원을 사용할 때 교착 상태(deadlock), 경합 상태(race condition) 등 여러 문제가 발생할 수 있다. 따라서 UI 업데이트를 메인 스레드에서만 허용한다.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6639993b-3b70-451d-a7de-bef3e3094670/_2021-02-01__10.57.17.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6639993b-3b70-451d-a7de-bef3e3094670/_2021-02-01__10.57.17.png)

경쟁상태 ([https://ko.wikipedia.org/wiki/경쟁_상태](https://ko.wikipedia.org/wiki/%EA%B2%BD%EC%9F%81_%EC%83%81%ED%83%9C))

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a1b98987-3d96-40c0-b0df-2cd0c2cdebd1/_2021-02-01__11.00.46.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a1b98987-3d96-40c0-b0df-2cd0c2cdebd1/_2021-02-01__11.00.46.png)

교착상태 ([https://ko.wikipedia.org/wiki/교착_상태](https://ko.wikipedia.org/wiki/%EA%B5%90%EC%B0%A9_%EC%83%81%ED%83%9C))

앱 프로세스가 시작되면서 메인 스레드가 생성된다. 컴포넌트의 생명주기 메서드와 그 안의 메서드 호출은 기본적으로 메인 스레드에서 실행된다. 메인 스레드는 UI를 변경할 수 있는 유일한 스레드이기 때문에 메인 스레드를 UI 스레드로 부르기도 한다. 서비스, 브로드캐스트 리시버, Application은 사용자 인터페이스가 아니기 때문에, UI 스레드에서 실행된다고 하면 개념을 혼동하기 쉽다. UI를 변경하는 유일한 수단이라는 의미를 강조하기 위해서 UI 스레드를 쓴다고 이해하면 편할 것 같다.

- 안드로이드 애플리케이션에서 메인 스레드

안드로이드 프레임워크 내부 클래스인 android.app.ActivityThread가 애플리케이션의 메인 클래스이고, ActivityThread의 main() 메서드가 애플리케이션의 시작 지점이다. ActivityThread는 어떤 것도 상속하지 않은 클래스다. 액티비티만 관련되어 있는 것도 아니고 모든 컴포넌트들이 다 관련되어 있다.

AppCompatActivity → FragmentActivity → ComponentActivity → androidx.core.app.ComponentActivity → Activity → ActivityThread 로 들어가면 볼 수 있다.

```kotlin
ActivityThread.java

public static void main(String[] args) {
    /* ..*/
    Looper.prepareMainLooper();  // 1번
		/* .. */
    ActivityThread thread = new ActivityThread();
    thread.attach(false, startSeq);
  
    if (sMainThreadHandler == null) {
        sMainThreadHandler = thread.getHandler();
    }
		/* .. */   
		Looper.loop(); // 2번

    throw new RuntimeException("Main thread loop unexpectedly exited");
}
```

1번 → 메인 Looper를 준비한다.

2번 → UI Message를 처리한다. Looper.loop() 메서드에서 무한 반복문이 있기 때문에 main() 메서드는 프로세스가 종료될 때까지 끝나지 않는다.

<aside>
💡 **Looper 클래스**

</aside>

- 스레드별로 Looper 생성
    
    -Looper는 TLS(thread local storage)에 저장되고 꺼내어진다. ThreadLocal<Looper>에 set() 메서드로 새로운 Looper를 추가하고, get() 메서드로 Looper를 가져올 때 스레드별로 다른 Looper가 반환된다. 그리고 Looper.prepare()에서 **스레드별로 Looper를 생성**한다. 특히 메인 스레드의 메인 Looper는 ActivityThread의 main() 메서드에서 Looper.prepareMainLooper()를 호출하여 생성한다. Looper.getMainLooper()를 사용하면 어디서든 메인 Looper를 가져올 수 있다.
    
- Looper별로 MessageQueue 가짐
    
    -**Looper는 각각의 MessageQueue를 가진다**. 특히 메인 스레드에서는 이 MessageQueue를 통해서 UI작업에서 경합 상태를 해결한다. 
    

<aside>
💡 **Message와 MessageQueue**

</aside>

**MessageQueue는 Message를 담는 자료구조**이다. 

Message를 생성할 때는 오브젝트 풀에서 가져온다.  오브젝트 풀은 Message를 최대 50개까지 저장한다.

<aside>
💡 **Handler 클래스**

</aside>

**Handler는 Message를 MessageQueue에 넣는 기능과 MessageQueue에서 꺼내 처리하는 기능을 함께 제공**한다.

```java
Handler()
Handler(Handler.Callback callback)
Handler(Looper looper)
Handler(Looper looper, Handler.Callback callback)
```

Handler에는 4가지 생성자가 있다. **Handler는 Looper(결국 MessageQueue)와 연결**되어 있다. 기본 생성자는 바로 생성자를 호출하는 스레드의 Looper를 사용하겠다는 의미이다. 메인 스레드에서 Handler 기본 생성자는 앱 프로세스가 시작할 때 ActivityThread에서 생성한 메인 Looper를 사용한다. Handler 기본 생성자는 UI 작업을 할 때 많이 사용된다. 

- Handler 동작
    
    -위에서 언급했듯이 Handler는 Message를 MessageQueue에 보내는 것과 Message를 처리하는 기능을 함께 제공한다. post(), postAtTime(), postDelayed() 메서드를 통해서 Runnable 객체도 전달되는데, Runnable도 내부적으로 Message에 포함 되는 값이다.
    
- Handler 용도
    
    -Handler는 일반적으로 UI 갱신을 위해 사용된다.
    
    1. 백그라운드 스레드에서 UI 업데이트 : 백그라운드 스레드에서 네트워크나 DB 작업 등을 하는 도중에 UI를 업데이트 한다. AsyncTask에서도 내부적으로 Handler를 이용해서 onPostExecute() 메서드를 실행해서 UI를 업데이트한다.
    2. 메인 스레드에서 다음 작업 예약 : UI 작업 중에 다음 UI 갱신 작업을 MessageQueue에 넣어 예약한다. 작업 예약이 필요한 경우가 있는데, 예를 들어 Activity의 onCreate() 메서드에서(소프트 키보드를 띄우는 것이나, ListView의 setSelection()) 작업을 할 경우 잘 동작하지 않는다. 이때 Handler에 Message를 보내면 현재 작업이 끝난 이후의 다음 타이밍에 Message를 처리한다.
    
- Handler의 타이밍 이슈
    
     -원하는 동작 시점과 실제 동작 시점에서 차이가 생기는데, 이런 타이밍 이슈는 메인 스레드와 Handler를 이해하고 나면 해결할 수 있다. Activity의 onCreate() 메서드에서 Handler의 post() 메서드를 실행하면 어느 시점에 실행될까? 실제 post() 메서드에 전달되는 Runnable이 실행되는 시점은 언제일까? 메인 스레드에서는 한 번에 하나의 작업밖에 못하고, 여러 작업이 서로 엉키지 않기 위해서 메인 Looper의 MessageQueue에서 Message를 하나씩 꺼내서 처리한다는 것을 염두에 두자. 
    
    MessageQueue에서 Message를 하나 꺼내오면 onCreate() ~ onResume()까지 쭉 실행이 된다. 그럼 답은 나왔다. **onCreate()에서 Handler의 post()에 전달한 Runnable은 onResume() 이후에 실행**된다.
    
- 지연 Message는 처리 시점을 보장할 수 없다.
    
    -Handler에서 전달된 지연 Message는 지연 시간을 정확하게 보장하지 않는다. MessageQueue에서 먼저 꺼낸 Message 처리가 오래 걸린다면 실행은 당연히 늦어진다.
    
    예를들어 0.2초 후에 로그는 남기는 Handler가 있고 0.5초를 멈추는 Handler가 있다고 가정하면 로그를 남기는 Handler는 0.2초 후가 아닌 0.5초가 지난 후에 로그를 남긴다.
    

<aside>
💡 **ANR (Application Not Responding)**

</aside>

어느 동작에서 메인 스레드를 오랫동안 점유하고 있다는 의미이다. 

안드로이드 프레임워크에서 ANR 관련한 내용은 com.android.server.am.ActivityManagerService에서 확인 할 수 있다.(ActivityManagerService는 system_server 프로세스에서 실행된다)

```java
static final int BROADCAST_FG_TIMEOUT = 10 * 1000;
static final int BROADCAST_BG_TIMEOUT = 60 * 1000;
static final int KEY_DISPATCHING_TIMEOUT = 5 * 1000;
```

- 화면 터치와 키 입력에서 ANR
    
    -메인 스레드를 어디선가 이미 점유하고 있다면 키 이벤트를 전달하지 못하는데, 이벤트를 전달할 수 없는 시간이 타임아웃을 넘는다면 이때 ANR이 발생한다. **키 이벤트인 볼륨, 메뉴, 백 키의 경우는 눌리고서 5초 이상 지연 시 바로 ANR을 발생**시킨다. 참고로 홈 키와 전원 키는 앱과 별개로 동작하고 ANR 발생과는 무관하다.
    
    터치 이벤트는 경우가 다르다. 터치 이벤트도 메인 스레드가 사용 중이라면 대기하는 것은 동일하지만 타임아웃 된다고 해서 바로 ANR이 발생하지 않는다. 그 다음으로 이어서 터치 이벤트가 왔을 떄는 **두 번째 터치 이벤트가 전달되지 않는 시간이 타임아웃되면 ANR이 발생**한다. 예를들어, 어디선가 메인 스레드를 블로킹하고 있는데 이때 첫 번째 터치 이벤트만으로는 ANR이 발생하지 않는다. 두 번째 터치 이벤트가 있고서 5초가 지나면 그때서야 ANR이 발생한다.
    
- Message 처리 각각이 5초 이내라도 총합 처리 시간 영향
    
    -가끔 혼동하는 경우가 있는데 특정 Message 처리가 5초가 넘더라도 그 사이에 터치가 없을 때는 문제가 발생하지 않는다. 예를들어, for문을 0부터 4까지 돌리는데 2초씩 메인 스레드를 블로킹하고 있다고 가정하자. 5개의 Message를 처리하는 시간은 총 10초다. 가만히 두면 문제가 없다. **하지만 Message를 처리하는 중에 화면을 두 번 이상 터치하면 ANR이 발생**한다. (앞에 쌓여있는 Message를 먼저 처리하느라 터치 이벤트에 대한 처리가 지연되는 것)
    
- 서비스나 브로드캐스트 리시버에서도 5초 이내로 Message 처리 필요
    
    -예를 들어 50초 동안 BroadcastReceiver의 onReceive()가 실행되고 있을 때 액티비티 화면을 터치하면 역시 ANR 발생 가능성이 높다. 브로드캐스트 리시버나 서비스도 액티비티가 떠있는 상태를 고려해서, 타임아웃을 5초라고 생각하는 편이 낫다. **결론적으로 브로드캐스트 리시버의 경우에 오래 걸리는 작업이 있다면 서비스로 넘겨서 실행해야 하고, 서비스에서는 다시 백그라운드 스레드를 이용**해야 한다.
    

---