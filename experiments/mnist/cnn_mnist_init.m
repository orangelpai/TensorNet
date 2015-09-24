function net = cnn_mnist_init(varargin)
% Initialize a simple TensorNet for MNIST.

net.layers = {} ;
inputModeSize = [4, 8, 8, 4] ;
secondModeSize = [5, 5, 5, 5] ;
ranks = [1, 2, 2, 2, 1] ;
W = tt_rand(secondModeSize.*inputModeSize, length(secondModeSize), ranks, []) ;
W = tt_matrix(W, secondModeSize, inputModeSize) ;
W.core = single(W.core) ;
net.layers{end+1} = struct('type', 'custom', ...
                           'forward', @vl_nntt_forward, ...
                           'backward', @vl_nntt_backward, ...
                           'W', W, ...
                           'weights', {{W.core, zeros(1,1,prod(secondModeSize),'single')}}, ...
                           'learningRate', [1, 2], ...
                           'weightDecay', [1, 0], ...
                           'outHeight', 1, ...
                           'outWidth', 1, ...
                           'outChannels', prod(secondModeSize)) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.1*randn(1,1,prod(secondModeSize),10, 'single'), zeros(1, 10, 'single')}}, ...
                           'learningRate', [1, 2], ...
                           'weightDecay', [1, 0], ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'softmaxloss') ;
