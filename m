Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbeDNJmp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 05:42:45 -0400
Subject: Re: remounted ro during operation, unmountable since
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
Date: Sat, 14 Apr 2018 17:42:36 +0800
MIME-Version: 1.0
In-Reply-To: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W5RQM4xDdReGMpFwTjUXVSk8rFnjZ600v"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W5RQM4xDdReGMpFwTjUXVSk8rFnjZ600v
Content-Type: multipart/mixed; boundary="N9DX8QcpkSRtp4h2oqWSvP7xXYGy3N1hj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
Message-ID: <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
Subject: Re: remounted ro during operation, unmountable since
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
In-Reply-To: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>

--N9DX8QcpkSRtp4h2oqWSvP7xXYGy3N1hj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8814=E6=97=A5 15:31, Timo Nentwig wrote:
> Hi!
>=20
> btrfs remounted itself ro during operation (don't have the dmesg) and
> fails to mount after reboot.

The common mount option please, and if possible, the hardware model of
sda2 please.

And the work load when the RO happens is also helpful.
(Well, the dmesg of RO happens would be the best though)
>=20
> Any advice?
>=20
>=20
> 4.15.15-1-ARCH #1 SMP PREEMPT Sat Mar 31 23:59:25 UTC 2018 x86_64 GNU/L=
inux
> btrfs-progs v4.16
> Label: '830'=C2=A0 uuid: 22e778f7-2499-4379-99d2-cdd399d1cc6e
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 34.39GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 59.49GiB used 58.98GiB path /dev/sda2
>=20
> [=C2=A0 867.041397] BTRFS info (device sda2): disk space caching is ena=
bled
> [=C2=A0 867.185357] BTRFS info (device sda2): bdev /dev/sda2 errs: wr 0=
, rd
> 158, flush 0, corrupt 0, gen 0
> [=C2=A0 868.423427] BTRFS error (device sda2): parent transid verify fa=
iled
> on 166030671872 wanted 1702074 found 1705980

Another metadata corruption.

> [=C2=A0 868.425400] BTRFS error (device sda2): failed to read block gro=
ups: -5

Extent tree is corrupted.
If your objective is just to salvage data, at least this means your data
should be mostly safe (if there is no other metadata corruption).

>=20
> # sudo btrfs check /dev/sda2
> parent transid verify failed on 166030671872 wanted 1702074 found 17059=
80
> parent transid verify failed on 166030671872 wanted 1702074 found 17059=
80
> Ignoring transid failure
> leaf parent key incorrect 166030671872
> ERROR: cannot open file system

I could enhance btrfs check to continue checking, but it may need some
time to get rid of all btrfs_block_group_cache usage in that case.

> # sudo btrfs-debug-tree -b 166030671872 /dev/sda2

Btrfs works because when using -b option, (current) btrfs check will not
try to read block groups any more, so it can continue.

> btrfs-progs v4.16
> parent transid verify failed on 166030671872 wanted 1702074 found 17059=
80
> parent transid verify failed on 166030671872 wanted 1702074 found 17059=
80
> Ignoring transid failure
> leaf parent key incorrect 166030671872
> leaf 166030671872 items 60 free space 95 generation 1705980 owner TREE_=
LOG

This output is pretty interesting, and pretty helpful.

The tree block causing the problem belongs to TREE_LOG, while according
to kernel dmesg, it should belong to extent tree.

So that's showing tree log code is more or less related to this situation=
=2E

> leaf 166030671872 flags 0x1(WRITTEN) backref revision 1
> fs uuid 22e778f7-2499-4379-99d2-cdd399d1cc6e
> chunk uuid bee8ad15-e128-45f1-a3d7-e2fda17806ce
> =C2=A0=C2=A0=C2=A0 item 0 key (46475 DIR_ITEM 2335543231) itemoff 3955 =
itemsize 40
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 location key (1973554 INODE_ITEM =
0) type FILE
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 transid 1705438 data_len 0 name_l=
en 10
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 name: 002443.sst
>=20
>

If your primary objective is to salvage data, please apply these patches
upon v4.16.
https://patchwork.kernel.org/patch/10334955/
https://patchwork.kernel.org/patch/10334957/

And then try btrfs restore to salvage as much as data as possible.
For the best case (no other tree block corruption), it should salvage
all your data.

Despite above salvage method, please also considering provide the
following data, as your case is pretty special and may help us to catch
a long hidden bug.

1) Extent tree dump
   Need above 2 patches applied first.

   # btrfs inspect dump-tree -t extent /dev/sda2 &> \
     /tmp/extent_tree_dump
   If above dump is too large, "grep -C20 166030671872" of the output is
   also good enough.

   This would help us to inspect the backref of that tree to see if we
   could find anything wrong.

2) super block dump
   # btrfs inspect dump-super -f /dev/sda2

3) Extra hardware info about your sda
   Things like SMART and hardware model would also help here.

4) The mount option of /dev/sda2

Thanks,
Qu

> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--N9DX8QcpkSRtp4h2oqWSvP7xXYGy3N1hj--

--W5RQM4xDdReGMpFwTjUXVSk8rFnjZ600v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrRzQwACgkQwj2R86El
/qg7Pwf7B4jHNvrWxvi4kxm8JITnsEC97ZsIo83c0Qb7JQNy+lQRhPkc4nza7u9h
U8x+izowtBfggmhA7vqZhoUz1l9KBN1x0gnX22mJN7VvtmEyt+hQcBMKRqTr2p6d
JhVidrh21qnlWnviATBdLjKAPEVgTgAXoMzO2skjhYRwuhZQJ8mpz3BnI2XWrdOD
zICGsi0Hstqo7LS6QduFmIKdPoJam3Yq33ThgSKj7wtSi8rtA/XaymPBF2QMqI0E
Vxcpf9QUl3TW+cAizDLwRa977lS4+GIQCfrU6X10/xg+0AVAF0wJ+z0Oe2A2Kabu
nYcRewJOy1dRu26WgMohA3ZA3NRg9A==
=EgYu
-----END PGP SIGNATURE-----

--W5RQM4xDdReGMpFwTjUXVSk8rFnjZ600v--
