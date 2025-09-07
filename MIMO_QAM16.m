%% 2x2 MIMO Simulation with 16-QAM and ZF Detection

clc; clear;

% Parameters
Nt = 2;          % Number of transmit antennas
Nr = 2;          % Number of receive antennas
numSymbols = 1000; % Number of 16-QAM symbols per antenna
M = 16;           % 16-QAM
SNR_dB = 20;      % SNR in dB

% Generate random 16-QAM symbols for each transmit antenna
txSymbols = randi([0 M-1], Nt, numSymbols);
qamSignal = qammod(txSymbols, M, 'UnitAveragePower', true);

% Channel: Rayleigh flat fading
H = (randn(Nr,Nt,numSymbols)+1j*randn(Nr,Nt,numSymbols))/sqrt(2);

% AWGN noise
noiseVar = 10^(-SNR_dB/10);
noise = sqrt(noiseVar/2)*(randn(Nr,numSymbols)+1j*randn(Nr,numSymbols));

% Transmit through channel
rxSymbols = zeros(Nr,numSymbols);
for k = 1:numSymbols
    rxSymbols(:,k) = H(:,:,k)*qamSignal(:,k) + noise(:,k);
end

% Zero-Forcing (ZF) Detection
rxDetected = zeros(size(qamSignal));
for k = 1:numSymbols
    rxDetected(:,k) = pinv(H(:,:,k))*rxSymbols(:,k);
end

% 16-QAM Demodulation
rxBits = qamdemod(rxDetected, M, 'UnitAveragePower', true);

% BER Calculation
BER = sum(txSymbols(:) ~= rxBits(:)) / (Nt*numSymbols);

disp(['Bit Error Rate (BER) for 2x2 MIMO 16-QAM: ', num2str(BER)]);
