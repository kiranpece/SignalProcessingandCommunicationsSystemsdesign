%% 2x2 MIMO-OFDM Simulation with QPSK

clc; clear;

%% Parameters
Nt = 2;                  % Transmit antennas
Nr = 2;                  % Receive antennas
N = 64;                   % Number of OFDM subcarriers
numSymbols = 10;          % OFDM symbols per antenna
modOrder = 4;             % QPSK
cpLen = 16;               % Cyclic prefix length
SNR_dB = 20;              % SNR

%% Generate random QPSK data for each transmit antenna
data = randi([0 modOrder-1], N, numSymbols, Nt);
modData = zeros(N, numSymbols, Nt);
for tx = 1:Nt
    modData(:,:,tx) = pskmod(data(:,:,tx), modOrder, pi/4);
end

%% IFFT to create OFDM symbols
ifftData = zeros(N, numSymbols, Nt);
for tx = 1:Nt
    ifftData(:,:,tx) = ifft(modData(:,:,tx), N);
end

%% Add cyclic prefix
ofdmSignal = zeros(N+cpLen, numSymbols, Nt);
for tx = 1:Nt
    ofdmSignal(:,:,tx) = [ifftData(end-cpLen+1:end,:,tx); ifftData(:,:,tx)];
end

%% Channel: 2x2 MIMO Rayleigh + AWGN
rxSignal = zeros(N+cpLen, numSymbols, Nr);
for k = 1:numSymbols
    H = (randn(Nr,Nt)+1j*randn(Nr,Nt))/sqrt(2);  % Flat fading per OFDM symbol
    noise = sqrt(10^(-SNR_dB/10)/2)*(randn(Nr,1)+1j*randn(Nr,1));
    for n = 1:N+cpLen
        rxSignal(n,k,:) = H * squeeze(ofdmSignal(n,k,:)) + noise;
    end
end

%% Receiver: Remove cyclic prefix & FFT
rxFFT = zeros(N, numSymbols, Nr);
for rx = 1:Nr
    rxFFT(:,:,rx) = fft(rxSignal(cpLen+1:end,:,rx), N);
end

%% Simple Zero-Forcing MIMO Detection (per subcarrier)
rxDetected = zeros(N, numSymbols, Nt);
for k = 1:numSymbols
    H = (randn(Nr,Nt)+1j*randn(Nr,Nt))/sqrt(2);  % Channel matrix (assume known)
    for n = 1:N
        rxDetected(n,k,:) = pinv(H) * squeeze(rxFFT(n,k,:));
    end
end

%% QPSK Demodulation
rxBits = zeros(N, numSymbols, Nt);
for tx = 1:Nt
    rxBits(:,:,tx) = pskdemod(squeeze(rxDetected(:,:,tx)), modOrder, pi/4);
end

disp('MIMO-OFDM simulation completed. Check rxBits for received symbols.');
