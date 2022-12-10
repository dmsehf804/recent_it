Fragment LifeCycle은 Fragment가 시작되고 종료될 때 까지 상태를 Fragment LifeCycle라고 한다.

Fragment LifeCycle에는 onAttach(), onCreate(), onCreateView(), onActivityCreated(), onStart(), onResume(), onPause(), onStop(), onDestroyView(), onDestroy(), onDetach() 가 있다.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/954e40e8-e5a9-468f-ae02-1c2445380f09/_2021-03-16__3.22.27.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/954e40e8-e5a9-468f-ae02-1c2445380f09/_2021-03-16__3.22.27.png)

- onAttach(Activity)
    
    -액티비티에서 프래그먼트가 호출될 때 최초 한번 호출되는 함수
    
- onCreate(Bundle)
    
    -프래그먼트가 생성될 떄 호출되는 함수
    
- onCreateView(LayoutInflater, ViewGroup, Bundle)
    
    -프래그먼트의 뷰를 생성하는 함수
    
- onActivityCreated(Bundle)
    
    -액티비티에서 onCreate()가 호출 된 프래그먼트에서 호출되는 함수
    
- onStart()
    
    -프래그먼트가 사용자한테 보여지기 직전 호출되는 함수
    
- onResume()
    
    -프래그먼트가 사용자와 상호작용할 수 있는 상태
    
- onPasue()
    
    -화면이 일부 가려졌을 때 호출
    
- onStop()
    
    -프래그먼트가 화면에 사라졌을 때 호출
    
- onDestroyView()
    
    -프래그먼트의 View가 사라질때 호출되는 함수
    
- onDestroy()
    
    -프래그먼트가 제거될 때 호출되는 함수
    
- onDetach()
    
    -프래그먼트가 액티비티와 연결이 종료될 때 호출되는 함수
    

### FragmentManager

-프래그먼트를 추가, 삭제 또는 교체하고 백스택에 추가하는 등의 작업을 실행하는 클래스

-프래그먼트의 변경사항 집합을 트랜잭션이라고 한다.

### FragmentTransaction

-각 트랜잭션은 수행하고자 하는 변경사항의 집합이다. 변경사항을 설정하려면 add(), remove(), replace()와 같은 메서드를 사용해야한다.