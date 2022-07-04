clear
clc
tic
format long;
global cf com cdm cqm cem FGT FGB FGAS QGTGB PECin PACin PV WT EL HL CL wes whs wcs wet_0 wht_0 wct_0 pedelta phdelta pcdelta We Wh Wc
%****************************************
PMTMaxPower=1575;
% PMTMaxPower=3000;
PMTMinPower=0;
QGBMaxPower=840;
% QGBMaxPower=2000;
QGBMinPower=0;

GridMaxImportPower=1470;
% GridMaxImportPower=2500;
GridMinImportPower=-630;
% GridMinImportPower=-2500;
PESMaxDischargingPower=630;
PESMaxChargingPower=-630;
PHSMaxDischargingPower=630;
PHSMaxChargingPower=-630;
PCSMaxDischargingPower=735;
PCSMaxChargingPower=-735;
% HACMaxPower=1500;
HACMaxPower=1050;
HACMinPower=0;
% PECMaxPower=1200;
PECMaxPower=840;
PECMinPower=0;
pmt=zeros(1,24);
qgb=zeros(1,24);
grid=zeros(1,24);
pes=zeros(1,24);
phs=zeros(1,24);
pcs=zeros(1,24);
hac=zeros(1,24);
pec=zeros(1,24);
Max_Dt=6000;
D=192;
N=600;
w_max=0.9;
w_min=0.3;
v_max=2;
s=1;

%***********************
for i=1:N
    for j=1:D
%         v(i,j)=randn;
        v(i,j)=0.0;
        if j<25
            x(i,j)=PMTMinPower+rand()*(PMTMaxPower-PMTMinPower);
        elseif j>24&&j<49
            x(i,j)=QGBMinPower+rand()*(QGBMaxPower-QGBMinPower);
        elseif j>48&&j<73
            x(i,j)=GridMinImportPower+rand()*(GridMaxImportPower-GridMinImportPower);
        elseif j>72&&j<97
            x(i,j)=PESMaxChargingPower+rand()*(PESMaxDischargingPower-PESMaxChargingPower);
        elseif j>96&&j<121
            x(i,j)=PHSMaxChargingPower+rand()*(PHSMaxDischargingPower-PHSMaxChargingPower);
        elseif j>120&&j<145
            x(i,j)=PCSMaxChargingPower+rand()*(PCSMaxDischargingPower-PCSMaxChargingPower);
        elseif j>144&&j<169
            x(i,j)=HACMinPower+rand()*(HACMaxPower-HACMinPower);
        elseif j>168&&j<193
            x(i,j)=PECMinPower+rand()*(PECMaxPower-PECMinPower);
        end
    end    
end

%****************
for i=1:N
    p(i)=fitness2(x(i,:),s);
    y(i,:)=x(i,:);
end
Pbest=fitness2(x(1,:),s);
pg=x(1,:);
for i=2:N
    if fitness2(x(i,:),s)<fitness2(pg,s)
       Pbest=fitness2(x(i,:),s);
       pg=x(i,:);
    end
end

%*****************************************
for t=1:Max_Dt
    for i=1:N
        w=w_max-(w_max-w_min)*t/Max_Dt;
        c1=(0.5-2.5)*t/Max_Dt+2.5; 
        c2=(2.5-0.5)*t/Max_Dt+0.5; 
        v(i,:)=w*v(i,:)+c1*rand()*(y(i,:)-x(i,:))+c2*rand()*(pg-x(i,:));
        for m=1:D
            if(v(i,m)>v_max)
                v(i,m)=v_max;
            elseif(v(i,m)<-v_max)
                v(i,m)=-v_max;
            end
        end
        
        x(i,:)=x(i,:)+v(i,:);
        
        for n=1:D
            if n<25
                   if x(i,n)<PMTMinPower
                         x(i,n)=PMTMinPower;
                         v(i,n)=-v(i,n); 
                   elseif x(i,n)>PMTMaxPower
                         x(i,n)=PMTMaxPower;
                         v(i,n)=-v(i,n); 
                   
                   end
            elseif n>24&&n<49
                    if x(i,n)<QGBMinPower
                         x(i,n)=QGBMinPower;
                         v(i,n)=-v(i,n);  
                   elseif  x(i,n)>QGBMaxPower
                         x(i,n)=QGBMaxPower;
                         v(i,n)=-v(i,n);                     
                  
                    end
            elseif n>48&&n<73
                    if x(i,n)<GridMinImportPower
                          x(i,n)=GridMinImportPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>GridMaxImportPower
                        x(i,n)=GridMaxImportPower;
                        v(i,n)=-v(i,n); 
                  
                    end
             elseif n>72&&n<97
                    if x(i,n)<PESMaxChargingPower
                          x(i,n)=PESMaxChargingPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>PESMaxDischargingPower
                        x(i,n)=PESMaxDischargingPower;
                        v(i,n)=-v(i,n); 
                  
                    end      
            elseif n>96&&n<121
                    if x(i,n)<PHSMaxChargingPower
                          x(i,n)=PHSMaxChargingPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>PHSMaxDischargingPower
                        x(i,n)=PHSMaxDischargingPower;
                        v(i,n)=-v(i,n); 
                  
                    end
            elseif n>120&&n<145
                    if x(i,n)<PCSMaxChargingPower
                          x(i,n)=PCSMaxChargingPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>PCSMaxDischargingPower
                        x(i,n)=PCSMaxDischargingPower;
                        v(i,n)=-v(i,n); 
                    end   
            elseif n>144&&n<169
                    if x(i,n)<HACMinPower
                          x(i,n)=HACMinPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>HACMaxPower
                        x(i,n)=HACMaxPower;
                        v(i,n)=-v(i,n); 
                    end   
            elseif n>168&&n<193
                    if x(i,n)<PECMinPower
                          x(i,n)=PECMinPower;
                          v(i,n)=-v(i,n); 
                   elseif x(i,n)>PECMaxPower
                        x(i,n)=PECMaxPower;
                        v(i,n)=-v(i,n); 
                    end   
            end
        end 
          
        if rand > 0.85
            k=ceil(D*rand);
