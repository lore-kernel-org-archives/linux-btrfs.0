From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Fwd: btrfs-tools backport for Debian Lenny
Date: Wed, 17 Feb 2010 19:12:19 +0100
Message-ID: <201002171912.25830.Martin@lichtvoll.de>
References: <201002171632.38310.ms@teamix.de> <f058a9c31002170921p37f00b83m1e9c9b91bacb54a8@mail.gmail.com> <f058a9c31002170922y2566427dpd5006c1c0298a444@mail.gmail.com> (sfid-20100217_185820_475893_1AEA3C19)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2168170.SF8O3kEGH4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>,
	Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c31002170922y2566427dpd5006c1c0298a444@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2168170.SF8O3kEGH4
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 17 Februar 2010 schrieben Sie:
> On Wed, Feb 17, 2010 at 3:32 PM, Martin Steigerwald <ms@teamix.de>=20
wrote:

Leaving Cc to backports-users mailinglist and Debian package maintainer=20
dropped as its a technical BTRFS discussion.

> > Hi!
[...]
> > It basically works, but I am wondering it the RAID options work
> > correctly. I used:
> >
> > mkfs.btrfs -d raid1 -m
> > raid1 /dev/mango1/homelokal1 /dev/mango2/homelokal2
> >
> > on two 200 GiB logical volumes and get
> >
> > mango:~# df -hT /mnt/zeit
> > Dateisystem   Typ    Gr=C3=B6=C3=9Fe Benut  Verf Ben% Eingeh=C3=A4ngt a=
uf
> > /dev/mapper/mango1-homelokal1
> >             btrfs    400G  101M  400G   1% /mnt/zeit
> >
> > Shouldn't that be 200GiB for a BTRFS Raid 1 setup?
>=20
> this has been discussed several times on the list.

Sorry, I admit I follow BTRFS irregularily and main point in my mail was=20
to announce the backport.

> Since btrfs file level redundancy policy, the proper way for it to
> behave is to show full physical capacity of the devices.
> Usage will be correctly accounted, so if you write a 100MB file in
> that raid1 FS tree
> the used space will indicate 200MB of additional used space.

Hmmm, that still doesn't match, cause I wrote a 100MiB file to the=20
partition:

mango:~# dd if=3D/dev/zero of=3D/mnt/zeit/ddimg bs=3D1M count=3D100
100+0 Datens=C3=A4tze ein
100+0 Datens=C3=A4tze aus
104857600 Bytes (105 MB) kopiert, 0,313594 s, 334 MB/s

Thus I should have get 200MiB used in df -h. Hmmm, maybe accurate size=20
reporting needs a newer BTRFS than in 2.6.32.3?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2168170.SF8O3kEGH4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkt8MYQACgkQmRvqrKWZhMfDLACgkJYGPxv3l/LOttRPznMHkJhX
LmcAn0+87H4SKE7yRNov+EWwng/0wxL1
=M/q8
-----END PGP SIGNATURE-----

--nextPart2168170.SF8O3kEGH4--
