From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Cross-subvolume link causes kernel BUG
Date: Mon, 8 Mar 2010 12:26:56 -0600
Message-ID: <20100308182656.GA7102@untroubled.org>
References: <20100308172438.GA5506@untroubled.org>
 <m3hboqsof9.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hboqsof9.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 08, 2010 at 12:39:38PM -0500, Chris Ball wrote:
> I think this is fixed in 2.6.33, as a result of the patch below.
> Let us know if you see a segfault on 2.6.33, or after applying this
> patch to your current kernel.

This patch does fix the problem for 2.6.32.9, thanks.  Has this patch
been submitted for the 2.6.32.y series?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuVQXAACgkQ6W+y3GmZgOhxjwCdHr0i/xfU1IIiYOX4LccP6jPn
Gx4AoKhQ7rSx5oYGP4kwGyVB19cwb908
=Mswe
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
