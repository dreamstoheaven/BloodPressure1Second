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

a = [double(T_sig12),double(sig12)];
b = [double(T_sig13),double(sig13)];
c = [double(T_sig14),double(sig14)];

% Define whatever pseudovalue you would like to assign to missing
% datapoints. Any negative value should work. 
if starttime ~= 1
    inx = knnsearch(a(:,1),starttime);
    a = a(inx:end,:);
    b = b(inx:end,:);
    c = c(inx:end,:);
    for i = 1:(endtime-a(inx,1))
        try
        if a(i,1) ~= a(inx,1)+i-1
            a = [a(1:i-1,:);[a(inx,1)+i-1,-10;];a(i:end,:)];
        end
        catch
            a(i,:) = [a(inx,1)+i-1,-1;];
        end
        try
        if b(i,1) ~= a(inx,1)+i-1
            b = [b(1:i-1,:);[a(inx,1)+i-1,-10;];b(i:end,:)];
        end
        catch
            b(i,:) = [a(inx,1)+i-1,-1;];
        end
        try
        if c(i,1) ~= a(inx,1)+i-1
            c = [c(1:i-1,:);[a(inx,1)+i-1,-10;];c(i:end,:)];
        end
        catch
            c(i,:) = [a(inx,1)+i-1,-1;];
        end
    end
else 
    for i = starttime:endtime
        try
        if a(i,1) ~= i-1
            a = [a(1:i-1,:);[i-1,-10;];a(i:end,:)];
        end
        catch
            a(i,:) = [i-1,-10;];
        end
        try
        if b(i,1) ~= i-1
            b = [b(1:i-1,:);[i-1,10;];b(i:end,:)];
        end
        catch
            b(i,:) = [i-1,-10;];
        end
        try
        if c(i,1) ~= i-1
            c = [c(1:i-1,:);[i-1,-10;];c(i:end,:)];
        end
        catch
            c(i,:) = [i-1,-10;];
        end
    end    
end
end