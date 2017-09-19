Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:51604 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdISSdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 14:33:38 -0400
Received: by mail-lf0-f53.google.com with SMTP id y187so480273lfc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:33:38 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>
Cc: linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com> <2457840.3HpkerP4PG@pcsenen>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
Date: Tue, 19 Sep 2017 21:33:31 +0300
MIME-Version: 1.0
In-Reply-To: <2457840.3HpkerP4PG@pcsenen>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bJeS7QQjGulLDRSTEp7XNbbckngljtdGL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bJeS7QQjGulLDRSTEp7XNbbckngljtdGL
Content-Type: multipart/mixed; boundary="TJQONKMjAToGIdOxbRAPsqgeBfGa4Jixk";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
Subject: Re: Storage and snapshots as historical yearly
References: <9208764.SjP1vfhOIA@pcsenen>
 <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com> <2457840.3HpkerP4PG@pcsenen>
In-Reply-To: <2457840.3HpkerP4PG@pcsenen>

--TJQONKMjAToGIdOxbRAPsqgeBfGa4Jixk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

19.09.2017 14:49, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=82:=

> Perfect!! Just what I was looking for.
> Sorry for the delay, because before doing so, I preferred to test to se=
e if it=20
> actually worked.
>=20
> I have a doubt. The system works perfectly, but at the time of deleting=
 the=20
> writing disk and merging the data on the read-only disk I fail to under=
stand=20
> the process.
>=20
> I have tried to remove the seed bit on disk A and delete the write B as=
 you=20
> mention, and so move the data to A, but tells me that disk B does not e=
xist.
> These are the orders I have made:
>=20
> md127-> A
> md126-> B
>=20
> btrfstune -S 0 /dev /md127
> mount /dev/md127 /mnt (I mount this disk since the md126 gives error)
> btrfs device delete /dev/md126 /mnt
> ERROR: error removing device '/dev/md126': No such file or directory
>=20
> Another thing I've tried is to remove disk B without removing the seed =
bit,=20
> but it gives me the error:
>=20
> ERROR: error removing device '/dev/md126': unable to remove the only wr=
iteable=20
> device.
>=20
> Any ideas about it?

Yes, sorry about it. Clearing seed flag on device invalidates
filesystem. What you can do, is to rotate devices. I.e. remove
/dev/md126, set seed flag on md127 and add md126 back.

I actually tested it and it works for me.

> Thank you very much for the reply.
> Greetings.
>=20
> El martes, 12 de septiembre de 2017 6:34:15 (CEST) Andrei Borzenkov esc=
ribi=C3=B3:
>> 11.09.2017 21:17, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
>>> I am trying to implement a system that stores the data in a unit (A) =
with
>>> BTRFS format that is untouchable and that future files and folders cr=
eated
>>> or modified are stored in another physical unit (B) with BTRFS format=
=2E
>>> Each year the new files will be moved to store A and start over.
>>>
>>> The idea is that a duplicate of disk A can be made to keep it in a sa=
fe
>>> place and that the files stored there can not be modified until the
>>> mixture of (A) and (B) is made.
>>
>> This can probably be achieved using seed device. Mark original device =
as
>> seed and all changes will go to another writable device, similar to
>> overlay; then remove seed bit from original device, "btrfs device remo=
ve
>> writable" device and it should relocate its content back. Rinse and re=
peat.
>=20



--TJQONKMjAToGIdOxbRAPsqgeBfGa4Jixk--

--bJeS7QQjGulLDRSTEp7XNbbckngljtdGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnBYv4ACgkQR6LMutpd94w1mwCeKZ3bByet6p+rWm0tvfzTZGJA
k88AoLLze4GhP0QpJCK5KIZ2cLfhrei/
=7b7e
-----END PGP SIGNATURE-----

--bJeS7QQjGulLDRSTEp7XNbbckngljtdGL--
