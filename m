Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F361AECDE46
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42DD205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C42DD205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbeJZUUM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:33540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbeJZUUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4B51AE5F
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/5] btrfs: Refactor btrfs_can_relocate
Date:   Fri, 26 Oct 2018 14:43:18 +0300
Message-Id: <1540554201-11305-3-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_can_relocate returns 0 when it concludes the given chunk can be
relocated and -1 otherwise. Since this function is used as a predicated
and it return a binary value it makes no sense to have it's return
value as an int so change it to bool. Furthermore, remove a stale
leftover comment from e6ec716f0ddb ("Btrfs: make raid attr array more
readable").

Finally make the logic in the list_for_each_entry loop a bit more obvious. Up
until now the fact that we are returning success (0) was a bit masked by the
fact that the 0 is re-used from the return value of find_free_dev_extent.
Instead, now just increment dev_nr if we find a suitable extent and explicitly
set can_reloc to true if enough devices with unallocated space are present.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 39 ++++++++++++++-------------------------
 fs/btrfs/volumes.c     |  3 +--
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68ca41dbbef3..06edc4f9ceb2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2680,7 +2680,7 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
 int btrfs_extent_readonly(struct btrfs_fs_info *fs_info, u64 bytenr);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_fs_info *info);
-int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
+bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   u64 bytes_used, u64 type, u64 chunk_offset,
 			   u64 size);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..816bca482358 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9423,10 +9423,10 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
 /*
  * checks to see if its even possible to relocate this block group.
  *
- * @return - -1 if it's not a good idea to relocate this block group, 0 if its
- * ok to go ahead and try.
+ * @return - false if not enough space can be found for relocation, true
+ * otherwise
  */
-int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
+bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_block_group_cache *block_group;
@@ -9441,7 +9441,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	int debug;
 	int index;
 	int full = 0;
-	int ret = 0;
+	bool can_reloc = true;
 
 	debug = btrfs_test_opt(fs_info, ENOSPC_DEBUG);
 
@@ -9453,7 +9453,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 			btrfs_warn(fs_info,
 				   "can't find block group for bytenr %llu",
 				   bytenr);
-		return -1;
+		return false;
 	}
 
 	min_free = btrfs_block_group_used(&block_group->item);
@@ -9489,16 +9489,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	 * group is going to be restriped, run checks against the target
 	 * profile instead of the current one.
 	 */
-	ret = -1;
+	can_reloc = false;
 
-	/*
-	 * index:
-	 *      0: raid10
-	 *      1: raid1
-	 *      2: dup
-	 *      3: raid0
-	 *      4: single
-	 */
 	target = get_restripe_target(fs_info, block_group->flags);
 	if (target) {
 		index = btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
@@ -9534,10 +9526,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 
 	/* We need to do this so that we can look at pending chunks */
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
+	if (IS_ERR(trans))
 		goto out;
-	}
 
 	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
@@ -9549,18 +9539,17 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 		 */
 		if (device->total_bytes > device->bytes_used + min_free &&
 		    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
-			ret = find_free_dev_extent(trans, device, min_free,
-						   &dev_offset, NULL);
-			if (!ret)
+			if (!find_free_dev_extent(trans, device, min_free,
+						   &dev_offset, NULL))
 				dev_nr++;
 
-			if (dev_nr >= dev_min)
+			if (dev_nr >= dev_min) {
+				can_reloc = true;
 				break;
-
-			ret = -1;
+			}
 		}
 	}
-	if (debug && ret == -1)
+	if (debug && !can_reloc)
 		btrfs_warn(fs_info,
 			   "no space to allocate a new chunk for block group %llu",
 			   block_group->key.objectid);
@@ -9568,7 +9557,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	btrfs_end_transaction(trans);
 out:
 	btrfs_put_block_group(block_group);
-	return ret;
+	return can_reloc;
 }
 
 static int find_first_block_group(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b0fd7bf3447..dc53d94a62aa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2856,8 +2856,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	 */
 	lockdep_assert_held(&fs_info->delete_unused_bgs_mutex);
 
-	ret = btrfs_can_relocate(fs_info, chunk_offset);
-	if (ret)
+	if (!btrfs_can_relocate(fs_info, chunk_offset))
 		return -ENOSPC;
 
 	/* step one, relocate all the extents inside this chunk */
-- 
2.7.4

