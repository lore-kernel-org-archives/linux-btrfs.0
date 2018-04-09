Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sgisoft.es ([87.106.190.187]:56521 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752501AbeDIJnC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 05:43:02 -0400
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Couldn't read tree root BTRFS - SEED
Date: Mon, 09 Apr 2018 11:42:52 +0200
Message-ID: <13247447.VRkfYOQAb7@pcsenen>
In-Reply-To: <d73a19fb-5f4a-a690-b688-b2af3e410895@gmx.com>
References: <1816851.fIrENY6aja@pcsenen>
 <d73a19fb-5f4a-a690-b688-b2af3e410895@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3072750.QPi9Beqptd";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3072750.QPi9Beqptd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hello Qu,
Thank you very much for the answer. I am sorry to answer late because befor=
e=20
bothering more, I decided to perform another cloning test.
In this time he has joined the second device correctly.
The problem has occurred because they are BCACHE devices, and although the=
=20
SEED disk does not vary over time, buy the read-write yes, with which I hav=
e=20
made sure this time empty the cache before performing the cloning.

Now, when inserting the discs I have managed to mount everything correctly:
Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6
        Total devices 2 FS bytes used 2.00TiB
        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache2
        devid    2 size 1.80TiB used 122.03GiB path /dev/bcache1

The truth is that the BTRFS-BCACHE-MDADM combination is complex, but the=20
results are really satisfactory and enormous versatility is achieved.

To thank the BTRFS team and other responsible people for doing a great job.


El jueves, 5 de abril de 2018 20:57:49 (CEST) Qu Wenruo escribi=C3=B3:
> On 2018=E5=B9=B404=E6=9C=8805=E6=97=A5 19:27, Sen=C3=A9n Vidal Blanco wro=
te:
> > Hello,
> > I have a problem when mounting the btrfs system with two units (one in
> > SEED
> > mode and the other in read-write mode)
> >=20
> > Initially it is functioning correctly in production:
> >=20
> > btrfs fi sh
> > Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6
> >=20
> >        Total devices 2 FS bytes used 2.00TiB
> >        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1
> >        devid    2 size 1.80TiB used 119.03GiB path /dev/bcache0
> >=20
> > Label: 'BOOT'  uuid: ce8fd2ef-975c-417a-b90c-280f8d324c44
> >=20
> >        Total devices 1 FS bytes used 536.86MiB
> >        devid    1 size 1.86GiB used 1.15GiB path /dev/md1
> >=20
> > Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877
> >=20
> >        Total devices 1 FS bytes used 1.94TiB
> >        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1
> >=20
> > The bcache0 and bcache1 units are what I mention.
> > bcache1 is the SEED
> > bcache0 is the read-write
> >=20
> > When it comes to mounting the two copy mirror devices that is in
> > production I have this result:
> >=20
> > parent transid verify failed on 2184045428736 wanted 269593 found 266275
> > parent transid verify failed on 2184045428736 wanted 269593 found 266275
>=20
> It's not the problem that btrfs fails to assemble correct seed/rw
> devices list, it's something wrong (metadata corruption) happened.
>=20
> > Ignoring transid failure
>=20
> So this is btrfs-progs (btrfs check). Kernel doesn't ignore any transid
> failure AFAIK.
>=20
> > Couldn't map the block 2287467560960
> > No mapping for 2287467560960-2287467577344
> > Couldn't map the block 2287467560960
> > bytenr mismatch, want=3D2287467560960, have=3D0
> > Couldn't read tree root
> > Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877
> >=20
> >        Total devices 1 FS bytes used 1.94TiB
> >        devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1
> >=20
> > Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6
> >=20
> >        Total devices 2 FS bytes used 1.98TiB
> >        devid    2 size 1.80TiB used 102.03GiB path /dev/bcache2
> >        *** Some devices missing
> >=20
> > Would there be any way to tell BTRFS that the missing unit is the one t=
hat
> > corresponds to the SEED unit so that it correctly rebuilds the file
> > system?
>=20
> The rw device is corrupted.
>=20
> To ensure your seed device is safe, please run "btrfs check <SEED
> device>" to see if there is any problem.
>=20
> From current output, it seems that your chunk tree is corrupted, so that
> btrfs check can't even map the logical address for your tree root.
>=20
> And to further debug the corrupted fs, please attach the following data:
>=20
> 1) btrfs inspect dump-super -fa <seed>
> 2) btrfs inspect dump-tree -t chunk <seed>
>=20
> Thanks,
> Qu
>=20
> > Thank you.

=2D-=20
	Sen=C3=A9n Vidal Blanco - SGISoft S.L.
=20
	Tlf.: 986413322 - 660923711
	GPG ID 466431A8AF01F99A
	http://www.sgisoft.com/
=2D-
=20

--nextPart3072750.QPi9Beqptd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWss1nAAKCRBGZDGorwH5
mlqFAJ4iaW/OnMKq1O6yLO8nlVbG8p2ZVgCeIjmkXn2kF6xzBuXVSfuPz4nziDc=
=vp+8
-----END PGP SIGNATURE-----

--nextPart3072750.QPi9Beqptd--

