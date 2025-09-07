%% Basic 2x2 MIMO Simulation with ZF Detection

clc; clear;

% Parameters
Nt = 2;          % Number of transmit antennas
Nr = 2;          % Number of receive antennas
numSymbols = 1000; % Number of symbols
SNR_dB = 20;     % SNR in dB

% Generate random BPSK symbols for each transmit antenna
txSymbols = randi([0 1], Nt, numSymbols)*2-1; % Map 0->-1, 1->1

% Channel: Rayleigh flat fading
H = (randn(Nr,Nt,numSymbols)+1j*randn(Nr,Nt,numSymbols))/sqrt(2);

% AWGN noise
noiseVar = 10^(-SNR_dB/10);
noise = sqrt(noiseVar/2)*(randn(Nr,numSymbols)+1j*randn(Nr,numSymbols));

% Transmit through channel
rxSymbols = zeros(Nr,numSymbols);
for k = 1:numSymbols
    rxSymbols(:,k) = H(:,:,k)*txSymbols(:,k) + noise(:,k);
end

% Zero-Forcing Detection
rxDetected = zeros(size(txSymbols));
for k = 1:numSymbols
    rxDetected(:,k) = pinv(H(:,:,k))*rxSymbols(:,k);
end

% Decision (BPSK)
rxBits = real(rxDetected)>0;

% Original bits
txBits = (txSymbols+1)/2;

% BER Calculation
BER = sum(txBits(:) ~= rxBits(:)) / (Nt*numSymbols);

disp(['Bit Error Rate (BER): ', num2str(BER)]);
