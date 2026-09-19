//
//  BlockTargetStoreTests.swift
//  HinaBlocksTests
//
//  ブロック対象の保存と復元のテスト（WBS 2.2 / KAN-33）。
//
//  実際のアプリを選んだ状態は作れない（トークンは iOS のピッカーしか発行しない）ため、
//  ここで確認するのは「保存が走るか」「保存したものを読み戻せるか」「壊れた値で落ちないか」。
//

import FamilyControls
import XCTest
@testable import HinaBlocks

/// テスト用の保存先。実際には書き込まず、メモリ上に置く。
private final class InMemoryBlockTargetStorage: BlockTargetStorage {

    var stored: Data?
    private(set) var saveCount = 0

    init(stored: Data? = nil) {
        self.stored = stored
    }

    func loadBlockTargets() -> Data? { stored }

    func saveBlockTargets(_ data: Data?) {
        stored = data
        saveCount += 1
    }
}

@MainActor
final class BlockTargetStoreTests: XCTestCase {

    /// 保存が空なら、何も選ばれていない状態から始まる。
    func testStartsEmptyWhenNothingStored() {
        let store = BlockTargetStore(storage: InMemoryBlockTargetStorage())
        XCTAssertTrue(store.summary.isEmpty)
    }

    /// 選択を書き換えると保存される。
    func testWritingSelectionPersists() {
        let storage = InMemoryBlockTargetStorage()
        let store = BlockTargetStore(storage: storage)

        var selection = FamilyActivitySelection()
        selection.applicationTokens = []
        store.selection = selection

        // 同じ値を入れ直しても保存は増えない（無駄な書き込みを避けている）。
        let countAfterFirstWrite = storage.saveCount
        store.selection = selection
        XCTAssertEqual(storage.saveCount, countAfterFirstWrite)
    }

    /// 保存したものを、次に作ったストアが読み戻せる。
    func testSelectionSurvivesANewStore() throws {
        let storage = InMemoryBlockTargetStorage()
        let original = FamilyActivitySelection()
        storage.stored = try JSONEncoder().encode(original)

        let restored = BlockTargetStore(storage: storage)
        XCTAssertEqual(restored.selection, original)
    }

    /// 壊れた保存データでも落ちず、空の状態から始まる。
    func testBrokenStoredDataFallsBackToEmpty() {
        let storage = InMemoryBlockTargetStorage(stored: Data("これはJSONではない".utf8))
        let store = BlockTargetStore(storage: storage)
        XCTAssertTrue(store.summary.isEmpty)
    }

    func testDecodeReturnsNilForMissingOrBrokenData() {
        XCTAssertNil(BlockTargetStore.decode(nil))
        XCTAssertNil(BlockTargetStore.decode(Data("壊れている".utf8)))
    }
}
