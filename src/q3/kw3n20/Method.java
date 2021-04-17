package q3.kw3n20;

import java.util.*;

/**
 * Link each method to its input and output.
 */
public class Method {
    String methodName;

    // fields for task 1
    Set<Integer> valueOfInterest;       // record all values of interest
    Map<Integer, Integer> inputMap;     // record inputTimes
    Map<Integer, Integer> outputMap;    // record outputTimes

    // fields for task 2
    int failures;

    /**
     * @return failure percentage
     */
    public double failureFrequency() {
        int inputTimes = 0;
        for (int input : inputMap.keySet()) {
            inputTimes += inputMap.get(input);
        }
        return ((double) failures) / inputTimes * 100;
    }

    // fields for task 3
    List<Long> execTimes;

    /**
     * @return the average execution time of this method (ms).
     */
    public double averageExecTime() {
        long sum = 0;
        for (long execTime : execTimes) {
            sum += execTime;
        }
        return ((double) sum) / execTimes.size();
    }

    /**
     * @return the standard deviation across all its invocations.
     */
    public double standardDeviation() {
        double sum = 0.0;
        double average = averageExecTime();
        for (long execTime: execTimes) {
            sum += Math.pow(execTime - average, 2);
        }
        return Math.sqrt(sum / execTimes.size());
    }


    public Method(String methodName) {
        this.methodName = methodName;
        valueOfInterest = new HashSet<>();
        inputMap = new HashMap<>();
        outputMap = new HashMap<>();

        failures = 0;

        execTimes = new ArrayList<>();
    }
}
