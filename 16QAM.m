%% 16-QAM Modulation and Demodulation

M = 16;                % 16-QAM
k = log2(M);           % Bits per symbol
numSymbols = 100;      % Number of symbols

% Generate random bit stream
bits = randi([0 1], 1, numSymbols*k);

% Reshape bits into groups of k bits per symbol
bitGroups = reshape(bits, k, []).';

% Map bits to 16-QAM symbols
symbols = bi2de(bitGroups,'left-msb'); 
qamSignal = qammod(symbols, M, 'UnitAveragePower', true);

% Plot constellation
figure;
scatter(real(qamSignal), imag(qamSignal), 'filled');
title('16-QAM Constellation');
xlabel('In-Phase'); ylabel('Quadrature');

%% Add AWGN noise
rxSignal = awgn(qamSignal, 20, 'measured'); % 20 dB SNR

% Demodulate
rxSymbols = qamdemod(rxSignal, M, 'UnitAveragePower', true);
rxBits = de2bi(rxSymbols, k, 'left-msb');
rxBits = reshape(rxBits.', 1, []);

disp('First 20 transmitted bits:');
disp(bits(1:20));
disp('First 20 received bits:');
disp(rxBits(1:20));
