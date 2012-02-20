From: Roman Mamedov <rm@romanrm.ru>
Subject: BTRFS misdetects NBD (Network Block Devices) as SSD
Date: Tue, 21 Feb 2012 00:51:57 +0600
Message-ID: <20120221005157.3b9f8db9@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7v7LoqMZYXxTedWM04VK.WN"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/7v7LoqMZYXxTedWM04VK.WN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I have noticed I have the following in my dmesg:

[319769.043163] nbd: registered device at major 43
[319769.104176]  nbd11: unknown partition table
[319769.130273] device fsid c2598ff2-1e3e-4edf-ab19-1f7ab41b0160 devid 1 tr=
ansid 125743 /dev/nbd11
[319769.130522] btrfs: force lzo compression
[319769.130528] btrfs: disk space caching is enabled
[319802.926547] Btrfs detected SSD devices, enabling SSD mode

The /dev/nbd11 device itself is not an SSD, it's an LVM volume situated on a
RAID5 array of regular hard drives, exported via NBD from another computer.

https://en.wikipedia.org/wiki/Network_block_device

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/7v7LoqMZYXxTedWM04VK.WN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Clk0ACgkQTLKSvz+PZwgWEQCdEtdMoyW93QDH07MaQ7U9w9Yd
uzIAnRj2weBdKwvpxvToMwKY6B0ST9oH
=nHvb
-----END PGP SIGNATURE-----

--Sig_/7v7LoqMZYXxTedWM04VK.WN--
