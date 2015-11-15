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
if let aStreamReader = StreamReader(file: "serial-output.txt", maxSleepInSeconds: 30) {
    for line in aStreamReader {
        print(line, terminator : "" )
    }
}
