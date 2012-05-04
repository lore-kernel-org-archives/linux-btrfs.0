From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: balancing metadata fails with no space left on device
Date: Fri, 4 May 2012 18:52:29 +0200
Message-ID: <201205041852.29290.Martin@lichtvoll.de>
References: <201205041835.39441.Martin@lichtvoll.de> (sfid-20120504_183812_269428_BBFB353B)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205041835.39441.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> Hi!
>=20
> merkaba:~> btrfs balance start -m /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> merkaba:~#19> dmesg | tail -22
> [   62.918734] CPU0: Package power limit normal
> [  525.229976] btrfs: relocating block group 20422066176 flags 1
> [  526.940452] btrfs: found 3048 extents
> [  528.803778] btrfs: found 3048 extents
> [  528.988440] btrfs: relocating block group 17746100224 flags 34
> [  529.116424] btrfs: found 1 extents
> [  529.247866] btrfs: relocating block group 17611882496 flags 36
> [  536.003596] btrfs: found 14716 extents
> [  536.170073] btrfs: relocating block group 17477664768 flags 36
> [  542.230713] btrfs: found 13170 extents
> [  542.353089] btrfs: relocating block group 17343447040 flags 36
> [  547.446369] btrfs: found 9809 extents
> [  547.663141] btrfs: 1 enospc errors during balance
> [  629.238168] btrfs: relocating block group 21894266880 flags 34
> [  629.359284] btrfs: found 1 extents
> [  629.520614] btrfs: 1 enospc errors during balance
> [  630.715766] btrfs: relocating block group 21927821312 flags 34
> [  630.749973] btrfs: found 1 extents
> [  630.899621] btrfs: 1 enospc errors during balance
> [  635.872857] btrfs: relocating block group 21961375744 flags 34
> [  635.906517] btrfs: found 1 extents
> [  636.038096] btrfs: 1 enospc errors during balance
>=20
>=20
> merkaba:~> btrfs filesystem show
> failed to read /dev/sr0
> Label: 'debian'  uuid: [=E2=80=A6]
>         Total devices 1 FS bytes used 7.89GB
>         devid    1 size 18.62GB used 17.58GB path /dev/dm-0
>=20
>=20
> Btrfs Btrfs v0.19
> merkaba:~> btrfs filesystem df /
> Data: total=3D15.52GB, used=3D7.31GB
> System, DUP: total=3D32.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.00GB, used=3D587.83MB

I thought data tree might have been to big, so out of curiousity I trie=
d a=20
full balance. It shrunk the data tree but it failed as well:

merkaba:~> btrfs balance start /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> dmesg | tail -63
[   89.306718] postgres (2876): /proc/2876/oom_adj is deprecated, pleas=
e=20
use /proc/2876/oom_score_adj instead.
[  159.939728] btrfs: relocating block group 21994930176 flags 34
[  160.010427] btrfs: relocating block group 21860712448 flags 1
[  161.188104] btrfs: found 6 extents
[  161.507388] btrfs: found 6 extents
[  161.692596] btrfs: relocating block group 21592276992 flags 1
[  162.804544] btrfs: found 1930 extents
[  164.615038] btrfs: found 1930 extents
[  164.836342] btrfs: relocating block group 21323841536 flags 1
[  165.261189] btrfs: found 714 extents
[  166.405800] btrfs: found 714 extents
[  166.599482] btrfs: relocating block group 21055406080 flags 1
[  167.554796] btrfs: found 1933 extents
[  168.984707] btrfs: found 1933 extents
[  169.169526] btrfs: relocating block group 20786970624 flags 1
[  170.829402] btrfs: found 2602 extents
[  172.817614] btrfs: found 2602 extents
[  173.020840] btrfs: relocating block group 19885195264 flags 1
[  177.102572] btrfs: found 5924 extents
[  179.853234] btrfs: found 5924 extents
[  180.124753] btrfs: relocating block group 18828230656 flags 1
[  185.524803] btrfs: found 15255 extents
[  190.716666] btrfs: found 15255 extents
[  190.968648] btrfs: relocating block group 17754488832 flags 1
[  194.653684] btrfs: found 4975 extents
[  197.213332] btrfs: found 4975 extents
[  197.427145] btrfs: relocating block group 16269705216 flags 1
[  203.988076] btrfs: found 9435 extents
[  206.879416] btrfs: found 9435 extents
[  207.094286] btrfs: relocating block group 15195963392 flags 1
[  214.046474] btrfs: found 12789 extents
[  218.398271] btrfs: found 12789 extents
[  218.685567] btrfs: relocating block group 13048479744 flags 1
[  226.665003] btrfs: found 10176 extents
[  230.115369] btrfs: found 10176 extents
[  230.418228] btrfs: relocating block group 11840520192 flags 1
[  238.866773] btrfs: found 10862 extents
[  241.769074] btrfs: found 10862 extents
[  242.030420] btrfs: relocating block group 10364125184 flags 1
[  253.602784] btrfs: found 15486 extents
[  257.715518] btrfs: found 15486 extents
[  257.982685] btrfs: relocating block group 8619294720 flags 1
[  267.146921] btrfs: found 13806 extents
[  271.022675] btrfs: found 13806 extents
[  271.268562] btrfs: relocating block group 6471811072 flags 1
[  278.922272] btrfs: found 14490 extents
[  283.589668] btrfs: found 14490 extents
[  283.838663] btrfs: relocating block group 5398069248 flags 1
[  292.536548] btrfs: found 15367 extents
[  296.030960] btrfs: found 15367 extents
[  296.346493] btrfs: relocating block group 4324327424 flags 1
[  304.276714] btrfs: found 10555 extents
[  306.996284] btrfs: found 10555 extents
[  307.285261] btrfs: relocating block group 3250585600 flags 1
[  317.425150] btrfs: found 26305 extents
[  322.227915] btrfs: found 26305 extents
[  322.537047] btrfs: relocating block group 2176843776 flags 1
[  331.945877] btrfs: found 17104 extents
[  335.615238] btrfs: found 17079 extents
[  335.897953] btrfs: relocating block group 1103101952 flags 1
[  347.888295] btrfs: found 28458 extents
[  352.736987] btrfs: found 28458 extents
[  353.099659] btrfs: 1 enospc errors during balance

