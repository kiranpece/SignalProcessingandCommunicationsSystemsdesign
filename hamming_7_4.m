%% Hamming (7,4) Code: Encoding, Transmission with Noise, Decoding

clc; clear;

% Generate random 4-bit message
msg = randi([0 1], 1, 4);
disp('Original message:');
disp(msg);

%% Encoding
% Generator matrix for (7,4) Hamming code
G = [1 0 0 0 0 1 1;
     0 1 0 0 1 0 1;
     0 0 1 0 1 1 0;
     0 0 0 1 1 1 1];

codeword = mod(msg*G,2);
disp('Encoded 7-bit codeword:');
disp(codeword);

%% Transmission with noise (simulate bit flip)
SNR = 5; % probability of bit error approx
rx = codeword;
for i = 1:length(rx)
    if rand < 0.5 * 10^(-SNR/10)
        rx(i) = 1 - rx(i); % flip bit
    end
end
disp('Received codeword with errors:');
disp(rx);

%% Decoding using syndrome
% Parity-check matrix H
H = [0 1 1 1 1 0 0;
     1 0 1 1 0 1 0;
     1 1 0 1 0 0 1];

s = mod(H*rx',2); % syndrome
s_decimal = bi2de(s','left-msb');

% Correct single-bit error if syndrome != 0
if s_decimal ~= 0
    rx(s_decimal) = 1 - rx(s_decimal);
    disp(['Error detected and corrected at bit position: ', num2str(s_decimal)]);
else
    disp('No error detected');
end

% Extract original message
decoded_msg = rx(1:4);
disp('Decoded message:');
disp(decoded_msg);
