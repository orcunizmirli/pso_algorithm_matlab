function [ swarm, obj, velocity, objit, sbestpos, sbestval ] = pso( alts, usts, boyut, ssize, w, c1, c2, it )
%PSO Summary of this function goes here
%   Detailed explanation goes here

swarm = unifrnd(alts, usts, [ssize boyut]);
% S�r�, alts -> alt s�n�r, usts -> �st s�n�r,
% alt ve �st s�n�r aras�nda random say� �retir, 
% ssize kadar sat�r, boyut kadar s�tun olur.

obj = zeros(ssize, 1);
% Ama� fonksiyonu, s�f�rdan ba�layarak toplaya toplaya gidiyor.

for i=1:ssize
    obj(i)=sum(swarm(i,:).^2); 
% Sat�r say�s� kadar s�rayla her stunun, 
% her eleman�n�n karesini al ve topla.
end

velocity = zeros(ssize, boyut); 
% Her par�ac���n h�z�, ba�lang�� s�f�r

pbestpos = swarm; % Par�ac���n bulundu�u en iyi yer.
pbestval = obj; % Par�ac���n en iyi de�eri.

sbestval = min(obj); % S�r�deki ama� fonksiyonlar�ndan en d�����n� yani s�r�n�n en iyisini verir.
idx = find(sbestval == obj); % sbestval'in hangi sat�rda oldu�unu g�sterir.
sbestpos = swarm(idx,:); % En iyi ��z�m� verir.

iteration = 1;
objit = sbestval; % En iyi de�eri tutuyor. 

while(iteration<it)

    for i=1:ssize % H�z g�ncelleme
        velocity(i,:)=w*velocity(i,:)+c1*0.35*(pbestpos(i,:)-swarm(i,:))+c2*0.35*(sbestpos-swarm(i,:));
     %   w = Eylemsizlik katsay�s� * eski h�z + c1 = par�ac���n kendi katsay�s� * rassal ad�m b�y�kl��� * 
     %   par�ac���n en iyi pozisyonu - par�ac���n �uanki pozisyonu + 
     %   c2 = s�r�ye ba�l� katsay�s� * rassal ad�m * (s�r�n�n en iyisi - par�ac���n �uanki pozisyonu)
    end 

    vmax = (usts-alts)/2; % Max h�z�m�z alan�n yar�s� kadar.

    for i=1:ssize  % Max h�z s�n�r� belirleme.
        for j=1:boyut
            if(velocity(i,j)>vmax) 
                velocity(i,j)=vmax;
            elseif (velocity(i,j)<-vmax)
                velocity(i,j)=-vmax;
            end
        end
    end

    swarm = swarm + velocity; % S�r�y� hareket ettir.

    for i=1:ssize  % S�n�r� a�anlar� s�n�ra yerle�tirme.
        for j=1:boyut
            if(swarm(i,j)>usts) 
                swarm(i,j)=usts;
            elseif (swarm(i,j)<alts)        
                swarm(i,j)=alts;
            end
        end
    end



    for i=1:ssize    % Yeni noktan�n ama� fonksiyonunu hesapla.
        obj(i)=sum(swarm(i,:).^2); 
    end

    for i=1:ssize % Par�ac���n en iyisini g�ncelle
        if (obj(i)<pbestval(i))   % Yeni ama� fonk. de�eri daha k���kse,
            pbestval(i)=obj(i);   % Par�ac���n en iyi ama� fonk. de�eri �imdikidir,
            pbestpos(i,:)=swarm(i,:); % Par�ac���n en iyi pozisyonu �uanki pozisyondur.
        end
    end

    if(min(obj)<sbestval) % S�r�n�n en iyisini g�ncelle.
        sbestval=min(obj);
        idx=find(sbestval == obj); 
        sbestpos = swarm(idx,:); 
    end
    iteration = iteration + 1;
    objit(iteration) = sbestval;

end



    plot(objit); % �yile�meyi g�rmek i�in g�rselle�tirme.

end



















