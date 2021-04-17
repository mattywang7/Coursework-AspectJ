package q3.kw3n20;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * If an exception is thrown,
 * execTime
 * input
 * failure
 */
public aspect RuntimeProfiling {
    // pointcut definitions
    pointcut methodCall(int i): call(public int q3..*(int)) && args(i); // exclude methods having no args
//    pointcut handlerPointcut(): handler(DemoException);

    // inter-type declarations
    Map<String, Method> methodMap = new HashMap<>(); // record each method

    int around(int i): methodCall(i) {
        long start = System.currentTimeMillis();
        String methodName = thisJoinPoint.getSignature().toLongString();
        Method currentMethod;

        // get the method object
        if (!methodMap.containsKey(methodName)) {
            currentMethod = new Method(methodName);
            methodMap.put(methodName, currentMethod);
        } else {
            currentMethod = methodMap.get(methodName);
        }

        // add currentMethod's input
        if (!currentMethod.inputMap.containsKey(i)) {
            currentMethod.inputMap.put(i, 1);
        } else {
            currentMethod.inputMap.put(i, currentMethod.inputMap.get(i) + 1);
        }
        currentMethod.valueOfInterest.add(i);

        int output = Integer.MIN_VALUE;
        try {
            // return the currentMethod's output
            output = proceed(i);
            if (!currentMethod.outputMap.containsKey(output)) {
                currentMethod.outputMap.put(output, 1);
            } else {
                currentMethod.outputMap.put(output, currentMethod.outputMap.get(output) + 1);
            }
            currentMethod.valueOfInterest.add(output);
            return output;
        } finally {
            long execTime = System.currentTimeMillis() - start;
            currentMethod.execTimes.add(execTime);
        }
    }

    // count failures
    after() throwing(Exception e): call(public int q3..*(int)) {
        String methodName = thisJoinPointStaticPart.getSignature().toLongString();
        Method currentMethod = methodMap.get(methodName);
        currentMethod.failures++;
    }

    after(): execution(public static void q3..main(..)) {
        // generate methodSignature-hist.csv files
        try {
            for (String methodSignature: methodMap.keySet()) {
                PrintWriter writer = new PrintWriter(methodSignature + "-hist.csv", StandardCharsets.UTF_8);
                writer.printf("%-15s%-15s%-15s\n", "Value", "Input Times", "Output Times");
                Method currentMethod = methodMap.get(methodSignature);
                for (int value: currentMethod.valueOfInterest) {
                    int inputTimes = currentMethod.inputMap.getOrDefault(value, 0);
                    int outputTimes = currentMethod.outputMap.getOrDefault(value, 0);
                    writer.printf("%-15d%-15d%-15d\n", value, inputTimes, outputTimes);
                }
                writer.flush();
                writer.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // generate failures.csv file
        try {
            PrintWriter writer = new PrintWriter("failures.csv", StandardCharsets.UTF_8);
            writer.println("Failure Frequency (%): ");
            for (Method currentMethod: methodMap.values()) {
                double failureFreq = currentMethod.failureFrequency();
                writer.printf("%-30s: %-20f\n", currentMethod.methodName, currentMethod.failureFrequency());
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // generate runtimes.csv file
        try {
            PrintWriter writer = new PrintWriter("runtimes.csv", StandardCharsets.UTF_8);
            writer.printf("%-30s%-30s%-30s\n", "Method Name", "Average ExecTime", "Standard Deviation");
            for (Method currentMethod: methodMap.values()) {
                double averageExecTime = currentMethod.averageExecTime();
                double standardDeviation = currentMethod.standardDeviation();
                writer.printf("%-30s%-30f%-30f\n", currentMethod.methodName, averageExecTime, standardDeviation);
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
