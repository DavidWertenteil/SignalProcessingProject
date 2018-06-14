function feat = featuresFromBuffer(aty, atz, fs)

persistent fhp
if(isempty(fhp))
    fhp = hpfilter;
    fhp.PersistentMemory = false;
end

feat = zeros(1,10);

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

feat(5:6) = spectralPeaksFeatures(abz, fs);

%%
feat(7:9) = spectralPowerFeaturesY(aby, fs);
feat(10) = spectralPowerFeaturesZ(abz, fs);

%%
function feats = covFeatures(x, fs)

feats = 0;

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
    feats = pks((end+1)/2);
end
%%
function feats = spectralPeaksFeatures(x, fs)

mindist_xunits = 0.3;

feats = zeros(1,2);

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

if(length(fpk) >= 5)
    feats(1) = fpk(5);
end
if(length(pks) >= 2)
    feats(2) = pks(2);
end
%%
function feats = spectralPowerFeaturesY(x, fs)

feats = zeros(1,3);

edges = [0.5, 1.5, 5, 10, 15, 20];

[p, f] = periodogram(x,[],4096,fs);
    
for kband = 2:length(edges)-2
    feats(kband - 1) = sum(p( (f>=edges(kband)) & (f<edges(kband+1)) ));
end
%%
function feats = spectralPowerFeaturesZ(x, fs)

edges = [0.5, 1.5, 5, 10, 15, 20];

[p, f] = periodogram(x,[],4096,fs);
    
feats = sum(p( (f>=edges(1)) & (f<edges(2)) ));

