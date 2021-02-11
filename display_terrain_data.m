clc; close all; clear all;
addpath([pwd '/filters']);
addpath([pwd '/export_fig']);

load terrain_data_C;
arena_carpet = terrain_data.data{1};
arena_gravel = terrain_data.data{2};
arena_tile = terrain_data.data{3};

% Colors
COLOR_BLUE = [30 67 154]/255;
COLOR_GREEN = [18 184 18]/255;
COLOR_RED = [230 23 23]/255;
COLOR_YELLOW = [255 161 23]/255;

%% Princple components
load terrain_data_duncaroach_train_features;
close all;
[coeff score latent] = princomp(train_features);
% impcont = zeros(25,25);
% for pc = 1:25
% impcont(:,pc) = sqrt(sum(coeff(:,1:pc).^2,2));
% end
% figure; contour(impcont); axis equal;
pc = 7;
importance = sqrt(sum(coeff(:,1:pc).^2,2));
figure;
subplot(2,1,1); hold on;
var_exp = 100*cumsum(latent)./sum(latent);
pt1 = 7; pt2 = 10; pt3 = 15; 
plot(var_exp,'LineSmoothing','On','LineWidth',4,'Color',COLOR_BLUE);
scatter([pt1],[var_exp(pt1)],'o','filled','SizeData',[150],'MarkerEdgeColor',COLOR_RED,'MarkerFaceColor',COLOR_RED);
scatter([pt2],[var_exp(pt2)],'o','filled','SizeData',[150],'MarkerEdgeColor',COLOR_GREEN,'MarkerFaceColor',COLOR_GREEN);
scatter([pt3],[var_exp(pt3)],'o','filled','SizeData',[150],'MarkerEdgeColor',COLOR_YELLOW,'MarkerFaceColor',COLOR_YELLOW);
line([0 pt1],[var_exp(pt1) var_exp(pt1)],'LineStyle','--','LineWidth',4,'Color',COLOR_RED);
line([pt1 pt1],[0 var_exp(pt1)],'LineStyle','--','LineWidth',4,'Color',COLOR_RED);
line([0 pt2],[var_exp(pt2) var_exp(pt2)],'LineStyle','--','LineWidth',4,'Color',COLOR_GREEN);
line([pt2 pt2],[0 var_exp(pt2)],'LineStyle','--','LineWidth',4,'Color',COLOR_GREEN);
line([0 pt3],[var_exp(pt3) var_exp(pt3)],'LineStyle','--','LineWidth',4,'Color',COLOR_YELLOW);
line([pt3 pt3],[0 var_exp(pt3)],'LineStyle','--','LineWidth',4,'Color',COLOR_YELLOW);
xlim([0.5 25]); ylim([50 100.5]); grid on;
set(gca,'FontName','CMU Serif','FontSize',18);
ylabel('Variance explained ($\%$)','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
xlabel('Number of features','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
set(gca,'XTick',1:25);
set(gca,'YTick',0:10:100);
legend('\sigma^2 explained',[num2str(ceil(var_exp(pt1))) '% (' num2str(pt1) ' features)'],[num2str(ceil(var_exp(pt2))) '% (' num2str(pt2) ' features)'],[num2str(ceil(var_exp(pt3))) '% (' num2str(pt3) ' features)'],'Location','SouthEast');

h = subplot(2,1,2);
bar(importance,'FaceColor',COLOR_BLUE); xlim([0 25.5]); %ylim([0 1]);
set(gca,'FontName','CMU Serif','FontSize',18);
tlabels = {'$f_{c}$',...
           '$\mu^{\ddot x}_2$',...
           '$\mu^{\ddot y}_2$',...
           '$\mu^{\ddot z}_2$',...
           '$\mu^{\dot \phi}_2$',...   % roll X
           '$\mu^{\dot \theta}_2$',... % pitch Y
           '$\mu^{\dot \psi}_2$',...   % yaw Z
           '$\mu^{\mathcal{E}_L}_2$',...
           '$\mu^{\mathcal{E}_R}_2$',...
           '$\mu^{\ddot x}_3$',...
           '$\mu^{\ddot y}_3$',...
           '$\mu^{\ddot z}_3$',...
           '$\mu^{\dot \phi}_3$',...
           '$\mu^{\dot \theta}_3$',...
           '$\mu^{\dot \psi}_3$',...
           '$\mu^{\mathcal{E}_L}_3$',...
           '$\mu^{\mathcal{E}_R}_3$',...
           '$\mu^{\ddot x}_4$',...
           '$\mu^{\ddot y}_4$',...
           '$\mu^{\ddot z}_4$',...
           '$\mu^{\dot \phi}_4$',...
           '$\mu^{\dot \theta}_4$',...
           '$\mu^{\dot \psi}_4$',...
           '$\mu^{\mathcal{E}_L}_4$',...
           '$\mu^{\mathcal{E}_R}_4$'};
           
set(gca,'XTick',1:25);
format_ticks(h,tlabels,[],[],[],[],[],[0.1],'Interpreter','latex','VerticalAlignment','bottom');
xlabel('Feature','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') - [0 .06 0])
ylabel('Importance weight (rank 7)','FontSize',24,'FontName','CMU Serif','Interpreter','latex');

h1 = subplot(2,1,1);
h2 = subplot(2,1,2);
axp1 = get(h1,'position');
axp2 = get(h2,'position');
set(h1,'position',[axp1(1:3) axp1(4) + .05]);
set(h2,'position',[axp2(1:3) axp2(4) + .05]);

set(gcf,'Units','inches');
set(gcf,'Position',[1 1 10 10]);
export_fig ../iros2012_gait/figures/pca -pdf -transparent

% figure; hold all;
% scatter(train_features(train_labels == 1,16), train_features(train_labels == 1,pc),'*r');
% scatter(train_features(train_labels == 2,16), train_features(train_labels == 2,pc),'*b');
% scatter(train_features(train_labels == 3,16), score(train_labels == 3,pc),'*g');
% set(gca,'YScale','log');
% xlabel('$f_{stride}$ (Hz)','FontSize',18,'FontName','CMU Serif','Interpreter','latex');
% ylabel('Principle Component 1');
% legend('Carpet','Gravel','Tile');

%%
% Separabiltiy and f_stride
load terrain_data_duncaroach_features;

close all; figure;

f1 = 2;
subplot(3,1,1); hold all;
set(gca,'FontName','CMU Serif','FontSize',18);
scatter(train_features(train_labels==1,1),train_features(train_labels==1,f1),'*','MarkerEdgeColor',COLOR_BLUE);
scatter(train_features(train_labels==2,1),train_features(train_labels==2,f1),'*','MarkerEdgeColor',COLOR_GREEN);
h = scatter(train_features(train_labels==3,1),train_features(train_labels==3,f1),'*','MarkerEdgeColor',COLOR_RED);
set(h,'Visible','off');
%xlabel('$f_{stride}$ (Hz)','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
ylabel('$2^{nd}$ moment of $\ddot x$','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
legend('Carpet','Gravel','Tile','Location','NorthWest');
set(gca,'XTickLabel',{});
xlim([0.5 10.5]); ylim([0 50000]);

f2 = 3;
subplot(3,1,2); hold all;
set(gca,'FontName','CMU Serif','FontSize',18);
%scatter(train_features(train_labels==1,1),train_features(train_labels==1,f2),'*','MarkerEdgeColor',COLOR_BLUE);
scatter(train_features(train_labels==2,1),train_features(train_labels==2,f2),'*','MarkerEdgeColor',COLOR_GREEN);
scatter(train_features(train_labels==3,1),train_features(train_labels==3,f2),'*','MarkerEdgeColor',COLOR_RED);
%xlabel('$f_{c}$ (Hz)','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
ylabel('$2^{nd}$ moment of $\ddot y$','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
set(gca,'XTickLabel',{});
xlim([0.5 10.5]); ylim([0 30000]);

f3 = 4;
subplot(3,1,3); hold all;
set(gca,'FontName','CMU Serif','FontSize',18);
scatter(train_features(train_labels==1,1),train_features(train_labels==1,f3),'*','MarkerEdgeColor',COLOR_BLUE);
%scatter(train_features(train_labels==2,1),train_features(train_labels==2,f3),'*','MarkerEdgeColor',COLOR_GREEN);
scatter(train_features(train_labels==3,1),train_features(train_labels==3,f3),'*','MarkerEdgeColor',COLOR_RED);
xlabel('$f_{c}$ (Hz)','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
ylabel('$2^{nd}$ moment of $\ddot z$','FontSize',24,'FontName','CMU Serif','Interpreter','latex');
%legend('Carpet','Gravel','Tile','Location','SouthEast');
xlim([0.5 10.5]); ylim([0 30000]);

h1 = subplot(3,1,1);
h2 = subplot(3,1,2);
h3 = subplot(3,1,3);
axp1 = get(h1,'position');
axp2 = get(h2,'position');
axp3 = get(h3,'position');
set(h1,'position',[axp1(1:3) axp1(4) + 0.04]);
set(h2,'position',[axp2(1:3) axp2(4) + 0.04]);
set(h3,'position',[axp3(1:3) axp3(4) + 0.04]);

set(gcf,'Units','inches');
set(gcf,'Position',[1 1 10 10]);
export_fig ../iros2012_gait/figures/fstride_comparison -pdf -transparent

%% Episode length vs accuracy
load lengthvsaccuracy_duncaroach;
close all; figure; hold on;
bl = plot(lengths*1000, accuracies+2.7319,'LineSmoothing','On','LineWidth',4,'Color',COLOR_BLUE);
rd = line([0 1000],[94 94],'LineStyle','--','LineWidth',4,'Color',COLOR_RED);
gn = line([350 350],[55 93.75],'LineStyle','--','LineWidth',4,'Color',COLOR_GREEN);
h = scatter([350],[93.75],'filled','SizeData',[150],'MarkerFaceColor',COLOR_GREEN,'MarkerEdgeColor',COLOR_GREEN);
set(gca,'FontName','CMU Serif','FontSize',18);
xlabel('Episode length (s)','FontSize',24,'FontName','CMU Serif');
ylabel('Classifier accuracy (%)','FontSize',24,'FontName','CMU Serif');
xlim([0 600]); ylim([60 100]);
legend('Accuracy','94% plateau','Final classifier','Location','SouthEast');
set(gcf,'Units','inches');
set(gcf,'Position',[1 1 10 6]);
export_fig ../iros2012_gait/figures/accuracy_length -pdf -transparent

%% Statistical moments of some data
close all;
i = 50;
% GyroZ
window = .350*300;
figure;
subplot(5,1,1); hold on; set(gca,'FontSize',12,'FontName','CMU Serif');
plot(arena_carpet(i).Time, arena_carpet(i).GyroZ,'b','LineSmoothing','On');
plot(arena_gravel(i).Time, arena_gravel(i).GyroZ,'g','LineSmoothing','On');
plot(arena_tile(i).Time, arena_tile(i).GyroZ,'r','LineSmoothing','On');
legend('Carpet','Gravel','Tile','Location','NorthEastOutside')
ylabel('Yaw Acceleration'); xlim([1.325 1.675]); %xlabel('Time (s)'); 

subplot(5,1,2); hold on; set(gca,'FontSize',12,'FontName','CMU Serif');
plot(arena_carpet(i).Time, moving_avg(arena_carpet(i).GyroZ, window),'b','LineSmoothing','On');
plot(arena_gravel(i).Time, moving_avg(arena_gravel(i).GyroZ, window),'g','LineSmoothing','On');
plot(arena_tile(i).Time, moving_avg(arena_tile(i).GyroZ, window),'r','LineSmoothing','On');
%legend('Carpet','Gravel','Tile');
ylabel('\mu_1'); xlim([1.325 1.675]); %xlabel('Time (s)'); 

subplot(5,1,3); hold on; set(gca,'FontSize',12,'FontName','CMU Serif');
plot(arena_carpet(i).Time, moving_moment(arena_carpet(i).GyroZ, 2, window),'b','LineSmoothing','On');
plot(arena_gravel(i).Time, moving_moment(arena_gravel(i).GyroZ, 2, window),'g','LineSmoothing','On');
plot(arena_tile(i).Time, moving_moment(arena_tile(i).GyroZ, 2, window),'r','LineSmoothing','On');
%legend('Carpet','Gravel','Tile');
ylabel('\mu_2'); xlim([1.325 1.675]); %xlabel('Time (s)'); 

subplot(5,1,4); hold on; set(gca,'FontSize',12,'FontName','CMU Serif');
plot(arena_carpet(i).Time, moving_moment(arena_carpet(i).GyroZ, 3, window),'b','LineSmoothing','On');
plot(arena_gravel(i).Time, moving_moment(arena_gravel(i).GyroZ, 3, window),'g','LineSmoothing','On');
plot(arena_tile(i).Time, moving_moment(arena_tile(i).GyroZ, 3, window),'r','LineSmoothing','On');
%legend('Carpet','Gravel','Tile');
ylabel('\mu_3'); xlim([1.325 1.675]); %xlabel('Time (s)'); 

subplot(5,1,5); hold on; set(gca,'FontSize',12,'FontName','CMU Serif');
plot(arena_carpet(i).Time, moving_moment(arena_carpet(i).GyroZ, 4, window),'b','LineSmoothing','On');
plot(arena_gravel(i).Time, moving_moment(arena_gravel(i).GyroZ, 4, window),'g','LineSmoothing','On');
plot(arena_tile(i).Time, moving_moment(arena_tile(i).GyroZ, 4, window),'r','LineSmoothing','On');
%legend('Carpet','Gravel','Tile');
xlabel('Time (s)'); ylabel('\mu_4'); xlim([1.325 1.675]);

set(gcf,'Units','inches');
set(gcf,'Position',[1 1 6 10]);
export_fig ../iros2012_gait/figures/accuracy_length -pdf -transparent

%% IMU
close all;
i = 45;

n_rms = 45;
damp = 50;
alpha_GyroZ = 0.5;
alpha_AccelX = 0.5;

window = 150;


GyroZ_fLow = 10;
GyroZ_fHigh = 20;
[GyroZ_b, GyroZ_a] = butter(3, [GyroZ_fLow/terrain_data.sampling_rate GyroZ_fHigh/terrain_data.sampling_rate], 'bandpass');

% %%
% Fs = sampling_rate;
% L = length(arena_carpet(i).GyroZ);
% figure; hold on;
% for j = 1:36
%     NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%     Y = fft(arena_carpet(j).GyroZ,NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);
% 
%     % Plot single-sided amplitude spectrum.
%     plot(f,2*abs(Y(1:NFFT/2+1)),'r') 
%     title('Single-Sided Amplitude Spectrum of y(t)')
%     xlabel('Frequency (Hz)')
%     ylabel('|Y(f)|')
% 
%     NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%     Y = fft(arena_tile(j).GyroZ,NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);
% 
%     % Plot single-sided amplitude spectrum.
%     plot(f,2*abs(Y(1:NFFT/2+1)),'b') 
% end
% legend('carpet','tile');
% 
% figure; hold on;
% for j = 1:36
%     NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%     Y = fft(filter(GyroZ_b, GyroZ_a, arena_carpet(j).GyroZ),NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);
% 
%     % Plot single-sided amplitude spectrum.
%     plot(f,2*abs(Y(1:NFFT/2+1)),'r') 
%     title('Single-Sided Amplitude Spectrum of y(t)')
%     xlabel('Frequency (Hz)')
%     ylabel('|Y(f)|')
% 
%     NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%     Y = fft(filter(GyroZ_b, GyroZ_a, arena_tile(j).GyroZ),NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);
% 
%     % Plot single-sided amplitude spectrum.
%     plot(f,2*abs(Y(1:NFFT/2+1)),'b') 
% end
% legend('carpet','tile');


Tmin = min(arena_carpet(i).Time(1), arena_carpet(i).Time(1));
Tmax = max(arena_carpet(i).Time(end), arena_carpet(i).Time(end));
% figure;
% % Llegs
% subplot(2,1,1); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).Llegs);
% plot(arena_gravel(i).Time, arena_gravel(i).Llegs);
% plot(arena_tile(i).Time, arena_tile(i).Llegs);
% legend('carpet','gravel','tile');
% xlabel('t'); ylabel('Llegs'); xlim([Tmin Tmax]);
% 
% % Rlegs
% subplot(2,1,2); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).Rlegs);
% plot(arena_gravel(i).Time, arena_gravel(i).Rlegs);
% plot(arena_tile(i).Time, arena_tile(i).Rlegs);
% legend('carpet','gravel','tile');
% xlabel('t'); ylabel('Rlegs'); xlim([Tmin Tmax]);

figure;
% DCL
% subplot(5,2,1); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).DCL);
% plot(arena_gravel(i).Time, arena_gravel(i).DCL);
% plot(arena_tile(i).Time, arena_tile(i).DCL);
% legend('carpet','gravel','tile');
% xlabel('t'); ylabel('DCL'); xlim([Tmin Tmax]);

