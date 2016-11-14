Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43775 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752781AbcKNTGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:06:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.17/8.16.0.17) with SMTP id uAEJ427o019718
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:06:33 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 26qesj9mb6-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:06:33 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 1/2] Btrfs: fix file extent corruption
Date: Mon, 14 Nov 2016 14:06:21 -0500
Message-ID: <1479150382-19273-1-git-send-email-jbacik@fb.com>
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
 fs/btrfs/file.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cbefdc8..1c15a98 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -706,6 +706,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	u64 num_bytes = 0;
 	u64 extent_offset = 0;
 	u64 extent_end = 0;
+	u64 last_end = 0;
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
 
-- 
2.7.4

