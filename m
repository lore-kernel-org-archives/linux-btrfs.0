Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:57658 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3G3JHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 05:07:39 -0400
Date: Tue, 30 Jul 2013 11:07:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thorsten Glaser <tg@mirbsd.de>
cc: Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: btrfs zero divide (was: Re: Linux 3.10 problem reports (yes,
 plural))
In-Reply-To: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
Message-ID: <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 30 Jul 2013, Thorsten Glaser wrote:
> NEW problem: btrfs doesn’t work at all. I had to reboot my
> buildd into 3.2 using echo s/u/s/o >/proc/sysrq-trigger as
> the attempt to mount it left the system hanging there.

> [    0.000000] Linux version 3.10-1-m68k (debian-kernel@lists.debian.org) (gcc version 4.8.1 (Debian 4.8.1-7+m68k.1) ) #1 Debian 3.10.3-1 (2013-07-27)

> [    6.720000] bio: create slab <bio-1> at 1
> [    6.740000] Btrfs loaded
> [    6.830000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> [    7.150000] EXT4-fs (nfhd8p1): mounted filesystem with ordered data mode. Opts: (null)
> [   14.520000] udevd[228]: starting version 175
> [   17.820000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> [   20.850000] Adding 3670012k swap on /dev/nfhd8p2.  Priority:-1 extents:1 across:3670012k
> [   21.380000] EXT4-fs (nfhd8p1): re-mounted. Opts: (null)
> [   31.300000] EXT4-fs (nfhd8p1): re-mounted. Opts: errors=remount-ro
> [   38.460000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> [   38.530000] btrfs: setting nodatacow, compression disabled
> [   38.540000] btrfs: enabling auto recovery
> [   38.570000] btrfs: disk space caching is enabled
> [   38.600000] *** ZERO DIVIDE ***   FORMAT=2
> [   38.630000] Current process id is 722
> [   38.660000] BAD KERNEL TRAP: 00000000
> [   38.680000] Modules linked in: evdev mac_hid ext4 crc16 jbd2 mbcache btrfs xor lzo_compress zlib_deflate raid6_pq crc32c libcrc32c
> [   38.730000] PC: [<319535b2>] __btrfs_map_block+0x11c/0x119a [btrfs]

Woops, adding the btrfs devs to CC.

> [   38.770000] SR: 2000  SP: 30c1fab4  a2: 30f0faf0
> [   38.800000] d0: 00000000    d1: 00001000    d2: 00000000    d3: 00000000
> [   38.830000] d4: 00010000    d5: 00000000    a0: 3085c72c    a1: 3085c72c
> [   38.850000] Process mount (pid: 722, task=30f0faf0)
> [   38.870000] Frame format=2 instr addr=319535ae
> [   38.880000] Stack from 30c1faec:
> [   38.880000]         00000000 00000020 00000000 00001000 00000000 01401000 30253928 300ffc00
> [   38.880000]         00a843ac 3026f640 00000000 00010000 0009e250 00d106c0 00011220 00000000
> [   38.880000]         00001000 301c6830 0009e32a 000000ff 00000009 3085c72c 00000000 00000000
> [   38.880000]         30c1fd14 00000000 00000020 00000000 30c1fd14 0009e26c 00000020 00000003
> [   38.880000]         00000000 0009dd8a 300b0b6c 30253928 00a843ac 00001000 00000000 00000000
> [   38.880000]         0000a008 3194e76a 30253928 00a843ac 00001000 00000000 00000000 00000002
> [   39.190000] Call Trace: [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.210000]  [<00010000>] res_func+0x1020/0x141a
> [   39.250000]  [<0009e250>] bvec_alloc+0xa2/0xbe
> [   39.270000]  [<00011220>] sasin+0x87c/0x944
> [   39.290000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.330000]  [<0009e32a>] bio_alloc_bioset+0xbe/0x12e
> [   39.360000]  [<0009e26c>] bio_alloc_bioset+0x0/0x12e
> [   39.380000]  [<0009dd8a>] bio_add_page+0x4a/0x58
> [   39.420000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.470000]  [<0000a008>] via_nubus_irq+0x1c/0xa2
> [   39.500000]  [<3194e76a>] submit_extent_page.isra.44+0x170/0x1bc [btrfs]
> [   39.530000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.560000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.600000]  [<31959778>] btrfs_map_bio+0x60/0x48c [btrfs]
> [   39.630000]  [<31931b72>] btree_submit_bio_hook+0x0/0xae [btrfs]
> [   39.660000]  [<3194eaa0>] end_bio_extent_readpage+0x0/0x69c [btrfs]
> [   39.710000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   39.730000]  [<31931944>] btrfs_bio_wq_end_io+0x16/0x50 [btrfs]
> [   39.760000]  [<31931bce>] btree_submit_bio_hook+0x5c/0xae [btrfs]
> [   39.780000]  [<3194bd36>] submit_one_bio+0x7c/0xb2 [btrfs]
> [   39.810000]  [<3194f174>] __extent_read_full_page+0x0/0x70a [btrfs]
> [   39.830000]  [<00058828>] unlock_page+0x0/0x26
> [   39.840000]  [<31951736>] read_extent_buffer_pages+0x1a8/0x218 [btrfs]
> [   39.890000]  [<00027d81>] devkmsg_read+0x213/0x39a
> [   39.930000]  [<31959006>] btrfs_num_copies+0x0/0x142 [btrfs]
> [   39.970000]  [<31930a66>] btree_read_extent_buffer_pages.constprop.52+0x42/0xca [btrfs]
> [   40.030000]  [<3192f7c2>] btree_get_extent+0x0/0x102 [btrfs]
> [   40.060000]  [<00027d81>] devkmsg_read+0x213/0x39a
> [   40.090000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   40.100000]  [<3193221e>] read_tree_block+0x38/0x48 [btrfs]
> [   40.130000]  [<00027d81>] devkmsg_read+0x213/0x39a
> [   40.140000]  [<319321e6>] read_tree_block+0x0/0x48 [btrfs]
> [   40.170000]  [<31933d00>] open_ctree+0xe80/0x15e6 [btrfs]
> [   40.200000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   40.220000]  [<00027d81>] devkmsg_read+0x213/0x39a
> [   40.230000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   40.260000]  [<000f280a>] resource_string.isra.12+0x2b4/0x2ee
> [   40.280000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   40.320000]  [<00001000>] kernel_pg_dir+0x0/0x1000
> [   40.350000]  [<000e59ba>] disk_name+0x72/0x80
> [   40.360000]  [<0000aff0>] mac_hwclk.part.0+0xe6/0x174
> [   40.390000]  [<31913ede>] btrfs_mount+0x450/0x73e [btrfs]
> [   40.410000]  [<00006ff0>] amiga_get_hardware_list+0x19e/0x44a
> [   40.460000]  [<0007acc0>] __kmalloc+0x14/0xac
> [   40.500000]  [<000675c6>] kstrdup+0x36/0x48
> [   40.530000]  [<0007fae4>] mount_fs+0x1c/0xc8
> [   40.560000]  [<0008fec8>] vfs_kern_mount+0x44/0xbe
> [   40.580000]  [<0008f55c>] put_filesystem+0x0/0x10
> [   40.620000]  [<00085e7e>] kern_path+0x0/0x3c
> [   40.640000]  [<00091a96>] do_mount+0x61e/0x6e0
> [   40.670000]  [<0007a73e>] kfree+0x0/0xa2
> [   40.680000]  [<0009144a>] copy_mount_string+0x0/0x2e
> [   40.700000]  [<00091bd0>] SyS_mount+0x78/0xb0
> [   40.730000]  [<00002614>] syscall+0x8/0xc
> [   40.750000]  [<0008c018>] __d_move+0x46/0x1a8
> [   40.770000]
> [   40.790000] Code: 222e ff74 2a2e ff5c 2c2e ff60 4c45 1402 <2d40> ff64 2d41 ff68 2205 4c2e 1800 ff68 4c04 0800 2041 d1c0 2206 4c2e 1400 ff68
> [   40.830000] Disabling lock debugging due to kernel taint

   0:	222e ff74      	movel %fp@(-140),%d1
   4:	2a2e ff5c      	movel %fp@(-164),%d5
   8:	2c2e ff60      	movel %fp@(-160),%d6
   c:	4c45 1402     <	divul %d5,%d2,%d1 >
  10:	2d40 ff64      	movel %d0,%fp@(-156)
  14:	2d41 ff68      	movel %d1,%fp@(-152)
  18:	2205           	movel %d5,%d1
  1a:	4c2e 1800 ff68 	mulsl %fp@(-152),%d1
  20:	4c04 0800      	mulsl %d4,%d0
  24:	2041           	moveal %d1,%a0
  26:	d1c0           	addal %d0,%a0
  28:	2206           	movel %d6,%d1
  2a:	4c2e 1400 ff68 	mulul %fp@(-152),%d0,%d1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