% DCR
% subplot(5,2,2); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).DCR);
% plot(arena_gravel(i).Time, arena_gravel(i).DCR);
% plot(arena_tile(i).Time, arena_tile(i).DCR);
% legend('carpet','gravel','tile');
% xlabel('t'); ylabel('DCR'); xlim([Tmin Tmax]);

% GyroX
subplot(4,2,1); hold all;
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).GyroX, window));
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).GyroX, window));
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).GyroX, window));
plot(arena_carpet(i).Time, arena_carpet(i).GyroX);
plot(arena_gravel(i).Time, arena_gravel(i).GyroX);
plot(arena_tile(i).Time, arena_tile(i).GyroX);
legend('carpet','gravel','tile');
xlabel('t'); ylabel('GyroX'); xlim([Tmin Tmax]);

% GyroY
subplot(4,2,2); hold all;
plot(arena_carpet(i).Time, arena_carpet(i).GyroY);
plot(arena_gravel(i).Time, arena_gravel(i).GyroY);
plot(arena_tile(i).Time, arena_tile(i).GyroY);
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).GyroY, window));
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).GyroY, window));
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).GyroY, window));
legend('carpet','gravel','tile');
xlabel('t'); ylabel('GyroY'); xlim([Tmin Tmax]);

% GyroZ
subplot(4,2,3); hold all;
plot(arena_carpet(i).Time, arena_carpet(i).GyroZ);
plot(arena_gravel(i).Time, arena_gravel(i).GyroZ);
plot(arena_tile(i).Time, arena_tile(i).GyroZ);
% plot(arena_carpet(i).Time, moving_stddev(arena_carpet(i).GyroZ, window) );
% plot(arena_gravel(i).Time, moving_stddev(arena_gravel(i).GyroZ, window) );
% plot(arena_tile(i).Time, moving_stddev(arena_tile(i).GyroZ, window) );
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).GyroZ, window));
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).GyroZ, window));
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).GyroZ, window));
%plot(arena_carpet(i).Time, simple_iir_hpf(arena_carpet(i).GyroZ, alpha_GyroZ));
%plot(arena_tile(i).Time, simple_iir_hpf(arena_tile(i).GyroZ, alpha_GyroZ));
%plot(arena_carpet(i).Time, filter(GyroZ_b, GyroZ_a, arena_carpet(i).GyroZ));
%plot(arena_carpet(i).Time, filter(GyroZ_b, GyroZ_a, arena_tile(i).GyroZ));
legend('carpet','gravel','tile');
xlabel('t'); ylabel('GyroZ'); xlim([Tmin Tmax]);

