function [ a,b,c ] = FillingGaps_Double_Filter( sig12,sig13,sig14,T_sig12,T_sig13,T_sig14, starttime,endtime )

% This function fills in all gaps in time and puts in -10 as the
% psuedovalue. Other negative values should work as well, but positive
% values might be a concern as they may in some cases remain in the dataset
% after filtering and be additional artifacts. This function expands the
% array by redefining the array rather than inserting an element into the
% erray; the later would be more intuitive but computationally costly. It is mathematically faster to simply delete all three
% datapoints when they are misaligned, but the find() function
% involved in this operation is extreemly costly and not the best choice
% for large databases and recursive operations. 

a = [double(T_sig12)*2,double(sig12)];
b = [double(T_sig13)*2,double(sig13)];
c = [double(T_sig14)*2,double(sig14)];

% Define whatever pseudovalue you would like to assign to missing
% datapoints. Any negative value should work. 
if starttime ~= 1
    inx_a = knnsearch(a(:,1),starttime);
    inx_b = knnsearch(b(:,1),a(inx_a,1));
    inx_c = knnsearch(c(:,1),a(inx_a,1));
    if b(inx_b,1) < a(inx_a,1)
        inx_b = inx_b + 1;
    end
    if c(inx_c,1) < a(inx_a,1)
        inx_c = inx_c + 1;
    end    
    a = a(inx_a:end,:);
    b = b(inx_b:end,:);
    c = c(inx_c:end,:);
    rightvalue = min([a(1,1), b(1,1), c(1,1)]);
    for i = 1:endtime-rightvalue - 1
        %try
        if a(i,1) ~= rightvalue+i-1
            a = [a(1:i-1,:);[rightvalue+i-1,-10;];a(i:end,:)];
        end
        %catch
        %    a(i,:) = [a(inx,1)+i-1,-10;];
        %end
        %try
        if b(i,1) ~= rightvalue+i-1
            b = [b(1:i-1,:);[rightvalue+i-1,-10;];b(i:end,:)];
        end
        %catch
        %    b(i,:) = [a(inx,1)+i-1,-10;];
        %end
        %try
        if c(i,1) ~= rightvalue+i-1
            c = [c(1:i-1,:);[rightvalue+i-1,-10;];c(i:end,:)];
        end
        %catch
        %    c(i,:) = [a(inx,1)+i-1,-10;];
        %end
    end
    if length(a(:,1)) < (endtime-rightvalue)
        a(endtime - rightvalue,:) = [rightvalue+i-1,-10];
    end
    if length(b(:,1)) < (endtime-rightvalue)
        b(endtime - rightvalue,:) = [rightvalue+i-1,-10];
    end
    if length(c(:,1)) < (endtime-rightvalue)
        c(endtime - rightvalue,:) = [rightvalue+i-1,-10];
    end
else 
    for i = starttime:endtime -1
        %try
        if a(i,1) ~= i-1
            a = [a(1:i-1,:);[i-1,-10;];a(i:end,:)];
        end
        %catch
        %   a(i,:) = [i-1,-10;];
        %end
        %try
        if b(i,1) ~= i-1
            b = [b(1:i-1,:);[i-1,10;];b(i:end,:)];
        end
        %catch
        %    b(i,:) = [i-1,-10;];
        %end
        %try
        if c(i,1) ~= i-1
            c = [c(1:i-1,:);[i-1,-10;];c(i:end,:)];
        end
        %catch
        %    c(i,:) = [i-1,-10;];
        %end
    end
    if length(a(:,1)) < (endtime-starttime+1)
        a(endtime-starttime+1,:) = [endtime-starttime,-10];
    end
    if length(b(:,1)) < (endtime-starttime+1)
        b(endtime-starttime+1,:) = [endtime-starttime,-10];
    end
    if length(c(:,1)) < (endtime-starttime+1)
        c(endtime-starttime+1,:) = [endtime-starttime,-10];
    end
    
end
end