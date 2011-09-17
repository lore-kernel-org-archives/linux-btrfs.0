From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Sat, 17 Sep 2011 20:30:21 +0200
Message-ID: <1316284222.3253.10.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <1316283907.3253.8.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-yvSQA1WXNU6iwMIHQ5Gm"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316283907.3253.8.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-yvSQA1WXNU6iwMIHQ5Gm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-09-17 at 20:25 +0200, Maciej Marcin Piechotka wrote:
> 1. Once the blank screen happened ot 23:00 UTC instead of 03:00 UTC
> 2. I tried to disable the caches
> 3. I tried to rsync via ext3 + btrfs-convert. I noticed something - in
> old fs the df looked like:
>=20
> Data: total=3D30.01GB, used=3D28.42GB
> System, DUP: total=3D8.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.00GB, used=3D199.47MB
> Metadata: total=3D8.00MB, used=3D0.00
>=20
> on new one (with ext3 image):
> Data: total=3D33.33GB, used=3D20.52GB
> System: total=3D32.00MB, used=3D4.00KB
> Metadata: total=3D16.64GB, used=3D11.36GB
>=20
> and without:
> Data: total=3D33.33GB, used=3D20.04GB
> System: total=3D32.00MB, used=3D4.00KB
> Metadata: total=3D16.64GB, used=3D10.88GB
>=20
> Given that lzo compression was used about 4 GB data difference was
> expected (difference depending on mount options on rsynbc). However:
>=20
> 1. What is DUP?
> 2. Why metadata is so big on convertion from ext3 while data is small
> (the sum is about right - 31GB vs 28.5GB)?
>=20

That should be a) b)

4. I think it triggered a bug with data loss - the new data was not
written to disk despite being visible from userspace after mount during
the same mount.

> Regards



--=-yvSQA1WXNU6iwMIHQ5Gm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOdOc9AAoJEJIdee2Vr4aPNwoP/2GXAGAnKWMxV6TYnxAQZI1t
enoImRaSdiB+w8/hIwOJOob7DPOnR7DapV9s4oIcqEqHI3vl+LTva92lghv1jdmI
hEeRoU9vGsOpQekP5S+sY5rhSUDEecXGD3XOkOm7lBqI3GwjyoZwPsb7ShUNsurM
cRQQjZC8YPs0Xs0C10teDwJPpZ2JmUrrqYwyKn/Kd4g+tkPR7xhmweuJvusaGM3w
iShCyabdBEdDSh2tr14alPNEJFiwwPaMsrxbtte6GVBM+6hPqDgAe2rxqUAmPk5f
AM+lhxn649o7nSeyRFiRzfMVF2Y0Gr4Lg5h7yjf2B8Z6atwhUWs09k1p6KdQJ0T2
ewkPH+3tP+C+plcgTuZfd+u29rY/dm+QzJycmzHozPnS1lgZT64oQNgJjhwkNeBO
datYkCiKq44Jb7CoUwvkTL6Vua03+uTOPAnnfBeYZfTIavfG4pu/vCt+oOf2RlwG
+4ScG21PENJfP2BNDrj1fa1gE4W87MMAGQG7NjaiabN3bhMmcg+jImoxiU40dWrL
wDDsEMyin49HxciQXkFrTPgBZqdCePX/kzcDUj9YKgH4L/KW0XKrFW6nzUFB6kWo
3hcVk3/10FFxuFYPAuuGlQkgvnmpZbiCjPSGSIveRHUver2nT8iBJ8dA3wUq7ooO
5IWNZ7XXFj2kyb5fwT4t
=FWll
-----END PGP SIGNATURE-----

--=-yvSQA1WXNU6iwMIHQ5Gm--


