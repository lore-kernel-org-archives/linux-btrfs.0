Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932763AbeCNBdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 21:33:42 -0400
Subject: Re: [PATCH 2/2] Btrfs-progs: add fsck test for filesystem with shared
 prealloc extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180313184713.30223-1-fdmanana@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7cc276b7-4f61-7dd3-ea43-685fdabfcf24@gmx.com>
Date: Wed, 14 Mar 2018 09:33:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180313184713.30223-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r4IuGxNy9yeXGmmu6LFcoj4xCAOZZM1PW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r4IuGxNy9yeXGmmu6LFcoj4xCAOZZM1PW
Content-Type: multipart/mixed; boundary="dlO1IANRhQ6LNQtspjEAAuBiVi20CmFxs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <7cc276b7-4f61-7dd3-ea43-685fdabfcf24@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: add fsck test for filesystem with shared
 prealloc extents
References: <20180313184713.30223-1-fdmanana@kernel.org>
In-Reply-To: <20180313184713.30223-1-fdmanana@kernel.org>

--dlO1IANRhQ6LNQtspjEAAuBiVi20CmFxs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 02:47, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Verify that a filesystem check operation (fsck) does not report the
> following scenario as an error:
>=20
> An extent is shared between two inodes, as a result of clone/reflink
> operation, and for one of the inodes, lets call it inode A, the extent =
is
> referenced through a file extent item as a prealloc extent, while for t=
he
> other inode, call it inode B, the extent is referenced through a regula=
r
> file extent item, that is, it was written to. The goal of this test is =
to
> make sure a filesystem check operation will not report "odd csum items"=

