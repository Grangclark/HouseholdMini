//
//  Persistence.swift
//  HouseholdMini
//
//  Created by 長橋和敏 on 2025/02/13.
//

import CoreData

struct PersistenceController {
    // シングルトンインスタンス
    static let shared = PersistenceController()
    
    // 永続化コンテナ
    let container: NSPersistentContainer
    
    // 初期化（inMemory: テストやプレビュー用に一時的なストアを利用する場合）
    init(inMemory: Bool = false) {
        // （nameは変えていない）
        container = NSPersistentContainer(name: "HouseholdMini")
        
        if inMemory {
            // テスト用：永続化ストアを一時的に/dev/nullに設定
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("永続化ストアの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
