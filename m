Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55046 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752051AbeAZKSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:18:05 -0500
Subject: Re: [PATCH 15/15] btrfs-progs: fsck-tests: add image for original and
 lowmem check
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-16-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <502deccc-fcc5-18ba-ffd1-2b387d5aa09d@gmx.com>
Date: Fri, 26 Jan 2018 18:17:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-16-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QH7t6QB4hyxE2XYunD3qj0bjy0kY4VGkp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QH7t6QB4hyxE2XYunD3qj0bjy0kY4VGkp
Content-Type: multipart/mixed; boundary="PI83zW1piobHwmIcyOdvjhEqNnDLX6j1W";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <502deccc-fcc5-18ba-ffd1-2b387d5aa09d@gmx.com>
Subject: Re: [PATCH 15/15] btrfs-progs: fsck-tests: add image for original and
 lowmem check
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-16-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-16-suy.fnst@cn.fujitsu.com>

--PI83zW1piobHwmIcyOdvjhEqNnDLX6j1W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> This image have two cases mixed:
> 1) Both filetypes of dir_item and dir_index about inode 258
>    are corrupted.
> 2) inode item 258 is missing.

It would be better to provide some debug tree output in commit message.

Something like:
------
        item 6 key (257 DIR_ITEM 4128386376) itemoff 15834 itemsize 35
                location key (258 INODE_ITEM 0) type DIR_ITEM.100
                transid 7 data_len 0 name_len 5
                name: file1
        item 7 key (257 DIR_INDEX 2) itemoff 15799 itemsize 35
                location key (258 INODE_ITEM 0) type DIR_ITEM.34
                transid 7 data_len 0 name_len 5
                name: file1
        item 8 key (258 INODE_REF 257) itemoff 15784 itemsize 15
                index 2 namelen 5 name: file1
------

would explain the problem easier.

And I think the coverage is not that good.

The image will fall into the fallback case as no reliable filetype.

But it would be better to have another image with regular/prealloc file
extent to allow us to exam the filetype guess/find code.

