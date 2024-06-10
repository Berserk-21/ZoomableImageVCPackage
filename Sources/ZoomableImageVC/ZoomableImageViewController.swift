//
//  ZoomableImageViewController.swift
//  ZoomableImageViewController
//
//  Created by Berserk on 07/06/2024.
//

import UIKit

public class ZoomableImageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var zoomableImageViewDelegate: ZoomableImageViewDelegate?
    private var closeButtonTintColor: UIColor = .white
    
    private let image: UIImage
    
    // MARK: - Life Cycle
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        zoomableImageViewDelegate?.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        
        view.backgroundColor = .black
        
        setupZoomableView()
        setupCancelButton()
    }
    
    private func setupZoomableView() {
        
        let zv = ZoomableImageView(image: image, frame: .zero)
        zv.panGestureDelegate = self
        zoomableImageViewDelegate = zv
        
        view.addSubview(zv)
        zv.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        zv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        zv.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        zv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        zv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCancelButton() {
        
        if navigationController == nil {
            let closeButton = UIButton()
            closeButton.setTitle("Close", for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            view.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0)
            ])
        } else {
            let leftBarButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
            leftBarButton.tintColor = closeButtonTintColor
            navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
     
        dismiss(animated: true)
    }

}

extension ZoomableImageViewController: PanGestureDelegate {
    
    /// Use this method to dismiss the view controller when a swipe down is recognized.
    func didSwipeDown() {
        self.dismiss(animated: true)
    }
}
