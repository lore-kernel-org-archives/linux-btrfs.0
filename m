Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from s17634251.onlinehome-server.info ([87.106.5.14]:54599 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751458AbdISLts (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:49:48 -0400
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Storage and snapshots as historical yearly
Date: Tue, 19 Sep 2017 13:49:40 +0200
Message-ID: <2457840.3HpkerP4PG@pcsenen>
In-Reply-To: <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com>
References: <9208764.SjP1vfhOIA@pcsenen>
 <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart13690649.5KosvGdWia";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart13690649.5KosvGdWia
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Perfect!! Just what I was looking for.
Sorry for the delay, because before doing so, I preferred to test to see if=
 it=20
actually worked.

I have a doubt. The system works perfectly, but at the time of deleting the=
=20
writing disk and merging the data on the read-only disk I fail to understan=
d=20
the process.

I have tried to remove the seed bit on disk A and delete the write B as you=
=20
mention, and so move the data to A, but tells me that disk B does not exist.
These are the orders I have made:

md127-> A
md126-> B

btrfstune -S 0 /dev /md127
mount /dev/md127 /mnt (I mount this disk since the md126 gives error)
btrfs device delete /dev/md126 /mnt
ERROR: error removing device '/dev/md126': No such file or directory

Another thing I've tried is to remove disk B without removing the seed bit,=
=20
but it gives me the error:

ERROR: error removing device '/dev/md126': unable to remove the only writea=
ble=20
device.

Any ideas about it?
Thank you very much for the reply.
Greetings.

El martes, 12 de septiembre de 2017 6:34:15 (CEST) Andrei Borzenkov escribi=
=C3=B3:
> 11.09.2017 21:17, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > I am trying to implement a system that stores the data in a unit (A) wi=
th
> > BTRFS format that is untouchable and that future files and folders crea=
ted
> > or modified are stored in another physical unit (B) with BTRFS format.
> > Each year the new files will be moved to store A and start over.
> >=20
> > The idea is that a duplicate of disk A can be made to keep it in a safe
> > place and that the files stored there can not be modified until the
> > mixture of (A) and (B) is made.
>=20
> This can probably be achieved using seed device. Mark original device as
> seed and all changes will go to another writable device, similar to
> overlay; then remove seed bit from original device, "btrfs device remove
> writable" device and it should relocate its content back. Rinse and repea=
t.

=2D-=20
	Sen=C3=A9n Vidal Blanco - SGISoft S.L.
=20
	Tlf.: 986413322 - 660923711
	GPG ID 466431A8AF01F99A
	http://www.sgisoft.com/
=2D-
=20

--nextPart13690649.5KosvGdWia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWcEEVAAKCRBGZDGorwH5
mrEgAKC9h0NN1UMeem+G38GqXaEx3AS6qwCeKmgZGkjKMNOK5FB4ChFrkz/WPww=
=Rbu4
-----END PGP SIGNATURE-----

--nextPart13690649.5KosvGdWia--

