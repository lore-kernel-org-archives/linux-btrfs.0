Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56108 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbbHLWe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 18:34:28 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx003) with ESMTPSA
 (Nemesis) id 0LgqQQ-1Z47oS2y7a-00oE1v for <linux-btrfs@vger.kernel.org>; Thu,
 13 Aug 2015 00:34:26 +0200
Date: Thu, 13 Aug 2015 00:34:19 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Deleted files cause btrfs-send to fail
Message-ID: <20150813003419.09f13c1a@thetick>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/B_4Asc.7S=s5_hZwz9ne5st"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/B_4Asc.7S=s5_hZwz9ne5st
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Starting today I have an interesting problem: I deleted some files as part =
(old
fcrontabs), which now persistently causes btrfs-send to fail.  The error
message I get is:

Aug 12 23:32:24 thetick make_backups.sh[1059]: ERROR: send ioctl failed wit=
h -2: No such file or directory
Aug 12 23:32:25 thetick make_backups.sh[1059]: ERROR: unexpected EOF in str=
eam.

There is nothing in the dmesg output.

Since this is the root file system, I haven't gotten a copy of the actual o=
utput
of "btrfs check", though I have run it from an initramfs rescue shell.  The
output I saw there was much like the following (taken from an Email by Roman
Mamedov from 2014-12-28):

root 22730 inode 6236418 errors 2000, link count wrong unresolved ref dir 1=
05512 index 586340 namelen 48 name [redacted].dat.bak filetype 0 errors 3, =
no dir item, no dir index

Only in my case, it's "root 5" and "root 4" (I think), and the file names
(and other file system specifics) are of course different.  I definitely saw
"errors 2000" (I take it that's supposed to be an error code?).

Is this something that "btrfs check --repair" (or something else) can safely
fix?

# uname -a
Linux thetick 4.1.4-gentoo #1 SMP PREEMPT Tue Aug 4 21:58:41 CEST 2015 x86_=
64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
# btrfs --version
btrfs-progs v4.1.2
# btrfs filesystem show
Label: 'MARCEC_ROOT'  uuid: 0267d8b3-a074-460a-832d-5d5fd36bae64
        Total devices 1 FS bytes used 59.30GiB
        devid    1 size 107.79GiB used 74.03GiB path /dev/sda1

Label: 'MARCEC_STORAGE'  uuid: 472c9290-3ff2-4096-9c47-0612d3a52cef
        Total devices 2 FS bytes used 597.75GiB
        devid    1 size 931.51GiB used 600.03GiB path /dev/sdc
        devid    2 size 931.51GiB used 600.03GiB path /dev/sdb

Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
        Total devices 1 FS bytes used 810.35GiB
        devid    1 size 976.56GiB used 837.06GiB path /dev/sdd2

btrfs-progs v4.1.2
# btrfs filesystem df /
Data, single: total=3D70.00GiB, used=3D57.53GiB
System, single: total=3D32.00MiB, used=3D16.00KiB
Metadata, single: total=3D4.00GiB, used=3D1.77GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

Greetings
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/B_4Asc.7S=s5_hZwz9ne5st
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVy8nxAAoJEL/Q5oYsiHj01soQAJ6CUfWVH8GJLEJETnPnQPOv
McBq7ive3qNL2U836h+xK6iIt6QW2mwLXoGIKyqcyo3Ex/6iqGFUx75hClhligD3
8wjRaPIsiJmzm3+7eXJA57aNQOHqpn/fwhTRRD1z8osmnG6J2MtfONMSKpjYMHHg
LDFR0QTLXDvCd19S+7GT2ya2ejkMyIWbSkqWNJOnK/i+uqd42Su39yQXba1l5pWp
tHNoaJLXMjpmEV/lhOuyB5Iud6jGUKiXxW4gEA87gfn19Wgw79D7iNw9gZxlS5OM
9xoiURVlAM3Si39UygA1BFA7djVngOw9WWcXEAOgFmRXMIYwUlQy7phJUsLQ1MRU
B/fUHotXikC3Dhe4WcHlaWpBc6+5KnAoofbHw903gJMHSqF8tyjt2NQ2ZWpgOgYP
pEQBoHCPgHNyLLSj8TiPPfhe6XXIiRWPAXJXUxZCJlgC7ocqBq+ZyuY+kpIJs8NO
5f4JofEldZ4UqZAL2fGyHJONi8aGgZiKVrsL2fZ2M4yNw925rMOM4i0svD/Vi9OF
vhn5De6ffHWas7xsfFvXljpkI5OtUQmEHgBCB03aF38OG5RV2KKUc24LK0r/Bu2v
Yr8LxLhS1vzv37MyRTuwlqAdIbV6+I9yUH609uxMmUpq14iRUbJLK3yDoderB2yU
b8fp0BuHuH5nf3AYgfam
=iWET
-----END PGP SIGNATURE-----

--Sig_/B_4Asc.7S=s5_hZwz9ne5st--
