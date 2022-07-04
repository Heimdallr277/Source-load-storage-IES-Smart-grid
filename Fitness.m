function result2=fitness2(x,k)
global cf com cdm cqm cem FGT FGB FGAS QGTGB PECin PACin PV WT EL HL CL wes whs wcs wet_0 wht_0 wct_0 pedelta phdelta pcdelta We Wh Wc

omiga1=0.5;
omiga2=0.5;
Eesmin=0;
% Eesmax=2500;
Eesmax=1878;
Ehsmin=0;
% Ehsmax=3000;
Ehsmax=1878;
Ecsmin=0;
% Ecsmax=3500;
Ecsmax=1890;
yesc=0.962;
yesd=0.962;
yhsc=0.984;
yhsd=0.984;
ycsc=0.976;
ycsd=0.956;
deltae=0.015;
deltah=0.022;
deltac=0.022;
yGEGT=0.32;
yGHGT=0.39;
yGHGB=0.88;
COPEC=4.2;
COPAC=1.35;
Pg=0.3523;
komgt=0.0271;
komgb=0.0251;
kompv=0.08985;
komwt=0.10211;
komgtyb=0.0181;
komec=0.0562;
komac=0.0414;
komes=0.028;
komhs=0.0215;
komcs=0.025;
com=0;
cdm=0;
rco2=0.04;
ngtco2=0.27;
ngbco2=0.45;
nacco2=0.17;
necco2=0.23;
ndmco2=0.381;
cem=0;
cqm=0;
We0=845;
% Wh0=1200;
% Wc0=1700;
Wh0=845;
Wc0=845;
We=zeros(1,24);
Wh=zeros(1,24);
Wc=zeros(1,24);
cf=0;
We_sum_delt=0;
Wh_sum_delt=0;
Wc_sum_delt=0;
d4=10;
d5=10;
d6=10;
ech_deltp_sum=0;
hch_deltp_sum=0;
cch_deltp_sum=0;
FGT=zeros(1,24);
FGB=zeros(1,24);
FGAS=zeros(1,24);
QGTGB=zeros(1,24);
PECin=zeros(1,24);
PACin=zeros(1,24);

for t=1:24
    FGT(t)=x(t)./yGEGT; 
end
for t=1:24
    FGB(t)=x(t+24)./yGHGB;
end
for t=1:24
    FGAS(t)=FGT(t)+FGB(t);
end
for t=1:24
    QGTGB(t)=x(t).*yGHGT*1.95;
end
for t=1:24
    PECin(t)=-x(t+168)./COPEC;
end
for t=1:24
    PACin(t)=-x(t+144)./COPAC;
end

PV=2*[110,125.4,101.2,105.6,110,88,99,103.4,88,149.6,165,105.6,167.2,160.6,88,132,81.4,136.4,125.4,132,176,132,125.4,112.2];%风机
WT=2*[0,0,0,0,0,0,15.4,24.2,33,66,82.5,118.8,158.4,154,151.8,99,66,29.7,16.5,0,0,0,0,0];
% PV=WT1+PV1
% WT=zeros(1,24);
EL=[1050,945,861,756,745.5,756,913.5,1029,1312.5,1575,1706.25,1837.5,2100,2231.25,2310,2341.5,2362.5,2383.5,2404.5,2341.5,2205,1890,1706.25,1638];%电负荷
HL=[735,714,693,672,682.5,714,756,798,829.5,866.25,876.75,903,934.5,966,966,903,840,787.5,798,913.5,829.5,808.5,787.5,766.5];%热负荷
% % CL=[960,875,850,940,1000,1125,1300,1500,1625,1750,1920,2080,2125,1960,1750,1625,1375,1280,1550,1525,1470,1270,1175,1125];%冷负荷
CL=[798,708.75,577.5,882,735,866.25,945,1155,1338.75,1417.5,1491,1554,1391.25,1323,1312.5,1181.25,1128.75,1029,1102.5,1181.25,1123.5,1018.5,918.75,866.25];%冷负荷
%
for t=1:24
    cem1=(rco2*ngtco2/yGEGT).*2.*x(t);
    cem2=(rco2*ngbco2/yGHGB).*x(t+24);
    cem3=(rco2*ndmco2).*abs(x(t+48));
    cem4=(rco2*nacco2).*x(t+144);
    cem5=(rco2*necco2).*x(t+168);
    cem=cem+cem1+cem2+cem3+cem4+cem5;
