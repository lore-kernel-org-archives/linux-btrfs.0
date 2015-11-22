Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rho.voidptr.de ([84.200.43.138]:57662 "EHLO rho.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbKVWIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 17:08:55 -0500
Received: from [192.168.4.99] (ipbcc0f566.dynamic.kabel-deutschland.de [188.192.245.102])
	by rho.voidptr.de (Postfix) with ESMTPSA id 763E4C9E820
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 22:59:40 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Nils Steinger <nst@voidptr.de>
Subject: btrfs send reproducibly fails for a specific subvolume after sending
 15 GiB, scrub reports no errors
Message-ID: <56523AC8.7050205@voidptr.de>
Date: Sun, 22 Nov 2015 22:59:36 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MBkdbagK3xKjUA4c2M4La5mQ9Ous9CWkC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MBkdbagK3xKjUA4c2M4La5mQ9Ous9CWkC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I recently ran into a problem while trying to back up some of my btrfs
subvolumes over the network:
`btrfs send` works flawlessly on snapshots of most subvolumes, but keeps
failing on snapshots of a certain subvolume =E2=80=94 always after sendin=
g 15 GiB:

btrfs send /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT |
pv | ssh kappa "btrfs receive /mnt/300gb/backups/snapshots/zeta/home/"
At subvol /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
At subvol 2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
ERROR: send ioctl failed with -2: No such file or directory
  15GB 0:34:34 [7,41MB/s]

I've tried piping the output to /dev/null instead of ssh and got the
same error (again after sending 15 GiB), so this seems to be on the
sending side.

However, btrfs scrub reports no errors and I don't get any messages in
dmesg when the btrfs send fails.

What could cause this kind of error?
And is there a way to fix it, preferably without recreating the FS?


Regards,
Nils Steinger


--MBkdbagK3xKjUA4c2M4La5mQ9Ous9CWkC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJWUjrLAAoJEO7L9/pIVYbo7JkH/2zmp7QRa0KcCa+YGbVCj7c4
1C1v1rhRBrZryWAfuOv8Lfz0UjaSV7BgUkfhlhv6Jo3OYCWQEbr9VCQAgHBwQbOy
ixSpy0SbSYDJ96xaJv2HnOYQB1k342Z5lZTS51Vz4ZKxXEdm5vObcIjdedCvb2xq
/fvmwB6m2jvp6iU2HzjNfk+fSl7vMO6CrGvtNH4/ONNj+f2DF0HWfDLOpy9TrGKt
DZvwBIGDoGqzoYxibdmJtF+BpAJ37e+kt5QrYSBTYQR5qFbqwdjSp98j75a9LiAf
DwRcRnNr+rZqrXhg3nwLW/E1mFEA1ewcvqtJdZvQpXQWgCoCuhCiSgasIQ8FPQs=
=I9aG
-----END PGP SIGNATURE-----

--MBkdbagK3xKjUA4c2M4La5mQ9Ous9CWkC--
