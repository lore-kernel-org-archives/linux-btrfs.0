Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57983 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0OEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 09:04:14 -0500
Date: Mon, 27 Jan 2014 14:03:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: KC <impactoria@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Snapshots =?utf-8?B?4oCTIG5vbw==?= =?utf-8?Q?b?= questions
Message-ID: <20140127140350.GL3314@carfax.org.uk>
References: <52E664E0.5070909@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EMQjp+MvU6EBGjHc"
In-Reply-To: <52E664E0.5070909@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EMQjp+MvU6EBGjHc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 02:53:36PM +0100, KC wrote:
> I have been trying to understand how snapshots work (in BRTFS and in
> general), but I still have some questions, and would appreciate if
> someone could clear them for me.
> To make things easier, I tried to make most of them Yes/No questions:
>=20
> 1. When creating the filesystem, I only made btrfs partition with no
> subvolumes. Do I have to use subvolumes, or can I snapshot entire
> =E2=80=9C/=E2=80=9C?

   / (the top level of the FS) is a subvolume as well -- it's the only
one that can't be renamed or deleted, though.

> 2. Can I take a snapshot of a working / root filesystem?

   Yes.

> 3. If I make a snapshot of / and there are some separate partitions
> mounted under /mnt/ or /home/, will snapshot skip them?

   Yes. Snapshots work on a single subvolume at a time.

> 4. If I have a snapshot of  /, can I completely erase this partition
> and later restore it in full form that snapshot,

   If you have your root filesystem as the top level of the btrfs
filesystem, then no, you can't. I would recommend using the filesystem
structure shown here

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_snapshots

because it makes making, managing and rolling back the snapshots much
easier.

> or do snapshots
> work only if a limited number of files has been changed?

   Snapshots will continue to work regardless of how many files have
been changed. The only thing to note is that as you make more
modifications (either to the snapshot or the original, or both), the
amount of storage requires goes up. Note that once you've made a
snapshot, there's no distinction between the snapshot and the original
-- they're completely equal partners. This means that you can delete
either one and the other one will remain.

> If the former, then does it mean that snapshot size will be
> comparable to the original data size?

   When you first make a snapshot, the total storage space required is
unchanged(*). As you make modifications, the two subvolumes will
diverge from each other, and more and more space is needed.
Eventually, when you've modified every file (on one side or the
other), you will end up needing enough space to store each one
separately. Basically, they share as many data extents as possible,
and use separate ones only when needed.

(*) OK, that's a lie -- you need an extra tree root for the snapshot,
but that's a whole 4k-16k, depending on the size of your tree nodes.

> 5. Can a snapshot be stored on a different partition? And if so,
> does that partition have to be BTRFS too? I ask, because I would
> also want to store snapshots in a cloud storage.

   No, they can't.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- For months now, we have been making triumphant retreats ---    =20
               before a demoralised enemy who is advancing              =20
                           in utter disorder.                           =20

--EMQjp+MvU6EBGjHc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUuZnRlheFHXiqx3kAQJ1ARAAteq5Rezkjwk+PTJs9uOv3Ko8wMIE+Bkr
ohGFqpZi0mbokOgMGfKIp3OheXfUtVH/VmzRq+OXXwB4LlIiNMPtik/YqknQ0f+B
aeyUk1EusF3wj7wJLu8PAFB78jnMl07YBG9Vqg4J0znUPcZqn+tGsjOubtsAqWoj
P9Xm64ZXzOU+Sj1NByMV4WDg79/L3ugLAl0yNWzAQ/0ugHtu/hATgkPboQCXpH0e
Kf4jmHb0W1dwzivYEt/FAvaAtiYUoLIL2LAaK1tOi6s9vW+KUHP4OinmR5r3gmiu
nmlcp5aWqH9eyIPkX82dBU8B/FHec9e4EuBzcBbtqRT9Isw/UVzlG1T3Gn3H2/5p
MdPsJNPz99MG5lNGZ8hHCkjMNKdpJ7FUd/eUOvfP7LBHua2A/ULl3rfIKlp/kLeM
3qowgSn5YwYuCvHBKdMq/bXrY2sNcGBXyxv1Xd86X2go0haMovVWiwfvxk1We/u3
t+4RbEQJU4M93EJhkk1rRxoVQGYx/AA7O0PYHidpeeLUVR4rfguxhF6DEqFxMuc2
2CDHNXGO9onxEeSpoOytv5AstcwFbKF7dQ0vH3c57ZoqRm9hG5EPUzWAvF+v4s+n
4+z82b5nm42S0HeA83zRKIyEIcuRfU3yVTBQcl1E28nlU+RtCBHUKfQWSYm2iYmo
rDEZm21QPNI=
=YGqd
-----END PGP SIGNATURE-----

--EMQjp+MvU6EBGjHc--
