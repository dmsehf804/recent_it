<aside>
๐ก AsyncTask

</aside>

AsyncTask๋ ๋น๋๊ธฐ์ ์ผ๋ก ์คํ๋  ํ์๊ฐ ์๋ ์์์ ์ํด ์ฌ์ฉํ๋ ํด๋์ค์ด๋ค.

์ฅ์ ์ผ๋ก๋ ๋น๋๊ธฐ์  ์ฒ๋ฆฌ๋ฅผ ํ๊ธฐ ์ฝ๊ณ , ํธ๋ค๋ฌ๋ณด๋ค ์ฝ๋์ ์ผ๋ก ๊น๋ํ๋ค๋ ์ฅ์ ์ด ์๋ค.

๋จ์ ์ ์ฌ์ฌ์ฉ์ด ๋ถ๊ฐํ๊ณ , ์ข๋ฃ๋ฅผ ํ์ง ์์ผ๋ฉด ์ข๋ฃ๊ฐ ๋์ง ์๋๋ค๋ ๋จ์ ์ด ์๋ค.

### AsynsTask๋ ์ deprecated ๋์๋๊ฐ?

1. ๋ฉ๋ชจ๋ฆฌ๋์
    
    -์กํฐ๋นํฐ ์ข๋ฃ์์ ๊ณผ ์ด์ฑํฌ๊ฐ ๋๋๋ ์์ ์ด ๋ค๋ฅด๋ค. ์กํฐ๋นํฐ๊ฐ ์ข๋ฃ๋  ๋ ์ด์ฑํฌ๊ฐ ์ค๋ ๊ฑธ๋ฆฌ๋ ๊ฒ ์๋๋ผ๋ฉด ์ผ์์ ์ธ ํ์์ด๋ฏ๋ก ํฐ ๋ฌธ์ ๋ ์๋. ๋ฌธ์ ๊ฐ ๋๋ ๊ฒ์ ํ๋ฉด ํ์  ๋ฑ์ผ๋ก ์ธํด ๊ณ์ํด์ ์ด์ฑํฌ๊ฐ ์์ฌ์ ์คํํ๋ ๊ฒฝ์ฐ. ์ด ๊ฒฝ์ฐ๋ ํ๋ฉด์ด ํ์ ํ  ๋ ์กํฐ๋นํฐ๋ ์ข๋ฃ๋๊ณ  ์๋ก ์์๋๋ค. ์๋ก ์์ฑ๋ ์กํฐ๋นํฐ๋ ๋ค๋ฅธ ์ธ์คํด์ค์ธ๋ฐ, ์ด์ฑํฌ๊ฐ ์์ง ์คํ ์ค์ธ ๊ฒฝ์ฐ์๋ ๊ธฐ์กด ์กํฐ๋นํฐ๋ ๋ฉ๋ชจ๋ฆฌ์์ ์ ๊ฑฐ๊ฐ ๋์ง ์๋๋ค(oom ์์ธ ๊ฐ๋ฅ์ฑ)
    
2. ์์ฐจ ์คํ์ผ๋ก ์ธํ ์๋์ ํ
3. ํ๋๊ทธ๋จผํธ์์ ์ด์ฑํฌ ์คํ๋ฌธ์ 
    
    -ํ๋๊ทธ๋จผํธ์์ ์ด์ฑํฌ๋ฅผ ์คํํ๊ณ  ๋ฐฑํค๋ก ์กํฐ๋นํฐ๋ฅผ ์ข๋ฃํ๋ฉด ํ๋๊ทธ๋จผํธ๋ ์กํฐ๋นํฐ์ ๋ถ๋ฆฌ๋๋ฉด์ getContext, getActivity๊ฐ null์ ๋ฆฌํด. ๋ฐ๋ผ์ onPostExecte์์ ๋ํฌ์ธํธ ๋ฐ์
    
4. ์์ธ์ฒ๋ฆฌ ๋ฉ์๋ ์์
    
    -์ทจ์(cancel)๋ง ์๊ณ  onError๊ฐ ์์
    
5. ๋ณ๋ ฌ ์คํ ์ doinBackground ์คํ ์์๊ฐ ๋ณด์ฅ๋์ง ์์
    
    -์๋๋ก์ด๋ ๋ฒ์ ์ด ์ฌ๋ผ๊ฐ๋ฉด์ ๊ธฐ๋ณธ ๋์์ด ๋ณ๋ ฌ ์คํ์์ ์์ฐจ ์คํ์ผ๋ก ๋ฐ๋