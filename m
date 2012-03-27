From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 17:08:05 +0600
Message-ID: <20120327170805.3df5e98f@natsu>
References: <87haxawbtw.fsf@falma.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EL6/rULt.z14ttjyXDRXg7E"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Christoph Groth <cwg@falma.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87haxawbtw.fsf@falma.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/EL6/rULt.z14ttjyXDRXg7E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Mar 2012 12:57:31 +0200
Christoph Groth <cwg@falma.de> wrote:

> root@mim:/# find / -inum 453509 -ls
> 453509 1976 -rw-r--r--   1 root     root      2020832 Mar  7 21:11 /usr/l=
ib/libreoffice/basis3.4/program/libsblx.so
>=20
> That file seems to be ok, there are no errors when re-reading it.

How about

$ sudo apt-get install debsums
$ debsums libreoffice-core | grep libsblx.so

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/EL6/rULt.z14ttjyXDRXg7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9xn5UACgkQTLKSvz+PZwhC0wCdEuL8OZENtpiSWpj8KLgtAcBV
n3EAoIHrpPMdWdoOm2iZzEoG8eGO4+F/
=FYS7
-----END PGP SIGNATURE-----

--Sig_/EL6/rULt.z14ttjyXDRXg7E--
