Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ninthfloor.org ([109.74.194.224]:56323 "EHLO
	mail.ninthfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965306AbbI2WUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 18:20:17 -0400
Received: from [192.168.1.2] (net-2-40-173-77.cust.dsl.teletu.it [2.40.173.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: pl)
	by mail.ninthfloor.org (Postfix) with ESMTPSA id 6E82B1C113
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 22:20:13 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Paride Legovini <pl@ninthfloor.org>
Subject: btrfs send -c fails saying "parent determination failed"
Message-ID: <560B0E9B.7020500@ninthfloor.org>
Date: Wed, 30 Sep 2015 00:20:11 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nkcf61bUvAv19Rf8hNN3bjiFO5vU4k8ki"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nkcf61bUvAv19Rf8hNN3bjiFO5vU4k8ki
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

btrfs send -c stopped working for me several months ago. My setup is
actually very simple. On the "send" side I have:

# btrfs sub list -u / | grep rootfs-snapshot-
ID 2221 gen 93340 top level 5 uuid adf43113-0442-9847-9ce4-7d9c06e77602
path rootfs-snapshot-20150923
ID 2262 gen 96026 top level 5 uuid 49f34ca5-42da-7d4b-a159-c3027650d8e6
path rootfs-snapshot-20150929

Several other subvolumes also exist there, just in case it matters.
On the receive side:

# btrfs sub list -R /mnt/cryptobackup/ | grep rootfs-snapshot-20150923
ID 1532 gen 3066 top level 5 received_uuid
adf43113-0442-9847-9ce4-7d9c06e77602 path snapshots/rootfs-snapshot-20150=
923

As you can see the uuids for rootfs-snapshot-20150923 are the same on
both sides. If I try to send|receive /rootfs-snapshot-20150929 using
rootfs-snapshot-20150923 as clone source it fails:

# btrfs send -c /rootfs-snapshot-20150923 /rootfs-snapshot-20150929 |
btrfs receive /mnt/cryptobackup/snapshots/
At subvol /rootfs-snapshot-20150929
ERROR: parent determination failed for 2221

while it works fine if I use btrfs send -p. This is always reproducible,
it fails every time across reboots and kernel upgrades; it works every
time with -p.

In both / and /mnt/cryptobackup I didn't mount any special subvolid:

# btrfs sub get-default /
ID 5 (FS_TREE)
# btrfs inspect-internal rootid /
5
# btrfs sub get-default /mnt/cryptobackup/
ID 5 (FS_TREE)
# btrfs inspect-internal rootid /mnt/cryptobackup/
5

so nothing strange here. Some other possibly useful information:

$ uname -a
Linux mandragola 4.2.0-1-amd64 #1 SMP Debian 4.2.1-1 (2015-09-25) x86_64
GNU/Linux

so you have guessed that I'm running an up to date Debian system. Keep
in mind that it is several kernel versions that I'm getting this
problem, it's nothing specific to this one.

$ btrfs --version
btrfs-progs v4.1.2

# btrfs fi show
Label: none  uuid: 5651d651-5c48-425f-9fc9-56f2a9ad004f
	Total devices 1 FS bytes used 118.24GiB
	devid    1 size 237.97GiB used 218.02GiB path /dev/sda2

Label: none  uuid: c4db7f4f-b976-4d36-bd76-76e818341cef
	Total devices 1 FS bytes used 934.71GiB
	devid    1 size 1.82TiB used 941.03GiB path /dev/mapper/cryptobackup

$ btrfs fi df /
Data, single: total=3D212.01GiB, used=3D116.98GiB
System, single: total=3D4.00MiB, used=3D48.00KiB
Metadata, single: total=3D6.01GiB, used=3D1.27GiB
GlobalReserve, single: total=3D448.00MiB, used=3D0.00B

$ btrfs fi df /mnt/cryptobackup/
Data, single: total=3D932.00GiB, used=3D931.70GiB
System, DUP: total=3D8.00MiB, used=3D128.00KiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, DUP: total=3D4.50GiB, used=3D3.01GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

$ dmesg | grep -i btrfs | curl -F "sprunge=3D<-" http://sprunge.us
http://sprunge.us/EiHE

If I hit a bug I'll be happy to help in finding it, just tell me if you
need further information. Otherwise, if I'm just missing something, I'll
appreciate any hint.

Thank you,

Paride


--nkcf61bUvAv19Rf8hNN3bjiFO5vU4k8ki
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWCw6bAAoJEFoJtFdt6AgOENsQALGBQqKrXAiqtHBvrbnaWp2a
5gFAnIizbSjKuR2RSrYPfJtFBGCUwyja2CwLIhe4M8ATp+6qZ+JybtlZbYl0e4q3
+Nh6pu4RsY+cX8hyp2oHrKCYjz9YU/GJrXK1YH7IOdd46d1qTqQkitpxBIiDVc/M
eKIpgEsVSGtLRwFW0fSkjRlZoNLx0po9auEqdJYbdUtiXgkOGi4SMmhtlAen+Wds
H5oozJ0Uhnz239nXr+sVPfg68LMRjG4W9rSEF4m7NlVezX3UsS70xoZyhZS+IgoX
MT3W9OT4EFUIOOj8Am7L6290rdloZJUSuSZCUzlvPL0E1gYmvY4cBu0J9HLauE/e
jKvoqTTQzMMrfiqXhMKCZjeToUb/GoHLDZV4li8eWGONMfIzexBUJId8BFZ9cCHW
yFUGX/xKz9rfRvJlBD2FS6hlIMBwA7p3mT2iE1lquYjuyq6d5yR/TXBg/U1gQXiE
AxWLzF9VsnJufUEbkQ4lJ7fnzDMShwJOa6ORyJismYNdWFq8Vs9MyvYciYh+UB+O
tIFLeQa0nmv5heEQDYbmWGHWmoMPTwQgbM4zta47Xxoq8pE/gb1Br7DVubEfDBrT
ERXTo1x7oSAiBmfKr995FszzldA2tmziuIF49ZtTd4w7YBmAaL97BRUH1I6AmoVA
ehb7SLIeWldrCvJAyK05
=dE2I
-----END PGP SIGNATURE-----

--nkcf61bUvAv19Rf8hNN3bjiFO5vU4k8ki--
