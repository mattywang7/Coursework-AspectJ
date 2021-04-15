package q2;

public class B {
    public int foo(int a) {
        bar(a);
        return 0;
    }

    public int bar(int b) {
        if (b < 0) {
            throw new IllegalArgumentException("argument to bar() should be positive");
        }
        return baz(b);
    }

    public int baz(int a) {
        return a + a;
    }
}
