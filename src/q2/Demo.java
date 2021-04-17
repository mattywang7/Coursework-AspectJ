package q2;

public class Demo {
    public static void main(String[] args) {
        A a = new A();
        B b = new B();

        a.foo(1);
        try {
            b.foo(-1);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
