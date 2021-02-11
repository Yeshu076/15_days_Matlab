function [y1] = cancerdetection(x1)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 22-Jan-2021 12:31:29.
%
% [y1] = myNeuralNetworkFunction(x1) takes these arguments:
%   x = 9xQ matrix, input #1
% and returns:
%   y = 2xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.gain = [2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222;2.22222222222222];
x1_step1.ymin = -1;

% Layer 1
b1 = [1.7946855797699123869;1.4920893982247533938;0.99581066122017869446;-0.75625671046336995218;0.24018656433200380462;0.15530172015003154695;0.62864080303044478359;1.5062847911403201007;-1.3052819752742894632;-1.789237863942953366];
IW1_1 = [-1.040437889669193483 0.026767450644719695957 -0.65092348390104048939 -0.16892636982975040016 0.52097836011743492435 0.3431224474613134845 -0.13126563515288797168 -0.98833046095363219496 -0.62127981157681588797;-0.037042625562901748681 -0.14804302686511242038 -0.042510824857029838597 -0.67141017975486760871 -0.83601968905388501785 0.79139523883761297984 -0.86598176205617793944 -0.59254886622864122447 -0.41382354120803016562;-0.36618723115393292389 -0.71952723452206535093 0.68614986612606976291 0.36852870998300235605 0.57800815516012726825 -0.86675981859222206438 -0.78764368321612165946 0.40115552847186686236 0.5311446179207767182;0.20657415388801750322 -0.1099949861397802181 0.56147985658572141521 -0.27401274625527749507 -0.99551641746410535205 0.57993779277962065333 0.24928570770269026236 0.82058638278802953359 0.75536313740669669414;-0.90057274577146761985 -0.35593790207065945097 -0.36575927899360438644 0.93915481748039197907 -0.68534829320969425925 -0.21374080314427035265 0.60067599889747091968 0.51299955705723021548 0.080086427642053259479;0.17627413832361957247 0.10289013388222867373 -0.46139649769410101543 -1.2592681907518916695 -0.83524008818919537323 0.44409397929438765296 0.47532304136756792223 -0.55362984672968518218 0.2050491579492946248;0.41222593121544648387 0.78461021143288356416 -0.63207466056228045481 0.78925238046172874196 0.95111060314274664673 -0.23355918527042363042 -0.14777574223309261625 -0.45927858025498863315 -0.3439735021778727031;0.60013789177107423889 0.37797226477609924267 0.55035177154538017508 0.14017750869069950381 -0.86915360666538998835 0.55776790923261931887 0.8231876223327149189 0.57603251266268740149 0.15606753863814926131;-0.12230532884872079291 1.1692798276363458587 0.065798247042266097551 0.13768662468660430864 0.25024237737414084526 0.66968368155160651334 0.094236493316714506352 0.91362347276159938669 0.84673437483414559779;-0.80572746208567325166 -0.77953488183924202204 -0.50978787902385958031 0.29825040713062128672 0.2675034214555404577 0.89383631162342547238 0.83867976797720045212 -0.39387150783476565508 -0.1142015500304010972];

% Layer 2
b2 = [0.722043126101379662;0.13525497876003639286];
LW2_1 = [0.0037680129590790950589 -0.33401551246698329978 1.086417570975939384 0.15965020951191652432 0.25893177044046772339 -0.42281743584504810629 -0.60574270510463146255 -1.681512346938676794 0.26721040375774707254 -0.031001063768935216425;-0.18001197284641462515 0.24284452384940258263 0.53796327944788968622 -0.14423330708339834882 -0.61599475934122505105 -0.94837519302636841267 0.067294134634645397242 1.4728881714702226624 1.0303116188141550058 0.32604405759183452407];

% ===== SIMULATION ========

% Dimensions
Q = size(x1,2); % samples

% Input 1
xp1 = mapminmax_apply(x1,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = softmax_apply(repmat(b2,1,Q) + LW2_1*a1);

% Output 1
y1 = a2;
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Competitive Soft Transfer Function
function a = softmax_apply(n,~)
if isa(n,'gpuArray')
    a = iSoftmaxApplyGPU(n);
else
    a = iSoftmaxApplyCPU(n);
end
end
function a = iSoftmaxApplyCPU(n)
nmax = max(n,[],1);
n = bsxfun(@minus,n,nmax);
numerator = exp(n);
denominator = sum(numerator,1);
denominator(denominator == 0) = 1;
a = bsxfun(@rdivide,numerator,denominator);
end
function a = iSoftmaxApplyGPU(n)
nmax = max(n,[],1);
numerator = arrayfun(@iSoftmaxApplyGPUHelper1,n,nmax);
denominator = sum(numerator,1);
a = arrayfun(@iSoftmaxApplyGPUHelper2,numerator,denominator);
end
function numerator = iSoftmaxApplyGPUHelper1(n,nmax)
numerator = exp(n - nmax);
end
function a = iSoftmaxApplyGPUHelper2(numerator,denominator)
if (denominator == 0)
    a = numerator;
else
    a = numerator ./ denominator;
end
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end