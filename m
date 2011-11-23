From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: mounting btrfs FS on zfs zvol hangs
Date: Wed, 23 Nov 2011 16:21:58 +0000
Message-ID: <20111123162158.GA4245@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, zfs-devel@zfsonlinux.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

yes, you'll probably think that is crazy, but after observing
better performance with btrfs in some work loads on md RAID5
than btrfs builtin RAID10, I thought I'd try btrfs on zfs
(in-kernel, not fuse) zvol (on raidz) just for a laugh.

While this procedure worked for ext4 and xfs, for btrfs, the
mount hangs suggesting there might be something wrong with btrfs
and/or zfs.

Here's what I'm doing:

zpool create X raidz /dev/sd{a,b,c,d,e,f}
zfs create -V 6T -o refreservation=0 X/Y
mkfs.btrfs /dev/zvol/X/Y
mount /dev/zvol/X/Y /mnt

backtrace for mount:

mount           D 0000000000000009     0  2193   1761 0x00000000
 ffff880401b4d9a8 0000000000000082 0000000000000001 0000000000000000
 ffff880401b4dfd8 ffff880401b4dfd8 ffff880401b4dfd8 0000000000012a40
 ffff8802092f0000 ffff88040ef7dc80 ffff880401b4d988 ffff88041fa732c0
Call Trace:
 [<ffffffff81109af0>] ? __lock_page+0x70/0x70
 [<ffffffff81056e9f>] schedule+0x3f/0x60
 [<ffffffff815e85af>] io_schedule+0x8f/0xd0
 [<ffffffff81109afe>] sleep_on_page+0xe/0x20
 [<ffffffff815e8dcf>] __wait_on_bit+0x5f/0x90
 [<ffffffff81109c68>] wait_on_page_bit+0x78/0x80
 [<ffffffff81081d80>] ? autoremove_wake_function+0x40/0x40
 [<ffffffffa041ab7a>] read_extent_buffer_pages+0x3ca/0x430 [btrfs]
 [<ffffffffa03eec40>] ? btrfs_destroy_pinned_extent+0xb0/0xb0 [btrfs]
 [<ffffffffa03f0daa>] btree_read_extent_buffer_pages.isra.62+0x8a/0xc0 [btrfs]
 [<ffffffffa03f2021>] read_tree_block+0x41/0x60 [btrfs]
 [<ffffffffa03f4735>] open_ctree+0xe75/0x1760 [btrfs]
 [<ffffffff812f2f64>] ? snprintf+0x34/0x40
 [<ffffffffa03d1438>] btrfs_fill_super.isra.38+0x78/0x150 [btrfs]
 [<ffffffff811cf55a>] ? disk_name+0xba/0xc0
 [<ffffffff812efbd7>] ? strlcpy+0x47/0x60
 [<ffffffffa03d2806>] btrfs_mount+0x3c6/0x470 [btrfs]
 [<ffffffff8116ae13>] mount_fs+0x43/0x1b0
 [<ffffffff8118565a>] vfs_kern_mount+0x6a/0xc0
 [<ffffffff81186a54>] do_kern_mount+0x54/0x110
 [<ffffffff811884f4>] do_mount+0x1a4/0x260
 [<ffffffff81188990>] sys_mount+0x90/0xe0
 [<ffffffff815f27c2>] system_call_fastpath+0x16/0x1b

3.0.0-13-generic #22-Ubuntu SMP Wed Nov 2 13:27:26 UTC 2011
x86_64

Best regards,
Stephane
