load debug_data
cueBeamPy=py.importlib.import_module('cueBeamCore3');
py.importlib.reload(cueBeamPy);


% mex tx format: pxx pyy pzz pzeros pfa pff
%tx=[0.1 0 0 0 1 0];
%tx=single(tx);
img_xz=squeeze(cueBeam.cueBeam_xz(tx',enviroment.wavenumber,x0,y0,z0,nx,ny,nz,dx,dy,dz));
elements_vectorized_tmp=tx(:,[2 1 3 5 6 4]);
elements_vectorized_tmp(:,5)=elements_vectorized_tmp(:,5);
elements_vectorized_tmp=elements_vectorized_tmp';
elements_vectorized=elements_vectorized_tmp(:);
t1=now;
pnx=1; % should be ny
pny=nx;
pnz=nz;
field_py=cueBeamPy.beamsim_remote(pyargs('k',enviroment.wavenumber,'elements_vectorized',elements_vectorized','dx',dy,'dy',dx,'dz',dz,'nx',uint32(pnx),'ny',uint32(pny),'nz',uint32(pnz),'x0',y0,'y0',x0,'z0',z0));
field=abs(ndarray2mat2(field_py));
t2=now;
figure(7); subplot(1,3,1); imagesc(img_xz); title('mex'); subplot(1,3,2); imagesc(field); title('py'); 
subplot(1,3,3); imagesc(img_xz-field); title('diff')
% calculate relative errror
rel_err =  max(abs(img_xz(:)-field(:))) / max(abs(img_xz(:)))
% start by trying some very simple points
%% try lambert 
% note, it does not have the data format altered from the original
elLa=tx';
elLa=elLa(:)';
lambert_radius=0.1;
lambert_map_density=500;
field_lambert_py=cueBeamPy.beamsim_lambert_remote(pyargs('k',wavenumber,'elements_vectorized',elLa,'lambert_radius',lambert_radius,'lambert_map_density',lambert_map_density));
field_lambert=ndarray2mat2(field_lambert_py);
imagesc(abs(field_lambert))