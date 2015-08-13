Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35486 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbHMDde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 23:33:34 -0400
Received: by wicne3 with SMTP id ne3so123089899wic.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 20:33:33 -0700 (PDT)
Received: from U64-desktop (smtp.infinitegrid.org. [46.182.105.104])
        by smtp.gmail.com with ESMTPSA id dz4sm1188170wib.17.2015.08.12.20.33.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 12 Aug 2015 20:33:32 -0700 (PDT)
Date: Thu, 13 Aug 2015 13:33:22 +1000
From: David Seikel <onefang@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Oddness with phantom device replacing real device.
Message-ID: <20150813133322.369c10af.onefang@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=+lFIVBxLV=2sbs8OiY2wZf"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/=+lFIVBxLV=2sbs8OiY2wZf
Content-Type: multipart/mixed; boundary="MP_/zqCMxEgHlh78dWmDceehzmd"

--MP_/zqCMxEgHlh78dWmDceehzmd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I don't actually think that this is a BTRFS problem, but it's showing
symptoms within BTRFS, and I have no other clues, so maybe the BTRFS
experts can help me figure out what is actually going wrong.

I'm a sysadmin working for a company that does scientific modelling.
They have many TBs of data.  We use two servers running Ubuntu 14.04 LTS
to backup all of this data.  One of them includes 16 spinning rust
disks hooked to a RAID controller running in JBOD mode (in other words,
as far as Linux is concerned, they are just 16 ordinary disks).  They
are /dev/sdc to /dev/sdr, all being used as a single BTRFS file system.

I have been having no end of trouble with this system recently.  Keep
in mind that due to the huge amount of data we deal with, doing
anything takes a long time.  So "recently" means "in the last several
months".

My latest attempt to beat some sense into this server was to upgrade it
to the latest officially backported kernel from Ubuntu, and compile my
own copy of btrfs-progs from source code (latest release from github).
Then I recreated the 16 disk BTRFS file system, and started the backup
software running again, from scratch.  The next day, /dev/sdc has
vanished, to be replaced be a phantom /dev/sds.  There's no such disk
as /dev/sds.  /dev/sds is now included in the BTRFS file system
replacing /dev/sdc.  In /dev sdc does indeed vanish, and sds does
indeed appear.  This was happening before.  /dev/sds then starts to
fill up with errors, since no such disk actually exists.

I don't know what is actually causing the problem.  The disks are in a
hot swap backplane, and if I actually pulled sdc out, then it would
still be listed as part of the BTRFS file system, wouldn't it?  If I
then where to plug some new disk into the same spot, it would not be
recognised as part of the file system?  So assuming that the RAID
controller is getting confused and thinking that sdc has been pulled,
then replaced by sds, it should not be showing up as part of the BTRFS
file system?  Or maybe there's a signature on sdc that BTRFS notices
makes it part of the file system, even though BTRFS is now confused
about it's location?

After a reboot, sdc returns and sds is gone again.

The RAID controller has recently been replaced, but there where similar
problems with the old one as well.  A better model of RAID controller
was chosen this time.

I've also not been able to complete a scrub on this system recently.
The really odd thing is that I get messages that the scrub has aborted,
yet the scrub continues, then much later (days later) the scrub causes
a kernel panic.  The "aborted" happens some random time into the scrub,
but usually in the early part of the scrub.  Mind you, if BTRFS is
completely confused due to a problem elsewhere, then maybe this can be
excused.

The other backup server is almost identical, though it has less disks
in the array.  It doesn't have any issues with the BTRFS file system.

Can any one help shed some light on this please?  Hopefully some
"quick" things to try, given my definition of "recently" above means
that most things take days or weeks, or even months for me to try.

I have attached the usual debugging info requested.  This is after the
bogus sds replaces sdc.

--=20
A big old stinking pile of genius that no one wants
coz there are too many silver coated monkeys in the world.

--MP_/zqCMxEgHlh78dWmDceehzmd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=onefang_btrfs_details.txt

> uname -a
Linux walker 3.19.0-25-generic #26~14.04.1-Ubuntu SMP Fri Jul 24 21:16:20 U=
TC 2015 x86_64 x86_64 x86_64 GNU/Linux


> /opt/btrfs-progs/bin/btrfs --version
btrfs-progs v4.1.2


>  /opt/btrfs-progs/bin/btrfs fi show
Label: none  uuid: 901d40d5-5881-468d-b07e-bfda80b20525
	Total devices 2 FS bytes used 24.79GiB
	devid    1 size 29.13GiB used 29.13GiB path /dev/sda1
	devid    2 size 29.13GiB used 29.13GiB path /dev/sdb1

