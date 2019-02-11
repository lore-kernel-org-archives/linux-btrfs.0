Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80634C282CC
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A80020863
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfBKIf1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:35:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:41536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbfBKIfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 03:35:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47E35AE27
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:35:16 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 08/12] btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
Date:   Mon, 11 Feb 2019 10:35:06 +0200
Message-Id: <20190211083510.27591-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190211083510.27591-1-nborisov@suse.com>
References: <20190211083510.27591-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that those function no longer require a handle to transaction to
inspect pending/pinned chunks the argument can be removed. At the same
time also remove any surrounding code which acquired the handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 36 +++---------------------------------
 fs/btrfs/volumes.c     | 11 ++++-------
 fs/btrfs/volumes.h     |  8 +++-----
 3 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 48bf3df0b194..39647ddb2195 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9864,12 +9864,10 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
  */
 int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
-	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
-	struct btrfs_trans_handle *trans;
 	u64 min_free;
 	u64 dev_min = 1;
 	u64 dev_nr = 0;
@@ -9968,13 +9966,6 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 		min_free = div64_u64(min_free, dev_min);
 	}
 
-	/* We need to do this so that we can look at pending chunks */
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
 		u64 dev_offset;
@@ -9985,7 +9976,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 		 */
 		if (device->total_bytes > device->bytes_used + min_free &&
 		    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
-			ret = find_free_dev_extent(trans, device, min_free,
+			ret = find_free_dev_extent(device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
 				dev_nr++;
@@ -10001,7 +9992,6 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 			   "no space to allocate a new chunk for block group %llu",
 			   block_group->key.objectid);
 	mutex_unlock(&fs_info->chunk_mutex);
-	btrfs_end_transaction(trans);
 out:
 	btrfs_put_block_group(block_group);
 	return ret;
@@ -11253,34 +11243,14 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 
 	while (1) {
 		struct btrfs_fs_info *fs_info = device->fs_info;
-		struct btrfs_transaction *trans;
 		u64 bytes;
 
 		ret = mutex_lock_interruptible(&fs_info->chunk_mutex);
 		if (ret)
 			break;
 
-		ret = down_read_killable(&fs_info->commit_root_sem);
-		if (ret) {
-			mutex_unlock(&fs_info->chunk_mutex);
-			break;
-		}
-
-		spin_lock(&fs_info->trans_lock);
-		trans = fs_info->running_transaction;
-		if (trans)
-			refcount_inc(&trans->use_count);
-		spin_unlock(&fs_info->trans_lock);
-
-		if (!trans)
-			up_read(&fs_info->commit_root_sem);
-
-		ret = find_free_dev_extent_start(trans, device, range->minlen,
-						 start, &start, &len);
-		if (trans) {
-			up_read(&fs_info->commit_root_sem);
-			btrfs_put_transaction(trans);
-		}
+		ret = find_free_dev_extent_start(device, range->minlen, start,
+						 &start, &len);
 
 		if (ret) {
 			mutex_unlock(&fs_info->chunk_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f8baa9d4c796..ece4e5fad9c6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1558,8 +1558,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
  * But if we don't find suitable free space, it is used to store the size of
  * the max free space.
  */
-int find_free_dev_extent_start(struct btrfs_transaction *transaction,
-			       struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent_start(struct btrfs_device *device, u64 num_bytes,
 			       u64 search_start, u64 *start, u64 *len)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
@@ -1715,13 +1714,11 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	return ret;
 }
 
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *len)
 {
 	/* FIXME use last free of some kind */
-	return find_free_dev_extent_start(trans->transaction, device,
-					  num_bytes, 0, start, len);
+	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
 static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
@@ -5040,7 +5037,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (total_avail == 0)
 			continue;
 
-		ret = find_free_dev_extent(trans, device,
+		ret = find_free_dev_extent(device,
 					   max_stripe_size * dev_stripes,
 					   &dev_offset, &max_avail);
 		if (ret && ret != -ENOSPC)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 49dc737d8a54..30c1f3002a81 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -445,11 +445,9 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset);
-int find_free_dev_extent_start(struct btrfs_transaction *transaction,
-			 struct btrfs_device *device, u64 num_bytes,
-			 u64 search_start, u64 *start, u64 *max_avail);
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent_start(struct btrfs_device *device, u64 num_bytes,
+			       u64 search_start, u64 *start, u64 *max_avail);
+int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
-- 
2.17.1

