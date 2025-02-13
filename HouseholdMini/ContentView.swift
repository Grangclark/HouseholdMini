//
//  ContentView.swift
//  HouseholdMini
//
//  Created by 長橋和敏 on 2025/02/13.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // 入力フォーム用の状態変数
    @State private var selectedType = "Income"
    @State private var amountText = ""
    @State private var selectedDate = Date()
    
    let types = ["Income", "Expense"]
    
    // Core DataからRecordをフェッチ
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: false)],
        animation: .default)
    
    // private var items: FetchedResults<Item>
    var records: FetchedResults<Record>

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("記録の追加")) {
                        Picker("タイプ", selection: $selectedType) {
                            ForEach(types, id: \.self) { type in
                                Text(type == "Income" ? "収入" : "支出")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("金額を入力", text: $amountText)
                            .keyboardType(.decimalPad)
                        
                        DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                        
                        Button(action: addRecord) {
                            Text("保存")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxHeight: 300) // フォームの高さを制限（任意）
                
                List {
                    ForEach(groupedRecords.keys.sorted(by: >), id: \.self) { month in
                        Section(header: Text(month)) {
                            ForEach(groupedRecords[month] ?? []) { record in
                                HStack {
                                    Text(record.type ?? "")
                                        .foregroundColor(record.type == "Expense" ? .red : .green)
                                    Spacer()
                                    Text("\(record.amount, specifier: "%.2f") 円")
                                }
                            }
                            if let total = monthlyTotal(for: groupedRecords[month] ?? []) {
                                HStack {
                                    Spacer()
                                    Text("合計: \(total, specifier: "%.2f") 円")
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("家計簿")
        }
    }
                                    
    ///  入力された内容を元に新規Recordを作成して保存
    private func addRecord() {
        guard let amount = Double(amountText) else { return }
        let newRecord = Record(context: viewContext)
        newRecord.id = UUID()
        newRecord.type = selectedType
        newRecord.amount = amount
        newRecord.date = selectedDate
                                
        do {
            try viewContext.save()
            amountText = "" // 保存後に金額入力をクリア
        } catch {
            print("記録の保存に失敗: \(error)")
        }
    }
                                    
    // Recordを「yyyy年MM月」ごとにグループ化
    private var groupedRecords: [String: [Record]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return Dictionary(grouping: records) { record in
            let date = record.date ?? Date()
            return formatter.string(from: date)
        }
    }
    
    ///  指定されたRecord群の合計金額を計算
    private func monthlyTotal(for records: [Record]) -> Double? {
        records.map { $0.amount }.reduce(0, +)
    }
}
