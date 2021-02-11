clc;
clear;
load classifier;
[filename, pathname] = uigetfile('*.*');
ImageData=imread(strcat(pathname,filename));
testFeature= extractHOGFeatures(ImageData,'CellSize',[8 8]);
RecognizedClass=predict(classifier,testFeature);
disp(RecognizedClass);



