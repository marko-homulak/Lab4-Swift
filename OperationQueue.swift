import Foundation

let concurrentQueue = OperationQueue()
concurrentQueue.maxConcurrentOperationCount = 1  // Set to 1 to ensure serial execution
var accountBalance = 1000
let balanceOperationQueue = OperationQueue()

class WithdrawOperation: Operation {
    let amount: Int
    
    init(amount: Int) {
        self.amount = amount
        super.init()
    }
    
    override func main() {
        balanceOperationQueue.addOperation {
            if accountBalance >= self.amount {
                // Simulate delay for demonstration purpose
                Thread.sleep(forTimeInterval: 1)
                accountBalance -= self.amount
                print("Withdrawal successful. Remaining balance: \(accountBalance)")
            } else {
                print("Insufficient funds")
            }
        }
    }
}

class RefillOperation: Operation {
    let amount: Int
    
    init(amount: Int) {
        self.amount = amount
        super.init()
    }
    
    override func main() {
        balanceOperationQueue.addOperation {
            // Simulate delay for demonstration purpose
            Thread.sleep(forTimeInterval: 1)
            accountBalance += self.amount
            print("Refill successful. Remaining balance: \(accountBalance)")
        }
    }
}

// Simulate multiple withdrawals happening concurrently
for _ in 1..<5 {
    let withdrawOperation = WithdrawOperation(amount: 150)
    let refillOperation = RefillOperation(amount: 200)
    
    concurrentQueue.addOperation(withdrawOperation)
    concurrentQueue.addOperation(refillOperation)
}

concurrentQueue.waitUntilAllOperationsAreFinished()
