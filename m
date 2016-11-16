Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752029AbcKPONu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 09:13:50 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.17/8.16.0.17) with SMTP id uAGE8wng001202
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 06:13:49 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 26rhxe9ygx-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 06:13:49 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 1/2][V2] Btrfs: fix file extent corruption
Date: Wed, 16 Nov 2016 09:13:39 -0500
Message-ID: <1479305619-1667-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1479150382-19273-1-git-send-email-jbacik@fb.com>
References: <1479150382-19273-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to do hole punching we have a block reserve to hold the reservation we
need to drop the extents in our range.  Since we could end up dropping a lot of
extents we set rsv->failfast so we can just loop around again and drop the
remaining of the range.  Unfortunately we unconditionally fill the hole extents
in and start from the last extent we encountered, which we may or may not have
dropped.  So this can result in overlapping file extent entries, which can be
tripped over in a variety of ways, either by hitting BUG_ON(!ret) in
fill_holes() after the search, or in btrfs_set_item_key_safe() in
btrfs_drop_extent() at a later time by an unrelated task.  Fix this by only
setting drop_end to the last extent we did actually drop.  This way our holes
are filled in properly for the range that we did drop, and the rest of the range
that remains to be dropped is actually dropped.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2:
- don't call fill_holes if our drop_end is == start.

 fs/btrfs/file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cbefdc8..23859e7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -706,6 +706,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	u64 num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 extent_end = 0;
+	u64 last_end = start;
 	int del_nr = 0;
 	int del_slot = 0;
 	int extent_type;
@@ -797,8 +798,10 @@ next_slot:
 		 * extent item in the call to setup_items_for_insert() later
 		 * in this function.
 		 */
-		if (extent_end == key.offset && extent_end >= search_start)
+		if (extent_end == key.offset && extent_end >= search_start) {
+			last_end = extent_end;
 			goto delete_extent_item;
+		}
 
 		if (extent_end <= search_start) {
 			path->slots[0]++;
@@ -861,6 +864,12 @@ next_slot:
 			key.offset = start;
 		}
 		/*
+		 * From here on out we will have actually dropped something, so
+		 * last_end can be updated.
+		 */
+		last_end = extent_end;
+
+		/*
 		 *  | ---- range to drop ----- |
 		 *      | -------- extent -------- |
 		 */
@@ -1010,7 +1019,7 @@ delete_extent_item:
 	if (!replace_extent || !(*key_inserted))
 		btrfs_release_path(path);
 	if (drop_end)
-		*drop_end = found ? min(end, extent_end) : end;
+		*drop_end = found ? min(end, last_end) : end;
 	return ret;
 }
 
@@ -2526,7 +2535,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
 
-		if (cur_offset < ino_size) {
+		if (cur_offset < drop_end && cur_offset < ino_size) {
 			ret = fill_holes(trans, inode, path, cur_offset,
 					 drop_end);
 			if (ret) {
-- 
2.7.4

