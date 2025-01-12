import matplotlib.pyplot as plt
import numpy as np
import matplotlib
from scipy.signal import find_peaks
matplotlib.rcParams.update({'font.size': 17})

coord = np.loadtxt('Scripts/Coordenades_orbita.txt')
x = coord[:,0]
y = coord[:,1]

plt.figure(figsize=(8,6))
plt.scatter(x,y, color='darkblue',s=1,label='Òrbita terrestre')
plt.xlabel('$\hat{x}$')
plt.ylabel('$\hat{y}$')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(loc="upper right", fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.axis('equal') 
plt.savefig('Scripts/Gràfics/plots/grafic_orbita.png',dpi=300)

# Declinació per mesos:
declinacio = np.loadtxt('Scripts/evo_declinacio.txt')
theta = declinacio[:,0]
alpha = declinacio[:,1]

plt.figure(figsize=(8,6))
plt.scatter(theta,alpha, color='firebrick',s=1,label='Declinació de la Terra')
plt.xlabel('$\\theta$')
plt.ylabel('$\\alpha$')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/declinacio.png',dpi=300)


elevacio = np.loadtxt('Scripts/elevacio_solar_anual.txt')
theta = elevacio[:,0]
delta = elevacio[:,1]
print('Antes d\'elevacio')
plt.figure(figsize=(8,6))
plt.scatter(theta,delta, color='firebrick',s=1,label='Elevació aparent del Sol')
plt.xlabel('$\\theta$')
plt.ylabel('$\delta$')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/elevacio.png',dpi=300)

#-------------------------------------INTENSITATS---------------------------------------

intensitat = np.loadtxt('Scripts/intensitats.txt')
inten = intensitat[:,1]
theta = intensitat[:,0]

peaks, _ = find_peaks(inten, height=0, distance=1)
envolupant = inten[peaks]
theta_env = theta[peaks]
plt.figure(figsize=(8,6))
plt.scatter(theta,inten, color='firebrick',s=1,label='Radiació')
plt.plot(theta_env,envolupant,color = 'k', markersize = 2,label='envolupant')
plt.xlabel('$\\theta$')
plt.ylabel('$I$ [W/m$^2$]')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/intensitat.png',dpi=300)

intensitat = np.loadtxt('Scripts/intensitats_no_atm.txt')
inten = intensitat[:,1]
theta = intensitat[:,0]

peaks, _ = find_peaks(inten, height=0, distance=1)
envolupant = inten[peaks]
theta_env = theta[peaks]
plt.figure(figsize=(8,6))
plt.scatter(theta,inten, color='firebrick',s=1,label='Radiació')
plt.plot(theta_env,envolupant,color = 'k', markersize = 2,label='envolupant')
plt.xlabel('$\\theta$')
plt.ylabel('$I$ [W/m$^2$]')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/intensitat_no_atm.png',dpi=300)


intensitat = np.loadtxt('Scripts/intensitats_N.txt')
inten = intensitat[:,1]
theta = intensitat[:,0]

peaks, _ = find_peaks(inten, height=0, distance=1)
envolupant = inten[peaks]
theta_env = theta[peaks]
plt.figure(figsize=(8,6))
plt.scatter(theta,inten, color='forestgreen',s=1,label='Radiació')
plt.plot(theta_env,envolupant,color = 'k', markersize = 2,label='envolupant')
plt.xlabel('$\\theta$')
plt.ylabel('$I$ [W/m$^2$]')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/intensitat_N.png',dpi=300)

intensitat = np.loadtxt('Scripts/intensitats_N_no_atm.txt')
inten = intensitat[:,1]
theta = intensitat[:,0]

peaks, _ = find_peaks(inten, height=0, distance=1)
envolupant = inten[peaks]
theta_env = theta[peaks]
plt.figure(figsize=(8,6))
plt.scatter(theta,inten, color='forestgreen',s=1,label='Radiació')
plt.plot(theta_env,envolupant,color = 'k', markersize = 2,label='envolupant')
plt.xlabel('$\\theta$')
plt.ylabel('$I$ [W/m$^2$]')
plt.minorticks_on()
plt.tick_params(which= 'major', direction='in',top = True,right =True,size = 10)
plt.tick_params(which= 'minor', direction='in',top = True,right =True,size = 5)
plt.grid(linestyle='--')
plt.legend(fontsize=16, markerscale=5)
plt.tight_layout(pad=0.56)
plt.savefig('Scripts/Gràfics/plots/intensitat_N_no_atm.png',dpi=300)


# ------------------------HISTOGRAMES------------------------
intensitatS = np.loadtxt('Scripts/intensitats.txt')
intensitatN = np.loadtxt('Scripts/intensitats_N.txt')
intenS = intensitatS[:,1]
intenN = intensitatN[:,1]
mesos = ['Gener','Febrer','Març','Abril','Maig','Juny','Juliol','Agost','Setembre','Octubre','Novembre','Desembre']
index_mes= (theta*365.25/(2*np.pi) % 12).astype(int) 
dades_per_mes_S = [np.mean(intenS[index_mes== i]) for i in range(12)] 
dades_per_mes_N = [np.mean(intenN[index_mes== i]) for i in range(12)] 

plt.figure(figsize=(8,6))
plt.bar(mesos,dades_per_mes_S/np.sum(dades_per_mes_S), color='firebrick',label=f'Sud, $I_{{max}}$ ={round(np.max(intenS),2)} W/m$^2$',alpha=0.6)
plt.bar(mesos,dades_per_mes_N/np.sum(dades_per_mes_N), color='forestgreen',label=f'Nord, $I_{{max}}$ ={round(np.max(intenN),2)} W/m$^2$',alpha=0.6)
plt.xticks(ticks=np.arange(0, 12), labels=mesos, rotation=45)
plt.ylabel('$I_{norm}$')
plt.legend(fontsize=14,loc="upper center", bbox_to_anchor=(0.5, 1.15), ncol=2)
plt.tight_layout(pad=0.56)

plt.savefig('Scripts/Gràfics/plots/intensitat_histograma.png',dpi=300)

intensitatS = np.loadtxt('Scripts/intensitats_no_atm.txt')
intensitatN = np.loadtxt('Scripts/intensitats_N_no_atm.txt')
intenS = intensitatS[:,1]
intenN = intensitatN[:,1]
mesos = ['Gener','Febrer','Març','Abril','Maig','Juny','Juliol','Agost','Setembre','Octubre','Novembre','Desembre']
index_mes= (theta*365.25/(2*np.pi) % 12).astype(int) 
dades_per_mes_S = [np.mean(intenS[index_mes== i]) for i in range(12)] 
dades_per_mes_N = [np.mean(intenN[index_mes== i]) for i in range(12)] 

plt.figure(figsize=(8,6))
plt.bar(mesos,dades_per_mes_S/np.sum(dades_per_mes_S), color='firebrick',label=f'Sud, $I_{{max}}$ ={round(np.max(intenS),2)} W/m$^2$',alpha=0.6)
plt.bar(mesos,dades_per_mes_N/np.sum(dades_per_mes_N), color='forestgreen',label=f'Nord, $I_{{max}}$ ={round(np.max(intenN),2)} W/m$^2$',alpha=0.6)
plt.xticks(ticks=np.arange(0, 12), labels=mesos, rotation=45)
plt.ylabel('$I_{norm}$')
plt.legend(fontsize=14, loc="upper center", bbox_to_anchor=(0.5, 1.15), ncol=2)
plt.tight_layout(pad=0.56)

plt.savefig('Scripts/Gràfics/plots/intensitat_histograma_no_atm.png',dpi=300)