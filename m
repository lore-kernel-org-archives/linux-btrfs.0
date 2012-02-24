From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Date: Fri, 24 Feb 2012 16:11:29 +0530
Message-ID: <4F476959.2010400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
	kamalesh@linux.vnet.ibm.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While working with 'fsfuzz - file system fuzzing tool' on 'btrfs' 
encountered the following kernel bug.

Environment:
Kernel Version: 3.3.0-rc4
Architecture: s390, x86

Providing the kernel trace from 's390' arch.

Btrfs loaded
device fsid 346683e8-0fcc-4440-b421-4535e73d60d6 devid 1 transid 4 
/dev/loop0
btrfs: disk space caching is enabled
unable to find logical 131072 len 4096
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3638!
illegal operation: 0001 [#1] SMP
Modules linked in: btrfs zlib_deflate crc32c libcrc32c loop dm_multipath 
dm_mod qeth_l3 ipv6 vmur dasd_eckd_mod dasd_mod scsi_dh_hp_sw 
scsi_dh_alua scsi_dh_rdac scsi_dh_emc scsi_dh scsi_mod qeth qdio 
ccwgroup ext3 mbcache jbd
CPU: 0 Not tainted 3.3.0-rc4-0.27-default #1
Process mount (pid: 2396, task: 000000003f176738, ksp: 0000000002ab7648)
Krnl PSW : 0704300180000000 000003e004c10e08 
(__btrfs_map_block+0x794/0x8cc [btrfs])
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:3 PM:0 EA:3
Krnl GPRS: 0000000000010000 0700000000000008 000000000000002d 
0400000000000000
            00000000004d3f26 00000000004e21a8 0000000002ab7828 
0000000002130d00
            000000003ee5ed90 000000003e962108 0000000000020000 
000000003e962110
            000003e004bb0000 000003e004c4c990 000003e004c10e04 
0000000002ab7620
Krnl Code: 000003e004c10df8: e34050000004       lg      %r4,0(%r5)
            000003e004c10dfe: c0e5fffcfb87       brasl   %r14,3e004bb050c
           #000003e004c10e04: a7f40001           brc     15,3e004c10e06
 >000003e004c10e08: a7f40000           brc     15,3e004c10e08
            000003e004c10e0c: 12bb               ltr     %r11,%r11
            000003e004c10e0e: a7c4ffb7           brc     12,3e004c10d7c
            000003e004c10e12: e31090200004       lg      %r1,32(%r9)
            000003e004c10e18: d507d0001078       clc     0(8,%r13),120(%r1)
Call Trace:
([<000003e004c10e04>] __btrfs_map_block+0x790/0x8cc [btrfs])
  [<000003e004c10f6e>] btrfs_map_block+0x2e/0x3c [btrfs]
  [<000003e004c11db4>] btrfs_map_bio+0x74/0x2ac [btrfs]
  [<000003e004be13c6>] btree_submit_bio_hook+0xd6/0xf0 [btrfs]
  [<000003e004c06b4c>] submit_one_bio+0xb4/0xf8 [btrfs]
  [<000003e004c0e292>] read_extent_buffer_pages+0x292/0x630 [btrfs]
  [<000003e004bddd0c>] btree_read_extent_buffer_pages+0xc8/0xfc [btrfs]
  [<000003e004bdf488>] read_tree_block+0x48/0x7c [btrfs]
  [<000003e004be30d6>] open_ctree+0xec6/0x15f8 [btrfs]
  [<000003e004bbb7d8>] btrfs_fill_super+0x90/0x170 [btrfs]
  [<000003e004bbbefa>] btrfs_mount+0x3ea/0x3f8 [btrfs]
  [<0000000000260b96>] mount_fs+0x5a/0x188
  [<00000000002852e6>] vfs_kern_mount+0x6e/0x11c
  [<0000000000285442>] do_kern_mount+0x52/0x114
  [<000000000028573c>] do_mount+0x238/0x288
  [<000000000028584e>] SyS_mount+0xc2/0xf0
  [<00000000004d7d88>] sysc_noemu+0x22/0x28
  [<000003fffd1fab1e>] 0x3fffd1fab1e
Last Breaking-Event-Address:
  [<000003e004c10e04>] __btrfs_map_block+0x790/0x8cc [btrfs]

---[ end trace 1e786b24696895a8 ]---


Steps to reproduce:
# mount <mangled file system image> <mount point> -t btrfs -o loop

Please let me know if you need more information. Thanks in advance.

Regards
R.Nageswara Sastry
