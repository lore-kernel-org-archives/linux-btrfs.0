From: kehon <coolkehon@gmail.com>
Subject: Re: Compression: per filesystem, or per subvolume?
Date: Sun, 8 May 2011 09:59:30 -0400
Message-ID: <20110508135930.GA30862@gshadow>
References: <BANLkTimwMnmS4jw=uwimm8b18662jO-Myw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimwMnmS4jw=uwimm8b18662jO-Myw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

At the moment btrfs doesn't support separate compression for volumes on
the same filesystem.

On 05/08/11 at 08:35pm, Fajar A. Nugraha wrote:
> Currently using Ubuntu Natty, kernel 2.6.38-9-generic, I have these
> mount points using btrs subvolumes
>=20
> $ mount -t btrfs
> /dev/sda2 on / type btrfs (rw,noatime,subvolid=3D256,compress-force=3Dzli=
b)
> /dev/sda2 on /home type btrfs (rw,noatime,subvolid=3D258,compress=3Dlzo)
>=20
> Yet dmesg seems to show only zlib compression enabled
> $ dmesg | grep btrfs
> [   11.097908] btrfs: force zlib compression
>=20
> Is this by design, or a bug?
>=20
> --=20
> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJNxqHBAAoJEFWnpyuyLRXaanYP/Au8Dv95D6YAvVvK79/SPPwH
IiT1OkMTsexq2ry3VcygIVGYQQYaO4yfJ2aMD0xKOs6klJHgmQ5D6c/RY6nnQHDF
nP8CJImXyxErHHgd8KU4X8kmBiKslHWi7kCMWu1CwyrN1aLhVsqJitoOzcM4WPZc
yVYU0E4IoZyADUmQ1PAPORHE8R/HnwIWaRmnQMcuDSgV/z6KPMCJPTV4IVMrGGKL
WVCraijFkzvTWGMZQpuTUskIOF+w4tfQ4UzTZNy0wORAR0VeVa7jh2AvnfEDQBwS
rHB9dZA4rGyP5n0nsX/c8EcHGXYCai0kvpYw41Sr6ccGYkk6J0kvTgB5eqW1r2Zm
hCVo6oGoVq+LG3MDE0Ym9lwKop25ho6qbp7OnmbN3QwjPGahHpYg4LtT1KWiMjaB
S3+qTAobjs0RR5Ghe/5AKOwfTsK8361AVdfdHIomz/ivV/Fv+pYWLVGGCYUg4qoR
dhIERS/bj0JSbkXYlpuQn8XMqlOfs0Ab3YoT7A0kFKdkKXAc2nAr7UJRSrZx7UIC
U0AsgvGNu44+fboV6M8Je/MKyVllhwvQyqwKS/paEhjogGbypzMuTpL3ID4+9Ybs
8odXzbV0gofbwePQkmikph5V/ZjI1+N+WNNuNjm2tEb6GKXpysv86ZFFsH3aG6eN
0SOj4cJvHpa5kyrBQtRW
=2U9w
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