> errors for the prealloc extent at inode A, because this scenario is val=
id
> since the extent was written through inode B and therefore it is expect=
ed
> to have checksum items in the filesystem's checksum btree for that shar=
ed
> extent.
>=20
> Such scenario can be created with the following steps for example:
>=20
>  mkfs.btrfs -f /dev/sdb
>  mount /dev/sdb /mnt
>=20
>  touch /mnt/foo
>  xfs_io -c "falloc 0 256K" /mnt/foo
>  sync
>=20
>  xfs_io -c "pwrite -S 0xab -b 0 256K" /mnt/foo
>  touch /mnt/bar
>  xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>  xfs_io -c "fsync" /mnt/bar
>=20
>  <power fail>
>  mount /dev/sdb /mnt
>  umount /mnt
>=20
> This scenario is fixed by the following patch for the filesystem checke=
r:
>=20
>  "Btrfs-progs: check, fix false error reports for shared prealloc exten=
ts"
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Checked the image manually, looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  .../reflinked-prealloc-extents.img.xz              | Bin 0 -> 3244 byt=
es
>  .../030-reflinked-prealloc-extents/test.sh         |  42 +++++++++++++=
++++++++
>  2 files changed, 42 insertions(+)
>  create mode 100644 tests/fsck-tests/030-reflinked-prealloc-extents/ref=
linked-prealloc-extents.img.xz
>  create mode 100755 tests/fsck-tests/030-reflinked-prealloc-extents/tes=
t.sh
>=20
> diff --git a/tests/fsck-tests/030-reflinked-prealloc-extents/reflinked-=
prealloc-extents.img.xz b/tests/fsck-tests/030-reflinked-prealloc-extents=
/reflinked-prealloc-extents.img.xz
> new file mode 100644
> index 0000000000000000000000000000000000000000..8adf0071328806fa6981f6e=
f225084e517d1bc3e
> GIT binary patch
> literal 3244
> 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
JY=3D
> zgM5#Nt%rY;GY*s%)x8WSes6E8vtAxZ0RAS&oR+(V%}@kdj~<PlKVab0g;!yqOSYF!
> z)SjQxIx6Ic3J}%|Bf1^W`chZ0UCAHQJXyUHA`eXx3=3DI?%oX!XP!Wu*$$;>mJ5{x#s
> zou?Fb;e7HrfU;p4?0sY877;Z1H?}-Ygcc31-G9Y(;OpjA_g*cpG4-G%Xr76TlW!S!
> zD_4#Gi<Wz-DAt^f$j?hp8ME4^p_@z}4X#GX2h`Qs%L?IFXLWewf;y6DZO?DQx;R)D
> zqU2WjKif$!=3Do6m%p`?{weM8d#!)lk-0@$>J9d6}O$qGTb3Ue-WLHSzqdibPv^Qgkk
> zF!gSYFP0o14elE{;)bNl<F*B{@c>2Z@l^s&kpk_=3Deh+ez))ZImHa$*Ti;e$`XkLqg
> zSP(U&{f0R?H;DC~3y7mGE!{R^vpI=3D_uSE%tjI~g#ih?Ln6gz3n`*V}gKOyr)vUi}w
> z8AcDrm${MstR=3D4MxubM%QS6^8F9MtEA!AVMExun)-S{WhkF+ed-#7js)&$Fm9l>Et
> z>G~Km`H;$$RF;JKpJ_{*56=3DSe53(~Yv`{#DSO;w=3De6G4}ivFf?PPm}qFweC&J>2lA
> zz)zLztUzz8+xjs4vKTGtziG?4_!{L8QLiD59#aYO9*$)ZFa;jOO2JwKYkd-kOVQI;
> zM{e<1!HQg4+0Hg@>Xqpf?S057lpn_3=3DQ*31|3jqcYeRZ6oCA*rIHb4n9bHL=3DaZS?v
> zvrOjS^s&Pojj4!3PjKdLh8=3D5AL<g6l?^7{n2&hUjj}ijvA<*7a9cJ((wuSo%6p{8b
> z2RUFS|5XoAZ^iZf7jooSYPp3n=3D{o%go~S(K3LWq=3Di%=3DCTU+CY04N6B^ysy@Y1#jS=
H
> ziU{ZW*?VF1bbDRG!Y#kB>)}GE_8FUOoL)ydGOEw#8T^B}n)nXror4+_n)>Z2*|b&r
> zQ4u*Sk<0g^s<hgs%!wKRAp9dwGen0ufCspP@ViVRqp@PRH@ce6LE~>2t7tye&Xdg8
> zG2HN`QJka}O}{dIqcp84O#rE32dAf5zHVN^@n8B&66QNP!JVEEuM%12AX~oRPIcGs
> zV=3Dps`>|WP1cQu?kUL<77wB&hGzYt`M0=3DlV#So{@_Iygr{o5Fn9<QgE@N(urC{1K(O
> zsuhG@9`|vfrB??t>|9HMk+a=3DFmqKk8_QB99ArRuR7>#!y%L9G!{j6!ncOTk_*3awa
> zkN;`~%$XI@o0Ahz7<PR=3DmH@5kl5ngzKLK+-m3B$(hLi;q`LOTgX`wh6F`)*>)ZNo_
> z2c`k7Oh;fsno7uR0!pBEg5BgjohMu8?^T<uxsEH9WQG7EnG{3?3YSnGb%#uxvS*3R
> zOcN1c_k+ZeD-zmXY~-g~9nLe(cf?$O-!1xD4^2f|pF=3D%NWj!N&xU+#xYVPr4=3DZ8T{
> zu7*SsVq6K#K<LXYuwk6nWWj~%Xc?1)39VDOYaKOw=3DN0=3D&!mgmbv}Is>N11DabusTj
> ze)_pSN^Ba6Wp^2aiQUvs2r>?R1ocR&>Q=3DDkRQbI>pgveJcmHt~_=3DuIcP3k7)2^GDc
> zN537UWwtmza_!k~6snP|;niI(9;M^(9c^6$;QOu}{65*q*%Fd|N&ck?tRCcNBmAhX
> z2F3n;IubrupC)EJ-_;I9Z+}0XRSRX-ats!dr@lFlB;jzLrz2nNCO!9`9{vD7cva-#
> e`Wb})0f-rZs2TvH_gU7l#Ao{g000001X)^Ms5!_0
>=20
> literal 0
> HcmV?d00001
>=20
> diff --git a/tests/fsck-tests/030-reflinked-prealloc-extents/test.sh b/=
tests/fsck-tests/030-reflinked-prealloc-extents/test.sh
> new file mode 100755
> index 00000000..4d3ef7da
> --- /dev/null
> +++ b/tests/fsck-tests/030-reflinked-prealloc-extents/test.sh
> @@ -0,0 +1,42 @@
> +#!/bin/bash
> +#
> +# Verify that a filesystem check operation (fsck) does not report the =
following
> +# scenario as an error:
> +#
> +# An extent is shared between two inodes, as a result of clone/reflink=
 operation,
> +# and for one of the inodes, lets call it inode A, the extent is refer=
enced
> +# through a file extent item as a prealloc extent, while for the other=
 inode,
> +# call it inode B, the extent is referenced through a regular file ext=
ent item,
> +# that is, it was written to. The goal of this test is to make sure a =
filesystem
> +# check operation will not report "odd csum items" errors for the prea=
lloc
> +# extent at inode A, because this scenario is valid since the extent w=
as written
> +# through inode B and therefore it is expected to have checksum items =
in the
> +# filesystem's checksum btree for that shared extent.
> +#
> +# Such scenario can be created with the following steps for example:
> +#
> +# mkfs.btrfs -f /dev/sdb
> +# mount /dev/sdb /mnt
> +#
> +# touch /mnt/foo
> +# xfs_io -c "falloc 0 256K" /mnt/foo
> +# sync
> +#
> +# xfs_io -c "pwrite -S 0xab -b 0 256K" /mnt/foo
> +# touch /mnt/bar
> +# xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
> +# xfs_io -c "fsync" /mnt/bar
> +#
> +# <power fail>
> +# mount /dev/sdb /mnt
> +# umount /mnt
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq btrfs
> +
> +check_image() {
> +	run_check "$TOP/btrfs" check "$1"
> +}
> +
> +check_all_images
>=20


--dlO1IANRhQ6LNQtspjEAAuBiVi20CmFxs--

--r4IuGxNy9yeXGmmu6LFcoj4xCAOZZM1PW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqoe+0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh9FwgAirC0kr9PaR2PwywZ+ge3pzVP
yDQISe7DYfFcNk27NBzrch4Ed73kcp2O1qN3CHTQau/ml4YQPs6TuS9DBrYFiaz9
vtgvZY1srEhDH3bz4QF3PtWjnWCuu++plyyyQLLmYh4XDnDdfUD5ZhLK8msRe7sH
6dJnQlr7QMZj4BrIpS9lo5UTH0eCvXroZ9PGd63fZmQx6X/GIa//aDLmqfRimpNT
TrGcULLzjMBx25qqFATVxrlHBQ4TwqGwxiXCmKNCOjyDAXfyJTOzm12aoNYOKTBX
Vloa6p++8MwtMKtSjk+FiMYrSx2Urtj+DE5qi84Myc34ZXY/p9Ar9Bykas93hw==
=iP3l
-----END PGP SIGNATURE-----

--r4IuGxNy9yeXGmmu6LFcoj4xCAOZZM1PW--
