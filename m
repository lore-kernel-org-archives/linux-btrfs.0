Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:38162 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3BAO7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 09:59:11 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 0E6985A691F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 15:59:07 +0100 (CET)
Message-ID: <510BD802.6050203@siedziba.pl>
Date: Fri, 01 Feb 2013 15:58:10 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: IO failure when trying to convert degraded raid1 to single
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Trying to convert degraded raid1 to single...

# mount btrfs0.img /mnt/test -oloop,degraded
# btrfs filesystem balance start -mconvert=single -dconvert=single -f 
/mnt/test

...ends up with:

Btrfs v0.20-rc1-56-g6cd836d
device fsid 88c73405-12f4-4dc8-90f2-71925867d0c5 devid 1 transid 4 
/dev/loop0
btrfs: allowing degraded mounts
btrfs: disk space caching is enabled
btrfs: force reducing metadata integrity
BTRFS error (device loop0) in write_all_supers:3070: IO failure (errors 
while submitting device barriers.)
btrfs is forced readonly
BTRFS warning (device loop0): Skipping commit of aborted transaction.
------------[ cut here ]------------
WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0xb7/0xd0()
Hardware name: Bochs
Pid: 334, comm: btrfs Not tainted 3.6.0+ #1
Call Trace:
  [<c101f4b8>] warn_slowpath_common+0x68/0xa0
  [<c110a0b7>] ? __btrfs_abort_transaction+0xb7/0xd0
  [<c110a0b7>] ? __btrfs_abort_transaction+0xb7/0xd0
  [<c101f54e>] warn_slowpath_fmt+0x2e/0x30
  [<c110a0b7>] __btrfs_abort_transaction+0xb7/0xd0
  [<c11305de>] btrfs_commit_transaction+0xde/0x940
  [<c1111619>] ? btrfs_search_slot+0x3a9/0x7f0
  [<c11508fe>] ? map_private_extent_buffer+0x5e/0xe0
  [<c1129050>] ? btree_set_page_dirty+0x30/0x40
  [<c10630b7>] ? set_page_dirty+0x47/0x50
  [<c114fa4f>] ? set_extent_buffer_dirty+0x6f/0xa0
  [<c1036b50>] ? abort_exclusive_wait+0x60/0x60
  [<c110cc0b>] ? btrfs_free_path+0x1b/0x20
  [<c11524a4>] insert_balance_item+0x494/0x4c0
  [<c1003833>] ? do_IRQ+0x43/0xa0
  [<c1156d16>] btrfs_balance+0x396/0x1030
  [<c101cf0e>] ? kmap_atomic+0xe/0x10
  [<c1060a6c>] ? get_page_from_freelist+0x22c/0x500
  [<c101ce7e>] ? kmap_atomic_prot+0x3e/0xc0
  [<c107d66a>] ? kmem_cache_alloc+0x5a/0xf0
  [<c115d88d>] ? btrfs_ioctl_balance+0x13d/0x430
  [<c115d816>] btrfs_ioctl_balance+0xc6/0x430
  [<c1160940>] ? update_ioctl_balance_args+0x420/0x420
  [<c116128f>] btrfs_ioctl+0x94f/0x1830
  [<c1076736>] ? anon_vma_prepare+0xb6/0x110
  [<c1064c8d>] ? lru_cache_add_lru+0x1d/0x40
  [<c1075fdc>] ? page_add_new_anon_rmap+0x6c/0x80
  [<c101c05e>] ? pte_alloc_one+0x1e/0x40
  [<c1160940>] ? update_ioctl_balance_args+0x420/0x420
  [<c108f456>] do_vfs_ioctl+0x76/0x570
  [<c10192b3>] ? do_page_fault+0x173/0x410
  [<c1073969>] ? do_brk+0x1a9/0x2d0
  [<c108f97d>] sys_ioctl+0x2d/0x60
  [<c1221a45>] syscall_call+0x7/0xb
---[ end trace b997a9531fdaebad ]---
BTRFS error (device loop0) in cleanup_transaction:1378: IO failure
delayed_refs has NO entry

Kernel and tools compiled from git.

I also uploaded my minimal qemu setup, which I use to experiment with btrfs:
http://pp.siedziba.pl/tmp/linux-btrfs-qemu.tar.xz (execute start.sh to 
run qemu, then test.sh script to trigger the error)

Regards
