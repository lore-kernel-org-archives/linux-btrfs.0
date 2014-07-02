Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51957 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaGBI6P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 04:58:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s628wDHn012765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 08:58:14 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s628wCvd023450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 08:58:13 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s628wA3P012416
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 08:58:11 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4] Btrfs: fix race of using total_bytes_pinned
Date: Wed,  2 Jul 2014 16:58:01 +0800
Message-Id: <1404291481-31773-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This percpu counter @total_bytes_pinned is introduced to skip unnecessary
operations of 'commit transaction', it accounts for those space we may free
but are stuck in delayed refs.

And we zero out @space_info->total_bytes_pinned every transaction period so
we have a better idea of how much space we'll actually free up by committing
this transaction.  However, we do the 'zero out' part a little earlier, before
we actually unpin space, so we end up returning ENOSPC when we actually have
free space that's just unpinned from committing transaction.

xfstests/generic/074 complained then.

This fixes it by actually accounting the percpu pinned number when 'unpin',
and since it's protected by space_info->lock, the race is gone now.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v4: Remove unnecessary check in btrfs_check_data_free_space.
v3: Really account the percpu pinned number when unpin, instead of zeroing
    it out, as we set transaction with UNBLOCKED before 'unpin', zeroing it
    out may end up with messing percpu pinned number(suggested by Miao).
v2: Add missing brakets for if statement

 fs/btrfs/extent-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99c2539..813537f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5678,7 +5678,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 	struct btrfs_caching_control *next;
 	struct btrfs_caching_control *caching_ctl;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_space_info *space_info;
 
 	down_write(&fs_info->commit_root_sem);
 
@@ -5701,9 +5700,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 
 	up_write(&fs_info->commit_root_sem);
 
-	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
-		percpu_counter_set(&space_info->total_bytes_pinned, 0);
-
 	update_global_block_rsv(fs_info);
 }
 
@@ -5741,6 +5737,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
 		space_info->bytes_pinned -= len;
+		percpu_counter_add(&space_info->total_bytes_pinned, -len);
 		if (cache->ro) {
 			space_info->bytes_readonly += len;
 			readonly = true;
-- 
1.8.1.4

