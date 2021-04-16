package q1.kw3n20;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.Set;

/**
 * q1-nodes.csv
 * q1-edges.csv
 */
public aspect DynamicCallGraphConstruction {
    // pointcut definitions
    pointcut nodeCall(): call(public int q1..*(int));
    pointcut edgeCheck(): withincode(public int q1..*(int));

    // inter-type declarations, avoid repeat entries
    Set<String> nodes = new HashSet<>();
    Set<String> edges = new HashSet<>();

    // Add nodes
    before(): nodeCall() {
        String node = thisJoinPoint.getSignature().toLongString();
        nodes.add(node);
    }

    // Add edges
    before(): nodeCall() && edgeCheck() {
        String caller = thisEnclosingJoinPointStaticPart.getSignature().toLongString();
        String called = thisJoinPointStaticPart.getSignature().toLongString();
        edges.add(caller + " -> " + called);
    }

    // Write the files after execution of main method
    after(): execution(public static void q1..main(..)) {
        // Write q1-nodes.csv
        try {
            PrintWriter writer = new PrintWriter("q1-nodes.csv", StandardCharsets.UTF_8);
            writer.println("Node List: ");
            for (String node : nodes) {
                writer.println(node + ","); // comma-separated
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Write q1-edges.csv
        try {
            PrintWriter writer = new PrintWriter("q1-edges.csv", StandardCharsets.UTF_8);
            writer.println("Edge List: ");
            for (String edge : edges) {
                writer.println(edge);
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
