function output = centerImg(input);
% This is to shift the brightest spot of image to the center.
[M,BrightRow]=max(input);
[M,BrightCol]=max(M);
BrightRow = BrightRow(BrightCol);
[Row,Col]=size(input);
output = circshift(input,[floor(Row/2-BrightRow) floor(Col/2-BrightCol)]);