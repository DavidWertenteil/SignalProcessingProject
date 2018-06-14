function feat = featuresFromBuffer(atx, aty, atz, fs)

persistent fhp
if(isempty(fhp))
    fhp = hpfilter;
    fhp.PersistentMemory = false;
end

feat = zeros(1,66);

abx = filter(fhp,atx);
aby = filter(fhp,aty);
abz = filter(fhp,atz);

%%
feat(1) = mean(aty);
feat(2) = mean(atz);

%%
feat(3) = rms(aby);

%%
feat(4) = covFeatures(aby, fs);

%%
feat(5) = spectralPeaksFeatures(abx, fs);
feat(40:51) = spectralPeaksFeatures(abz, fs);

%%
feat(52:56) = spectralPowerFeatures(abx, fs);
feat(57:61) = spectralPowerFeatures(aby, fs);
feat(62:66) = spectralPowerFeatures(abz, fs);

%%
function feats = covFeatures(x, fs)

feats = zeros(1);

[c, lags] = xcorr(x);

minprom = 0.0005;
mindist_xunits = 0.3;
minpkdist = floor(mindist_xunits/(1/fs));
[pks,locs] = findpeaks(c,...
    'minpeakprominence',minprom,...
    'minpeakdistance',minpkdist);

tc = (1/fs)*lags;
tcl = tc(locs);
% Feature 1 - peak height at 0
if(~isempty(tcl))   % else f1 already 0
    feats(1) = pks((end+1)/2);
end

%%
function feats = spectralPeaksFeatures(x, fs)

mindist_xunits = 0.3;

feats = zeros(1);

N = 4096;
minpkdist = floor(mindist_xunits/(fs/N));

[p, f] = pwelch(x,rectwin(length(x)),[],N,fs);

[pks,locs] = findpeaks(p,'npeaks',20,'minpeakdistance',minpkdist);
if(~isempty(pks))
    mx = min(6,length(pks));
    [spks, idx] = sort(pks,'descend');
    slocs = locs(idx);

    pks = spks(1:mx);
    locs = slocs(1:mx);

    [slocs, idx] = sort(locs,'ascend');
    spks = pks(idx);
    pks = spks;
    locs = slocs;
end
fpk = f(locs);

% Features 1-6 positions of highest 6 peaks
feats(1) = fpk(6);

function feats = spectralPowerFeatures(x, fs)

feats = zeros(1,5);

edges = [0.5, 1.5, 5, 10, 15, 20];

[p, f] = periodogram(x,[],4096,fs);
    
for kband = 1:length(edges)-1
    feats(kband) = sum(p( (f>=edges(kband)) & (f<edges(kband+1)) ));
end
