Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37392 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbbDTK1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 06:27:07 -0400
Date: Mon, 20 Apr 2015 10:27:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?=22N=E9moz_Saint-Dizier=2C_Olivier=22?=
	<olivier@onsd.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount a btrfs file system kernel 3.19.2
Message-ID: <20150420102705.GF18187@carfax.org.uk>
References: <5534D201.7080803@onsd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGu/vTNewDGZ7tmp"
In-Reply-To: <5534D201.7080803@onsd.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MGu/vTNewDGZ7tmp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2015 at 12:16:33PM +0200, "N=E9moz Saint-Dizier, Olivier" w=
rote:
> Hello everyone,
>=20
> I have an issue with my ssd where a btrfs partition is located. I have a
> /dev/sdb1 in ext4 for the /boot, and the rest of the ssd is /dev/sdb2
> which is the root of my Archlinux. When I boot, it hangs up after
> loading the kernel. So I tried with an Archlinux liveboot, and I have
> the same behavior with the following trace in logs when I try to mount
> the btrfs partition :
>=20
> Apr 11 16:25:56 archiso kernel: INFO: task mount:573 blocked for more tha=
n 120 seconds.
> Apr 11 16:25:56 archiso kernel:       Not tainted 3.19.2-1-ARCH #1
[snip]
> btrfs-progs v3.19
>=20
> Linux archiso 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015 x=
86_64 GNU/Linux
>=20
> And the full output from journald is available there :
> http://sprunge.us/jPMG
>=20
> Is it a known bug? Or does someone have an idea about how I could fix
> this issue?

   See the first issue here: https://btrfs.wiki.kernel.org/index.php/Gotchas

   Hugo.

--=20
Hugo Mills             | Do not meddle in the affairs of system
hugo@... carfax.org.uk | administrators, for they are subtle, and quick to
http://carfax.org.uk/  | anger.
PGP: E2AB1DE4          |

--MGu/vTNewDGZ7tmp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVNNR5AAoJEFheFHXiqx3keTUQAKkDNKy2kqs4Ut6uqZpu3pAs
EiCePuc6exM4DVykL5pM/c6vUW52smlIfo9eYoY6Yzvam0InGHiB/otvLQjTo19j
ZdC4iRAOzw8mjLpBz3pd7ftKRfm8c7D5ffh/yt16fYijGiDGlyfbPCgXD3ZVCjrs
bidopauuP/CEAJrHzwCS6kmmWw3T9kNqenytEm/HW4PG22SpdMeQbQjSIed7p8dr
hX/H+gZ4vBHCA79VqK/XoWtQv+KkYtLE75R6GF1/c+3zNDchRCMmk6l50iF3FhY8
70Nx7aMUepLtfpTsD9X0eZvf2oV3m/IhdLzae/g2MrwSD3mrnq3jinTCHzorZmsG
YrpdGai8f+KEkue49lYqr/no6A76VfReo+XnqChRyrakALaE/JcNDRTBOWbrHVoZ
RNWlKOKhbxOIrzm05u6zeshfDMA/07BWWK1CNedlbLwJW3avaPC8FfwjJTBw+nTj
pHle1qm1q/hFYg9hgvtSYd5/KuBcd7WogQl3ODKar5HcNXWRar7s3otwE0hFEbyv
l0yl+3hqwHx/Q4zJ14JGVlAhTV6XuQucZu4IRkXyGjWPSxLsaVzRAhFnbGT6CgXF
fKyejQ0sRkjG6T3PDYb6YgveQWV38KkE8KE8xI2aOQ+/ljrCNPf+//240jyWAM/P
S7gurtzi59reG1m7zAZq
=Rzw9
-----END PGP SIGNATURE-----

--MGu/vTNewDGZ7tmp--