% AccelX
subplot(4,2,4); hold all;
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).AccelX, window) );
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).AccelX, window) );
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).AccelX, window) );
% plot(arena_carpet(i).Time, arena_carpet(i).AccelX);
% plot(arena_gravel(i).Time, arena_gravel(i).AccelX);
% plot(arena_tile(i).Time, arena_tile(i).AccelX);
% plot(arena_carpet(i).Time, moving_max(arena_carpet(i).AccelX, window) );
% plot(arena_gravel(i).Time, moving_max(arena_gravel(i).AccelX, window) );
% plot(arena_tile(i).Time, moving_max(arena_tile(i).AccelX, window) );
plot(arena_carpet(i).Time, moving_moment3(arena_carpet(i).AccelX, window) );
plot(arena_gravel(i).Time, moving_moment3(arena_gravel(i).AccelX, window) );
plot(arena_tile(i).Time, moving_moment3(arena_tile(i).AccelX, window) );
legend('carpet','gravel','tile');
xlabel('t'); ylabel('AccelX (m/s^2)'); xlim([Tmin Tmax]);

% AccelY
subplot(4,2,5); hold all;
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).AccelY, window) );
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).AccelY, window) );
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).AccelY, window) );
% plot(arena_carpet(i).Time, arena_carpet(i).AccelY);
% plot(arena_gravel(i).Time, arena_gravel(i).AccelY);
% plot(arena_tile(i).Time, arena_tile(i).AccelY);
% plot(arena_carpet(i).Time, moving_max(arena_carpet(i).AccelY, window) );
% plot(arena_gravel(i).Time, moving_max(arena_gravel(i).AccelY, window) );
% plot(arena_tile(i).Time, moving_max(arena_tile(i).AccelY, window) );
plot(arena_carpet(i).Time, moving_moment(arena_carpet(i).AccelY, 4, window) );
plot(arena_gravel(i).Time, moving_moment(arena_gravel(i).AccelY, 4, window) );
plot(arena_tile(i).Time, moving_moment(arena_tile(i).AccelY, 4, window) );
legend('carpet','gravel','tile');
xlabel('t'); ylabel('AccelY (m/s^2)'); xlim([Tmin Tmax]);

