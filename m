Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dehost.average.org ([88.198.2.197]:34629 "EHLO
	dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMWtG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 18:49:06 -0400
Received: from [IPv6:2001:470:1f09:520:a60:6eff:fe69:494] (unknown [IPv6:2001:470:1f09:520:a60:6eff:fe69:494])
	by dehost.average.org (Postfix) with ESMTPSA id 9625F3A8BC3
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 02:39:06 +0400 (MSK)
Message-ID: <53223380.3000308@average.org>
Date: Fri, 14 Mar 2014 02:38:56 +0400
From: Eugene Crosser <crosser@average.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during raid1 rebalance
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7fpS87anFx4UiXoeGufmuLPoooC09GstL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7fpS87anFx4UiXoeGufmuLPoooC09GstL
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

Hello,

I want to report that I have the same problem as Michael Russo, except in=
 my
case there is definitely *a lot* of free space.

I had ext4 on a 1Tb LVM mirror. The filesystem was 96% full, with many mu=
lti-Gb
files. I successfully converted it into btrfs, removed ext2_saved subvolu=
me, but
did *not* defragment or balance.

Then I added two fresh 4Tb disks to the filesystem, and tried to convert =
it to
raid1. My plan was to then delete the original LVM disk and have all my d=
ata
migrated to the new 4Tb disks under btrfs mirror.

But balancing cannot complete with the same symptoms:

[...]
[12746.391828] block group has cluster?: no
[12746.391830] 0 blocks of free space at or bigger than bytes is
[12747.420098] btrfs: 35 enospc errors during balance

root@pccross:~# btrfs fi sh
Label: 'export'  uuid: 02f39e9d-9115-4a79-9015-a3a9decb87cf
	Total devices 3 FS bytes used 798.15GB
	devid    3 size 3.64TB used 855.03GB path /dev/sdd1
	devid    2 size 3.64TB used 855.00GB path /dev/sdc1
	devid    1 size 891.51GB used 175.48GB path /dev/md5

Btrfs v0.20-rc1

root@pccross:~# btrfs fi df /export
Data, RAID1: total=3D849.00GB, used=3D650.25GB
Data: total=3D175.48GB, used=3D145.64GB
System: total=3D32.00MB, used=3D136.00KB
Metadata, RAID1: total=3D6.00GB, used=3D2.21GB

root@pccross:~# uname -a
Linux pccross 3.13.0-17-generic #37-Ubuntu SMP Mon Mar 10 21:44:01 UTC 20=
14
x86_64 x86_64 x86_64 GNU/Linux

Attempt "btrfs device delete" fails with the same "no space" diagnostic.

I am running defragmentation on all files bigger than 1Gb now, and see wh=
at
happens. If that does not help, is there any other advice? I can collect
debugging data if needed.

Thanks,

Eugene


--7fpS87anFx4UiXoeGufmuLPoooC09GstL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUyIzhzy8vXtX5W5FAQL02Af9E7+U9PEjLKMi3smOdK+KqzvLUT8NBLfp
dGo/GHH55DFjipEKcayWmzQr9a7z68wGd0KrGJkfamklipqjal4Hn+ZNnIUacIVf
B7YVUBWrIPzPZJFILKtnF7Us+TizQEha1BFBz2x8oJjySBktRw4EP+uIR+5LG8oN
CcdyMMd/OMfk0agjaYPXSBBm89Oqyb55mEEiO0UaFylBpHk1eFcXxe2sliyi5SZ6
4OS+aMsCJX0MM6OEEH7j7cxoAP56W8YDayz/dhHARMeemuAFp8tJDflntx1AjiAX
f3fb07CYkFE/RaddwI71TZ8414CIB51p0E9DDbAnUNkTKQVY46AOaQ==
=3WFF
-----END PGP SIGNATURE-----

--7fpS87anFx4UiXoeGufmuLPoooC09GstL--
