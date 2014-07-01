Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaGAJ2z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 05:28:55 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s619SsJj026472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 09:28:55 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s619SrwL001307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 09:28:54 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s619Srl2001300
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 09:28:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] Btrfs: fix race of using total_bytes_pinned
Date: Tue,  1 Jul 2014 17:28:46 +0800
Message-Id: <1404206926-7953-1-git-send-email-bo.li.liu@oracle.com>
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
and when finding space for writing, if it finds that pinned bytes is less
than needed, we first try again to check if we have space now, as someone
may have committed transaction, yes means we're good, while no means we
really have run out of space.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3: Really account the percpu pinned number when unpin, instead of zeroing
    it out, as we set transaction with UNBLOCKED before 'unpin', zeroing it
    out may end up with messing percpu pinned number(suggested by Miao).
v2: Add missing brakets for if statement

 fs/btrfs/extent-tree.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99c2539..f36fb13 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3685,7 +3685,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
-	int ret = 0, committed = 0, alloc_chunk = 1;
+	int ret = 0, committed = 0, alloc_chunk = 1, check_pinned = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3756,11 +3756,18 @@ alloc:
 		 * allocation don't bother committing the transaction.
 		 */
 		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
-					   bytes) < 0)
-			committed = 1;
+					   bytes) < 0) {
+			if (check_pinned) {
+				committed = 1;	/* really run out of space. */
+			} else {
+				check_pinned = 1;
+				spin_unlock(&data_sinfo->lock);
+				goto again;
+			}
+		}
 		spin_unlock(&data_sinfo->lock);
 
-		/* commit the current transaction and try again */
+	/* commit the current transaction and try again */
 commit_trans:
 		if (!committed &&
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
@@ -5678,7 +5685,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 	struct btrfs_caching_control *next;
 	struct btrfs_caching_control *caching_ctl;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_space_info *space_info;
 
 	down_write(&fs_info->commit_root_sem);
 
@@ -5701,9 +5707,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 
 	up_write(&fs_info->commit_root_sem);
 
-	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
-		percpu_counter_set(&space_info->total_bytes_pinned, 0);
-
 	update_global_block_rsv(fs_info);
 }
 
@@ -5741,6 +5744,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
 		space_info->bytes_pinned -= len;
+		percpu_counter_add(&space_info->total_bytes_pinned, -len);
 		if (cache->ro) {
 			space_info->bytes_readonly += len;
 			readonly = true;
-- 
1.8.1.4

