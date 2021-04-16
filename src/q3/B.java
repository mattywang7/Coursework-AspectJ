package q3;

public class B {
    public int foo(int a) {
        if (a % 3 == 0) {
            bar(a);
        } else {
            baz(a);
        }
        return 0;
    }

    public int bar(int b) {
        if (b % 2 == 0) {
            throw new DemoException();
        }
        return baz(b);
    }

    public int baz(int b) {
        b %= 7;
        for (int i = 0; i < b * b; i++) {
            try {
                Thread.sleep(200);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return b + b;
    }
}
