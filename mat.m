data_latih = xlsread('data_latih.xlsx' , 'data_latih', 'B2:K298');
data_test = xlsread('data_latih.xlsx' , 'data_testing', 'B2:K76');

% Proses Normalisasi Data
% max_data = max(max(data_latih));
% min_data = min(min(data_latih));
 
% [m, n] = size(data_latih);
% data_norm = zeros(m,n);
% for x = 1:m
%     for y = 1:n
%         data_norm(x, y) = 0.1 + 0.8 * (data_latih(x, y) - min_data) / (max_data - min_data);
%     end
% end

%datalatih
T_latih = data_latih(:, 1);
P_latih = data_latih(:, 2:end);

%Convert to vector
T_latih_v = ind2vec(T_latih');
 
%data test/uji
T_test = data_test(:, 1);
P_test = data_test(:, 2:end);
 
%membangun jarinagn lvq
net = lvqnet(200, 0.001, 'learnlv1');
net.trainParam.epochs = 1000;
net.performFcn = 'mse';
net.adaptFcn = 'adaptwb';
net.divideFcn = 'dividerand'; 
net.divideMode = 'sample';  
net.trainFcn = 'trainr';
net.trainParam.goal = 1e-5;

%proses training
[net, tr, Y, E] = train(net, P_latih', T_latih_v);
view(net)

latih_result = [vec2ind(Y); T_latih']
latih_jumlah_salah = 0;
latih_jumlah_benar = 0;
for i = 1:length(T_latih)
    if latih_result(2, i) == latih_result(1, i)
        latih_jumlah_benar = latih_jumlah_benar + 1;
    end
end

latih_jumlah_salah = length(T_latih) - latih_jumlah_benar;
latih_percentage = (latih_jumlah_benar / length(T_latih)) * 100;

%proses uji
Uji = net(P_test');
T_Uji_v = vec2ind(Uji);
result = [T_Uji_v; T_test'];

jumlah_salah = 0;
jumlah_benar = 0;
for i = 1:length(T_Uji_v)
    if result(2, i) == result(1, i)
        jumlah_benar = jumlah_benar + 1;
    end
end
jumlah_benar=jumlah_benar
jumlah_salah = length(T_Uji_v) - jumlah_benar;
percentage = (jumlah_benar / length(T_Uji_v)) * 100;

