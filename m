Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smx-7fb.smtp.startmail.com ([37.153.204.247]:35054 "EHLO
	smx-7fb.smtp.startmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609AbbKDVS7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Nov 2015 16:18:59 -0500
Received: from smx-8a9.int1.startmail.com (smx-8a9.int1.startmail.com [10.1.137.139])
	by smx-7fb.smtp.startmail.com (Postfix) with ESMTPS id 651D0B7A5B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2015 22:10:48 +0100 (CET)
Message-ID: <563A7452.4050202@startmail.com>
Date: Wed, 04 Nov 2015 21:10:42 +0000
From: OmegaPhil <OmegaPhil@startmail.com>
Mime-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Unable to allocate for space usage in particular btrfs volume
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ImgTg2HP1Qn0K8xPIIT7fiwXwjLdOo1iW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ImgTg2HP1Qn0K8xPIIT7fiwXwjLdOo1iW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Back in September I noticed that 'sudo du -chs /mnt/storage-1' reported
887GB used and 'df -h' 920GB for this particular volume - I went on
#btrfs for any suggestions, and balancing + defraging made no
difference. It had no subvolumes/snapshots etc, I basically used it like
a checksumed ext4fs.

Since the volume was converted from ext4, I redid it from scratch (so
made with kernel v4.1.3 or v4.1.6 on this Debian Testing machine), and
the problem went away.

After a couple of months, df reports 907GB used, whereas du says 884GB -
I currently have 8 large (1-5.5TB volumes) btrfs volumes in use,
storage-1 is the only SSD volume and the only one with this problem.

No balancing or defraging this time, it didn't make a difference before
and this is a relatively new volume.

Are there any sysadmin-level ways I can account for the ~23GB lost space?=


Thanks for any help.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

$ uname -a

Linux omega1 4.2.0-1-amd64 #1 SMP Debian 4.2.5-1 (2015-10-27) x86_64
GNU/Linux

$ btrfs --version

btrfs-progs v4.2.2

$ sudo btrfs fi usage /mnt/storage-1

Overall:
    Device size:		 953.87GiB
    Device allocated:		 932.04GiB
    Device unallocated:		  21.83GiB
    Device missing:		     0.00B
    Used:			 906.10GiB
    Free (estimated):		  45.35GiB	(min: 34.43GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:925.01GiB, Used:901.50GiB
   /dev/sdb	 925.01GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdb	   8.00MiB

Metadata,DUP: Size:3.50GiB, Used:2.30GiB
   /dev/sdb	   7.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdb	   4.00MiB

System,DUP: Size:8.00MiB, Used:128.00KiB
   /dev/sdb	  16.00MiB

Unallocated:
   /dev/sdb	  21.83GiB

$ sudo btrfs-show-super /dev/sdb

superblock: bytenr=3D65536, device=3D/dev/sdb
---------------------------------------------------------
csum			0x7f6b70be [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			27430475-c49a-4e3f-8f8d-be5c14be59db
label			storage-1
generation		114344
root			683413471232
sys_array_size		226
chunk_root_generation	114251
root_level		1
chunk_root		21004288
chunk_root_level	1
log_root		683413979136
log_root_transid	0
log_root_level		0
total_bytes		1024209543168
bytes_used		971565568000
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	114344
uuid_tree_generation	114344
dev_item.uuid		c6b32341-6300-4f21-8c3b-3d7d458c3668
dev_item.fsid		27430475-c49a-4e3f-8f8d-be5c14be59db [match]
dev_item.type		0
dev_item.total_bytes	1024209543168
dev_item.bytes_used	1000765128704
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

dmesg contains a lot of information which is superfluous to btrfs and
personal, I can filter on a regex and report if necessary.


--ImgTg2HP1Qn0K8xPIIT7fiwXwjLdOo1iW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOnRXAAoJEBfSPH39wvOPc6YP+we36uzozlU/RtEGP4nANC+h
nn7MqB02DY6S7pNndfQ22XLTrOC50EMV/87YSkLfbTEiUmkaPr0eXCDGfZv1SM9i
sVN4yd7OCCd305AvPeWHE4GDjz77RSH54YjDqTaLT+TclQDjk9SUsWeKlzFJfs+o
Gb6Nqko1uhhd/i/f2xbUEK23zum3hNKwxC5VMaZueAsnuuim08zGzy3Ch1WKvaTa
g+30WqFonanutr4AhHE86f8RbqfnB0eujEvH6QFSIUg1Q3e3i+YBW5Z1piODZGqj
1E3dtCvVqoDM621QNJrRcEOXlgm3c0d5rDSUSDlQU0uRCLH8bo01J2p3241VZGWj
jOrHA57U3nhBGNgjkozBB5ziS9PtNtkisfxd7juC5WHEmwOeHDePRDj3/kF+QrHu
/YLU1GKeFPt0D6ywMnnocdoTbOsXpp4ndlPqBJwsLWL8kFuw/bau3A1Z4iygkj+r
YhpH0EWANqzhbHAGkOMoym4xMMxbM0dApI2SE7HjKRkZulB/LA+pB9cUWsAaudNe
BrcPiL2axCzveNOjyE/RqM6YB4eUdNIDXs//vlD0KuP1YFUU6GYBZA2dLxL8Jxto
VCyVbuPdAcFJEOXiVbLUWKvL6GonegVNNST3qEmyF8BhwZuI09IK48rAqmjRKOkW
pB1LpUDceHGQ25N3dyBI
=+qIG
-----END PGP SIGNATURE-----

--ImgTg2HP1Qn0K8xPIIT7fiwXwjLdOo1iW--
