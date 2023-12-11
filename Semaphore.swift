import Foundation

let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
var accountBalance = 1000
let semaphore = DispatchSemaphore(value: 1)

func withdraw(amount: Int) {
    concurrentQueue.async {
        semaphore.wait()
        defer {
            semaphore.signal()
        }

        if accountBalance >= amount {
            // Simulate delay for demonstration purpose
            Thread.sleep(forTimeInterval: 1)
            accountBalance -= amount
            print("Withdrawal successful. Remaining balance: \(accountBalance)")
        } else {
            print("Insufficient funds")
        }
    }
}

func refillBalance(amount: Int) {
    concurrentQueue.async {
        semaphore.wait()
        defer {
            semaphore.signal()
        }

        // Simulate delay for demonstration purpose
        Thread.sleep(forTimeInterval: 1)
        accountBalance += amount
        print("Refill successful. Remaining balance: \(accountBalance)")
    }
}

// Simulate multiple withdrawals happening concurrently
for _ in 1..<5 {
    DispatchQueue.global().async {
        withdraw(amount: 150)
    }

    DispatchQueue.global().async {
        refillBalance(amount: 200)
    }
}