merkaba:~> btrfs filesystem df /
Data: total=3D10.00GB, used=3D7.31GB
System, DUP: total=3D64.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.12GB, used=3D587.20MB

merkaba:~> btrfs filesystem show
failed to read /dev/sr0
Label: 'debian'  uuid: [=E2=80=A6]
        Total devices 1 FS bytes used 7.88GB
        devid    1 size 18.62GB used 12.38GB path /dev/dm-0


=46or the sake of it I tried another time. It failed again:

martin@merkaba:~> dmesg | tail -32
[  353.099659] btrfs: 1 enospc errors during balance
[  537.057375] btrfs: relocating block group 32833011712 flags 36
[  537.141258] btrfs: relocating block group 31759269888 flags 1
[  537.284200] btrfs: relocating block group 30685528064 flags 1
[  537.427898] btrfs: relocating block group 29611786240 flags 1
[  541.103070] btrfs: found 8018 extents
[  543.033896] btrfs: found 8018 extents
[  543.242608] btrfs: relocating block group 28538044416 flags 1
[  554.136612] btrfs: found 28088 extents
[  557.621779] btrfs: found 28088 extents
[  557.964021] btrfs: relocating block group 27464302592 flags 1
[  568.547296] btrfs: found 27207 extents
[  572.411358] btrfs: found 27207 extents
[  572.749233] btrfs: relocating block group 26390560768 flags 1
[  583.383545] btrfs: found 23359 extents
[  586.907206] btrfs: found 23359 extents
[  587.280967] btrfs: relocating block group 25316818944 flags 1
[  597.054363] btrfs: found 22546 extents
[  600.206597] btrfs: found 22546 extents
[  600.444821] btrfs: relocating block group 24243077120 flags 1
[  610.921027] btrfs: found 17593 extents
[  613.609900] btrfs: found 17593 extents
[  613.900155] btrfs: relocating block group 23169335296 flags 1
[  624.355734] btrfs: found 18764 extents
[  627.252739] btrfs: found 18764 extents
[  627.567920] btrfs: relocating block group 22095593472 flags 1
[  637.448364] btrfs: found 21593 extents
[  641.256887] btrfs: found 21593 extents
[  641.479140] btrfs: relocating block group 22062039040 flags 34
[  641.695614] btrfs: relocating block group 22028484608 flags 34
[  641.840179] btrfs: found 1 extents
[  641.965843] btrfs: 1 enospc errors during balance


merkaba:~#19> btrfs filesystem df /
Data: total=3D10.00GB, used=3D7.31GB
System, DUP: total=3D32.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.12GB, used=3D586.74MB
merkaba:~> btrfs filesystem show
failed to read /dev/sr0
Label: 'debian'  uuid: [=E2=80=A6]
        Total devices 1 FS bytes used 7.88GB
        devid    1 size 18.62GB used 12.32GB path /dev/dm-0

Btrfs Btrfs v0.19


Well, in order to be gentle to the SSD again I stop my experiments now =
;).

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
