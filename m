From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Resize command syntax wrong?
Date: Thu, 1 Dec 2011 02:07:30 +0600
Message-ID: <20111201020730.33980a5e@natsu>
References: <20111201011547.66633b20@natsu>
	<ByrP+cZy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x/IHmaLjYQxEwmEaSJjMrB="; protocol="application/pgp-signature"
Cc: Hullen@t-online.de, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ByrP+cZy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/x/IHmaLjYQxEwmEaSJjMrB=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 30 Nov 2011 20:43:00 +0100
"Helmut Hullen" <Hullen@t-online.de> wrote:

> Hallo, Roman,
>=20
> Du meintest am 01.12.11:
>=20
> > What if I need to replace an individual device with a smaller or a
> > larger one?
>=20
> 1) add the new device
> 2) balance (may be it's not necessary)
> 3) run "remove" for the "individual" device
> 4) remove it
> 5) balance

Okay, adding a new device wasn't the best example to explain my point.

What I meant is resizing a BTRFS partition, enlarging it or shrinking it as=
 needed, while still on the same device.

Of course in the enlarge scenario the partition(or the LV) is resized upwar=
ds first, and then the filesystem, and on shrinking it's vice versa. Suppos=
e I used half of a 1000GB disk for BTRFS (a 500GB partition), and the secon=
d half for something else. Now I want to remove this other partition, and m=
ake BTRFS occupy the whole disk.

Resizing in both 'directions' seems to work very well on single-device BTRF=
S filesystems, and also it's very useful that BTRFS is almost the only mode=
rn FS (besides ext4) that can be shrinked. But with multi-device filesystem=
s, don't you agree it's non-obvious how (or is not even possible) to resize=
 the areas that BTRFS occupies on individual devices?

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/x/IHmaLjYQxEwmEaSJjMrB=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7WjQIACgkQTLKSvz+PZwhyngCdGXTLxIIIlhTLt0P0K4HlF+EM
f6EAn3ELRjJZwIByZnqBxtZQRigFr3Ii
=cBtI
-----END PGP SIGNATURE-----

--Sig_/x/IHmaLjYQxEwmEaSJjMrB=--
