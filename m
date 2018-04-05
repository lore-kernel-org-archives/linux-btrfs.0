Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:46183 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbeDEM5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 08:57:55 -0400
Subject: Re: Couldn't read tree root BTRFS - SEED
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>,
        linux-btrfs@vger.kernel.org
References: <1816851.fIrENY6aja@pcsenen>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d73a19fb-5f4a-a690-b688-b2af3e410895@gmx.com>
Date: Thu, 5 Apr 2018 20:57:49 +0800
MIME-Version: 1.0
In-Reply-To: <1816851.fIrENY6aja@pcsenen>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n7pQazDrA2L8Eptbrx0hI7550MItBu3Qm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n7pQazDrA2L8Eptbrx0hI7550MItBu3Qm
Content-Type: multipart/mixed; boundary="49bGZIwrVxxEih4X8C4O561ZmCHW9c0zI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <d73a19fb-5f4a-a690-b688-b2af3e410895@gmx.com>
Subject: Re: Couldn't read tree root BTRFS - SEED
References: <1816851.fIrENY6aja@pcsenen>
In-Reply-To: <1816851.fIrENY6aja@pcsenen>

--49bGZIwrVxxEih4X8C4O561ZmCHW9c0zI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8805=E6=97=A5 19:27, Sen=C3=A9n Vidal Blanco wro=
te:
> Hello,
> I have a problem when mounting the btrfs system with two units (one in =
SEED=20
> mode and the other in read-write mode)
> =20
> Initially it is functioning correctly in production:
> =20
> btrfs fi sh=20
> Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6=20
>        Total devices 2 FS bytes used 2.00TiB=20
>        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1=20
>        devid    2 size 1.80TiB used 119.03GiB path /dev/bcache0=20
> =20
> Label: 'BOOT'  uuid: ce8fd2ef-975c-417a-b90c-280f8d324c44=20
>        Total devices 1 FS bytes used 536.86MiB=20
>        devid    1 size 1.86GiB used 1.15GiB path /dev/md1=20
> =20
> Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877=20
>        Total devices 1 FS bytes used 1.94TiB=20
>        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1
> =20
> The bcache0 and bcache1 units are what I mention.
> bcache1 is the SEED
> bcache0 is the read-write
> =20
> When it comes to mounting the two copy mirror devices that is in produc=
tion I=20
> have this result:
> =20
> parent transid verify failed on 2184045428736 wanted 269593 found 26627=
5=20
> parent transid verify failed on 2184045428736 wanted 269593 found 26627=
5

It's not the problem that btrfs fails to assemble correct seed/rw
devices list, it's something wrong (metadata corruption) happened.



> Ignoring transid failure

So this is btrfs-progs (btrfs check). Kernel doesn't ignore any transid
failure AFAIK.

> Couldn't map the block 2287467560960=20
> No mapping for 2287467560960-2287467577344=20
> Couldn't map the block 2287467560960=20
> bytenr mismatch, want=3D2287467560960, have=3D0=20
> Couldn't read tree root=20
> Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877=20
>        Total devices 1 FS bytes used 1.94TiB=20
>        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1=20
> =20
> Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6=20
>        Total devices 2 FS bytes used 1.98TiB=20
>        devid    2 size 1.80TiB used 102.03GiB path /dev/bcache2=20
>        *** Some devices missing
> =20
> Would there be any way to tell BTRFS that the missing unit is the one t=
hat=20
> corresponds to the SEED unit so that it correctly rebuilds the file sys=
tem?

The rw device is corrupted.

To ensure your seed device is safe, please run "btrfs check <SEED
device>" to see if there is any problem.

=46rom current output, it seems that your chunk tree is corrupted, so tha=
t
btrfs check can't even map the logical address for your tree root.

And to further debug the corrupted fs, please attach the following data:

1) btrfs inspect dump-super -fa <seed>
2) btrfs inspect dump-tree -t chunk <seed>

Thanks,
Qu

>=20
> Thank you.
>=20


--49bGZIwrVxxEih4X8C4O561ZmCHW9c0zI--

--n7pQazDrA2L8Eptbrx0hI7550MItBu3Qm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrGHU0ACgkQwj2R86El
/qghCQf+Ps6blfdkcuz1Ot7yhcLq++PBJny7jS/JYSBoY9hxqLZVuxhjBJKf9zBO
Pea+gQozqnyZ4MfGTx3HzFj05qa3mqPiIOH5rDe5f+oTAD7X3pkttd4gM7sOLt4E
0U7bKLhiPsv2gier22VpxWBHj1SYYsh6LhbkeTTO1vqtwWdHx/pw9rAO7m67rShf
/OzFBmY+JW56Is+k532AeCa+q38ArnY9Uss/ortk+4o+mVq/CaJJdwOULaAQQ8Mq
d/n1oAFSMv9Hc0O3dD++B2xXZBizGD6SUZ/XNw/s2/1umzhQ/q2AidK3JABGX1Bj
jx+1Jog6lFAGnDdlJWEw5P5LOOyUGQ==
=PfGo
-----END PGP SIGNATURE-----

--n7pQazDrA2L8Eptbrx0hI7550MItBu3Qm--