Label: none  uuid: a017a1f7-8a09-4427-8f4b-25fe39dd3a61
	Total devices 16 FS bytes used 952.21GiB
	devid    1 size 2.73TiB used 20.00MiB path /dev/sds
	devid    2 size 2.73TiB used 0.00B path /dev/sdd
	devid    3 size 2.73TiB used 0.00B path /dev/sde
	devid    4 size 2.73TiB used 0.00B path /dev/sdf
	devid    5 size 2.73TiB used 0.00B path /dev/sdg
	devid    6 size 2.73TiB used 0.00B path /dev/sdh
	devid    7 size 2.73TiB used 0.00B path /dev/sdi
	devid    8 size 2.73TiB used 0.00B path /dev/sdj
	devid    9 size 3.64TiB used 636.00GiB path /dev/sdk
	devid   10 size 2.73TiB used 0.00B path /dev/sdl
	devid   11 size 2.73TiB used 1.00GiB path /dev/sdm
	devid   12 size 2.73TiB used 1.00GiB path /dev/sdn
	devid   13 size 2.73TiB used 1.00GiB path /dev/sdo
	devid   14 size 2.73TiB used 1.00GiB path /dev/sdp
	devid   15 size 3.64TiB used 635.01GiB path /dev/sdq
	devid   16 size 3.64TiB used 635.01GiB path /dev/sdr


> /opt/btrfs-progs/bin/btrfs fi df /var/lib/backuppc
btrfs-progs v4.1.2
Data, RAID1: total=3D951.00GiB, used=3D950.04GiB
Data, single: total=3D8.00MiB, used=3D0.00B
System, RAID1: total=3D8.00MiB, used=3D160.00KiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, RAID1: total=3D4.00GiB, used=3D2.63GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


> dmesg
[60174.590577] BTRFS: bdev /dev/sds errs: wr 1920, rd 0, flush 640, corrupt=
 0, gen 0
[60174.613263] BTRFS: lost page write due to I/O error on /dev/sds
[60174.613265] BTRFS: bdev /dev/sds errs: wr 1921, rd 0, flush 640, corrupt=
 0, gen 0
[60174.635281] BTRFS: lost page write due to I/O error on /dev/sds
[60174.635282] BTRFS: bdev /dev/sds errs: wr 1922, rd 0, flush 640, corrupt=
 0, gen 0
[60174.659822] BTRFS: lost page write due to I/O error on /dev/sds
[60174.659824] BTRFS: bdev /dev/sds errs: wr 1923, rd 0, flush 640, corrupt=
 0, gen 0
[60206.196739] BTRFS: bdev /dev/sds errs: wr 1923, rd 0, flush 641, corrupt=
 0, gen 0
[60206.219317] BTRFS: lost page write due to I/O error on /dev/sds
[60206.219321] BTRFS: bdev /dev/sds errs: wr 1924, rd 0, flush 641, corrupt=
 0, gen 0
[60206.241866] BTRFS: lost page write due to I/O error on /dev/sds
[60206.241870] BTRFS: bdev /dev/sds errs: wr 1925, rd 0, flush 641, corrupt=
 0, gen 0
[60206.265205] BTRFS: lost page write due to I/O error on /dev/sds
[60206.265208] BTRFS: bdev /dev/sds errs: wr 1926, rd 0, flush 641, corrupt=
 0, gen 0
[60237.102648] BTRFS: bdev /dev/sds errs: wr 1926, rd 0, flush 642, corrupt=
 0, gen 0
[60237.125815] BTRFS: lost page write due to I/O error on /dev/sds
[60237.125819] BTRFS: bdev /dev/sds errs: wr 1927, rd 0, flush 642, corrupt=
 0, gen 0
[60237.148393] BTRFS: lost page write due to I/O error on /dev/sds
[60237.148398] BTRFS: bdev /dev/sds errs: wr 1928, rd 0, flush 642, corrupt=
 0, gen 0
[60237.170912] BTRFS: lost page write due to I/O error on /dev/sds
[60237.170917] BTRFS: bdev /dev/sds errs: wr 1929, rd 0, flush 642, corrupt=
 0, gen 0
[60268.100120] BTRFS: bdev /dev/sds errs: wr 1929, rd 0, flush 643, corrupt=
 0, gen 0
[60268.123432] BTRFS: lost page write due to I/O error on /dev/sds
[60268.123435] BTRFS: bdev /dev/sds errs: wr 1930, rd 0, flush 643, corrupt=
 0, gen 0
[60268.145911] BTRFS: lost page write due to I/O error on /dev/sds
[60268.145915] BTRFS: bdev /dev/sds errs: wr 1931, rd 0, flush 643, corrupt=
 0, gen 0
[60268.168411] BTRFS: lost page write due to I/O error on /dev/sds
[60268.168415] BTRFS: bdev /dev/sds errs: wr 1932, rd 0, flush 643, corrupt=
 0, gen 0
[60299.811546] BTRFS: bdev /dev/sds errs: wr 1932, rd 0, flush 644, corrupt=
 0, gen 0
[60299.833913] BTRFS: lost page write due to I/O error on /dev/sds
[60299.833918] BTRFS: bdev /dev/sds errs: wr 1933, rd 0, flush 644, corrupt=
 0, gen 0
