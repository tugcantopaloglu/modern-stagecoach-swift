import UIKit
import Foundation
import Darwin

struct FixtureFailure: Error {
    let message: String
}

@main
class NativeFixtureDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var checks = [String]()
    private var onboarding: ViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        DispatchQueue.main.async { self.runFixtures() }
        return true
    }

    private func verify(_ condition: @autoclosure () -> Bool, _ message: String) throws {
        guard condition() else { throw FixtureFailure(message: message) }
        checks.append(message)
    }

    private func runFixtures() {
        do {
            let travel = TravelListViewController()
            travel.destination1 = "Fixture origin"
            travel.destination2 = "Fixture destination"
            travel.date = "01.01.2030"
            try verify(!travel.updateTravels(from: Data("invalid JSON".utf8)), "Malformed travel data is rejected")
            try verify(travel.destinations.isEmpty, "Malformed travel data leaves a fresh list empty")
            try verify(travel.updateTravels(from: Data("[]".utf8)), "Empty travel data is accepted")
            try verify(travel.destinations.isEmpty, "Empty travel data has no rows")
            try verify(travel.updateTravels(from: Data("[{\"time\":\"10:00\",\"price\":\"25\"}]".utf8)), "Partial optional travel fields decode")
            try verify(travel.destinations.count == 1, "One decoded travel creates one destination")
            try verify(travel.destinations[0].startDestination == "Fixture origin", "Destination mapping preserves the selected route")

            guard let ticket = UINib(nibName: "Ticket", bundle: .main).instantiate(withOwner: nil).first as? Ticket else {
                throw FixtureFailure(message: "Ticket nib loads its existing cell class")
            }
            ticket.configure(model: travel.destinations[0])
            try verify(ticket.timeLabel.text == "10:00", "Ticket outlets display fixture travel data")
            try verify(ticket.travelTimeLabel.text == nil, "Missing optional ticket text remains empty")
            try verify(ticket.busImages.image == nil, "Missing optional ticket image remains empty")
            try verify(travel.updateTravels(from: Data("[]".utf8)), "An empty replacement response is accepted")
            try verify(travel.destinations.isEmpty, "An empty replacement clears old rows")

            guard let bought = UINib(nibName: "BoughtTicket", bundle: .main).instantiate(withOwner: nil).first as? BoughtTicket else {
                throw FixtureFailure(message: "BoughtTicket nib loads its existing cell class")
            }
            try verify(bought.passengerLabel != nil && bought.ticketCostLabel != nil, "BoughtTicket outlets connect to their owning cell")

            let passenger = BusScreenViewController()
            let offscreenTable = UITableView(frame: .zero)
            offscreenTable.register(UINib(nibName: "User", bundle: .main), forCellReuseIdentifier: "usersCellIdentifier")
            passenger.usersTableView = offscreenTable
            passenger.ticketListCollectionView = offscreenTable
            let index = IndexPath(row: 0, section: 0)
            guard let firstForm = passenger.tableView(offscreenTable, cellForRowAt: index) as? User else {
                throw FixtureFailure(message: "User nib loads its existing cell class")
            }
            firstForm.nameSurnameTextField.text = "Fixture Passenger"
            firstForm.nameSurnameTextField.sendActions(for: .editingChanged)
            firstForm.idNoTextField.text = "fixture-id"
            firstForm.idNoTextField.sendActions(for: .editingChanged)
            try verify(offscreenTable.cellForRow(at: index) == nil, "Passenger row is unavailable through visible-cell lookup")
            guard let replacementForm = passenger.tableView(offscreenTable, cellForRowAt: index) as? User else {
                throw FixtureFailure(message: "A replacement passenger form loads")
            }
            try verify(replacementForm.nameSurnameTextField.text == "Fixture Passenger", "Passenger name survives cell recreation")
            try verify(replacementForm.idNoTextField.text == "fixture-id", "Passenger ID survives cell recreation")

            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "onboardingIdentity") as? ViewController else {
                throw FixtureFailure(message: "Onboarding storyboard resolves its controller")
            }
            onboarding = controller
            window?.rootViewController = controller
            controller.loadViewIfNeeded()
            controller.view.layoutIfNeeded()
            try verify(controller.slides.count > 1, "Onboarding loads its existing slides")
            controller.currentPage = controller.slides.count - 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) { self.verifyManualLastPage(storyboard) }
        } catch {
            finish(error: error)
        }
    }

    private func verifyManualLastPage(_ storyboard: UIStoryboard) {
        do {
            guard let controller = onboarding else { throw FixtureFailure(message: "Onboarding fixture is retained") }
            try verify(controller.currentPage == controller.slides.count - 1, "An automatic tick after manual last-page navigation stays in bounds")
            try verify(!controller.advanceOnboardingPage(), "The final slide cannot advance to a nonexistent item")
            guard let dismissed = storyboard.instantiateViewController(withIdentifier: "onboardingIdentity") as? ViewController else {
                throw FixtureFailure(message: "Dismissal fixture loads its controller")
            }
            dismissed.loadViewIfNeeded()
            dismissed.viewWillDisappear(false)
            onboarding = dismissed
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) { self.verifyDismissedTimer() }
        } catch {
            finish(error: error)
        }
    }

    private func verifyDismissedTimer() {
        do {
            try verify(onboarding?.currentPage == 0, "A dismissed onboarding controller stops automatic advances")
            finish(error: nil)
        } catch {
            finish(error: error)
        }
    }

    private func finish(error: Error?) {
        let report: [String: Any] = [
            "passed": error == nil,
            "checks": checks,
            "failure": (error as? FixtureFailure)?.message ?? error.map { String(describing: $0) } ?? ""
        ]
        do {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let data = try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
            try data.write(to: directory.appendingPathComponent("fixture-result.json"), options: .atomic)
            print(String(data: data, encoding: .utf8) ?? "")
        } catch {
            print("Unable to write native fixture evidence: \(error)")
        }
        Darwin.exit(error == nil ? 0 : 1)
    }
}