end

for t=1:24
    cf=cf+Pg*(x(t)./yGEGT+x(t+24)./yGHGB)
    com=com+(komgtyb.*x(t)*1.97*0.4+kompv.*PV(t)+komwt.*WT(t)+komgt.*x(t)+komgb.*x(t+24)+komes.*abs(x(t+72))+komhs.*abs(x(t+96))+komcs.*abs(x(t+120))+komac.*x(t+144)+komec.*x(t+168));%各机组运行维护成本函数计算

    if t>=1&&t<=7
        if x(t+48)<0
            cdm1=0.36.*x(t+48);
        elseif x(t+48)>0
                cdm1=0.49.*x(t+48);
        else
                cdm1=0;
        end
    cdm=cdm+cdm1;
    elseif (t>7&&t<=11)||(t>14&&t<=18)||(t>21&&t<=24)
        if x(t+48)<0
            cdm1=0.52.*x(t+48);
        elseif x(t+48)>0
                cdm1=0.63.*x(t+48);
        else
                cdm1=0;
        end
    cdm=cdm+cdm1;
    else
        if x(t+48)<0
            cdm1=0.82.*x(t+48);
        elseif x(t+48)>0
                cdm1=0.96.*x(t+48);
        else
                cdm1=0;
        end
    cdm=cdm+cdm1;
    end
    
        if FGB(t)<=250%
            cqm1=5.22.*FGB(t);
        elseif (FGB(t)>250)&&(FGB(t)<=4167)%
            cqm1=3.61.*FGB(t);
        elseif FGB(t)>4167
            cqm1=2.58.*FGB(t);
    
        end
    cqm=cqm+cqm1;
    
end

for t=1:24
    
%     if (We0>Eesmin)&&(We0<Eesmax)
        if x(t+72)>0
            We0=We0*(1-deltae)-x(t+72)./yesd;
            We(t)=We0;
        elseif x(t+72)<0 
            We0=We0*(1-deltae)-x(t+72).*yesc;
            We(t)=We0;
        else
            We0=We0*(1-deltae);
            We(t)=We0;
        end
        We_sum_delt= We_sum_delt+max(max(0,We(t)-Eesmax),Eesmin-We(t));
end

if(We_sum_delt==0)
    d1=0;
elseif(We_sum_delt>0&&We_sum_delt<=500)
    d1=1;
elseif(We_sum_delt>500&&We_sum_delt<=1000)
    d1=10;
elseif(We_sum_delt>1000&&We_sum_delt<=2000)
    d1=100;
else
    d1=1000;
end    

for t=1:24
%     if (We0>Eesmin)&&(We0<Eesmax)
        if x(t+96)>0
            Wh0=Wh0*(1-deltah)-x(t+96)./yhsd;
            Wh(t)=Wh0;
        elseif x(t+96)<0 
            Wh0=Wh0*(1-deltah)-x(t+96).*yhsc;
            Wh(t)=Wh0;
        else
            Wh0=Wh0*(1-deltah);
            Wh(t)=Wh0;
        end
        Wh_sum_delt= Wh_sum_delt+max(max(0,Wh(t)-Ehsmax),Ehsmin-Wh(t));
end
if(Wh_sum_delt==0)
    d2=0;
elseif(Wh_sum_delt>0&&Wh_sum_delt<=500)
    d2=1;
elseif(Wh_sum_delt>500&&Wh_sum_delt<=1000)
    d2=10;
