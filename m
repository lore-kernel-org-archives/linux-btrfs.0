From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Wed, 9 May 2012 02:56:46 +0600
Message-ID: <20120509025646.2894f7ea@natsu>
References: <20120508200228.GM8938@carfax.org.uk>
	<C8TGo1T9CXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zENJFH=kR2DmBq_jXCnKa=s"; protocol="application/pgp-signature"
Cc: Hullen@t-online.de, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TGo1T9CXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/zENJFH=kR2DmBq_jXCnKa=s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 08 May 2012 22:19:00 +0200
Hullen@t-online.de (Helmut Hullen) wrote:

> What I still hope (may be it's impossible): when 1 disk/partition fails, =
=20
> then the contents of the other disks is "somehow" restorable. And not =20
> irreproducable.

You should look for file/directory-level tree merging, e.g. this FUSE based
virtual FS:=20

  https://romanrm.ru/en/mhddfs

Or various other unionfs'es, some of which are kernel-based.

Regarding btrfs, AFAIK even "btrfs -d single" suggested above works not "per
file", but per allocation extent, so in case of one disk failure you will l=
ose
random *parts* (extents) of random files, which in effect could mean no file
in your whole file system will remain undamaged.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/zENJFH=kR2DmBq_jXCnKa=s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+piI4ACgkQTLKSvz+PZwi9KwCbBE38hAKs5+4D4Us+nOPN2vus
PZkAn0iLutwgAI5yNviWaVFcpcRSAT82
=KfnH
-----END PGP SIGNATURE-----

--Sig_/zENJFH=kR2DmBq_jXCnKa=s--
