대부분의 경우 모든 Android Application은 Linux 프로세스에서 실행된다. 이 과정은 해당 코드의 요구의 일부를 실행하는 경우 응용 프로그램에 대해 생성되고, 더 이상 필요하지 않을 떄까지 계속 실행된다. 

안드로이드는 프로세스를 가능한 오래 유지하려고 하지만, 새로운 프로세스를 생성하거나 보다 중요한 프로세스의 메모리 확보를 위해서 다른 프로세스를 종료 시키는 경우가 있다. 어떤 프로세스를 종료시키고, 또 어떤 프로세스를 남겨둘지 결정하기 위해서 시스템은 각 프로세스를 컴포넌트의 상태나 진행 상황에 따라 중요도를 결정한다. 중요도가 가장 낮은 프로세스 부터 종료의 대상이 되고, 이 순서에 따라 프로세스를 종료시키며 리소스를 확보한다.

1. Foreground Process
    
    ⇒ 사용자가 현재 조작하고 있는 일에 필요한 Process, 다음 조건 중 하나라도 충족되면 프로세스사 포그라운드에 있는 것으로 간주한다.
    
    - 사용자가 현재 조작하고 있는 Activity(onResume()이 호출된 Activity)
    - BroadcastRReceiver가 현재 동작중인 상태(onReceive()가 동작 중인 상태)
    - Service에서 콜백함수가 활성중일 때(onCreate(), onStatrt(), onDestroy())
2. Visible Process
    
    ⇒ Foreground componet를 가지고 있지만, 사용자가 화면에서 볼 수 없는 프로세스
    
    - onPause()가 호출되었지만, 여전히 화면에서 확인할 수 있는 Activity. 예를들면 Dialog가 떴을 때
    - 보여지고 있는 Activity와 biding 되어 있는 Service
3. Service Process
    
    ⇒ 위 두 상태에 포함되지는 않지만, startService()가 호출되어 실행중인 Service. 사용자가 직접 눈으로 확인할 수 있는 그 어떤 요소와도 연결되어 있지는 않지만, 사용자가 하고 있는 일에 영향을 주는 일을 한다. (예를들면 음악재생, 데이터 다운로드 등)
    
4. Cached Process
    
    ⇒ Activity가 있지만, onStop()이 불린 이후여서 더 이상 사용자에게 보이지 않는 Process. 더 이상 사용성에 직접적인 영향을 끼치지 않기 때문에, 메모리가 부족할 경우 System이 Foreground Process, Visible Process, Service Process에 앞서 종료 시킨다. 일반적으로 많은 Background Process들이 있는데, 이들은 LRU(Least Recently Used)목록에 따라서, 최근 실행된 프로세스가 나중에 종료되도록 되어 있다. 만약 Actvitiy가 생명주기 메소드를 제대로 구현했고, 현재 상태를 저장하도록 한다면, 사용자가 앱을 다시 실행시킬 경우 저장한 상태를 복구한다. 따라서 사용자는 마치 pause되었다가 resume되는 것 처럼 여길 수 있다.
    
5. Empty Process
    
    ⇒ Activity Compenet를 갖고 있지 않는 Process. 살아 있는 이유는 다음에 재실행될 떄, 시작 시간을 다운시키기 위해서 시스템이 프로세스를 캐싱하고 있기 떄문이다.