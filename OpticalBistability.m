clear all; clc; format long;

% Defining variables

luminance1 = cell(9, 1);        % cell containing quantity luminance for cup 1
luminance2 = cell(9, 1);

luminance1_avg = zeros(9,1);    % average luminance for cup 1
hotluminance1_avg = zeros(6,1); % average luminance for cup 1 as it was heating back up

temp1 = [-2, -1, 0, 0, 1, 1, 2, 4, 7];      % cooling temperatures for cup 1
hottemp1 = [2, 5, 8, 9, 12, 14];            % warming temperatures for cup 2


luminance2_avg = zeros(9,1);    % average luminance for cup 2
hotluminance2_avg = zeros(6,1); % average luminance for cup 1 as it was heating back up

temp2 = [-2, -2, 0, 0, 1, 1, 3, 4, 6];      % cooling temperatures for cup 2
hottemp2 = [1, 6, 4, 6, 9, 11];

luminance1_r = zeros(2350, 9);              % stores all the data stored in the luminance1 cell as an array (r for raw)
luminance2_r = zeros(2350, 9);

luminance1_avgs = zeros(2350, 1);           % averages actross the raw array
luminance2_avgs = zeros(2350, 1);

luminance_array = zeros(2350, 2);           % array comprised of the average luminance of both cups

luminance_avg = zeros(2350, 1);             % luminance arrays collapsed into a single average

temp = [temp1', temp2'];                    % temperature array comprised of the cooling temperatures of both cups
temp_avg = mean(temp, 2);                   % collapsed into a single average temperature


hotluminance1 = cell(6, 1);
hotluminance2 = cell(6, 1);

hotluminance1_r = zeros(2350, 6);           % similar idea as described above but for the warming luminance and temperatures
hotluminance2_r = zeros(2350, 6);

hotluminance1_avgs = zeros(2350, 1);
hotluminance2_avgs = zeros(2350, 1);

hotluminance_array = zeros(2350, 2);

hotluminance_avg = zeros(2350, 1);

hottemp = [hottemp1', hottemp2'];
hottemp_avg = mean(hottemp, 2);

% Loops through files to make reading them into MATLAB easier
for i = 1:9

    filepath = fullfile('OB_Data\Zips', ...                 % iterates through the mutliple csv files imported from phyphox                      
        sprintf('Cup1_m%d', i), ...                              
        sprintf('Data.csv'));            
    data1 = readtable(filepath, NumHeaderLines = 1);       

    filepath = fullfile('OB_Data\Zips', ...   
        sprintf('Cup2_m%d', i), ...           
        sprintf('Data.csv'));            
    data2 = readtable(filepath, NumHeaderLines = 1); 


    luminance1{i} = data1{1:2350, 3};                       % populates luminance1 cell with relevant data

    luminance2{i} = data2{1:2350, 3};

    
    % Creating a single luminance array, as outlined in the variable definition section

    luminance1_avg(i) = mean(luminance1{i});
    luminance2_avg(i) = mean(luminance2{i});

    luminance1_r(:, i) = luminance1{i};
    luminance1_avgs = mean(luminance1_r, 1)';

    luminance2_r(:, i) = luminance2{i};
    luminance2_avgs = mean(luminance2_r, 1)';

    luminance_array = [luminance1_avgs, luminance2_avgs];

    luminance_avg = mean(luminance_array, 2);

    luminance_sdev = std(luminance_array, 0, 2);
    luminance_stat = luminance_sdev / sqrt(2);

end




for k = 1:6
    
    hotfilepath = fullfile('OB_Data', ...                       
        sprintf('Cup1_HOTm%d.csv', k));            
    hotdata1 = readtable(hotfilepath, NumHeaderLines = 1);      

    hotfilepath2 = fullfile('OB_Data', ...                       
        sprintf('Cup2_HOTm%d.csv', k));            
    hotdata2 = readtable(hotfilepath2, NumHeaderLines = 1); 

    hotluminance1{k} = hotdata1{1:2350, 3};
    hotluminance2{k} = hotdata2{1:2350, 3};


    hotluminance1_avg(k) = mean(hotluminance1{k});
    hotluminance2_avg(k) = mean(hotluminance2{k});

    hotluminance1_r(:, k) = hotluminance1{k};
    hotluminance1_avgs = mean(hotluminance1_r, 1)';

    hotluminance2_r(:, k) = hotluminance2{k};
    hotluminance2_avgs = mean(hotluminance2_r, 1)';

    hotluminance_array = [hotluminance1_avgs, hotluminance2_avgs];

    hotluminance_avg = mean(hotluminance_array, 2);

    hotluminance_sdev = std(hotluminance_array, 0, 2);
    hotluminance_stat = hotluminance_sdev / sqrt(2);

end


% Plot

figure(3)
    hold on
    errorbar(temp_avg', luminance_avg, luminance_stat, 'bo-', ...
    'LineWidth', 1.5, 'MarkerSize', 7);

    errorbar(hottemp_avg', hotluminance_avg, hotluminance_stat, 'ro-', ...
    'LineWidth', 1.5, 'MarkerSize', 7);

    xlabel('Mean Temperature (^\circC)', fontsize = 18)
    ylabel('Mean Luminance (a.u)', fontsize = 18)
    title(' Mean Luminance Vs Mean Temperature')


    xlim([-3, 15])

    legend('Cooling', 'Heating');

    set(gca, fontsize = 16)
    grid on
    exportgraphics(gcf, 'LuminanceVsTemperature.png', 'ContentType', 'vector')



