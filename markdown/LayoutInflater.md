<aside>
💡 LayoutInflater

</aside>

⇒ XML에 정의된 Resource(자원)들을 View의 형태로 반환해 준다. 자바코드에서 View, ViewGroup을 사용하거나 Adapter의 getView() 등 배경화면이 될 Layout을 만들어 놓고 View 형태로 반환받아 Activity, Fragment에서 실행하게 된다. 

보통 Activity를 만들면 onCreate()메서드에 추가되어 있는 setContentView(리소스.id) 메서드와 같은 원리다. 이 메서드 또한 xml파일을 View로 만들어서 Activity위에 보여주는 방식이다.