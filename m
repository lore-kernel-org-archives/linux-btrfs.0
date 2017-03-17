Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36382 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751098AbdCQCHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 22:07:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <chris@colorremedies.com>
Subject: [PATCH 1/2] btrfs-progs: lowmeme check: Fix false alert about backref lost for SHARED_DATA_REF
Date: Fri, 17 Mar 2017 10:06:33 +0800
Message-ID: <20170317020634.29287-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check_extent_data_item(), after checking extent item of one data
extent, we search inlined data backref, then EXTENT_DATA_REF_KEY.

But we didn't search SHARED_DATA_REF, so if the backref is
SHARED_DATA_REF, then we will raise a false alert about backref lost.

Fix by also checking SHARED_DATA_REF_KEY in check_extent_data_item().

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5cc84690..17b7efbf 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10229,10 +10229,8 @@ static int check_extent_data_item(struct btrfs_root *root,
 	dbref_key.offset = btrfs_file_extent_disk_num_bytes(eb, fi);
 
 	ret = btrfs_search_slot(NULL, extent_root, &dbref_key, &path, 0, 0);
-	if (ret) {
-		err |= BACKREF_MISSING;
-		goto error;
-	}
+	if (ret)
+		goto out;
 
 	leaf = path.nodes[0];
 	slot = path.slots[0];
@@ -10273,11 +10271,10 @@ static int check_extent_data_item(struct btrfs_root *root,
 		ptr += btrfs_extent_inline_ref_size(type);
 	}
 
-	/* Didn't found inlined data backref, try EXTENT_DATA_REF_KEY */
 	if (!found_dbackref) {
 		btrfs_release_path(&path);
 
-		btrfs_init_path(&path);
+		/* Didn't find inlined data backref, try EXTENT_DATA_REF_KEY */
 		dbref_key.objectid = btrfs_file_extent_disk_bytenr(eb, fi);
 		dbref_key.type = BTRFS_EXTENT_DATA_REF_KEY;
 		dbref_key.offset = hash_extent_data_ref(root->objectid,
@@ -10285,13 +10282,32 @@ static int check_extent_data_item(struct btrfs_root *root,
 
 		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
 					&dbref_key, &path, 0, 0);
-		if (!ret)
+		if (!ret) {
 			found_dbackref = 1;
+			goto out;
+		}
+
+		btrfs_release_path(&path);
+
+		/*
+		 * Neither inlined nor EXTENT_DATA_REF found, try
+		 * SHARED_DATA_REF as last chance.
+		 */
+		dbref_key.objectid = disk_bytenr;
+		dbref_key.type = BTRFS_SHARED_DATA_REF_KEY;
+		dbref_key.offset = eb->start;
+
+		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
+					&dbref_key, &path, 0, 0);
+		if (!ret) {
+			found_dbackref = 1;
+			goto out;
+		}
 	}
 
+out:
 	if (!found_dbackref)
 		err |= BACKREF_MISSING;
-error:
 	btrfs_release_path(&path);
 	if (err & BACKREF_MISSING) {
 		error("data extent[%llu %llu] backref lost",
-- 
2.12.0



