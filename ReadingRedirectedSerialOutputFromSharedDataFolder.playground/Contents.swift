import Cocoa

/*:

### Step 1

If you have not yet, create this folder using the Finder:

    ~/Documents/Shared Playground Data

*/

// Get path to the Documents folder
let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString

// Append folder name of Shared Playground Data folder
let sharedDataPath = documentPath.stringByAppendingPathComponent("Shared Playground Data")

// List the contents of the shared folder (an array is returned)
var contents: [String] = []
do {
    contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(sharedDataPath)
    print("Contents are")
    print("\(contents)")
} catch let error as NSError {
    print("error")
    print(error.localizedDescription)
}

// Append file name to folder path string
let filePath = sharedDataPath + "/" + contents[1]

// Now try reading from the file
if let aStreamReader = StreamReader(path: filePath) {
    for line in aStreamReader {
        print(line)
    }
}