Thanks,
Qu
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  .../029-mismatched-filetype-no-inode/default_case.img    | Bin 0 -> 30=
72 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 tests/fsck-tests/029-mismatched-filetype-no-inode/d=
efault_case.img
>=20
> diff --git a/tests/fsck-tests/029-mismatched-filetype-no-inode/default_=
case.img b/tests/fsck-tests/029-mismatched-filetype-no-inode/default_case=
=2Eimg
> new file mode 100644
> index 0000000000000000000000000000000000000000..57fc55b13c18bb9e5098a2f=
c4cb78f44fcf4abd9
> GIT binary patch
> literal 3072
> zcmeHIdr;F?7EXCTRG?Bxc@>Nzl**%3o;ExN5K61)k|sa|c?E0?0tS<45}pcFF|3HG
> zP(T(C5ekF^)P$A90ufn+LPC@zJVi+;1Oh=3DIf!~6&Gaa4TKlhKF@ywljzjJ23d(ZjK
> zojF%g#i^6~k^cn!$27LiPu{I9Fuxu2_TKVAAg%4)oBa+Gw*w%~J8ZGd_-G#$_^81D
> zqXPJmONab%?&_8cU%hU@e3P9%Ckpzm)Ff$v)Wc@$>`BOZ#`Pp<)M#>*a!#6gR-n6^
> z)1=3Dc4bzkSqAeVbqNE#^6(OCUuf%ng!<@)45b#aP846yZF4X-R_(Y-V^`b{r7%mwmG
> zSWwtole>bWF5})+N6j;AXb0Gxy74YnHE}t5`;DOxH;HrQz7u)mWsTfIuMAkZ<(_L<
> zC!F*GIJRKTD$r+#ynp(^1;1avE`FkKNIg+L5PnOuanrCw<r7L^+;xULn#a2B7=3DCtr
> zs4O>R`tt$)P*2%T!%ObT%-uhb?}*&D?n%}JRS;pn;z#C$w4a`Mn{yX|Ga9U}x~oOl
> zPdy&K^u@GIhKy*>SRG86A0MnN+-sb03Tf_vZ5-E+liKXMd_&vzazm2Gne+MktgGVy
> zvel#Bjd}T{tkT9P=3DzgwDEa(bJDo>c|p2U#nuEy7Oq}9Yu^C{YMx%Hc`+EvW8NX3^E
> zk5b)CX?>IaMfBjmD-m+Yq}J{ZNNVX0?AQ<#|9zRx-J>V|%LlTp#^N=3DX)8>mh-)=3Df9
> zEYlDVvLL+$VG(Ui8HDAoY(D;gCVKkJ-@HePR*lull}K3i@%ZJsPNw}D=3D_Eh9%JD@h
> z?Erk8B2lV5KN*FmZmG~q(|r;G^8W)cQe$Qm!0sCQG}HAsPz|4CwFrA_^+e2sR_0gZ
> zT6?nGG7Cq$kNKf{KyPloT`ZqIZM2Cu7Dyak38$c#V`;-zUb>Sns-7=3DGO_RFo*VdgR
> zuqI*rZ54Ur!&<Nktt_=3DqwYT0D`{aeDnQJcqW;k4U@!_JtC&3Y6hCc_~3~StNabqtN
> zucrxtJ82q>Sl>f9N%#3``J4tLz`huK;mr8Mfx0Knd3o)jenuy1{i@HR#*`hTB~${6
> zUv_Afxa)cPYb5}TDS<Zybm~}XtG1UA%v>e(!p&B4Ya=3D~W>ofT{n+nz8oS~p4#lC`~
> zb8u11IWe6w=3Df)s&>P;TI(=3Dk?N@SPvz&PJ9UlXj%_3Z(%0d_CZmZU@ut8ci9#8f$HC
> z*WTjhvI#~*-wngRh#7=3DX-Fmp=3DjPY=3DIh0Wy^83noKY+xx`U!G=3DAWh5CjX{nVD9L=
F{R
> zU-WeEL{Wb4;-3oGNM9i?p>g7ijF+qbFuJxU3sZdd{#01uO$yD{GvFk&d(6xiY^PD`
> z`WsWygqmUnBww<AN=3Df-z|I3v7FQyO>#H6qGUm0wp*HH~P%N?E<<}ITl?5LserSj}(
> z297#+hWh84_Y2p@xTsd%x#--#Nni#Q|4Ipxp<3r7+8+PXxx%Y-r5X!!=3D_|}{J!L^2
> zj)_*GCH6DoSd?di6o{=3Dgi$ToxU!<VWg!#+Ul@A+ZSO@@+3tK%|eS#l>sEUY<bfUnd
> z#z3(u>%_(a-G;Yng@p_aR!m56_S-4Kkx`wb-~;)P!B|l#<=3D%tqh!TpM*i_|yOSAQ4
> zvW?d6n(=3DHfFPM`F&Z!$djU!(>x!?y?d%v=3DA;NURFAf7^dPE5VSt3>8OZ!b$jB>d=3D=
R
> zUi2N&gsLW#yNe%L557Lz@L)84{Q4l9BWL3)GF6Y&!utQ%Wd=3DU5E>~6_7O${=3D+w`i(
> z%3#13Z=3Dw)Kdf}4|UKpK;xUcCxgl6f)p}g4$b6lc71QCwFLt}^}kC=3DPd@dZitR_Fgr
> zf%3Tpr&Fw75HCo1nW(9PfPwbUeOrmw&Kp#7!4BH?vg6sS-ETPM%E9-Nx3v?98T^30
> z!E<e6$T@1JTsO|k&(!1Bgxa*?+N!22&m4JD_)=3DS!<bs%(BImU<xmqX_rwtN-wO0o#
> z+MuM7R4Ar0B=3DB~zLu5(*{mK>+k^4=3D*tXx5D5H3qd4x8U8kRwaU7RMO#zpG5`D%hQ{
> zQ@Id0-jr`iP(?4BQ3O;KRS<hPP9Rcj0zpavn@1$>T&=3D3_7=3Dbz}(DFsr=3D=3DY@6ke=
Z0m
> ztya!P0$!o(C1)SCJ9hSoSk5^t{Zb`iYVMb$BO^M)46RnlO3RAX#_TMYwqi77@8KNm
> zMEX%lf3IE;C<ATPVc`?mUoqC6zzlCka><GfbQpT?a&7vz*jX<DY0X42bXNZZ)<^e$
> HufV?n{Xac9
>=20
> literal 0
> HcmV?d00001
>=20


--PI83zW1piobHwmIcyOdvjhEqNnDLX6j1W--

--QH7t6QB4hyxE2XYunD3qj0bjy0kY4VGkp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlprAFYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgnRgf+JGy+S+mhYRM7xFQBevvodLTO
amN2xc5Yor4bOSBGY82dkVrV3DodfCa7xCL6o3gCuOxPITd0Z1HwZa8jNghsYRCT
ZiVTmv4HwO1bPxm75ioqUgupylaxurdgv338cLG+RExjMfqtTOni22YBGnPKHerI
ozqeZSQvaUSTFyKsdXexV/LKTkIf8Ek9i6eVGN0O2KBIYrcJy471Aq0i1A22QmcA
8OChhuXzVEKhrOXmhy1OyZV1z9rXlIb665uUVXgaTfhOdpJykOwQlUD1ZumzNhg5
vgdm7gBMP3UG1vmhU1J0J45+1rMvm9BiyS/LC5NK6R+vCpHGgV8jE6K6UIU0BQ==
=YkNC
-----END PGP SIGNATURE-----

--QH7t6QB4hyxE2XYunD3qj0bjy0kY4VGkp--
