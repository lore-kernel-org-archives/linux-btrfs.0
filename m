Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3AaNTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 08:19:25 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C883CA51B7
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 14:19:23 +0100 (CET)
Date: Thu, 31 Jan 2013 12:55:58 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [bug, 3.8rc4] failed to load free space cache
Message-ID: <20130131115558.GI30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

followup to http://article.gmane.org/gmane.comp.file-systems.btrfs/22561
where I saw a crash inside btrfs_set_item_key_safe. After reboot, mount
crashed with the messages below. Next reboot and mount was fine. Scrub does not
report any errors.

It may be an unhandled error case after 'failed to load free space cache for
block group'.

[  182.873165] btrfs: disk space caching is enabled                                                                                                                                         [20/9016]
[  183.086153] block group 14029815808 has an wrong amount of free space
[  183.086744] btrfs: failed to load free space cache for block group 14029815808
[  183.145968] btrfs: truncated 17 orphans
[  393.261337] ------------[ cut here ]------------
[  393.263148] WARNING: at fs/btrfs/inode.c:2214 btrfs_orphan_commit_root+0x10a/0x110 [btrfs]()
[  393.265079] Hardware name: Bochs
[  393.265118] Pid: 4647, comm: btrfs-transacti Not tainted 3.8.0-rc4-desktop+ #54
[  393.265119] Call Trace:
[  393.265137]  [<ffffffffa00ff2ea>] ? btrfs_orphan_commit_root+0x10a/0x110 [btrfs]
[  393.265153]  [<ffffffff81048daa>] warn_slowpath_common+0x7a/0xb0
[  393.265156]  [<ffffffff81048df5>] warn_slowpath_null+0x15/0x20
[  393.265168]  [<ffffffffa00ff2ea>] btrfs_orphan_commit_root+0x10a/0x110 [btrfs]
[  393.265181]  [<ffffffffa00f8961>] commit_fs_roots+0xd1/0x1a0 [btrfs]
[  393.265198]  [<ffffffffa00f99d7>] btrfs_commit_transaction+0x4a7/0x920 [btrfs]
[  393.265206]  [<ffffffff8106d830>] ? wake_up_bit+0x40/0x40
[  393.265209]  [<ffffffff8106d830>] ? wake_up_bit+0x40/0x40
[  393.265219]  [<ffffffffa00f4461>] transaction_kthread+0x211/0x220 [btrfs]
[  393.265230]  [<ffffffffa00f4250>] ? __btree_submit_bio_start+0x10/0x10 [btrfs]
[  393.265233]  [<ffffffff8106d026>] kthread+0xc6/0xd0
[  393.265236]  [<ffffffff8106cf60>] ? kthread_freezable_should_stop+0x70/0x70
[  393.265246]  [<ffffffff815f7a7c>] ret_from_fork+0x7c/0xb0
[  393.265249]  [<ffffffff8106cf60>] ? kthread_freezable_should_stop+0x70/0x70
[  393.265250] ---[ end trace da3d2c22c42edd57 ]---
[  573.556339] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[  573.557216] IP: [<ffffffffa00e9060>] block_rsv_release_bytes+0x30/0x1b0 [btrfs]
[  573.557216] PGD be25b1067 PUD be8e4e067 PMD 0
[  573.571247] Oops: 0000 [#1] PREEMPT SMP
[  573.571247] CPU 47
[  573.571247] Pid: 4671, comm: fsx Tainted: G        W    3.8.0-rc4-desktop+ #54 Bochs Bochs
[  573.571247] RIP: 0010:[<ffffffffa00e9060>]  [<ffffffffa00e9060>] block_rsv_release_bytes+0x30/0x1b0 [btrfs]
[  573.571247] RSP: 0018:ffff880be9a01c88  EFLAGS: 00010286
[  573.571247] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000018000
[  573.571247] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
[  573.571247] RBP: ffff880be9a01cb8 R08: 0000000000001000 R09: ffff880be9a01b40
[  573.571247] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000018
[  573.571247] R13: 0000000000018000 R14: 0000000000000000 R15: 0000000000018000
[  573.571247] FS:  00007fbfcd062700(0000) GS:ffff880c1f5e0000(0000) knlGS:0000000000000000
[  573.571247] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  573.571247] CR2: 0000000000000010 CR3: 0000000bebebc000 CR4: 00000000000006e0
[  573.571247] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  573.571247] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  573.571247] Process fsx (pid: 4671, threadinfo ffff880be9a00000, task ffff880be2c10680)
[  573.571247] Stack:
[  573.571247]  ffff880be73c8000 ffff880beb170d38 0000000000000135 ffff880be80af000
[  573.571247]  ffff880be73c8000 0000000000018000 ffff880be9a01cc8 ffffffffa00e9578
[  573.571247]  ffff880be9a01d08 ffffffffa00e9692 0000000000000100 ffff880beb170d38
[  573.571247] Call Trace:
[  573.571247]  [<ffffffffa00e9578>] btrfs_block_rsv_release+0x38/0x40 [btrfs]
[  573.571247]  [<ffffffffa00e9692>] btrfs_orphan_release_metadata+0xe2/0x120 [btrfs]
[  573.571247]  [<ffffffffa00ff36c>] btrfs_orphan_del+0x7c/0xe0 [btrfs]
[  573.571247]  [<ffffffffa0100ece>] btrfs_truncate+0x2be/0x2f0 [btrfs]
[  573.571247]  [<ffffffffa0104c05>] btrfs_setsize+0x145/0x1b0 [btrfs]
[  573.571247]  [<ffffffffa0104d2d>] btrfs_setattr+0xbd/0xd0 [btrfs]
[  573.571247]  [<ffffffff8118f779>] notify_change+0x209/0x370
[  573.571247]  [<ffffffffa00fc100>] ? btrfs_getattr+0x50/0x90 [btrfs]
[  573.571247]  [<ffffffff8117369f>] do_truncate+0x5f/0x90
[  573.571247]  [<ffffffff811737f8>] do_sys_ftruncate+0x128/0x1a0
[  573.571247]  [<ffffffff8117387e>] sys_ftruncate+0xe/0x10
[  573.571247]  [<ffffffff815f7b29>] system_call_fastpath+0x16/0x1b
[  573.571247] Code: 83 ec 30 4c 89 65 e0 4c 8d 66 18 4c 89 6d e8 48 89 7d d0 49 89 cd 48 89 5d d8 4c 89 e7 4c 89 75 f0 4c 89
 7d f8 48 89 f3 49 89 d6 <4c> 8b 7e 10 e8 e7 70 50 e1 49 83 fd ff 74 31 48 8b 03 48 8b 53
