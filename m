Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57070 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030434AbbKDVal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2015 16:30:41 -0500
Date: Wed, 4 Nov 2015 21:30:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: OmegaPhil <OmegaPhil@startmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unable to allocate for space usage in particular btrfs volume
Message-ID: <20151104213039.GC27446@carfax.org.uk>
References: <563A7452.4050202@startmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
In-Reply-To: <563A7452.4050202@startmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 04, 2015 at 09:10:42PM +0000, OmegaPhil wrote:
> Back in September I noticed that 'sudo du -chs /mnt/storage-1' reported
> 887GB used and 'df -h' 920GB for this particular volume - I went on
> #btrfs for any suggestions, and balancing + defraging made no
> difference. It had no subvolumes/snapshots etc, I basically used it like
> a checksumed ext4fs.
> 
> Since the volume was converted from ext4, I redid it from scratch (so
> made with kernel v4.1.3 or v4.1.6 on this Debian Testing machine), and
> the problem went away.
> 
> After a couple of months, df reports 907GB used, whereas du says 884GB -
> I currently have 8 large (1-5.5TB volumes) btrfs volumes in use,
> storage-1 is the only SSD volume and the only one with this problem.
> 
> No balancing or defraging this time, it didn't make a difference before
> and this is a relatively new volume.
> 
> Are there any sysadmin-level ways I can account for the ~23GB lost space?

   There's an issue where replacing blocks in the middle of an
existing extent won't split the extent, and thus the "old" blocks
aren't freed up, because they're held by the original extent (even
though not actually referenced by any existing file). This might be
what you're seeing.

   I'm not sure how to confirm this theory, or what to do about it if
it's true. (Defrag the file? Copy it elsewhere? Other?)

   Two other cases for df > du are orphaned files, although 23 GiB of
orphans is large; and missing out the dot-files in the directory that
du is run from (if doing, say, "du *" rather than "du ."). I've been
bitten by both of those in the past.

   Hugo.

> Thanks for any help.
> 
> =========================================================
> 
> $ uname -a
> 
> Linux omega1 4.2.0-1-amd64 #1 SMP Debian 4.2.5-1 (2015-10-27) x86_64
> GNU/Linux
> 
> $ btrfs --version
> 
> btrfs-progs v4.2.2
> 
> $ sudo btrfs fi usage /mnt/storage-1
> 
> Overall:
>     Device size:		 953.87GiB
>     Device allocated:		 932.04GiB
>     Device unallocated:		  21.83GiB
>     Device missing:		     0.00B
>     Used:			 906.10GiB
>     Free (estimated):		  45.35GiB	(min: 34.43GiB)
>     Data ratio:			      1.00
>     Metadata ratio:		      2.00
>     Global reserve:		 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:925.01GiB, Used:901.50GiB
>    /dev/sdb	 925.01GiB
> 
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sdb	   8.00MiB
> 
> Metadata,DUP: Size:3.50GiB, Used:2.30GiB
>    /dev/sdb	   7.00GiB
> 
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sdb	   4.00MiB
> 
> System,DUP: Size:8.00MiB, Used:128.00KiB
>    /dev/sdb	  16.00MiB
> 
> Unallocated:
>    /dev/sdb	  21.83GiB
> 
> $ sudo btrfs-show-super /dev/sdb
> 
> superblock: bytenr=65536, device=/dev/sdb
> ---------------------------------------------------------
> csum			0x7f6b70be [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			27430475-c49a-4e3f-8f8d-be5c14be59db
> label			storage-1
> generation		114344
> root			683413471232
> sys_array_size		226
> chunk_root_generation	114251
> root_level		1
> chunk_root		21004288
> chunk_root_level	1
> log_root		683413979136
> log_root_transid	0
> log_root_level		0
> total_bytes		1024209543168
> bytes_used		971565568000
> sectorsize		4096
> nodesize		16384
> leafsize		16384
> stripesize		4096
> root_dir		6
> num_devices		1
> compat_flags		0x0
> compat_ro_flags		0x0
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA )
> csum_type		0
> csum_size		4
> cache_generation	114344
> uuid_tree_generation	114344
> dev_item.uuid		c6b32341-6300-4f21-8c3b-3d7d458c3668
> dev_item.fsid		27430475-c49a-4e3f-8f8d-be5c14be59db [match]
> dev_item.type		0
> dev_item.total_bytes	1024209543168
> dev_item.bytes_used	1000765128704
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		1
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
> 
> =========================================================
> 
> dmesg contains a lot of information which is superfluous to btrfs and
> personal, I can filter on a regex and report if necessary.
> 



-- 
Hugo Mills             | There are three things you should never see being
hugo@... carfax.org.uk | made: laws, standards, and sausages.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWOnj/AAoJEFheFHXiqx3kQbQQALvoTjw3/IDDNC7TfZ0Zo0Qp
ALlMe2Xo7rEZOgm0ZL4gsfIl+oFDgESGjduBZMOoHBUn0+Hz8e/xqhbnxbfo2vKU
ISyZ3v2M33Nxyh9W8P1/8OjlDzqHcoTuYVWHykVtkAcn3D/HjVnVJzPBNJ3fBbC0
WYt50UDz/+gcbuhO+q1n2RaLvf+cL64GIlK/9zTy33eKSYhsnXkyS7vwQee26VEX
a8KGcvTADopTRb89szUdR1Sddr9gMHRIesJ4FS012HaEH2zs2J//OY4YGA1adoE+
W7k/g3nYYL9uqFpJiOVBDR+oA05lPm/4H/OiNv1cSpkRl1lh4QOS1+PCA970YSzA
DxXKzS/uVF+CZFO9WzExcwOhJgWhhHqEW4RGts82QZQ9AsfQVjq5KCOf0uWiTQsO
uDnRKlK3Qsw29OoOytsZw2/2UAQSCDFgpo1B7dsFfvpJ6NB/5eU9cG7fTT3MI2cX
cO+I/BNDMU9NELbfm9LcFe0PGWw3ndsbeW9yoQGzJ9V3Xxk0UD8QcftAKUivsH2R
xLseqn6ARZKUmNthniGRiaS9x2hJZ3HfjT/4XndOG9lDgn5/jFdMo7ma8YBXzUbH
ng7NSi0M4N1+B+9E8ppVMDgxwm3TbIxePwksmytxUzABI49X/c4ajqu34nhlvSUl
3O/n0G9tu2of0aNFJYhU
=r4Zy
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
