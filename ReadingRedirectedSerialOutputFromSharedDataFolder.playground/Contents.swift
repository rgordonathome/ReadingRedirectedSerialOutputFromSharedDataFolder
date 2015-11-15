import Cocoa

// Try reading from the file that contains serial output
//
// File must exist in:
//      ~/Shared Playground Data
//
// Use maxSleepInSeconds argument to set how long the file should be monitor for
// Default is 15 seconds.
// In other words, program will always run for 15 seconds by default.
//
var currentValue : Int = 0

// Begin reading the file with serial output in shared folder
if let aStreamReader = StreamReader(file: "serial-output.txt", maxSleepInSeconds: 30) {
    
    // Read data from the file
    for line in aStreamReader {
        
        // Print line of data received from file
        print(line, terminator : "" )
        
        // Convert received value to integer
        currentValue = NSString(string: line).integerValue
    }
}
