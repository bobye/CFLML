%% configuration
data = dlmread('data/bals.data');
projdim = 3;
knearest = 5;
EMitermax = 5;

repeattime = 10;

%% evaluation bench
tic;
knnerr = [];
eucknnerr = [];
for i = 1:repeart;
% data input and cut
dataset = data(:,1:end-1);
label = data(:,end);
[trainset, trainidx] = cutset(dataset, label, .85);
trainlabel = label(trainidx);
dataset(trainidx,:) = [];
label(trainidx) = [];
testset = dataset;
testlabel = label;

    
    numberoftestinstance = size(testset,1);
    numberoftraininstance = size(trainset,1);
    %% knn classification
    dimension = size(trainset,2);
    
    [M MIDX R RC]= CFLML(trainset, trainlabel, projdim, knearest, eye(dimension), EMitermax);

    

       
    testclass = knnclsmm(testset, R, RC, knearest, MIDX, M);
    euctestclass = knnclassify(testset, R, RC, knearest);
    
    knnerr(end+1) = 1 - sum(testclass == testlabel)/numberoftestinstance;
    eucknnerr(end+1) = 1 - sum(euctestclass == testlabel)/numberoftestinstance;
end
strtmp = sprintf('k:%d\terr:%.2f(%.2f)%%\t%.2f(%.2f)%%', knearest, ...
    100*mean(knnerr), 100*std(knnerr), 100*mean(eucknnerr), 100*std(eucknnerr));
disp(strtmp);
toc;
