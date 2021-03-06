
function proc_non_linear_ray_res3

return


%%

fn = 'initExpt.wf.txt';
a = textread(fn);

%%
% 1   2   3   4   5   6   7   8   9   10
% xx, yy, zz, cc, vr, om, rh, ja, tr, ss

fn = 'splinedEig.dat';
a = textread(fn);

%% plot raypath: load parameter file prm...
%% with columns: x, y, z, raypath_length, travel time, scaled_pressure\n");
% NR.xx[i], NR.yy[i], NR.zz[i], NR.ss[i], NR.tr[i], NR.ps[i])
%% 
% NR.xx[i], NR.yy[i], NR.zz[i], NR.ss[i], NR.tr[i], NR.ps[i])
% fn = 'Toygenray-0_Prm_100_3060.609_1.0Ex.txt'
% fn = 'NCP_zuvwtdp_Prm_100_384.188_1.0Ex.txt'
% fn = 'Toygenray-0_Prm_100_340.288_1.0Ex.txt'
fn = 'ray_params.txt'
ray = textread(fn);
Ntimesteps = size(ray,1)

%% plot ray
figure
plot3(ray(:,1)/1000,ray(:,2)/1000,ray(:,3)/1000, 'r')
hold on; rotate3d;
ylim([-1 1])
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')

%%
figure
plot(a(:,3)/1000, a(:,6),'b')
hold on; zoom on;
%%
% R.xx[i], R.yy[i], R.zz[i], R.ss[i], R.tr[i], R.om[i], R.ja[i]
fn = 'currentRay.dat';
a = textread(fn);

%%
I = 1:3824;
figure
plot(a(I,6), a(I,4)/1000,'b')
hold on; zoom on;




%%  load u (pressure) waveform along ray path
%% columns are: reduced_time, waveform1 2 3 ...Ntimesteps; 
% fn = 'Toygenray-0_Prs_100_340.288_1.0Ex.txt'
fn = 'pressure_wf_evolution.txt';

a = textread(fn); % the first column is reduced time; after that each column contains the waveform at that time step

if (Ntimesteps~=(size(a,2)-1))
    error('time steps in the ray parameter and the waveform files are different. They may not be from the same run')
end
%% plot the intial waveform vs reduced time
figure
plot(a(:,1)/1000, a(:,2)/1000,'b')
hold on; zoom on;
title('Initial waveform');


%%  plot points on eigenpath that correspond to the plotted waveforms in waterfall

I = 2:40:size(a,2);
figure
plot3(ray(:,1)/1000,ray(:,2)/1000,ray(:,3)/1000, 'r')
hold on; grid on; rotate3d;
plot3(ray(I-1,1)/1000,ray(I-1,2)/1000,ray(I-1,3)/1000, '.b')
ylim([-1 1])
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
title(sprintf('Eigenray path with markers for the waterfall plot'))

%% a waterfall
%  addpath(genpath('/home/doru/Doru_utilities'))
wf_dv(a(:,2:40:end)', 1, a(:,1)); %should start from column 2; the first is the time
xlabel('Reduced time [s]')
%%
j = 445;
figure
plot(a(:,1), a(:,j),'b')
hold on; zoom on;
plot(a(:,1), a(:,j+1)-0.06,'r')
% title(sprintf('j=%d', j))
xlabel('Reduced time [s]')

%% waterfall with anotation
auto = 1;
I = 2:40:size(a,2);
trvtime = ray(I-1, 5);
z_km = ray(I-1,3)/1000;
x = a(:,I)';
t = a(:,1);

if ~exist('auto')
  auto=0;
end
[M,N]=size(x);
if ~exist('t')
  t=[1:N];
end

figure
hold on; zoom on;

if (auto==0)
  mnx=min(min(x));
  mxx=max(max(x));
  dx=mxx-mnx;
  for i=1:M
    plot(t,x(i,:)-(i-1)*dx)
  end
else
  mnx=min(x,[],2);
  mxx=max(x,[],2);
  for i=1:M
    x(i,:)=(x(i,:)-mnx(i))/(mxx(i)-mnx(i));
    plot(t,x(i,:)-(i-1))
    text(t(1),x(i,1)-(i-1), sprintf('%.1f sec; z = %.1f km', trvtime(i), z_km(i))) 
  end
end
xlabel('Reduced time [s]')
title(sprintf('Waterfall of (scaled) waveform evolution along the eigenray path'))
return

%% plot raypath and waterfall side by side

I = 2:40:size(a,2);
fig1 = figure('Position', [319 137 1044 472])
hax1 = axes('Position', [0.0677395 0.114237 0.351801 0.748051])
plot3(ray(:,1)/1000,ray(:,2)/1000,ray(:,3)/1000, 'r')
hold on; grid on; rotate3d;
plot3(ray(I-1,1)/1000,ray(I-1,2)/1000,ray(I-1,3)/1000, '.b')
ylim([-1 1])
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
title(sprintf('Eigenray path with markers for the waterfall plot'))

hax2 = axes('Position', [0.495211 0.11 0.482759 0.724746])
auto = 1;
I = 2:40:size(a,2);
trvtime = ray(I-1, 5);
z_km = ray(I-1,3)/1000;
x = a(:,I)';
t = a(:,1);

if ~exist('auto')
  auto=0;
end
[M,N]=size(x);
if ~exist('t')
  t=[1:N];
end

% figure
hold on; 

if (auto==0)
  mnx=min(min(x));
  mxx=max(max(x));
  dx=mxx-mnx;
  for i=1:M
    plot(t,x(i,:)-(i-1)*dx)
  end
else
  mnx=min(x,[],2);
  mxx=max(x,[],2);
  for i=1:M
    x(i,:)=(x(i,:)-mnx(i))/(mxx(i)-mnx(i));
    plot(t,x(i,:)-(i-1))
    text(t(1),x(i,1)-(i-1), sprintf('%.1f sec; z = %.1f km', trvtime(i), z_km(i))) 
  end
end
xlabel('Reduced time [s]')
title(sprintf('Waterfall of (scaled) waveform evolution along the eigenray path'))


%%


createfigure1(ray(:,1)/1000,ray(:,2)/1000,ray(:,3)/1000, ray(I-1,1)/1000,ray(I-1,2)/1000,ray(I-1,3)/1000, t, x)

%% save to .png
print(fig1, '-dpng', 'fig_wnrt_example')
%%
print(fig1, '-djpeg', 'fig_wnrt_example')

%%
print(fig1, '-depsc2', 'fig_wnrt_example')

%%
print(fig1, '-dtiff', 'fig_wnrt_example')
%% -----------------------




%%
figure
plot3(a(:,2), a(:,3), a(:,4))
hold on;rotate3d;
%%

figure
plot(a(:,10), a(:,1),'r')
hold on; zoom on;
plot(a(:,10), a(:,11)*1000,'r')
%%
% fn = 'proofile111_Prs_100_-0.000_1.0Ex.txt'
% fn = 'proofile111_Prm_100_-0.000_1.0Ex.txt'
fn = 'proofile111_Prs_100_1226.399_1.0Ex.txt'
a = textread(fn);

%%

figure
plot(a(:,1), a(:,2))
hold on; zoom on;
%%
j = 100
figure
plot(a(:,1), a(:,j))
hold on; zoom on;

%%
j = 100
figure
plot3(a(:,1), a(:,2), a(:,3))
hold on;rotate3d;







return
