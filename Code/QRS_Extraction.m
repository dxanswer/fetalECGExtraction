function [ QRS_ECG ] = QRS_Extraction(ECG,thres,range)

ECG_length = length(ECG);
QRS_ECG = zeros(1,(ECG_length+2*range));
ECG = [zeros(range,1);ECG;zeros(range,1)];
for i = range:ECG_length
    if (abs(ECG(i))> abs(ECG(i-1)) && abs(ECG(i)) > abs(ECG(i+1)) && abs(ECG(i)) > thres)
        QRS_ECG(i) = ECG(i);
        QRS_ECG(i:-1:i-range+1) = ECG(i:-1:i-range+1);
        QRS_ECG(i:i+range-1) = ECG(i:i+range-1);
    end
end
QRS_ECG = QRS_ECG(range+1:ECG_length+range);
end

