//
//  ZoomableImageView.swift
//  ZoomableImageViewController
//
//  Created by Berserk on 07/06/2024.
//

import UIKit

protocol ZoomableImageViewDelegate {
    func viewDidLayoutSubviews()
}

protocol PanGestureDelegate: AnyObject {
    func didSwipeDown()
}

final class ZoomableImageView: UIScrollView {
    
    // MARK: - Properties
    
    private let imageView: UIImageView
    weak var panGestureDelegate: PanGestureDelegate?
    
    // MARK: - Life Cycle
        
    init(image: UIImage, frame: CGRect) {
        imageView = UIImageView(image: image)
        super.init(frame: frame)

        setupLayout()
        setupPanGesture()
        setupDoubleTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupLayout() {
        
        setupScrollView()
        initializeImageView()
    }
    
    private func setupScrollView() {
        
        backgroundColor = .clear
        maximumZoomScale = 3.0
        minimumZoomScale = 1
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        clipsToBounds = true
    }
    
    private func initializeImageView() {
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
    }
    
    /// Use this method to update frames when views did layout subviews.
    private func setupFrames() {
        
        setupScrollViewFrame()
        
        setupImageViewFrame()
        
        // Centering image view
        centerImageViewFrame()
    }
    
    /// Use this method to setup ScrollView frame, taking safeAreaInsets in consideration.
    private func setupScrollViewFrame() {
        
        guard let containerView = superview else { return }
        
        // Setup ScrollView frame.
        let topInset = containerView.safeAreaInsets.top
        let bottomInset = containerView.safeAreaInsets.bottom
        
        let scrollViewFrame = CGRect(x: 0.0, y: topInset, width: containerView.frame.width, height: containerView.frame.height - topInset - bottomInset)
        frame = scrollViewFrame
    }
    
    /// Use this method to setup the ImageView frame based on the parent ScrollView width.
    private func setupImageViewFrame() {
        guard let image = imageView.image else { return }
        
        let scrollViewWidth = frame.width
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        var aspectRatio: CGFloat = 1

        if imageWidth > imageHeight { // Landscape
            aspectRatio = imageHeight / imageWidth
            imageView.frame.size.width = scrollViewWidth
            imageView.frame.size.height = scrollViewWidth * aspectRatio
        } else if imageHeight > imageWidth { // Portrait
            aspectRatio = imageWidth / imageHeight
            imageView.frame.size.width = scrollViewWidth * aspectRatio
            imageView.frame.size.height = scrollViewWidth
            
        } else { // Square
            imageView.frame.size.width = scrollViewWidth
            imageView.frame.size.height = scrollViewWidth
        }
    }
    
    // Update ImageView x and y position.
    func centerImageViewFrame() {
        
        let scrollViewBoundsSize = self.bounds.size
        let imageViewWidth = imageView.frame.width
        let imageViewHeight = imageView.frame.height
        
        imageView.frame.origin.x = (imageViewWidth < scrollViewBoundsSize.width) ?
        (scrollViewBoundsSize.width - imageViewWidth) / 2.0 : 0.0
        imageView.frame.origin.y = (imageViewHeight < scrollViewBoundsSize.height) ?
        (scrollViewBoundsSize.height - imageViewHeight) / 2.0 : 0.0
    }
}

// MARK: UIScrollViewDelegate

extension ZoomableImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageViewFrame()
    }
}

// MARK: ZoomableImageViewDelegate

extension ZoomableImageView: ZoomableImageViewDelegate {
    
    func viewDidLayoutSubviews() {
        setupFrames()
    }
}


// MARK: - UIPanGesture Methods

extension ZoomableImageView {
    
    private func setupPanGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard zoomScale < 2.0 else { return }
        
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        let velocityThreshold: CGFloat = 800.0
        let xMaxTranslation: CGFloat = 50.0
        let yMinTranslaton: CGFloat = 100.0
                
        switch gesture.state {
        case .ended:
            if translation.y > yMinTranslaton && abs(translation.x) < xMaxTranslation, velocity.y > velocityThreshold {
                panGestureDelegate?.didSwipeDown()
            }
        default:
            break
        }
    }
}

// MARK: - UITapGesture Methods

extension ZoomableImageView {
    
    private func setupDoubleTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        let scrollViewSize = bounds.size
            
        // Determine the position of the tap
        let tapPoint = gesture.location(in: imageView)
        
        // Calculate the new zoom scale
        let newZoomScale: CGFloat = zoomScale == minimumZoomScale ? maximumZoomScale : minimumZoomScale
        
        // Calculate the size of the zoomed area
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        
        // Calculate the new content offset to center the tapped point
        let offsetX = tapPoint.x - (width / 2.0)
        let offsetY = tapPoint.y - (height / 2.0)
        
        // Create a rectangle then zoom into, prevent negative offsets.
        let zoomRect = CGRect(x: max(offsetX, 0), y: max(offsetY, 0), width: width, height: height)
        zoom(to: zoomRect, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ZoomableImageView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
