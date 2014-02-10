Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaBJJH0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 04:07:26 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1A97Pe9028120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:07:26 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1A97OJ7005429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:07:25 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1A97Olf019870
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 09:07:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix possible deadlock in btrfs_cleanup_transaction
Date: Mon, 10 Feb 2014 17:07:16 +0800
Message-Id: <1392023236-25797-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[13654.480669] ======================================================
[13654.480905] [ INFO: possible circular locking dependency detected ]
[13654.481003] 3.12.0+ #4 Tainted: G        W  O
[13654.481060] -------------------------------------------------------
[13654.481060] btrfs-transacti/9347 is trying to acquire lock:
[13654.481060]  (&(&root->ordered_extent_lock)->rlock){+.+...}, at: [<ffffffffa02d30a1>] btrfs_cleanup_transaction+0x271/0x570 [btrfs]
[13654.481060] but task is already holding lock:
[13654.481060]  (&(&fs_info->ordered_root_lock)->rlock){+.+...}, at: [<ffffffffa02d3015>] btrfs_cleanup_transaction+0x1e5/0x570 [btrfs]
[13654.481060] which lock already depends on the new lock.

[13654.481060] the existing dependency chain (in reverse order) is:
[13654.481060] -> #1 (&(&fs_info->ordered_root_lock)->rlock){+.+...}:
[13654.481060]        [<ffffffff810c4103>] lock_acquire+0x93/0x130
[13654.481060]        [<ffffffff81689991>] _raw_spin_lock+0x41/0x50
[13654.481060]        [<ffffffffa02f011b>] __btrfs_add_ordered_extent+0x39b/0x450 [btrfs]
[13654.481060]        [<ffffffffa02f0202>] btrfs_add_ordered_extent+0x32/0x40 [btrfs]
[13654.481060]        [<ffffffffa02df6aa>] run_delalloc_nocow+0x78a/0x9d0 [btrfs]
[13654.481060]        [<ffffffffa02dfc0d>] run_delalloc_range+0x31d/0x390 [btrfs]
[13654.481060]        [<ffffffffa02f7c00>] __extent_writepage+0x310/0x780 [btrfs]
[13654.481060]        [<ffffffffa02f830a>] extent_write_cache_pages.isra.29.constprop.48+0x29a/0x410 [btrfs]
[13654.481060]        [<ffffffffa02f879d>] extent_writepages+0x4d/0x70 [btrfs]
[13654.481060]        [<ffffffffa02d9f68>] btrfs_writepages+0x28/0x30 [btrfs]
[13654.481060]        [<ffffffff8114be91>] do_writepages+0x21/0x50
[13654.481060]        [<ffffffff81140d49>] __filemap_fdatawrite_range+0x59/0x60
[13654.481060]        [<ffffffff81140e13>] filemap_fdatawrite_range+0x13/0x20
[13654.481060]        [<ffffffffa02f1db9>] btrfs_wait_ordered_range+0x49/0x140 [btrfs]
[13654.481060]        [<ffffffffa0318fe2>] __btrfs_write_out_cache+0x682/0x8b0 [btrfs]
[13654.481060]        [<ffffffffa031952d>] btrfs_write_out_cache+0x8d/0xe0 [btrfs]
[13654.481060]        [<ffffffffa02c7083>] btrfs_write_dirty_block_groups+0x593/0x680 [btrfs]
[13654.481060]        [<ffffffffa0345307>] commit_cowonly_roots+0x14b/0x20d [btrfs]
[13654.481060]        [<ffffffffa02d7c1a>] btrfs_commit_transaction+0x43a/0x9d0 [btrfs]
[13654.481060]        [<ffffffffa030061a>] btrfs_create_uuid_tree+0x5a/0x100 [btrfs]
[13654.481060]        [<ffffffffa02d5a8a>] open_ctree+0x21da/0x2210 [btrfs]
[13654.481060]        [<ffffffffa02ab6fe>] btrfs_mount+0x68e/0x870 [btrfs]
[13654.481060]        [<ffffffff811b2409>] mount_fs+0x39/0x1b0
[13654.481060]        [<ffffffff811cd653>] vfs_kern_mount+0x63/0xf0
[13654.481060]        [<ffffffff811cfcce>] do_mount+0x23e/0xa90
[13654.481060]        [<ffffffff811d05a3>] SyS_mount+0x83/0xc0
[13654.481060]        [<ffffffff81692b52>] system_call_fastpath+0x16/0x1b
[13654.481060] -> #0 (&(&root->ordered_extent_lock)->rlock){+.+...}:
[13654.481060]        [<ffffffff810c340a>] __lock_acquire+0x150a/0x1a70
[13654.481060]        [<ffffffff810c4103>] lock_acquire+0x93/0x130
[13654.481060]        [<ffffffff81689991>] _raw_spin_lock+0x41/0x50
[13654.481060]        [<ffffffffa02d30a1>] btrfs_cleanup_transaction+0x271/0x570 [btrfs]
[13654.481060]        [<ffffffffa02d35ce>] transaction_kthread+0x22e/0x270 [btrfs]
[13654.481060]        [<ffffffff81079efa>] kthread+0xea/0xf0
[13654.481060]        [<ffffffff81692aac>] ret_from_fork+0x7c/0xb0
[13654.481060] other info that might help us debug this:

[13654.481060]  Possible unsafe locking scenario:

[13654.481060]        CPU0                    CPU1
[13654.481060]        ----                    ----
[13654.481060]   lock(&(&fs_info->ordered_root_lock)->rlock);
[13654.481060]				 lock(&(&root->ordered_extent_lock)->rlock);
[13654.481060]				 lock(&(&fs_info->ordered_root_lock)->rlock);
[13654.481060]   lock(&(&root->ordered_extent_lock)->rlock);
[13654.481060]
 *** DEADLOCK ***
[...]

======================================================

btrfs_destroy_all_ordered_extents()
gets &fs_info->ordered_root_lock __BEFORE__ acquiring &root->ordered_extent_lock,
while btrfs_[add,remove]_ordered_extent()
acquires &fs_info->ordered_root_lock __AFTER__ getting &root->ordered_extent_lock.

This patch fixes the above problem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3903bd3..8cd48c3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3794,9 +3794,11 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 		list_move_tail(&root->ordered_root,
 			       &fs_info->ordered_roots);
 
+		spin_unlock(&fs_info->ordered_root_lock);
 		btrfs_destroy_ordered_extents(root);
 
-		cond_resched_lock(&fs_info->ordered_root_lock);
+		cond_resched();
+		spin_lock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
 }
-- 
1.8.1.4

