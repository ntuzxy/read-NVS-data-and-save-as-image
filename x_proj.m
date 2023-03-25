function [x_low,x_high]=x_proj(frames)        
        first_xprojection=sum(frames)>0;
        first_xprojection_rshift=circshift(first_xprojection,[0 1]);
        first_xprojection_rshift(1,1)=0;
        xrshift_xor=first_xprojection & ~first_xprojection_rshift;
        x_low=find(xrshift_xor==1);
        %%% x_high calculation
        first_xprojection_lshift=circshift(first_xprojection,[0 -1]);
        first_xprojection_lshift(1,end)=0;
        xlshift_xor=first_xprojection & ~first_xprojection_lshift;
        x_high=find(xlshift_xor==1);