[  573.571247] RIP  [<ffffffffa00e9060>] block_rsv_release_bytes+0x30/0x1b0 [btrfs]
[  573.571247]  RSP <ffff880be9a01c88>
[  573.571247] CR2: 0000000000000010
[  573.669394] ---[ end trace da3d2c22c42edd58 ]---

2205         if (root->orphan_item_inserted &&
2206             btrfs_root_refs(&root->root_item) > 0) {
2207                 ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
2208                                             root->root_key.objectid);
2209                 BUG_ON(ret);
2210                 root->orphan_item_inserted = 0;
2211         }
2212
2213         if (block_rsv) {
2214                 WARN_ON(block_rsv->size > 0);
^^^^
2215                 btrfs_free_block_rsv(root, block_rsv);
2216         }
2217 }

(gdb) l *(block_rsv_release_bytes+0x30)
0x22060 is in block_rsv_release_bytes (fs/btrfs/extent-tree.c:4094).
4089
4090    static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
4091                                        struct btrfs_block_rsv *block_rsv,
4092                                        struct btrfs_block_rsv *dest, u64 num_bytes)
4093    {
4094            struct btrfs_space_info *space_info = block_rsv->space_info;
^^^^
4095
4096            spin_lock(&block_rsv->lock);
4097            if (num_bytes == (u64)-1)
4098                    num_bytes = block_rsv->size;

# btrfs fi df /mnt/btrfs/
Data: total=3.00GiB, used=11.36MiB
System, RAID1: total=32.00MiB, used=4.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID1: total=2.00GiB, used=400.00KiB

Excepts from debug-tree where the block group number is mentioned:

(root tree)
leaf 11381215232 items 13 free space 2215 generation 2088 owner 1
fs uuid a15e1f6c-0e19-420e-93e2-82b4aa072a47
chunk uuid 877f29bb-f02a-48e8-b784-e35d1f9f1701
        item 11 key (FREE_SPACE UNTYPED 14029815808) itemoff 2979 itemsize 41
                location key (261 INODE_ITEM 0)
                cache generation 2088 entries 381 bitmaps 0

(extent tree)
leaf 11380310016 items 38 free space 1060 generation 2088 owner 2
fs uuid a15e1f6c-0e19-420e-93e2-82b4aa072a47
chunk uuid 877f29bb-f02a-48e8-b784-e35d1f9f1701
        item 27 key (14029815808 BLOCK_GROUP_ITEM 1073741824) itemoff 2540 itemsize 24
                block group used 10719232 chunk_objectid 256 flags 1

(device tree)
        item 8 key (2 DEV_EXTENT 1048576) itemoff 3603 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 14029815808 length 1073741824

david
