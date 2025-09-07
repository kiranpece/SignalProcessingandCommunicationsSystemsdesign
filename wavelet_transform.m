
% Multi-resolution analysis and denoising using Discrete Wavelet Transform (DWT)

fs = 1000;                     % Sampling frequency
t = 0:1/fs:2-1/fs;             % Time vector (2 seconds)

% Create a multi-frequency signal with noise
signal = sin(2*pi*50*t) + 0.5*sin(2*pi*120*t);
noisy_signal = signal + 0.5*randn(size(t));

%% Plot original and noisy signal
figure;
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(2,1,2);
plot(t, noisy_signal);
title('Noisy Signal');
xlabel('Time (s)'); ylabel('Amplitude');

%% Perform Discrete Wavelet Transform
waveletName = 'db4';            % Daubechies 4 wavelet
level = 4;                       % Decomposition level

[C,L] = wavedec(noisy_signal, level, waveletName);

% Reconstruct signal (denoising)
thr = wthrmngr('dw1ddenoLVL','penalhi',C,L);  % Threshold using penalhi
denoised_signal = wdencmp('gbl',C,L,waveletName,level,thr,'s');

%% Plot denoised signal
figure;
plot(t, noisy_signal, 'r', 'DisplayName','Noisy Signal');
hold on;
plot(t, denoised_signal, 'b', 'DisplayName','Denoised Signal');
title('Wavelet Denoising');
xlabel('Time (s)'); ylabel('Amplitude');
legend;
