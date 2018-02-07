function [handPositions] = kalmanHandTracking(detectedPositions, count, defaultPositions)
    persistent hand1est hand2est hand1p hand2p;
    if isempty(hand1est)
        hand1est = zeros(9, 1);
        hand2est = zeros(9, 1);
        hand1p = zeros(9, 9);
        hand2p = zeros(9, 9);
    end
    %Apply a kalman filter for each coordinate x,y,z
    % x y z Vx Vy Vz Ax Ay Az
    dt = 1;
    A=[ 1 0 0 dt 0 0 0 0 0;
        0 1 0 0 dt 0 0 0 0;
        0 0 1 0 0 dt 0 0 0;
        0 0 0 1 0 0 dt 0 0;
        0 0 0 0 1 0 0 dt 0;
        0 0 0 0 0 1 0 0 dt;
        0 0 0 0 0 0 0.75 0 0;
        0 0 0 0 0 0 0 0.75 0;
        0 0 0 0 0 0 0 0 0.75];
    H = [ 1 0 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0 0; 0 0 1 0 0 0 0 0 0 ];    % Initialize measurement matrix
    Q = eye(9);
    R = 1000 * eye(3);
    % Predicted state and covariance
    hand1prd = A * hand1est;
    hand2prd = A * hand2est;
    hand1pprd = A * hand1p * A' + Q;
    hand2pprd = A * hand2p * A' + Q;
    % Estimation
    S1 = H * hand1pprd' * H' + R;
    S2 = H * hand2pprd' * H' + R;
    B1 = H * hand1pprd';
    B2 = H * hand2pprd';
    klm_gain1 = (S1 \ B1)';
    klm_gain2 = (S2 \ B2)';
    % Estimated state and covariance
    position = detectedPositions(1,:);
    tmp = hand1prd + klm_gain1 * (position - H * hand1prd);
    D1 = sqrt(sum((tmp - position) .^ 2));
    tmp = hand2prd + klm_gain2 * (position - H * hand2prd);
    D2 = sqrt(sum((tmp - position) .^ 2));
    if count == 2
        position2 = detectedPositions(2,:);
        tmp = hand1prd + klm_gain1 * (position2 - H * hand1prd);
        D3 = sqrt(sum((tmp - position) .^ 2));
        tmp = hand2prd + klm_gain2 * (position2 - H * hand2prd);
        D4 = sqrt(sum((tmp - position) .^ 2));
        if D3 < D4
            if D1 < D2
                hand1est = hand1prd + klm_gain1 * (detectedPositions(1,:) - H * hand1prd);
                hand1p = hand1pprd - klm_gain1 * H * hand1pprd;
                hand2est = hand2prd + klm_gain2 * (detectedPositions(2,:) - H * hand2prd);
                hand2p = hand2pprd - klm_gain2 * H * hand2pprd;
            else
                hand1est = hand1prd + klm_gain1 * (detectedPositions(2,:) - H * hand1prd);
                hand1p = hand1pprd - klm_gain1 * H * hand1pprd;
                hand2est = hand2prd + klm_gain2 * (detectedPositions(1,:) - H * hand2prd);
                hand2p = hand2pprd - klm_gain2 * H * hand2pprd;
            end
        else
            hand1est = hand1prd + klm_gain1 * (detectedPositions(2,:) - H * hand1prd);
            hand1p = hand1pprd - klm_gain1 * H * hand1pprd;
            hand2est = hand2prd + klm_gain2 * (detectedPositions(1,:) - H * hand2prd);
            hand2p = hand2pprd - klm_gain2 * H * hand2pprd;
        end
    elseif count == 1
        if D1 < D2
            hand1est = hand1prd + klm_gain1 * (detectedPositions(1,:) - H * hand1prd);
            hand1p = hand1pprd - klm_gain1 * H * hand1pprd;
            hand2est = hand2prd;
            hand2p = hand2pprd;
        else
            hand2est = hand2prd + klm_gain2 * (detectedPositions(1,:) - H * hand2prd);
            hand2p = hand2pprd - klm_gain2 * H * hand2pprd;
            hand1est = hand1prd;
            hand1p =  hand1pprd;
        end
    else
        % hands are lost, keep estimating
        hand1est = hand1prd;
        hand1p = hand1pprd;
        hand2est = hand2prd;
        hand2p = hand2pprd;
    end
    % return estimation
    tmp = H * hand1est;
    handPositions(1,:) = tmp(1,:);
    tmp = H * hand2est;
    handPositions(2,:) = tmp(1,:);
end