%             x(i,k)=xlimit_min(i) + (xlimit_max(i) - xlimit_min(i)) * rand;
            if k<25
            x(i,k)=PMTMinPower+rand()*(PMTMaxPower-PMTMinPower);
        elseif k>24&&k<49
            x(i,k)=QGBMinPower+rand()*(QGBMaxPower-QGBMinPower);
        elseif k>48&&k<73
            x(i,k)=GridMinImportPower+rand()*(GridMaxImportPower-GridMinImportPower);
        elseif k>72&&k<97
            x(i,k)=PESMaxChargingPower+rand()*(PESMaxDischargingPower-PESMaxChargingPower);
        elseif k>96&&k<121
            x(i,k)=PHSMaxChargingPower+rand()*(PHSMaxDischargingPower-PHSMaxChargingPower);
        elseif k>120&&k<145
            x(i,k)=PCSMaxChargingPower+rand()*(PCSMaxDischargingPower-PCSMaxChargingPower);
        elseif k>144&&k<169
            x(i,k)=HACMinPower+rand()*(HACMaxPower-HACMinPower);
        elseif k>168&&k<193
            x(i,k)=PECMinPower+rand()*(PECMaxPower-PECMinPower);
        end
        end
        
        if fitness2(x(i,:),t)<p(i)
            p(i)=fitness2(x(i,:),t);
            y(i,:)=x(i,:);
        end
        if p(i)<Pbest
            Pbest=p(i);
            pg=y(i,:);
            s=t;
        end
    end 
    Pbest1(t)=fitness2(pg,s);
end

disp('best position: ')

Solution=pg'
for m=1:24
    pmt(m)=pg(m);
end
for m=25:48
    qgb(m-24)=pg(m);
end
for m=49:72
    grid(m-48)=pg(m);
end
for m=73:96
    pes(m-72)=pg(m);
end
for m=97:120
    phs(m-96)=pg(m);
end
for m=121:144
    pcs(m-120)=pg(m);
end
for m=145:168
    hac(m-144)=pg(m);
end
for m=169:192
    pec(m-168)=pg(m);
end

gridz=zeros(1,24);
gridf=zeros(1,24);
for t=1:24
    if grid(t)>=0
        gridz(t)=grid(t);
        gridf(t)=0;
    elseif grid(t)<0
        gridz(t)=0;
        gridf(t)=grid(t);
    end
end
pesz=zeros(1,24);
pesf=zeros(1,24);
for t=1:24
    if pes(t)>=0
        pesz(t)=pes(t);
        pesf(t)=0;
    elseif pes(t)<0
        pesz(t)=0;
        pesf(t)=pes(t);
    end
end
phsz=zeros(1,24);
phsf=zeros(1,24);
for t=1:24
    if phs(t)>=0
        phsz(t)=phs(t);
        phsf(t)=0;
    elseif phs(t)<0
        phsz(t)=0;
        phsf(t)=phs(t);
    end
end
pcsz=zeros(1,24);
pcsf=zeros(1,24);
for t=1:24
    if pcs(t)>=0
        pcsz(t)=pcs(t);
        pcsf(t)=0;
    elseif pcs(t)<0
        pcsz(t)=0;
        pcsf(t)=pcs(t);
    end
end

disp('final value: ')
Resulta=fitness2(pg,s)
toc
