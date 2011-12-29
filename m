From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 10:37:36 +0600
Message-ID: <20111229103736.26a3a07d@natsu>
References: <201112281757.16019.Martin@lichtvoll.de>
 <4EFBE668.7030800@cn.fujitsu.com>
 <CAG1y0se+ctBx0YpsCGaW-8TKEN7PZix7PA8Eu-FzfVtkNPkkUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9sFV+Mz4cKMIxOIgl6J6mpZ"; protocol="application/pgp-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0se+ctBx0YpsCGaW-8TKEN7PZix7PA8Eu-FzfVtkNPkkUQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9sFV+Mz4cKMIxOIgl6J6mpZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Dec 2011 11:21:14 +0700
"Fajar A. Nugraha" <list@fajar.net> wrote:

> Slightly off-topic, how useful would trim be for btrfs when using
> newer SSD which have their own garbage collection and wear leveling
> (e.g. sandforce-based)?
>=20
> I'm trying fstrim and my disk is now pegged at write IOPS. Just
> wondering if maybe a "btrfs fi balance" would be more useful, since:
> - with trim, used space will remain used. Thus future writes will only
> utilized space marked as "free", making them wear faster
> - with "btrfs fi balance", btrfs will move the data around so (to some
> degree) the currently-unused space will be used, and  currently-used
> space will be unused, which will improve wear leveling.

Modern controllers (like the SandForce you mentioned) do their own wear lev=
eling 'under the hood', i.e. the same user-visible sectors DO NOT neccessar=
ily map to the same locations on the flash at all times; and introducing 'm=
anual' wear leveling by additional rewriting is not a good idea, it's just =
going to wear it out more.


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/9sFV+Mz4cKMIxOIgl6J6mpZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk777pAACgkQTLKSvz+PZwiJjACgiNHKQaa+DJJatXgfwiFjMycY
RpEAmwQHxlBV/YCgAzokPVZsCJ+xH6Tt
=+Olp
-----END PGP SIGNATURE-----

--Sig_/9sFV+Mz4cKMIxOIgl6J6mpZ--
