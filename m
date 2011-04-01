From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: On masking access to snapshots thru single path
Date: Fri, 1 Apr 2011 19:33:30 +0100
Message-ID: <B45B2DB3-9BC9-4BBE-A84D-B84784647A91@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-2--894419916"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-2--894419916
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

Hello all,

I've been trying to use btrfs with a very specific purpose during my MSc =
thesis, and now I would very much appreciate any comments you may have =
on a given issue.

Currently I'm trying to mask accesses to different snapshots by =
different processes, while still using the same FS entry point. In a =
nutshell, a process trying to access /btrfs.mnt/S, instead of actually =
operating on 'S', will operate on /btrfs.mnt/Sx, with 'x' being the =
process' pid.

I've already accomplished this, simply by implementing a btrfs-specific =
'd_hash' on 'btrfs_dentry_operations', which will basically change the =
path accordingly to the implementation requirements and generate a new =
hash, thus avoiding dcache conflicts. However, given my yet-recent =
experience with btrfs, I can only wonder if any of you find any problems =
with such approach that I might have missed.

I would honestly appreciate any input.

Cheers,
Joao

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-2--894419916
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJNlhqAAAoJEJ9vvxhHfCbluHgH/2VV8m1M9G44hZE1R7k3R0Zp
xgA7gtv685c7ja5qjkJbogmGMFEzpVf2zVeBjBDMfu5Prw2N0le86shFB9hGrC8d
hjNtLrj1ZiHVJZCEN16bCfnqvoM/d7EMuGuUl1CqUVGWY7GMwzHZzfu010QVw/kp
hFlNfuMqmFY55636lZJxJDVvhtfhT5aADH6TFje7iEysCNrHcaasRJkRyvo031Ib
pNotsYqPcuuaZlUm2xhPDUQTPWW+vqfo8aP0+cq4cfGSKj69AtLmh7htokEipmPs
P/NIgg38tkl0eEWIfKMOAN+1oqFy7GOoxn5IqTlzmQDKf8/ZxcqmEg8a07p6zcw=
=LG2k
-----END PGP SIGNATURE-----

--Apple-Mail-2--894419916--
