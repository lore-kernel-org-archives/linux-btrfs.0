Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:47265 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961Ab3HHUFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 16:05:12 -0400
Date: Thu, 8 Aug 2013 20:01:34 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
To: Joe Perches <joe@perches.com>
cc: Josef Bacik <jbacik@fusionio.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
In-Reply-To: <1375218347.2075.133.camel@joe-AO722>
Message-ID: <Pine.BSM.4.64L.1308081947410.20073@herc.mirbsd.org>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>  <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
  <20130730204001.GG24583@localhost.localdomain> <1375218347.2075.133.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tl;dr: we got the faulty code pinned down, it's m68k specific,
except the m68k specific part didn’t change from 3.2…


Joe Perches dixit:

>Something like this maybe. (uncompiled/untested)

I tried this:

--- div64.h.orig	2013-08-08 19:34:32.663540965 +0000
+++ -	2013-08-08 19:47:30.309776791 +0000
@@ -6,6 +6,8 @@
 #else

 #include <linux/types.h>
+#include <linux/bug.h>
+#include <linux/printk.h>

 /* n = n / base; return rem; */

@@ -16,6 +18,11 @@
 	} __n;							\
 	unsigned long __rem, __upper;				\
 								\
+if (base == 0) { \
+WARN(1, "Attempted division by 0\n"); \
+dump_stack(); \
+__rem = 0; \
+} else { \
 	__n.n64 = (n);						\
 	if ((__upper = __n.n32[0])) {				\
 		asm ("divul.l %2,%1:%0"				\
@@ -26,6 +33,7 @@
 		: "=d" (__n.n32[1]), "=d" (__rem)		\
 		: "d" (base), "1" (__upper), "0" (__n.n32[1]));	\
 	(n) = __n.n64;						\
+} \
 	__rem;							\
 })



It didn’t trigger, apparently:

[817508.370000] bio: create slab <bio-1> at 1
[817508.510000] Btrfs loaded
[817524.110000] loop: module loaded
[817534.860000] device fsid 01cfa645-5cde-4e4c-9b0b-df7b37bdc495 devid 1 transid 4 /dev/loop0
[817534.860000] btrfs: disk space caching is enabled
[817534.860000] *** ZERO DIVIDE ***   FORMAT=2
[817534.860000] Current process id is 32312
[817534.860000] BAD KERNEL TRAP: 00000000
[817534.860000] Modules linked in: loop btrfs lzo_compress zlib_deflate raid6_pq crc32c libcrc32c xor ipv6 evdev mac_hid ext3 mbcache jbd [last unloaded: btrfs]
[817534.860000] PC: [<31c46612>] __btrfs_map_block+0x134/0x147a [btrfs]
[817534.860000] SR: 2000  SP: 0249fab0  a2: 3010f660
[817534.860000] d0: 00000000    d1: 00022000    d2: 00000000    d3: 00000000
[817534.860000] d4: 00010000    d5: 00010000    a0: 021777a4    a1: 021777a4
[817534.860000] Process mount (pid: 32312, task=3010f660)
[817534.860000] Frame format=2 instr addr=31c4660e
[817534.860000] Stack from 0249fae8:
        00000000 00000020 00000000 00001000 00000000 00022000 0766a928 07621800
        00415d84 00000070 077a97c0 00000070 0249fb68 0009e250 00d106c0 00011220
        00000070 00000020 00000000 00022000 000000ff 00000009 00001000 00000000
        00000000 021777a4 00000000 00000020 00000000 0249fd14 0009e26c 00000020
        00000003 00000000 0009dd8a 3007c02c 0766a928 00415d84 00001000 00000000
        00000000 00000110 31c417ae 0766a928 00415d84 00001000 00000000 00000000