% AccelZ
subplot(4,2,6); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).AccelZ);
% plot(arena_gravel(i).Time, arena_gravel(i).AccelZ);
% plot(arena_tile(i).Time, arena_tile(i).AccelZ);
% plot(arena_carpet(i).Time, moving_rms(arena_carpet(i).AccelZ, window) );
% plot(arena_gravel(i).Time, moving_rms(arena_gravel(i).AccelZ, window) );
% plot(arena_tile(i).Time, moving_rms(arena_tile(i).AccelZ, window) );
% plot(arena_carpet(i).Time, moving_max(arena_carpet(i).AccelZ, window) );
% plot(arena_gravel(i).Time, moving_max(arena_gravel(i).AccelZ, window) );
% plot(arena_tile(i).Time, moving_max(arena_tile(i).AccelZ, window) );
plot(arena_carpet(i).Time, moving_moment3(arena_carpet(i).AccelZ, window) );
plot(arena_gravel(i).Time, moving_moment3(arena_gravel(i).AccelZ, window) );
plot(arena_tile(i).Time, moving_moment3(arena_tile(i).AccelZ, window) );
legend('carpet','gravel','tile');
xlabel('t'); ylabel('AccelZ (m/s^2)'); xlim([Tmin Tmax]);

% LBEMF
subplot(4,2,7); hold all;
% plot(arena_carpet(i).Time, arena_carpet(i).LBEMF);
% plot(arena_gravel(i).Time, arena_gravel(i).LBEMF);
% plot(arena_tile(i).Time, arena_tile(i).LBEMF);
plot(arena_carpet(i).Time, moving_moment(arena_carpet(i).LBEMF, 4, window) );
plot(arena_gravel(i).Time, moving_moment(arena_gravel(i).LBEMF, 4, window) );
plot(arena_tile(i).Time, moving_moment(arena_tile(i).LBEMF, 4, window) );
legend('carpet','gravel','tile');
xlabel('t'); ylabel('LBEMF'); xlim([Tmin Tmax]);

