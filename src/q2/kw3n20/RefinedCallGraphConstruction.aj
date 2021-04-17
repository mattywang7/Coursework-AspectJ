package q2.kw3n20;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.Set;

public aspect RefinedCallGraphConstruction {
    // pointcut definitions
    pointcut nodeCall(): call(public int q2..*(int));
    pointcut edgeCheck(): withincode(public int q2..*(int));
    pointcut nodeExecution(): execution(public int q2..*(int));

    // inter-type declarations, avoid repeat entries
    Set<String> nodes = new HashSet<>();
    Set<String> edges = new HashSet<>();
    Set<String> exceptions = new HashSet<>();

    // Adding nodes
    before(): nodeCall() {
        String node = thisJoinPoint.getSignature().toLongString();
        nodes.add(node);
    }

    // Adding edges
    before(): nodeCall() && edgeCheck() {
        String caller = thisEnclosingJoinPointStaticPart.getSignature().toLongString();
        String called = thisJoinPointStaticPart.getSignature().toLongString();
        edges.add(caller + " -> " + called);
    }

    // Remove edges if the called throws an exception in the caller
    // and add the thrown exceptions
    after() throwing(Exception e): nodeCall() && edgeCheck() {
        String caller = thisEnclosingJoinPointStaticPart.getSignature().toLongString();
        String called = thisJoinPointStaticPart.getSignature().toLongString();
        edges.remove(caller + " -> " + called);
        exceptions.add(e.toString());
    }

    // Write the files after execution of main method
    after(): execution(public static void q2..main(..)) {
        // Write q2-nodes.csv
        try {
            PrintWriter writer = new PrintWriter("q2-nodes.csv", StandardCharsets.UTF_8);
            writer.println("Node List: ");
            for (String node : nodes) {
                writer.println(node + ",");
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Write q2-edges.csv
        try {
            PrintWriter writer = new PrintWriter("q2-edges.csv", StandardCharsets.UTF_8);
            writer.println("Edge List: ");
            for (String edge : edges) {
                writer.println(edge);
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Write q2-exceptions.csv
        try {
            PrintWriter writer = new PrintWriter("q2-exceptions.csv", StandardCharsets.UTF_8);
            writer.println("Thrown Exceptions: ");
            for (String exception : exceptions) {
                writer.println(exception);
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
