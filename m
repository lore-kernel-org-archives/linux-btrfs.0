Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45576 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3I0Tg5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 15:36:57 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1VPdqR-0007Sl-M5
	for linux-btrfs@vger.kernel.org; Fri, 27 Sep 2013 19:36:56 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1VPdqR-0001gm-3j
	for linux-btrfs@vger.kernel.org; Fri, 27 Sep 2013 20:36:55 +0100
Date: Fri, 27 Sep 2013 20:36:55 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: extlinux and btrfs RAID-1
Message-ID: <20130927193655.GC28147@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I'm trying to get a system booting, and I'm having something of a
hard time with it. I'd like to check whether anyone's managed to do
what I'm attempting, and whether I'm doing something silly, or just
need to upgrade something.

   I've got two disks, /dev/sda and /dev/sdb, each partitioned the
same way, with GPTs. The second partition on each is part of a RAID-1
(data and metadata) btrfs, with no compression.

# btrfs fi show
Label: 'amelia'  uuid: cba252b5-af1b-4f31-9f8f-191ef66f777d
	   Total devices 2 FS bytes used 1.03GB
	   devid    1 size 275.48GB used 3.04GB path /dev/sda2
	   devid    2 size 275.48GB used 3.03GB path /dev/sdb2

   I have the gptmbr.bin from extlinux installed on the boot sector of
each device:

# cat /usr/lib/syslinux/gptmbr.bin >/dev/sda
# cat /usr/lib/syslinux/gptmbr.bin >/dev/sdb

   I've attempted to install extlinux from a chroot:

# extlinux --install /boot/extlinux

   This is extlinux 4.05, which claims (on the syslinux website) to
support btrfs.

   When I boot the machine from its disks, I'm being told that
extlinux only supports single-disk btrfs. Is this still the case? Or
am I just using a version that's far too old? (Looks like there's a
v6.01 available). I can't see a list of the limitations and
capabilities of syslinux and btrfs on the syslinux website.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no. 9: Standard Deviation ---     

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkXeVlheFHXiqx3kAQIubA//QJ985JG8eHwSOA3g5F/zgJqc/WJDo11p
gk2rzM/5Ek7Q90H24zUyx0wOrS5g/2Cw1kI5Fx0PMC+zpFoI/KLssmpuk4WMXK8Y
GDpr8fsl4tQEjYehYr6WP+qQGSNQuHCuLV9+2Wd9/QTdH7wUPAcbB0irNpt4GYWn
0+QqE8M0BAEvohpZpYuaSjGRo6GnJadT4DPoaUUHzxQlnEY9H4AVGd1womO3Z2/U
RB1/89YpvkqB7sbWoo8CqdazH7j8zbmRx87GwVUfDXYR18GFJ/jnKKt1RW+KikSZ
rOpBmjReGugIZSXgkLv6Jqm18cVDYFHWoWwlV1PwRPhT4+y7B/m3khjFOWcTmKyZ
tgT4N2yXc30MZrp2qX+6WR04mOYnhx1tu2j5b00y2ZiLqJ8R+BmYOGSWkfdcRvFq
YXWKuHYPHj9PMOVWGHxk+Rcj4ROFt5Okk3plHf5XOxnOKxnlsFnO6VTHDIasX1pH
0g4ODylHaEMSSvuFSd4raCU/QMlgSFlZbsPptgppRGtajuzDe/Nw5hsRndA/Z/bN
vr86WE5E3iMpBNefGQcSEcJWGATcSLJhKAMafxq6abiFOIdmbaQhEfBd/10lnlVz
MMDFsfW5f5433xqtGXx4xWuqlAsDQiDiWkYBqPibNSvD8rYitKR+m/DcEWYREUyR
2UvMZyrL10Y=
=sd2Z
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
