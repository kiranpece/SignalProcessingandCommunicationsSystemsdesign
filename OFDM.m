%% Simple OFDM Simulation

N = 64;                    % Number of subcarriers
numSymbols = 10;            % OFDM symbols
modOrder = 4;               % QPSK for subcarriers

% Generate random data for all subcarriers
data = randi([0 modOrder-1], N, numSymbols);

% QPSK modulation for each subcarrier
modData = pskmod(data, modOrder, pi/4);

% IFFT to generate OFDM symbols
ifftData = ifft(modData, N);

% Add cyclic prefix
cpLen = 16;
ofdmSignal = [ifftData(end-cpLen+1:end,:); ifftData];

% Serialize OFDM signal
txSignal = ofdmSignal(:);

% Plot first OFDM symbol
figure;
plot(real(txSignal(1:N+cpLen)));
title('OFDM Signal (Real Part with Cyclic Prefix)');
xlabel('Sample'); ylabel('Amplitude');

%% Add AWGN
rxSignal = awgn(txSignal, 20, 'measured');

% Receiver: Remove cyclic prefix
rxSymbols = reshape(rxSignal, N+cpLen, numSymbols);
rxSymbols = rxSymbols(cpLen+1:end, :);

% FFT to recover subcarriers
rxData = fft(rxSymbols, N);

% QPSK demodulation
rxBits = pskdemod(rxData, modOrder, pi/4);

disp('First 10 transmitted symbols:');
disp(data(:,1)');
disp('First 10 received symbols:');
disp(rxBits(:,1)');