% REBMF
subplot(4,2,8); hold all;
plot(arena_carpet(i).Time, arena_carpet(i).RBEMF);
plot(arena_gravel(i).Time, arena_gravel(i).RBEMF);
plot(arena_tile(i).Time, arena_tile(i).RBEMF);
legend('carpet','gravel','tile');
xlabel('t'); ylabel('RBEMF'); xlim([Tmin Tmax]);

% 
% 
% figure;
% subplot(3,1,1); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).AccelX,damp));
% plot(rocks(i).time,movingstddev(rocks(i).AccelX,damp));
% plot(seeds(i).time,movingstddev(seeds(i).AccelX,damp));
% plot(tile(i).time,movingstddev(tile(i).AccelX,damp));
% plot(freerun(i).time,movingstddev(freerun(i).AccelX,damp));
% legend('carpet','rocks','tile','seeds','freerun');
% title('Var AccelX'); xlabel('t'); ylabel('Var AccelX');
% 
% subplot(3,1,2); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).AccelY,damp));
% plot(rocks(i).time,movingstddev(rocks(i).AccelY,damp));
% plot(seeds(i).time,movingstddev(seeds(i).AccelY,damp));
% plot(tile(i).time,movingstddev(tile(i).AccelY,damp));
% plot(freerun(i).time,movingstddev(freerun(i).AccelY,damp));
% legend('carpet','rocks','tile','seeds','freerun');
% title('Var AccelY'); xlabel('t'); ylabel('Var AccelY');
% 
% subplot(3,1,3); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).AccelZ,damp));
% plot(rocks(i).time,movingstddev(rocks(i).AccelZ,damp));
% plot(seeds(i).time,movingstddev(seeds(i).AccelZ,damp));
% plot(tile(i).time,movingstddev(tile(i).AccelZ,damp));
% plot(freerun(i).time,movingstddev(freerun(i).AccelZ,damp));
% legend('carpet','rocks','tile','seeds','freerun');
% title('Var AccelZ'); xlabel('t'); ylabel('Var AccelZ');
% 
% 
% %% Moving variance of gyro
% 
% figure;
% subplot(3,1,1); hold all;
% plot(carpet(i).time,tsmovavg(carpet(i).GyroX,'e',damp,1));
% plot(rocks(i).time,tsmovavg(rocks(i).GyroX,'e',damp,1));
% plot(tile(i).time,tsmovavg(tile(i).GyroX,'e',damp,1)); 
% plot(seeds(i).time,tsmovavg(seeds(i).GyroX,'e',damp,1)); 
% plot(freerun(i).time,tsmovavg(freerun(i).GyroX,'e',damp,1)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('Avg GyroX'); xlabel('t'); ylabel('GyroX');
% 
% subplot(3,1,2); hold all;
% plot(carpet(i).time,tsmovavg(carpet(i).GyroY,'e',damp,1));
% plot(rocks(i).time,tsmovavg(rocks(i).GyroY,'e',damp,1));
% plot(tile(i).time,tsmovavg(tile(i).GyroY,'e',damp,1)); 
% plot(seeds(i).time,tsmovavg(seeds(i).GyroY,'e',damp,1)); 
% plot(freerun(i).time,tsmovavg(freerun(i).GyroY,'e',damp,1)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('Avg GyroY'); xlabel('t'); ylabel('GyroY');
% 
% subplot(3,1,3); hold all;
% plot(carpet(i).time,tsmovavg(carpet(i).GyroZ,'e',damp,1));
% plot(rocks(i).time,tsmovavg(rocks(i).GyroZ,'e',damp,1));
% plot(tile(i).time,tsmovavg(tile(i).GyroZ,'e',damp,1)); 
% plot(seeds(i).time,tsmovavg(seeds(i).GyroZ,'e',damp,1)); 
% plot(freerun(i).time,tsmovavg(freerun(i).GyroZ,'e',damp,1)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('Avg GyroZ'); xlabel('t'); ylabel('GyroZ');
% 
% figure;
% subplot(3,1,1); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).GyroX,damp));
% plot(rocks(i).time,movingstddev(rocks(i).GyroX,damp));
% plot(tile(i).time,movingstddev(tile(i).GyroX,damp)); 
% plot(seeds(i).time,movingstddev(seeds(i).GyroX,damp)); 
% plot(freerun(i).time,movingstddev(freerun(i).GyroX,damp)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('StdDev GyroX'); xlabel('t'); ylabel('GyroX');
% 
% subplot(3,1,2); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).GyroY,damp));
% plot(rocks(i).time,movingstddev(rocks(i).GyroY,damp));
% plot(tile(i).time,movingstddev(tile(i).GyroY,damp)); 
% plot(seeds(i).time,movingstddev(seeds(i).GyroY,damp)); 
% plot(freerun(i).time,movingstddev(freerun(i).GyroY,damp)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('StdDev GyroY'); xlabel('t'); ylabel('GyroY');
% 
% subplot(3,1,3); hold all;
% plot(carpet(i).time,movingstddev(carpet(i).GyroZ,damp));
% plot(rocks(i).time,movingstddev(rocks(i).GyroZ,damp));
% plot(tile(i).time,movingstddev(tile(i).GyroZ,damp)); 
% plot(seeds(i).time,movingstddev(seeds(i).GyroZ,damp)); 
% plot(freerun(i).time,movingstddev(freerun(i).GyroZ,damp)); 
% legend('carpet','rocks','tile','seeds','freerun');
% title('StdDev GyroZ'); xlabel('t'); ylabel('GyroZ');
% 
% %% BEMF
% % close all;
% % figure; hold all;
% % damp = 150;
% % %subplot(2,1,1); hold on; plot(carpet(i).time,tsmovavg(carpet(i).AccelY/3,'e',damp,1),'-b');
% % plot(carpet(i).time,movingvar(carpet(i).LBEMF,50),'-r');
% % %subplot(2,1,2); hold on; plot(rocks(i).time,tsmovavg(rocks(i).AccelY/3,'e',damp,1),'-b');
% % plot(rocks(i).time,movingvar(rocks(i).LBEMF,50),'-b'); 
% % title('LEBMF'); xlabel('t'); ylabel('LBEMF');

%% Space plots
% stddev AccelX vs GyroZ
figure; hold on;
for i = 1:10
%scatter(simple_iir_hpf(arena_carpet(i).AccelX, alpha_AccelX), simple_iir_hpf(arena_carpet(i).GyroZ, alpha_GyroZ), '.b');
%scatter(simple_iir_hpf(arena_tile(i).AccelX, alpha_AccelX), simple_iir_hpf(arena_tile(i).GyroZ, alpha_GyroZ), '.r');
% scatter(arena_carpet(i).AccelX, filter(GyroZ_b, GyroZ_a, arena_carpet(i).GyroZ), '.b');
% scatter(arena_tile(i).AccelX, filter(GyroZ_b, GyroZ_a, arena_tile(i).GyroZ), '.r');
% scatter(moving_stddev(arena_carpet(i).AccelZ, window), moving_stddev(arena_carpet(i).GyroZ, window), '.b');
% scatter(moving_stddev(arena_tile(i).AccelZ, window), moving_stddev(arena_tile(i).GyroZ, window), '.r');
% scatter(moving_stddev(arena_gravel(i).AccelZ, window), moving_stddev(arena_gravel(i).GyroZ, window), '.g');
scatter(moving_stddev(arena_carpet(i).AccelZ, window), moving_stddev(arena_carpet(i).GyroZ, window), '.b');
scatter(moving_stddev(arena_tile(i).AccelZ, window), moving_stddev(arena_tile(i).GyroZ, window), '.r');
scatter(moving_stddev(arena_gravel(i).AccelZ, window), moving_stddev(arena_gravel(i).GyroZ, window), '.g');
% scatter3(moving_stddev(arena_carpet(i).AccelX,damp),moving_stddev(arena_carpet(i).GyroZ,damp),moving_stddev(arena_carpet(i).AccelZ,damp),'ob');
% scatter3(moving_stddev(arena_tile(i).AccelX,damp),moving_stddev(arena_tile(i).GyroZ,damp),moving_stddev(arena_tile(i).AccelZ,damp),'or');
xlabel('\sigma_{AccelZ}'); ylabel('\sigma_{GyroZ}'); %zlabel('avg AccelX');
legend('carpet','tile','gravel');
end
