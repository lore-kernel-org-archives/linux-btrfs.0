From: Paddy Steed <jarktasaa@gmail.com>
Subject: SSD optimizations
Date: Sun, 12 Dec 2010 17:24:14 +0000
Message-ID: <1292174654.11248.10.camel@paddy-desktop>
Reply-To: jarktasaa@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MBtxhq5B1UV/LlLJsmiQ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-MBtxhq5B1UV/LlLJsmiQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In a few weeks parts for my new computer will be arriving. The storage
will be a 128GB SSD. A few weeks after that I will order three large
disks for a RAID array. I understand that BTRFS RAID 5 support will be
available shortly. What is the best possible way for me to get the
highest performance out of this setup. I know of the option to optimize
for SSD's, but wont that affect all the drives in the array, not to
mention having the SSD in the raid array will make the usable size much
smaller as RAID 5 goes by the smallest disk. Is there a way to use it as
a cache the works even on power down. My current plan is to have
the /tmp directory in RAM on tmpfs, the /boot directory on a dedicated
partition on the SSD along with a 12GB swap partition also on the SSD
with the rest of the space (on the SSD) available as a cache. The three
mechanical hard drives will be on a RAID 5 array using BTRFS. Can anyone
suggest any improvements to my plan and also how to implement the cache?

--=-MBtxhq5B1UV/LlLJsmiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJNBQU5AAoJEDU7InHYx9g8UL0H/2sZlnqPUDXAPdYEI5MIpRzn
pHIv5ap4QagTiuwjty7sN+DKV7yFEkqlBZaRjFxLrw29Aj8p05HLmEQrHIXOtObj
piwYeSZAciBKR4eA8Ru1PRu5+o5Lk7nfP5AZSSue78GQzM7weqYjBF807/FUpyRP
UzzEyh9A9LW6FBJ+TtVYysGPTcnHbXTgdZ4hALTepj5XChZXkGJqouY6oi0y4PO2
SRk1R0iy076EaNOtJnTQ4UY4Vw/kxjyC3JP/apNHsLqVfCynTgMDTYEpL94vDVw3
3oMR7ZozrjoHMZ0o8LDGcumwOOA+chMQOv427Qy1PNxmC06k50xqRE5ixqpwdUw=
=JYTU
-----END PGP SIGNATURE-----

--=-MBtxhq5B1UV/LlLJsmiQ--

