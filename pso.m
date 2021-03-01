function [ swarm, obj, velocity, objit, sbestpos, sbestval ] = pso( alts, usts, boyut, ssize, w, c1, c2, it )
%PSO Summary of this function goes here
%   Detailed explanation goes here

swarm = unifrnd(alts, usts, [ssize boyut]);
% Sürü, alts -> alt sýnýr, usts -> üst sýnýr,
% alt ve üst sýnýr arasýnda random sayý üretir, 
% ssize kadar satýr, boyut kadar sütun olur.

obj = zeros(ssize, 1);
% Amaç fonksiyonu, sýfýrdan baþlayarak toplaya toplaya gidiyor.

for i=1:ssize
    obj(i)=sum(swarm(i,:).^2); 
% Satýr sayýsý kadar sýrayla her stunun, 
% her elemanýnýn karesini al ve topla.
end

velocity = zeros(ssize, boyut); 
% Her parçacýðýn hýzý, baþlangýç sýfýr

pbestpos = swarm; % Parçacýðýn bulunduðu en iyi yer.
pbestval = obj; % Parçacýðýn en iyi deðeri.

sbestval = min(obj); % Sürüdeki amaç fonksiyonlarýndan en düþüðünü yani sürünün en iyisini verir.
idx = find(sbestval == obj); % sbestval'in hangi satýrda olduðunu gösterir.
sbestpos = swarm(idx,:); % En iyi çözümü verir.

iteration = 1;
objit = sbestval; % En iyi deðeri tutuyor. 

while(iteration<it)

    for i=1:ssize % Hýz güncelleme
        velocity(i,:)=w*velocity(i,:)+c1*0.35*(pbestpos(i,:)-swarm(i,:))+c2*0.35*(sbestpos-swarm(i,:));
     %   w = Eylemsizlik katsayýsý * eski hýz + c1 = parçacýðýn kendi katsayýsý * rassal adým büyüklüðü * 
     %   parçacýðýn en iyi pozisyonu - parçacýðýn þuanki pozisyonu + 
     %   c2 = sürüye baðlý katsayýsý * rassal adým * (sürünün en iyisi - parçacýðýn þuanki pozisyonu)
    end 

    vmax = (usts-alts)/2; % Max hýzýmýz alanýn yarýsý kadar.

    for i=1:ssize  % Max hýz sýnýrý belirleme.
        for j=1:boyut
            if(velocity(i,j)>vmax) 
                velocity(i,j)=vmax;
            elseif (velocity(i,j)<-vmax)
                velocity(i,j)=-vmax;
            end
        end
    end

    swarm = swarm + velocity; % Sürüyü hareket ettir.

    for i=1:ssize  % Sýnýrý aþanlarý sýnýra yerleþtirme.
        for j=1:boyut
            if(swarm(i,j)>usts) 
                swarm(i,j)=usts;
            elseif (swarm(i,j)<alts)        
                swarm(i,j)=alts;
            end
        end
    end



    for i=1:ssize    % Yeni noktanýn amaç fonksiyonunu hesapla.
        obj(i)=sum(swarm(i,:).^2); 
    end

    for i=1:ssize % Parçacýðýn en iyisini güncelle
        if (obj(i)<pbestval(i))   % Yeni amaç fonk. deðeri daha küçükse,
            pbestval(i)=obj(i);   % Parçacýðýn en iyi amaç fonk. deðeri þimdikidir,
            pbestpos(i,:)=swarm(i,:); % Parçacýðýn en iyi pozisyonu þuanki pozisyondur.
        end
    end

    if(min(obj)<sbestval) % Sürünün en iyisini güncelle.
        sbestval=min(obj);
        idx=find(sbestval == obj); 
        sbestpos = swarm(idx,:); 
    end
    iteration = iteration + 1;
    objit(iteration) = sbestval;

end



    plot(objit); % Ýyileþmeyi görmek için görselleþtirme.

end



















