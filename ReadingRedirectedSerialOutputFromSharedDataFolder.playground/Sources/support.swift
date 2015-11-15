import Foundation

// Source for StreamReader class obtained from:
//
// http://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift
//
//
public class StreamReader {
    
    let encoding : UInt
    let chunkSize : Int
    
    var fileHandle : NSFileHandle!
    let buffer : NSMutableData!
    let delimData : NSData!
    var atEof : Bool = false
    var sleepMax : Int
    var sleepCount = 0
    
    public init?(file: String, maxSleepInSeconds : Int = 15, delimiter: String = "\n", encoding : UInt = NSUTF8StringEncoding, chunkSize : Int = 4096) {
        
        // initialize variables
        self.sleepMax = maxSleepInSeconds
        self.chunkSize = chunkSize
        self.encoding = encoding
        
        // Get path to the Documents folder
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        // Append folder name of Shared Playground Data folder
        let sharedDataPath = documentPath.stringByAppendingPathComponent("Shared Playground Data")
        
        // Append file name to folder path string
        let filePath = sharedDataPath + "/" + file
        print(filePath)
        
        // clear the console area
//        for _ in 1...30 {
//            print("")
//        }
        
        if let fileHandle = NSFileHandle(forReadingAtPath: filePath),
            delimData = delimiter.dataUsingEncoding(encoding),
            buffer = NSMutableData(capacity: chunkSize)
        {
            self.fileHandle = fileHandle
            self.delimData = delimData
            self.buffer = buffer
        } else {
            print("in nil")
            self.fileHandle = nil
            self.delimData = nil
            self.buffer = nil
            return nil
        }
    }
    
    deinit {
        self.close()
    }
    
    /// Return next line, or nil on EOF.
    public func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        if atEof {
            if sleepCount < sleepMax {
                sleepCount++
                sleep(1)
                atEof = false
//                return "sleeping"
            } else {
                return nil
            }
        }
        
        // Read data chunks from file until a line delimiter is found:
        var range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let tmpData = fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                atEof = true
                // Buffer contains last line in file (not terminated by delimiter).
                // (Commented out because we don't want to return the last line, we skip it because file still being written to)
//                if buffer.length > 0 {
//
//                    let line = NSString(data: buffer, encoding: encoding)
//                    
//                    buffer.length = 0
//                    let outputLine = (line as String?)! + "\n"
//                    return outputLine
//                }
                // No more lines.
//                return nil
            }
            buffer.appendData(tmpData)
            range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)), encoding: encoding)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        //print("range location \(range.location)")
        if (range.location != 0 && range.location != 1) {
            let outputLine = (line as String?)! + "\n"
            return outputLine
        } else {
            return ""
        }
    }
    
    /// Start reading from the beginning of file.
    public func rewind() -> Void {
        fileHandle.seekToFileOffset(0)
        buffer.length = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    public func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : SequenceType {
    public func generate() -> AnyGenerator<String> {
        return anyGenerator {
            return self.nextLine()
        }
    }
}