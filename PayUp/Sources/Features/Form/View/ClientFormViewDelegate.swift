//
//  ClientFormViewDelegate.swift
//  PayUp
//
//  Created by Arthur Rios on 30/06/25.
//

protocol ClientFormViewDelegate: AnyObject {
    func didTapCancel()
    func didTapSave()
    func didTapDelete()
}