elseif(Wh_sum_delt>1000&&Wh_sum_delt<=2000)
    d2=100;
else
    d2=1000;
end  

for t=1:24
%     if (We0>Eesmin)&&(We0<Eesmax)
        if x(t+120)>0
            Wc0=Wc0*(1-deltac)-x(t+120)./ycsd;
            Wc(t)=Wc0;
        elseif x(t+120)<0 
            Wc0=Wc0*(1-deltac)-x(t+120).*ycsc;
            Wc(t)=Wc0;
        else
            Wc0=Wc0*(1-deltac);
            Wc(t)=Wc0;
        end
        Wc_sum_delt= Wc_sum_delt+max(max(0,Wc(t)-Ecsmax),Ecsmin-Wc(t));
end
if(Wc_sum_delt==0)
    d3=0;
elseif(Wc_sum_delt>0&&Wc_sum_delt<=500)
    d3=1;
elseif(Wc_sum_delt>500&&Wc_sum_delt<=1000)
    d3=10;
elseif(Wc_sum_delt>1000&&Wc_sum_delt<=2000)
    d3=100;
else
    d3=1000;
end  

for t=1:24
   ech_deltp=abs(PV(t)+WT(t)+x(t)+x(t+48)+x(t+72)-x(t+168)./COPEC-EL(t));
   ech_deltp_sum=ech_deltp_sum+ech_deltp;
end
if(ech_deltp_sum==0)
   r1=0;
elseif(ech_deltp_sum>0&&ech_deltp_sum<=500)
%    r=10*sqrt(k);
   r1=1;
elseif(ech_deltp_sum>500&&ech_deltp_sum<=1000)
   r1=10;
elseif(ech_deltp_sum>1000&&ech_deltp_sum<=2000)
   r1=100;
else
   r1=1000;
end

for t=1:24
   hch_deltp=abs(x(t).*yGHGT*1.95+x(t+24)+x(t+96)-x(t+144)./COPAC-HL(t));
   hch_deltp_sum=hch_deltp_sum+hch_deltp;
end
if(hch_deltp_sum==0)
   r2=0;
elseif(hch_deltp_sum>0&&hch_deltp_sum<=500)
%    r=10*sqrt(k);
   r2=1;
elseif(hch_deltp_sum>500&&hch_deltp_sum<=1000)
   r2=10;
elseif(hch_deltp_sum>1000&&hch_deltp_sum<=2000)
   r2=100;
else
   r2=1000;
end

for t=1:24
   cch_deltp=abs(x(t+144)+x(t+168)+x(t+120)-CL(t));
   cch_deltp_sum=cch_deltp_sum+cch_deltp;
end
if(cch_deltp_sum==0)
   r3=0;
elseif(cch_deltp_sum>0&&cch_deltp_sum<=500)
%    r=10*sqrt(k);
   r3=1;
elseif(cch_deltp_sum>500&&cch_deltp_sum<=1000)
   r3=10;
elseif(cch_deltp_sum>1000&&cch_deltp_sum<=2000)
   r3=100;
else
   r3=1000;
end

wes=d1*We_sum_delt;
whs=d2*Wh_sum_delt;
wcs=d3*Wc_sum_delt;
wet_0=d4*(We(24)-We(1));
wht_0=d5*(Wh(24)-Wh(1));
wct_0=d6*(Wc(24)-Wc(1));
pedelta=r1*ech_deltp_sum;
phdelta=r2*hch_deltp_sum;
pcdelta=r3*cch_deltp_sum;
%Goal
result2=omiga1*(cf+com+cdm+cqm)+omiga2*cem+d1*We_sum_delt+d2*Wh_sum_delt+d3*Wc_sum_delt+d4*abs(We(24)-We(1))+d5*abs(Wh(24)-Wh(1))+d6*abs(Wc(24)-Wc(1))+r1*ech_deltp_sum+r2*hch_deltp_sum+r3*cch_deltp_sum;
end



