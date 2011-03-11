From: Libor =?utf-8?q?Klep=C3=A1=C4=8D?= <libor.klepac@bcom.cz>
Subject: Raid1 resync
Date: Fri, 11 Mar 2011 14:05:47 +0100
Message-ID: <201103111405.49352.libor.klepac@bcom.cz>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1473646.5PPs5J41Sy";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1473646.5PPs5J41Sy
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
before my ssd crashed, my /home partion was sitting on md raid1 consisting =
of=20
partition on disk and iScsi LUN in network, it was created with bitmaps and=
=20
iscsi lun was set writemostly.
So when i came to work, i fired up iscsi, added lun to raid and partial res=
ync=20
went ahead.
Before leaving work, i failed iscsci disk and kicked it from raid.
I would like to use something like this with btrfs, without mdraid below it.

Is it somehow posible?
1) I can't go below 2 devices.
2) Does btrfs support resync only of changed blocks like mdraid with bitmap=
s?

Thanks
Libor

--nextPart1473646.5PPs5J41Sy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJNeh4sAAoJEPDvjG7Cn0eOEHgQAKYU0eCg3PCYXoqDHeNkrZe4
Ox1X9pSY5ee4tIrwKXT/3NPTXDr6D9zBsX+u2KV98ZSJrmxvcfqvO4xRNDfeONuA
9nmH7jKVIYTPTAitGWf9/W/z4zPGys+e2ugRY2I13qcFxuiYedy7YNmTO0X2X4C2
/vkaymzAOd1Om+s13a7lFyxzc/pPHeOJ/Zhme7T9TLB+6cCXckXNvh2zA4s40XWj
ZUu7PkW7Bqjb/Pst/8csN5ppTOYysiNnTlqzOwpstTDRVEIarxSAC0k2HYMZ982e
s0Xnf0l+K0bFLNNf5c9o0vsaQs4WY+6nYbxeKVEb97mwV9dfw/RHVU+Tp99qotLq
ZdiePlzocqOtkMuqvQTVdH7nYWM3wsCcUClqtvyemm/TzpKnuwIl24RLiiNg4a49
8A2fciAAP6hQ+HQjcs6Bhhg7bLUMzK3nbSRuPKIuCdtfwHV1MjP6ZZrP9wf2lXBP
S5yPGwlB9wMZhDPU43gFzItq3pr/E6Xj+/bpFiEY9h/Ekh6VkgHv3Aui+EjFrR4/
5A36JiyWqx4sIOAAS5w4sTTAYV1v+d+Z3jTPWmxpK1LyBg7Xxc1hsXIEWs0l3zUJ
6KhF8Ran/Xeh5PIewwED/bNaz2uHg+kQesZytz82uHWlAAynZqA5pcQw6ZJOIPM+
LQzCSGBL6XFk1xvwklkZ
=S3ij
-----END PGP SIGNATURE-----

--nextPart1473646.5PPs5J41Sy--
