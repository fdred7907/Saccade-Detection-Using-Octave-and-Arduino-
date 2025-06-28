#simulation of ecg signal with pvc
# filtering and cleaning ecg data
# identify R points through peak detection
# finding RR intervals and measuring 
# identifying PVC by falgging too short RR intervals and early P detection

% PVC Detection in ECG Signal
clear; clc; close all;

% Parameters
fs = 500; % Sampling frequency in Hz
t = 0:1/fs:10; % 10 seconds duration

% --- Step 1: Simulate ECG signal with a PVC ---
% Create synthetic ECG-like waveform
ecg_clean = 1.5 * sawtooth(2 * pi * 1.2 * t, 0.5); % base rhythm
noise = 0.1 * randn(size(t)); % EMG noise
ecg_signal = ecg_clean + noise;

% Inject a PVC at ~5.2s
pvc_index = round(5.2 * fs);
ecg_signal(pvc_index:pvc_index+20) = ecg_signal(pvc_index:pvc_index+20) + 2; % wide abnormal spike

% --- Step 2: Filter the signal (bandpass 0.5–40 Hz) ---
[b, a] = butter(2, [0.5 40]/(fs/2), 'bandpass');
ecg_filtered = filtfilt(b, a, ecg_signal);

% --- Step 3: R-peak detection using simple threshold method ---
min_peak_height = 1;  % adjust for simulated signal
[~, locs_R] = findpeaks(ecg_filtered, 'MinPeakHeight', min_peak_height, 'MinPeakDistance', round(0.4*fs),"DoubleSided");

% --- Step 4: Compute RR intervals ---
RR_intervals = diff(locs_R) / fs;

% --- Step 5: Detect PVC ---
% Rule: RR_i < 0.6*mean(RR) and QRS is wide → likely PVC
RR_mean = mean(RR_intervals);
pvc_candidates = find(RR_intervals < 0.6 * RR_mean);

% Mark detected PVC
pvc_locs = locs_R(pvc_candidates + 1); % PVC occurs at next beat

% --- Step 6: Plotting ---
figure;
subplot(2,1,1);
plot(t, ecg_filtered); hold on;
plot(locs_R/fs, ecg_filtered(locs_R), 'go', 'MarkerFaceColor', 'g');
plot(pvc_locs/fs, ecg_filtered(pvc_locs), 'ro', 'MarkerFaceColor', 'r');
legend('Filtered ECG', 'R-peaks', 'Detected PVC');
title('PVC Detection from Simulated ECG');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(2,1,2);
plot(RR_intervals, '-o'); hold on;
yline(RR_mean, '--', 'Mean RR');
yline(0.6*RR_mean, '--r', 'PVC Threshold');
title('RR Intervals');
xlabel('Beat #'); ylabel('Interval (s)'); grid on;