[817534.860000] Call Trace: [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.860000]  [<0009e250>] bvec_alloc+0xa2/0xbe
[817534.860000]  [<00011220>] sasin+0x87c/0x944
[817534.860000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.860000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<0009e26c>] bio_alloc_bioset+0x0/0x12e
[817534.860000]  [<0009dd8a>] bio_add_page+0x4a/0x58
[817534.860000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<31c417ae>] submit_extent_page.isra.44+0x170/0x1bc [btrfs]
[817534.860000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<31c4cbfe>] btrfs_map_bio+0x60/0x48c [btrfs]
[817534.860000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.860000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.860000]  [<31c24bb2>] btree_submit_bio_hook+0x0/0xae [btrfs]
[817534.860000]  [<31c41ae4>] end_bio_extent_readpage+0x0/0x69c [btrfs]
[817534.860000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.860000]  [<31c24984>] btrfs_bio_wq_end_io+0x16/0x50 [btrfs]
[817534.860000]  [<31c24c0e>] btree_submit_bio_hook+0x5c/0xae [btrfs]
[817534.870000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.870000]  [<31c3ed7a>] submit_one_bio+0x7c/0xb2 [btrfs]
[817534.870000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.870000]  [<31c421b8>] __extent_read_full_page+0x0/0x70a [btrfs]
[817534.870000]  [<00058828>] unlock_page+0x0/0x26
[817534.870000]  [<31c44780>] read_extent_buffer_pages+0x1a8/0x218 [btrfs]
[817534.880000]  [<31c4c3b2>] btrfs_num_copies+0x0/0x142 [btrfs]
[817534.880000]  [<31c23aa6>] btree_read_extent_buffer_pages.constprop.52+0x42/0xca [btrfs]
[817534.880000]  [<31c22802>] btree_get_extent+0x0/0x102 [btrfs]
[817534.880000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.880000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.880000]  [<31c2525e>] read_tree_block+0x38/0x48 [btrfs]
[817534.880000]  [<31c25226>] read_tree_block+0x0/0x48 [btrfs]
[817534.890000]  [<31c26d40>] open_ctree+0xe80/0x15e6 [btrfs]
[817534.890000]  [<00022000>] _060_fpsp_effadd+0xb2c0/0xd518
[817534.890000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.890000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.890000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.890000]  [<00001000>] kernel_pg_dir+0x0/0x1000
[817534.890000]  [<000e0000>] blk_stack_limits+0x54/0x2ec
[817534.890000]  [<0000af71>] mac_hwclk.part.0+0x67/0x174
[817534.890000]  [<31c06ede>] btrfs_mount+0x450/0x73e [btrfs]
[817534.900000]  [<0007acc0>] __kmalloc+0x14/0xac
[817534.900000]  [<000675c6>] kstrdup+0x36/0x48
[817534.900000]  [<0007fae4>] mount_fs+0x1c/0xc8
[817534.900000]  [<0008fec8>] vfs_kern_mount+0x44/0xbe
[817534.900000]  [<0008f55c>] put_filesystem+0x0/0x10
[817534.900000]  [<00085e7e>] kern_path+0x0/0x3c
[817534.900000]  [<00091a96>] do_mount+0x61e/0x6e0
[817534.900000]  [<0007a73e>] kfree+0x0/0xa2
[817534.900000]  [<0009144a>] copy_mount_string+0x0/0x2e
[817534.900000]  [<00091bd0>] SyS_mount+0x78/0xb0
[817534.900000]  [<00002614>] syscall+0x8/0xc
[817534.900000]  [<0008c018>] __d_move+0x46/0x1a8
[817534.900000]
[817534.900000] Code: 2400 6704 4c46 0002 222e ff7c 4c46 1402 <2d40> ff68 2d41 ff6c 2006 4c2e 0800 ff6c 222e ff68 4c04 1800 2041 d1c0 222e ff6c
[817534.900000] Disabling lock debugging due to kernel taint

This is stdio of what I did:

root@ara3:~ # dd if=/dev/zero of=/butter bs=1048576 count=128
128+0 records in
128+0 records out
134217728 bytes (134 MB) copied, 14.6502 s, 9.2 MB/s
root@ara3:~ # modprobe btrfs
root@ara3:~ # losetup /dev/loop0 /butter
root@ara3:~ # mkfs.btrfs /dev/loop0

WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

SMALL VOLUME: forcing mixed metadata/data groups
Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/loop0
        nodesize 4096 leafsize 4096 sectorsize 4096 size 128.00MB
Btrfs v0.20-rc1
root@ara3:~ # mount -t btrfs /dev/loop0 /mnt
Segmentation fault
139|root@ara3:~ # lsmod | fgrep btrfs
btrfs                 585560  2
lzo_compress            1510  1 btrfs
zlib_deflate           15039  1 btrfs
raid6_pq               82747  1 btrfs
libcrc32c                698  1 btrfs
xor                     5048  1 btrfs
root@ara3:~ # dpkg -l | fgrep btrfs
ii  btrfs-tools                        0.19+20130315-5              m68k         Checksumming Copy on Write Filesystem utilities

An rmmod at this point does not work, with -f it does.
This gives more backtraces.


Ooooookay now I’ve done this:

[…]
#if 1 /*def CONFIG_CPU_HAS_NO_MULDIV64*/
#include <asm-generic/div64.h>
#else
[…]

And get:

root@ara3:~ # losetup /dev/loop1 /butter
root@ara3:~ # mount -t btrfs /dev/loop1 /mnt2
[817960.710000] bio: create slab <bio-1> at 1
[817960.710000] Btrfs loaded
[817994.120000] device fsid 01cfa645-5cde-4e4c-9b0b-df7b37bdc495 devid 1 transid 4 /dev/loop1
[817994.120000] btrfs: disk space caching is enabled

I can also write there.

So, my apologies to the btrfs people and a confirmation
that your guess seems to have been right at first. The
machdep division code appears to be faulty.

On the other hand, the code didn’t change from 3.2 only
the condition, but we used the asm code in 3.2 already.
So either btrfs changed to use do_div more now, or it
misuses it (e.g. two 64-bit numbers) and that is not
cought by the macro, or it’s a byproduct of us moving
to gcc-4.8 and new binutils.

Geert et al. is there anything that we can do about this?

Thanks,
//mirabilos
-- 
FWIW, I'm quite impressed with mksh interactively. I thought it was much
*much* more bare bones. But it turns out it beats the living hell out of
ksh93 in that respect. I'd even consider it for my daily use if I hadn't
wasted half my life on my zsh setup. :-) -- Frank Terbeck in #!/bin/mksh
