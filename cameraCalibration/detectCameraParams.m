function params = detectCameraParams(images,imageFileNames,InitialIntrinsicMatrix,InitialRadialDistortion)
    % Detect the calibration pattern.
    [imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
    
    % Generate the world coordinates of the corners of the squares.
    squareSizeInMM = 25;
    worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

    % Calibrate the camera.
    I = readimage(images,1); 
    imageSize = [size(I, 1),size(I, 2)];
    params = estimateCameraParameters(...
        imagePoints,worldPoints,'ImageSize',imageSize,...
        'InitialIntrinsicMatrix', InitialIntrinsicMatrix,...
        'InitialRadialDistortion',InitialRadialDistortion...
        );

    % Visualize the calibration accuracy.
    %showReprojectionErrors(params);

    % Visualize camera extrinsics.
    figure;
    showExtrinsics(params);
    %drawnow;
end
