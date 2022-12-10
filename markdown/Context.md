### Context

Context가 없으면 액티비티를 시작할 수도, 브로드캐스트를 발생시킬 수도, 서비스를 시작할 수도 없다. 리소스에 접근할 떄도 Context를 통해서만 가능하다. Context는 여러 컴포넌트의 상위 클래스이다.

Context는 추상 클래스인데 메서드 구현이 거의 없고 상수 정의와 추상 메서드로 이루어진다. Context를 직접 상속한 것은 ContextWrapper이고 ContextWrapper를 상속한 것은 

Activity, Service, Application이다. (BroadCastReceiver와 ContentProvider는 Context를 상속한 것이 아님)

### ContextWrapper 클래스

ContextWrapper 클래스는 Context를 래핑한 ContextWrapper(Context base) 생성자를 갖고 있다.

```kotlin
public ContextWrapper(Context base) { // 1
    mBase = base;
}

protected void attachBaseContext(Context base) { // 2
    if (mBase != null) {
        throw new IllegalStateException("Base context already set");
    }
    mBase = base;
}

public Context getBaseContext() {
    return mBase;
}

@Override
public Context getApplicationContext() {
    return mBase.getApplicationContext();
}

@Override
public void startActivity(Intent intent) {
    mBase.startActivity(intent);
}

@Override
public void sendBroadcast(Intent intent) {
    mBase.sendBroadcast(intent);
}

@Override
public Resources getResources() {
    return mBase.getResources();
}
```

1, 2 에서 base 파라미터에 전달되는 것은 Context의 여러 메서드를 직접 구현한 ContextImpl 인스턴스이다.

ContextWrapper의 여러 메서드는 base의 메서드를 그대로 다시 호출한다. Activity, Service, Application은 1의 생성자를 사용하지 않고, 실제로는 2의 attachBaseContext() 메서드를 사용한다.

Activity, Service, Application 모두 내부적으로 ActivityThread에서 컴포넌트가 시작된다. 이떄 각 컴포넌트의 attach() 메서드를 실행하고 attach() 메서드에서 또다시 attachBaseContext() 메서드를 호출한다.

ContextWrapper에 getBaseContext()와 getApplicationContext()라는 2개의 메서드가 별도인 것을 보면 싱글톤이 아닌 것을 알 수 있다.

Activity, Service, Application 컴포넌트는 각각 생성한 ContextImpl을 하나씩 래핑하고 있고 getBaseContext()는 각각 ContextImpl 인스턴스를 리턴한다.

getApplicationContext()는 Application 인스턴스를 리턴하는 것으로 Application은 앱에서 1개밖에 없고 어디서나 동일한 인스턴스를 반환한다.

### ContextImpl의 메서드

- 앱 패키지 정보를 제공하거나 내/외부 파일, SharedPreferences, 데이터베이스 등을 사용하기 위한 헬퍼 메서드
- Activity, BroadcastReceiver, Service와 같은 컴포넌트를 시작하는 메서드와 퍼미션 체크 메서드
- ActivityManagerService를 포함한 시스템 서비스에 접근하기 위해서 getSystemService() 메서드

### Context와 하위 클래스

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0d5abf95-991d-442f-b2db-e89a030c7e5f/d0fc31d12b93ba6fdbbdd63788a5fd6a.jpeg](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0d5abf95-991d-442f-b2db-e89a030c7e5f/d0fc31d12b93ba6fdbbdd63788a5fd6a.jpeg)

Activity, Service, Application을 보면 ContextImpl을 직접 상속하지 않고, ContextImpl의 메서드를 호출하는 형태라는 것을 알 수 있다.

이렇게 하면 ContextImpl의 변수가 노출 되지 않고, ContextWrapper에서는 ContextImpl의 공개 메서드만 호출하게 된다. 또한 각 컴포넌트별로 사용하는 기능을 제어하기도 단순해 진다.

### 사용 가능한 Context

Activity로 예를 들어보면 Context 인스턴스는 3개가 있다.

- Activity 인스턴스 자신(this)
- getBaseContext()를 통해 가져오는 ContextImpl 인스턴스
- getApplicationContext()를 통해 가져오는 Application 인스턴스 : Activity의 getApplication() 메서드로 가져오는 인스터스와 같다.

위 3개의 인스턴스가 다르기 떄문에 캐스팅을 함부로 하면 안된다. 이를테면 getBaseContext()로 가져오는 것을 Activity로 캐스팅하면 ClassCastException이 발생한다.

View의 클래스를 보면 생성자에 Context가 들어가는데 이 Context가 어디서 온 것인지 확인해 볼 수 있다.

```kotlin
val context1 = (view.context == this) // 1
val context2 = (view.context == baseContext) // 2
val context3 = (view.context == applicationContext) // 3
val context4 = (view.context == application) // 4

println(context1)
println(context2)
println(context3)
println(context4)

>> true
>> false
>> false
>> false
```

1에서만 true가 나오는 것을 볼 수 있다. View 클래스는 생성자에 Context가 전달되어야 하는데 Activity에 쓸 수 있는 3가지 Context 모두 다 전달 가능하다. 

그러나 View와 연관이 깊은 것은 Activity이므로 Activity가 전달된 것을 이해할 수 있을 것이다.

- 요약정리
    
    -리눅스 환경에서 어플리케이션을 프로세스 단위로 관리한다. 프로세스 내에서 컴포넌트를 관리를 해야하고 이를 관리하기 위해 만든 추상클래스이다. 즉, 리눅스에서 프로세스를 ID를 붙여 관리하듯 안드로이드 시스템은 어플리케이션 또는 컴포넌트 등을 콘테스트로 관리한다.
    

Context ?

안드로이드 시스템이 어플리케이션이나 컴포넌트 등을 관리하기 위한 것!