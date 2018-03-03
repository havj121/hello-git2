clear
clc

evalDataTable=readtable('LKA介入时机评价_result_171026.csv');%记得修改目录
evalDataTable=evalDataTable(:,1:6); 

fullname={'lanxiaoming' 'hexiaolin' 'zhongbin' 'chenjiachen' 'mike' 'guohongqiang' 'dangjianmin' 'zhangjiren' 'ruanyandong' 'lijiancong' 'xieli' 'liujunshuai' 'caoxing' 'hupeng'};%这个顺序直接决定记录进文件的驾驶员序号
name={};driver_No=[];date=[];c_Q1=[];TLC=[];dis=[];

for driver_i=5%1:length(fullname)
    tempEval_driver=evalDataTable(strcmp(evalDataTable.name,fullname{driver_i}),:);%获得数据表中dirver_i的所有数据
    date_all=unique(tempEval_driver.date);%将temp表中日期列的重复元素去掉，以便知道在哪几天做了实验
    for date_i=1:length(date_all)
        tempEval=tempEval_driver(tempEval_driver.date==date_all(date_i),:);
        
%         for vy_temp=[0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7]
%             for DLC_temp=0.2:0.1:0.8
%                 logical1=tempEval(tempEval.Vy==vy_temp & tempEval.DLC==DLC_temp,:).eva > tempEval(tempEval.Vy==vy_temp & tempEval.DLC>DLC_temp,:).eva;
%                 
%                 logical2=tempEval(tempEval.Vy==vy_temp & tempEval.DLC==DLC_temp,:).eva > tempEval(tempEval.Vy==vy_temp & tempEval.DLC==DLC_temp,:).eva;
%                 if()
%                 end
%             end
%         end
        
        x1=tempEval.DLC;x2=tempEval.Vy;y=tempEval.eva;
        [b, bint,r,rint,stats]=regress(y,[x1 x2 ones(length(y),1)]);
        c_Q1_temp=b(1);TLC_temp=-b(2)/b(1);dis_temp=-b(3)/b(1);
        
        name=[name;fullname{driver_i}];driver_No=[driver_No;driver_i];date=[date;date_all(date_i);];
        c_Q1=[c_Q1;c_Q1_temp];TLC=[TLC;TLC_temp];dis=[dis;dis_temp];
        
        %查看单一驾驶员不同日趋的3维主客观关系图
        figure(driver_i)
        plot3(x1,x2,y,'o');
%         scatter3(x1,x2,y,'filled');
        hold on;grid on;
        x1fit = min(x1):0.1:max(x1);
        x2fit = min(x2):0.1:max(x2);
        [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
        YFIT=b(1)*X1FIT+b(2)*X2FIT+b(3);
%         mesh(X1FIT,X2FIT,YFIT)
        surf(X1FIT,X2FIT,YFIT)
        xlabel('DLC(m)');ylabel('vy(m/s)');zlabel('eva');
%         xlim([0 1.2]);ylim([-0.2 1.2]);
        
%         %查看单一驾驶员不同日期的评价结果图
%         figure(driver_i)
%         plot(TLC_temp,dis_temp,'o');hold on;grid on;
%         text(TLC_temp,dis_temp,{[' ' fullname{driver_i}] date_all(date_i)});xlabel('TLC');ylabel('dis');
%         xlim([0 1.2]);ylim([-0.2 1.2]);
%         
%         %查看所有驾驶员所有日期的评价结果图
%         figure(20)
%         plot(TLC_temp,dis_temp,'o');hold on;grid on;
%         text(TLC_temp,dis_temp,{[' ' fullname{driver_i}] date_all(date_i)});xlabel('TLC');ylabel('dis');
%         xlim([0 1.2]);ylim([-0.2 1.2]);
        
%         figure
%         plot3(tempEval.DLC,tempEval.Vy,tempEval.eva,'o');title({fullname{driver_i};date_all(date_i)});
    end
end

% %如果要把结果写入文件中的话去掉这段注释
% evalResult=table(name,driver_No,date,c_Q1,TLC,dis);
% writetable(evalResult,'evalResult.csv','Delimiter',',');
