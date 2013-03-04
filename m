Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:10428 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab3CDRYk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 12:24:40 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (josoe mo42) (RZmta 31.19 AUTH)
	with ESMTPA id J070eap24G3Ud3 for <linux-btrfs@vger.kernel.org>;
	Mon, 4 Mar 2013 18:24:36 +0100 (CET)
Message-ID: <5134D8D7.9000501@giantdisaster.de>
Date: Mon, 04 Mar 2013 18:24:39 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] during balance operation, WARNING: at fs/btrfs/relocation.c:1624
 replace_file_extents+0x74b/0x7e0 [btrfs]()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just ran the following command sequence and got lots of WARNINGs.
The issue is reproducible.
The box was running the cmason/for-linus that made it into Linux 3.9 RC1.

#!/bin/sh
mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
mount /dev/sdl /mnt
dd if=/dev/urandom of=/mnt/urandom.1GB bs=10M count=100 &
dd if=/dev/zero of=/mnt/zero.4GB bs=10M count=400 &
(cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
wait

((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
sleep 5
btrfs fi balance start /mnt



btrfs: disk space caching is enabled
btrfs flagging fs with big metadata feature
btrfs: relocating block group 6471811072 flags 17
btrfs: found 1 extents
------------[ cut here ]------------
WARNING: at fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid6_pq xor raid1 mpt2sas scsi_transport_sas raid_class
Pid: 3390, comm: btrfs Not tainted 3.8.0+ #56
Call Trace:
 [<ffffffff810871fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81087245>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eddeb>] replace_file_extents+0x74b/0x7e0 [btrfs]
 [<ffffffffa00c0b63>] ? __set_extent_bit+0x223/0x460 [btrfs]
 [<ffffffffa00f32c6>] btrfs_reloc_cow_block+0x186/0x230 [btrfs]
 [<ffffffffa007ff11>] __btrfs_cow_block+0x391/0x4c0 [btrfs]
 [<ffffffff810e098d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810bf98b>] ? local_clock+0x4b/0x60
 [<ffffffffa008023c>] btrfs_cow_block+0x11c/0x1d0 [btrfs]
 [<ffffffffa00ee4bf>] do_relocation+0x46f/0x530 [btrfs]
 [<ffffffff810e12df>] ? lock_release_holdtime.part.24+0xf/0x180
 [<ffffffffa0088a10>] ? block_rsv_add_bytes+0x50/0x70 [btrfs]
 [<ffffffffa00f178b>] relocate_tree_blocks+0x66b/0x6a0 [btrfs]
 [<ffffffffa00eff88>] ? add_data_references+0x288/0x2c0 [btrfs]
 [<ffffffffa00f26f0>] relocate_block_group+0x430/0x690 [btrfs]
 [<ffffffffa00f2af2>] btrfs_relocate_block_group+0x1a2/0x2e0 [btrfs]
 [<ffffffffa00c8c6c>] btrfs_relocate_chunk.isra.60+0x4c/0x460 [btrfs]
 [<ffffffffa00da6bd>] ? btrfs_tree_read_unlock_blocking+0x5d/0xe0 [btrfs]
 [<ffffffffa00cdfcf>] btrfs_balance+0x8bf/0xe40 [btrfs]
 [<ffffffff81197b57>] ? create_object+0x247/0x300
 [<ffffffffa00d477f>] btrfs_ioctl_balance+0x23f/0x550 [btrfs]
 [<ffffffffa00d8e7f>] btrfs_ioctl+0xc0f/0x1ca0 [btrfs]
 [<ffffffff810b0dee>] ? up_read+0x1e/0x40
 [<ffffffff81982a94>] ? __do_page_fault+0x2d4/0x510
 [<ffffffff811ac8cb>] do_vfs_ioctl+0x8b/0x570
 [<ffffffff810e12df>] ? lock_release_holdtime.part.24+0xf/0x180
 [<ffffffff8197f409>] ? retint_swapgs+0xe/0x13
 [<ffffffff811ace41>] sys_ioctl+0x91/0xb0
 [<ffffffff8144b86e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81986d52>] system_call_fastpath+0x16/0x1b
---[ end trace 6973e65f64077371 ]---


  ret = get_new_location(rc->data_inode, &new_bytenr,
                         bytenr, num_bytes);
  if (ret > 0) {
          WARN_ON(1); <-- line 1624
          continue;
  }
  BUG_ON(ret < 0);

