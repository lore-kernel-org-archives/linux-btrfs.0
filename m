Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2EVQyy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 12:54:54 -0400
Subject: warnings met in introduce extent buffer cache for each i-node patch
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 May 2012 09:54:54 -0700
Message-ID: <1337705694.3796.181.camel@schen9-DESK>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao,

I was trying out your patch on scalability testing for BTRFS on v3.3
kernel.
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg14930.html

However, I ran into a lot of warnings (see the dmesg below).  Wonder if
you have a more up to date version of this patch?

In addition, I have to do this modification to fix a warning in your
original patch.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 892b347..e0210c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4608,7 +4613,7 @@ fail_dir_item:
                int err;

                err = btrfs_del_inode_ref(trans, root, name, name_len,
-                                         ino, parent_ino, &local_index);
+                                         inode, parent_ino, &local_index);
        }
        return ret;
 }

Thanks.
Tim


May 22 09:23:57 bigbox kernel: [56455.532138] ------------[ cut here ]------------
May 22 09:23:57 bigbox kernel: [56455.532146] NG: at fs/btrfs/extent_io.c:3795 free_extent_buffer+0x31/6455.532189] Hardware name: PRIMEQUEST 1800E2
May 22 09:23:57 bigbox kernel: [56455.53nked in: scsi_ram lockd nf_conntrack_ipv4 nf_defrag_ipv4 xtfat ioatdma i2c_i801 i7core_edac e1000e microcode edac_core i2c_core igb iTCO_wdt iTCO_vendor_support dca uinput sunrpc usb_stortsas mptscsih mptbase scsi_transport_sas [last unloaded: scsi_wait_sca55.532431] Pid: 4399, comm: btrfs-endio-wri Tainted: G        W    3.3.0c-scsiram-btrfs2+ #30
May 22 09:23:57 bigbox kernel: [56455.532486] Call Trace:
May 22 09:23:57 bigbox kernel: [56455. [<ffffffff8105471f>] warn_slowpath_common+0x7f/0xc0
May 22 09:23:57 bigbox kernel: [5645]  [<ffffffff8105477a>] warn_slowpath_null+0x1a/0x20
May 22 09:23:57 bigbox kernel: [56455.53220]  [<ffffffff813004b1>] free_extent_buffer+0x31/0x40
May 22 09:23:57 bigbox kernel: ]  [<ffffffff812c0f97>] read_block_for_search+0x117/0x3d0
May 22 09:23:57 bigbox kernel: 32559]  [<ffffffff812c0857>] ? generic_bin_search.constprop.4+0[<ffffffff812be27d>] ? unlock_up+0x15d/0x190
May 22 09:23:57 bigbox kernel: [56455.5ffff812c31c1>] btrfs_search_slot+0x241/0x720
May 22 09:23:57 bigbox kernel: [56455.5326fff812c3adc>] btrfs_search_slot_for_inode+0x43c/0x910
May 22 09:23:57 bigbox kernel: [56455.532fffffff812d5f04>] btrfs_lookup_file_extent+0x54/0x70
May 22 09:23:57 bigbox kernel: [56455.532646ffff812f097c>] btrfs_drop_extents+0xec/0x940
May 22 09:23:57 bigbox kernel: [56455.532662] fff81084eec>] ? try_to_wake_up+0x1bc/0x2b0
May 22 09:23:57 bigbox kernel: [56455.53268 [<ffffffff812facef>] ? set_state_bits+0x3f/0x80
May 22 09:23:57 bigbox kernel: [56455fff8116228c>] ? kmem_cache_alloc+0x10c/0x140
May 22 09:23:57 bigbox kernel: [56455.532713]  [<ffffffff812be2ca>] ? btrfs_alloc_path+0x1a/0x20
May 22 09:23:57 bigbox kernel: [5645532]  [<ffffffff812e3713>] insert_reserved_file_extent.constpr13+0x73/0x270
May 22 09:23:57 bigbox kernel: [56455.532746]  [<ffffffff812df6eb>] ? join_transactio0x2b/0x2b0
May 22 09:23:57 bigbox kernel: [56455.532759]  [<ffffffff812e1224>] ? start_transaction+0x94/0x320
May 22 09:23:57 bigbox kernel: [56455.532774]  [<ffffffff812e6cca>] btrfinish_ordered_io+0x2ca/0x320
May 22 09:23:57 bigbox kernel: [56455.532793]  [<ffffffff812e6d6d>age_end_io_hook+0x4d/0xc0
May 22 09:23:57 bigbox kernel: [56455.532813]  [<ffffffff812fed>] <ffffffff811a94ef>] ? bio_free+0x5f/0x70
May 22 09:23:57 bigbox kernel: [56455.532837] fff811a817d>] bio_endio+0x1d/0x40
May 22 09:23:57 bigbox kernel: [56455.532869]  [<ffffffff812d9846>] end_workqueue_fn+0x56/0x140
May 22 09:23:57 bigbox kernel: [56455.532886]  [<ffffffff8130aeb8>] worker_loop+0x148/0x580
May 22 09:23:57 bigbox kernel: [56455.532898]  [<ffffffff8130ad70>] ? btrfs_queue_worker+0x2e0/0x2e0
May 22 09:23:57 bigbox kernel: [56455.532915]  [<ffffffff81076473>] kthread+0x93/0xa0
May 22 09:23:57 bigbox kernel: [56455.532929]  [<ffffffff81678be4>] kernel_thread_helper+0x4/0x10
May 22 09:23:57 bigbox kernel: [56455.532944]  [<fffffffff3/0x13
May 22 09:23:57 bigbox kernel: [56455.532972] ---[ end trace a7919e7f17c42adb ]---
May 22 09:23:57 bigbox kernel: [56455.532985] ------------[ cut here ]------------


