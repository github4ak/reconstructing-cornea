%To measure the thickness of Cornea.
%Author:Abishek Krishnan
clc;
close all;
clear all;
warning('off', 'Images:initSize:adjustingMag'); 
%To turn off the warning the image is to big to fit in this window

I = imread('ODa_after_extraction.jpg');
level = graythresh(I);
I_bin = im2bw(I,level);
[rows columns] = size(I_bin);
ad = zeros(rows,columns);
al = logical(ad);
alr = logical(ad);

count = 1;
rcount = 1;
se1 = strel('line',2,0);
se2 = strel ('line',2,90);

for c = 1:columns;
	for r = 1:rows;
		if(I_bin(r,c)==1)
			al(r,c) = 1;
			xset(count) = c;
			yset(count) = r;
			count= count +1;
			break;
		end
	end
end

for cr = 1:columns;
	for rr = rows:-1:1;
		if(al(rr,cr)~=1 && I_bin(rr,cr) == 1)
			alr(rr,cr) = 1;
			rcount = rcount+1;
			break;
		end;
	end;
end;

I_before_dilation_top = mat2gray(al);
I_extracted = imdilate(I_before_dilation_top,[se1 se2]);
I_before_dilation_bottom = mat2gray(alr);
I_bottom_extracted = imdilate(I_before_dilation_bottom,[se1 se2]);
imshow(I_extracted)
imshow(I_bottom_extracted)
I_final = I_extracted + I_bottom_extracted;
imshow(I_final)

%Polyfit
[r1, c1] = find(I_extracted);
figure;
plot(c1,r1,'.');
hold on;

f1 = fit(c1, r1, 'poly2');
plot((min(c1):max(c1)),f1(min(c1):max(c1)), 'red', 'LineWidth', 1);

[r2, c2] = find(I_bottom_extracted);
figure;
plot(c2,r2,'.');
hold on;

f2 = fit(c2, r2, 'poly2');
plot((min(c2):max(c2)),f2(min(c2):max(c2)), 'red', 'LineWidth', 1);

%Change of origin
x = (min(c1):max(c1))';
y = round(f1(x));
I1 = zeros(size(I_extracted));
I1(y +((x-1)*size(I1,1))) = 1;
figure
imshow(I1)

x1 = (min(c2):max(c2))';
y1 = round(f2(x));
I2 = zeros(size(I_bottom_extracted));
I2(y1 +((x1-1)*size(I2,1))) = 1;
figure
imshow(I2);

I3 = I1+I2;
imshow(I3)

%Trying to dilate the final image and apply a morph to it
I_f = imdilate(I3,[se1 se2]);
imshow(I_f)

%On this apply the up down algo and populate the array
[rf cf] = size(I_f);
adf = zeros(rf,cf);
alf = logical(adf);
alrf = logical(adf);
countf = 1;
rcountf = 1;

for c = 1:cf;
	for r = 1:rf;
		if(I_f(r,c)==1)
			alf(r,c) = 1;
			top(countf,:) = [c,r];
			countf= countf +1;
			break;
		end
	end
end

for cr = 1:cf;
	for rr = rf:-1:1;
		if(alf(rr,cr)~=1 && I_f(rr,cr) == 1)
			alrf(rr,cr) = 1;
			bottom(rcountf,:) = [cr,rr];
			rcountf = rcountf+1;
			break;
		end;
	end;
end;

count = countf-1;
%Subtracting the distance
for i = 1:count
	sub(i) = abs(top(i,2)-bottom(i,2));
end

%Plot the graph of difference in length
x = 1:count;
y = sub(x);
p = polyfit(x,y,2);
plot(x,y);