%% Test for kalman
measured = [];
filtered = [];
for k = 1:100
    detectedPositions = [k/200,sin(k/100),1
                            k/100,1,1];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k)=detectedPositions(1,2);
    filtered(k)=results(1,2);
end
for k = 101:150
    detectedPositions = [k/100,1,1
                            0,0,0];
    results = kalmanHandTracking(detectedPositions,1);
    measured(k)=detectedPositions(1,2);
    filtered(k)=results(1,2);
end
for k = 151:200
    detectedPositions = [k/200,sin(k/100),1
                            k/100,1,1];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k)=detectedPositions(1,2);
    filtered(k)=results(1,2);
end
for k = 201:220
    detectedPositions = [0,0,0
                         0,0,0];
    results = kalmanHandTracking(detectedPositions,0);
    measured(k)=detectedPositions(1,2);
    filtered(k)=results(1,2);
end
for k = 221:250
    detectedPositions = [k/200,sin(k/100),1
                            k/100,1,1];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k)=detectedPositions(1,2);
    filtered(k)=results(1,2);
end

plot(measured)
hold on
plot(filtered)