[60299.856655] BTRFS: lost page write due to I/O error on /dev/sds
[60299.856659] BTRFS: bdev /dev/sds errs: wr 1934, rd 0, flush 644, corrupt=
 0, gen 0
[60299.878772] BTRFS: lost page write due to I/O error on /dev/sds
[60299.878776] BTRFS: bdev /dev/sds errs: wr 1935, rd 0, flush 644, corrupt=
 0, gen 0
[60330.940527] BTRFS: bdev /dev/sds errs: wr 1935, rd 0, flush 645, corrupt=
 0, gen 0
[60330.964429] BTRFS: lost page write due to I/O error on /dev/sds
[60330.964434] BTRFS: bdev /dev/sds errs: wr 1936, rd 0, flush 645, corrupt=
 0, gen 0
[60330.987095] BTRFS: lost page write due to I/O error on /dev/sds
[60330.987099] BTRFS: bdev /dev/sds errs: wr 1937, rd 0, flush 645, corrupt=
 0, gen 0
[60331.009462] BTRFS: lost page write due to I/O error on /dev/sds
[60331.009466] BTRFS: bdev /dev/sds errs: wr 1938, rd 0, flush 645, corrupt=
 0, gen 0
[60361.875654] BTRFS: bdev /dev/sds errs: wr 1938, rd 0, flush 646, corrupt=
 0, gen 0
[60361.898426] BTRFS: lost page write due to I/O error on /dev/sds
[60361.898431] BTRFS: bdev /dev/sds errs: wr 1939, rd 0, flush 646, corrupt=
 0, gen 0
[60361.922188] BTRFS: lost page write due to I/O error on /dev/sds
[60361.922192] BTRFS: bdev /dev/sds errs: wr 1940, rd 0, flush 646, corrupt=
 0, gen 0
[60361.944643] BTRFS: lost page write due to I/O error on /dev/sds
[60361.944647] BTRFS: bdev /dev/sds errs: wr 1941, rd 0, flush 646, corrupt=
 0, gen 0
[60393.246924] BTRFS: bdev /dev/sds errs: wr 1941, rd 0, flush 647, corrupt=
 0, gen 0
[60393.269525] BTRFS: lost page write due to I/O error on /dev/sds
[60393.269529] BTRFS: bdev /dev/sds errs: wr 1942, rd 0, flush 647, corrupt=
 0, gen 0
[60393.292396] BTRFS: lost page write due to I/O error on /dev/sds
[60393.292401] BTRFS: bdev /dev/sds errs: wr 1943, rd 0, flush 647, corrupt=
 0, gen 0
[60393.314915] BTRFS: lost page write due to I/O error on /dev/sds
[60393.314919] BTRFS: bdev /dev/sds errs: wr 1944, rd 0, flush 647, corrupt=
 0, gen 0
[60424.085923] BTRFS: bdev /dev/sds errs: wr 1944, rd 0, flush 648, corrupt=
 0, gen 0
[60424.109367] BTRFS: lost page write due to I/O error on /dev/sds
[60424.109371] BTRFS: bdev /dev/sds errs: wr 1945, rd 0, flush 648, corrupt=
 0, gen 0
[60424.131817] BTRFS: lost page write due to I/O error on /dev/sds
[60424.131819] BTRFS: bdev /dev/sds errs: wr 1946, rd 0, flush 648, corrupt=
 0, gen 0
[60424.154242] BTRFS: lost page write due to I/O error on /dev/sds
[60424.154246] BTRFS: bdev /dev/sds errs: wr 1947, rd 0, flush 648, corrupt=
 0, gen 0
[60454.996199] BTRFS: bdev /dev/sds errs: wr 1947, rd 0, flush 649, corrupt=
 0, gen 0
[60455.019418] BTRFS: lost page write due to I/O error on /dev/sds
[60455.019423] BTRFS: bdev /dev/sds errs: wr 1948, rd 0, flush 649, corrupt=
 0, gen 0
[60455.042932] BTRFS: lost page write due to I/O error on /dev/sds
[60455.042937] BTRFS: bdev /dev/sds errs: wr 1949, rd 0, flush 649, corrupt=
 0, gen 0
[60455.067661] BTRFS: lost page write due to I/O error on /dev/sds
[60455.067665] BTRFS: bdev /dev/sds errs: wr 1950, rd 0, flush 649, corrupt=
 0, gen 0

--MP_/zqCMxEgHlh78dWmDceehzmd--

--Sig_/=+lFIVBxLV=2sbs8OiY2wZf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlXMEAIACgkQM4aCtK1wD2JndQCfcA4K84JNbCtoWyamrNm5lQNY
UwEAoI3bWSG5sgcXi7M+70W8895uOhBl
=a635
-----END PGP SIGNATURE-----

--Sig_/=+lFIVBxLV=2sbs8OiY2wZf--
