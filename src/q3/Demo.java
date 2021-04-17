package q3;

public class Demo {
    public static void main(String[] args) throws DemoException {
        B b = new B();
        for (int i = 0; i < 5; i++) {
            try {
                b.foo(i);
            } catch (DemoException e) {
                e.printStackTrace();
            }
        }
//        b.foo(2);
//        A a = new A();
//        a.foo(1);
    }
}
