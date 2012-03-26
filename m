From: Sander <sander@humilis.net>
Subject: kernel BUG at fs/btrfs/extent-tree.c:4263  (due to lost usb
 connection)
Date: Mon, 26 Mar 2012 14:52:55 +0200
Message-ID: <20120326125255.GA23075@attic.humilis.net>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I've just encountered a "kernel BUG at fs/btrfs/extent-tree.c:4263" due
to a usb connection hickup to the storage (so you might as well stop
reading now ;-) )

With google, a lot turns up on "kernel BUG at fs/btrfs/extent-tree.c",
but not on the specific line number, nor on
"PC is at drop_outstanding_extent"
or
"LR is at btrfs_delalloc_release_metadata"

The system is a pandaboard running a plain Linus kernel 3.3.0 with a
btrfs filesystem just created this morning, over two Intel 320 600GB
ssd's, connected via usb (on an usb hub), on top of md_crypt. Mount
options: "subvol=rootvolume,space_cache,inode_cache,compress=lzo,ssd"

It seems the usb hub lost its connection, so it seems perfectly normal
for the system to Oops. I'm reporting this just as a datapoint.

FWIW, the filesystem seems to be just fine after the reboot. A 'scrub'
found 0 errors. I'd say that is pretty neat!

	Sander


[ 8409.792541] ------------[ cut here ]------------
[ 8409.797576] kernel BUG at fs/btrfs/extent-tree.c:4263!
[ 8409.797576] Internal error: Oops - BUG: 0 [#1] SMP
[ 8409.797576] Modules linked in:
[ 8409.809112] CPU: 1    Not tainted  (3.3.0 #8)
[ 8409.815734] PC is at drop_outstanding_extent+0xa/0x44
[ 8409.821044] LR is at btrfs_delalloc_release_metadata+0x39/0x94
[ 8409.827148] pc : [<c010e0e2>]    lr : [<c01138bd>]    psr: 60000133
[ 8409.827148] sp : ed72fe30  ip : 00000000  fp : 00000000
[ 8409.827148] r10: 00001000  r9 : eee13da8  r8 : d3d2c738
[ 8409.827148] r7 : eee13c08  r6 : ed54c800  r5 : 00000000  r4 : 00009fff
[ 8409.851440] r3 : eee13bf0  r2 : 00000000  r1 : 00001000  r0 : eee13da8
[ 8409.858276] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment kernel
[ 8409.863708] Control: 50c5387d  Table: ad50804a  DAC: 00000015
[ 8409.863708] Process btrfs-transacti (pid: 241, stack limit = 0xed72e2f8)
[ 8409.879119] Stack: (0xed72fe30 to 0xed730000)
[ 8409.879119] fe20:                                     eee13da8 00000001 00009000 eee13da8
[ 8409.892242] fe40: ffffffff ed54c800 d3d4c428 d3d2c738 ed658c00 00009000 00000000 c014761d
[ 8409.892242] fe60: d3d4c428 d3d2c738 00000000 00000000 00000000 00000000 ed54c800 d3d4c428
[ 8409.902862] fe80: eee13da8 ed658c00 d3d2c738 c011a283 00000000 00000000 00009000 00000000
[ 8409.902862] fea0: 00009000 00000000 ed72fec8 d3d4c428 ed72fec8 00000000 ffffffff 00000000
[ 8409.902862] fec0: 00000000 00000000 5ecb0000 00000000 00000000 d3d4c428 ed5c303c 00000000
[ 8409.926483] fee0: ed5c3000 ed54c800 00000002 ed5c304c 00000000 c011ed07 00000000 d3c8af54
[ 8409.926483] ff00: ed54c800 ee0f6000 ed653410 00000000 ed5c3000 c0152c2d ed653400 d3c8ae90
[ 8409.952148] ff20: ed653410 ed5c0c00 d3d4c428 d3c8ae90 d3c8af14 d3c8ae98 00000000 000000d5
[ 8409.952148] ff40: 00000000 c011f869 00000000 c011f037 00000000 00000000 00000000 00000000
[ 8409.952148] ff60: ed72da40 c00322e5 ed72ff68 ed72ff68 ed5c0c00 00000000 00000000 ed5c0c00
[ 8409.977813] ff80: 00000033 00000000 00000000 00000000 00000000 c011b473 00000000 ed70bc10
[ 8409.977813] ffa0: ed5c0c00 c011b379 00000033 00000000 ed70bc10 ed5c0c00 c011b379 c0032059
[ 8409.994934] ffc0: ed70bc10 00000000 ed5c0c00 00000000 00000000 dead4ead ffffffff ffffffff
[ 8409.996551] ffe0: ed72ffe0 ed72ffe0 ed70bc10 c003200d c000cd39 c000cd39 00000000 00000000
[ 8410.012054] [<c010e0e2>] (drop_outstanding_extent+0xa/0x44) from [<c01138bd>] (btrfs_delalloc_release_metadata+0x39/0x94)
[ 8410.023559] [<c01138bd>] (btrfs_delalloc_release_metadata+0x39/0x94) from [<c014761d>] (btrfs_write_out_ino_cache+0x55/0x68)
[ 8410.023559] [<c014761d>] (btrfs_write_out_ino_cache+0x55/0x68) from [<c011a283>] (btrfs_save_ino_cache+0x1eb/0x22c)
[ 8410.023559] [<c011a283>] (btrfs_save_ino_cache+0x1eb/0x22c) from [<c011ed07>] (commit_fs_roots+0x6f/0xe0)
[ 8410.051208] [<c011ed07>] (commit_fs_roots+0x6f/0xe0) from [<c011f869>] (btrfs_commit_transaction+0x2cb/0x506)
[ 8410.051208] [<c011f869>] (btrfs_commit_transaction+0x2cb/0x506) from [<c011b473>] (transaction_kthread+0xfb/0x188)
[ 8410.066650] [<c011b473>] (transaction_kthread+0xfb/0x188) from [<c0032059>] (kthread+0x4d/0x60)
[ 8410.066650] [<c0032059>] (kthread+0x4d/0x60) from [<c000cd39>] (kernel_thread_exit+0x1/0x6)
[ 8410.090301] Code: 73dc f8d3 21a4 b902 (de02) 3a01 
[ 8410.100433] ---[ end trace 6b16e1c6e6a2dd9c ]---

-- 
Humilis IT Services and Solutions
http://www.humilis.net
