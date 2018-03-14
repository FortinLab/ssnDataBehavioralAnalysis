function [smi] = CalculateSMI(responseMatrix)
%% CalculateSMI
% Calculate Sequence Memory Index (SMI). Adapted from BehavioralAnalysis.m
% by Norbert Fortin & Tim Allen

%% SMI
numerator = (responseMatrix(1,1)*responseMatrix(2,2))-(responseMatrix(2,1)*responseMatrix(1,2));
denominator = sqrt((responseMatrix(1,1)+responseMatrix(1,2))*(responseMatrix(1,1)+responseMatrix(2,1))*(responseMatrix(2,1)+responseMatrix(2,2))*(responseMatrix(1,2)+responseMatrix(2,2)));
smi = numerator/denominator;
