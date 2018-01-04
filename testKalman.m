%% Test for kalman
measured = [];
filtered = [];
for k = 1:100
    detectedPositions = [k/200,sin(k/100),k
                            k/100,1,k];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k,:,:)=detectedPositions;
    filtered(k,:,:)=results;
end
for k = 101:150
    detectedPositions = [k/100,1,k
                            0,0,k];
    results = kalmanHandTracking(detectedPositions,1);
    measured(k,:,:)=detectedPositions;
    filtered(k,:,:)=results;
end
for k = 151:200
    detectedPositions = [k/200,sin(k/100),k
                            k/100,1,k];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k,:,:)=detectedPositions;
    filtered(k,:,:)=results;
end
for k = 201:220
    detectedPositions = [0,0,k
                         0,0,k];
    results = kalmanHandTracking(detectedPositions,0);
    measured(k,:,:)=detectedPositions;
    filtered(k,:,:)=results;
end
for k = 221:250
    detectedPositions = [k/200,sin(k/100),k
                            k/100,1,k];
    results = kalmanHandTracking(detectedPositions,2);
    measured(k,:,:)=detectedPositions;
    filtered(k,:,:)=results;
end

plot3(filtered(:,1,1),filtered(:,1,2),filtered(:,1,3))
hold on
plot3(filtered(:,2,1),filtered(:,2,2),filtered(:,2,3))
plot3(measured(:,1,1),measured(:,1,2),measured(:,1,3),'-.')
plot3(measured(:,2,1),measured(:,2,2),measured(:,2,3),'--')