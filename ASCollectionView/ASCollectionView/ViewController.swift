//
//  ViewController.swift
//  ASCollectionView
//
//  Created by Joshua on 2021/02/13.
//

import UIKit

import AsyncDisplayKit

fileprivate let ASYNC_COLLECTION_LAYOUT = true

fileprivate let kItemSize = CGSize(width: 180, height: 90)

class ViewController: UIViewController {
    var collectionNode: ASCollectionNode?
    var data: [[String]] = []
    var moveRecognizer: UILongPressGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let moveRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.moveRecognizer = moveRecognizer

        self.view.addGestureRecognizer(moveRecognizer)

        let collectionNode: ASCollectionNode

        if ASYNC_COLLECTION_LAYOUT {
            let layoutDelegate = ASCollectionGalleryLayoutDelegate(scrollableDirections: [.up, .down])
            layoutDelegate.propertiesProvider = self
            collectionNode = ASCollectionNode.init(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.headerReferenceSize = CGSize(width: 50, height: 50)
            layout.footerReferenceSize = CGSize(width: 50, height: 50)
            layout.itemSize = kItemSize
            collectionNode = ASCollectionNode(frame: self.view.bounds, collectionViewLayout: layout)
            collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
            collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        }
        
        self.collectionNode = collectionNode

        self.collectionNode?.dataSource = self
        self.collectionNode?.delegate = self

        self.collectionNode?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionNode?.backgroundColor = .white

        collectionNode.frame = self.view.bounds

        self.view.addSubnode(collectionNode)
        self.collectionNode = collectionNode

        if SIMULATE_WEB_RESPONSE {
            self.navigationItem.leftItemsSupplementBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                    target: self,
                                                                    action: #selector(reloadTapped))

            self.loadData()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(2)) { [weak self] in
                self?.handleSimulatedWebResponse()
            }
        }
    }

    @objc func reloadTapped() {
        self.collectionNode?.reloadData()
    }

    @objc func handleLongPress() {
        guard let collectionView = self.collectionNode?.view,
              let recognizer = self.moveRecognizer else { return }

        let location = recognizer.location(in: collectionView)

        switch recognizer.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        case .failed, .cancelled:
            collectionView.cancelInteractiveMovement()
        case .possible:
            break
        @unknown default:
            break
        }
    }

    private func handleSimulatedWebResponse() {
        self.collectionNode?.performBatchUpdates({
            self.loadData()
            self.collectionNode?.insertSections(IndexSet(0..<self.data.count))
        })
    }

    private func loadData() {
        var data = [[String]]()

        for i in 0..<100 {
            var items = [String]()

            for j in 0..<10 {
                items.append(String(format: "[%zd, %zd] says hi", i, j))
            }
            data.append(items)
        }

        self.data = data
    }
}

extension ViewController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let text = self.data[indexPath.section][indexPath.item]

        return {
            ItemNode(with: text)
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let isHeaderSection = kind == UICollectionView.elementKindSectionHeader
        let text = isHeaderSection ? "Header": "Footer"
        let node = SupplementaryNode(with: text)
        node.backgroundColor = isHeaderSection ? .blue: .red

        return node
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return self.data.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.data[section].count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, canMoveItemWith node: ASCellNode) -> Bool {
        return true
    }

    func collectionNode(_ collectionNode: ASCollectionNode, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let object = self.data[sourceIndexPath.section][sourceIndexPath.item]

        self.data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        self.data[destinationIndexPath.section].insert(object, at: destinationIndexPath.item)
    }
}

extension ViewController: ASCollectionDelegateFlowLayout {
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        print("fetch additional content")
        context.completeBatchFetching(true)
    }
}

extension ViewController: ASCollectionGalleryLayoutPropertiesProviding {
    func galleryLayoutDelegate(_ delegate: ASCollectionGalleryLayoutDelegate, sizeForElements elements: ASElementMap) -> CGSize {
        return kItemSize
    }
}



