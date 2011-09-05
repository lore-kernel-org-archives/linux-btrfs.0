From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 22:25:23 +0300
Message-ID: <20110905222523.4531abe0@sf.home>
References: <4E64D3D5.7020407@petaramesh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.nLyE1A5k3chceS87LJ4Cmq"; protocol="application/pgp-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64D3D5.7020407@petaramesh.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.nLyE1A5k3chceS87LJ4Cmq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Sep 2011 15:51:17 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Hi list,
>=20
> I don't trust theoretical benchmarks that much and prefer "real-life=20
> benchs" on the occasion, so here's mine:
>=20
> Given 4 laptops, the most powerful of which was running BTRFS and the=20
> others ext3 or ext4, all machines running Ubuntu 11.04 Natty 32-bit with=
=20
> a stock Ubuntu 2.6.38-11 kernel, all machines were given the following=20
> FS-intensive task :
>=20
> - Upgrade O.S. from Ubuntu 11.04 Natty to 11.10 Oneiric (beta), using a=20
> local packages apt-cacher.
>=20
> Machines :
>=20
> 1/ Acer Aspire 3104 WLMi, AMD Sempron Mobile 3500+ @1.8 GHz, 1.5 GB RAM,=
=20
> 80 GB SATA HD, ext4 over standard partitions
>=20
> 2/ Asus EeePC 1005PE, Intel Atom N450 @1.66 GHz, 2 GB RAM, 250 GB SATA=20
> HD, ext3 over AES-128 encrypted LVM
>=20
> 3/ Compaq Mini CQ10-740SF, Intel Atom N455 @1.66 GHz, 1 GB RAM, 250 GB=20
> SATA HD, ext4 over standard partitions
>=20
> 4/ Dell XPS M1330, Intel Core 2 Duo T9300 @2.5 GHz, 2 GB RAM, 160 B SATA=
=20
> HD, BTRFS over AES-128 encrypted LVM
>=20
> Results :
>=20
> All 3 ext3 /  ext4 machines took between 60 and 90 minutes to complete=20
> their upgrade.
>=20
> BTRFS machine took 20 HOURS so far, still counting (ETA 15 minutes left).
>=20
> Wow. Impressive.

I've seen similar problem on Ubuntu-11 + Aspire One (8GB of slow "SSD").
More specifically half of ubuntu install went very fast and when
disk was ~50% free things _suddenly_ gone slow.

According to strace fsync() started to take ~10 seconds(!) and upper.
It's not common filesystem behaviour, but a plain (and hard to catch?) bug.

I don't have the box anymore. The root cause it to be found by some
brave soul yet.

I wonder if latencytop would get the profile of the issue.

Maybe, btrfs degrades only after certain (insanely large?) amount of fsync()
calls?

--=20

  Sergei

--Sig_/.nLyE1A5k3chceS87LJ4Cmq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5lIigACgkQcaHudmEf86oXuwCeLRXbXyNamINqcYTDDlLqjqSY
EpgAn1tk6mGiGuzeR5+9hnZm0mDGY2bg
=Z9vu
-----END PGP SIGNATURE-----

--Sig_/.nLyE1A5k3chceS87LJ4Cmq--
