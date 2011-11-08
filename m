From: Sami Liedes <sami.liedes@aalto.fi>
Subject: Re: Number of hard links limit
Date: Tue, 8 Nov 2011 23:23:43 +0200
Message-ID: <20111108212342.GE28900@sli.dy.fi>
References: <20100802114046.GA29926@lh.kyla.fi>
 <20100806113039.GA18858@lh.kyla.fi>
 <20100806134607.GB19942@think>
 <201110121934.07105.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
To: linux-btrfs@vger.kernel.org,
	Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201110121934.07105.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2011 at 07:34:06PM +0200, Martin Steigerwald wrote:
> What is the status of fixing the limits of hardlinks in BTRFS?
>=20
> It is now easy to hit on Debian systems that have git package installed:

I too wonder if there still is an intention to fix this... I'd expect
to see much more breakage like this once some distribution adopts
btrfs as the default filesystem. If this is not going to be fixed in
btrfs, perhaps we should start considering it a possible bug in
programs that trigger it (that's apparently the way it was fixed in
Debian for git)?

	Sami

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOuZ3eAAoJEKLT589SE0a0RoEP/j3F0WwDnN3ChhOW89Ga9/lx
oG47hinB2Q2sZZjhxqrsQPUgZ/MM6hPNECfaJ0Izjxz5DbiY2DgOUuWOv28CiNGf
qWE91pevUrkQk0KdQgzs95Sp4M3XCFoEjXKtg3DxSujUaostWaczbXSkhnCFz+lS
Koggk7qkafywG8S/kkVEaOOJlTLf8W2qasNhXySNfT0vHIujEJqO676wGtrqmy05
ZLW1TfoS3BJdFYVo9NtbQkVSDxqAoKNgk+UtpCfWr1on2gnanIBNwlBq9+zjvtxo
tKyW13mNOSUQS256FK9LgQPBD4NLx4U1knrxtQpuFio/C/Sq3RxC99JGWZyLSzvV
Kq8NPmrWLC8r9zu6Q7gwhn7QF05+xjv2RnPBC1HqrYI6YWYNANW00m76AkOaWEF6
N1SiqLDcK0D6nMOiz+VmVPUyIgQLvQqIReAan9pV2Zn9If179aycutlwN9UdJUpP
sWctqLn75iqav0s1oWyM434leokS5OF5a7uoY6QlGtUYlwKZgOC2lAM4DNDUbI8f
NfpGUPAExwZkHsHf+BAMOX5NxderjjHLXOXpf9OwjqfPgigjdsqBUhfnFs3NPDJ/
DpLzm6223x0F5fEhBkWIRZX/3u03Khd1qI0am/BddOZIJZYqGGd/UrJKB5oJ/mTi
fw3ED9+laDFtZb8UCqHn
=tgfv
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
