Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751663AbdCADSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:08 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1171848A2947
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:21 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 19/20] btrfs-progs: cmds-check.c: add punch_extent_hole
Date: Wed, 1 Mar 2017 11:14:02 +0800
Message-ID: <20170301031403.23902-20-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'punch_extent_hole' to punch holes while
repair file extent.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ae80d5f0..d228fc62 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4483,6 +4483,7 @@ next:
 		memcpy(name_ret, namebuf, len);
 		*namelen_ret = len;
 	}
+
 	/* Check root dir ref */
 	if (ref_key->objectid == BTRFS_FIRST_FREE_OBJECTID) {
 		if (index != 0 || len != strlen("..") ||
@@ -5105,6 +5106,33 @@ next:
 }
 
 /*
+ * Wrapper function of btrfs_punch_hole.
+ *
+ * Returns 0 means success.
+ */
+static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
+			      u64 len)
+{
+	struct btrfs_trans_handle *trans;
+	int ret = 0;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_punch_hole(trans, root, ino, start, len);
+	if (ret) {
+		error("Failed to add hole [%llu, %llu] in inode [%llu]",
+		      start, len, ino);
+	} else {
+		btrfs_commit_transaction(trans, root);
+		printf("Added hole [%llu, %llu] in inode [%llu]\n", start, len,
+		      ino);
+	}
+	return ret;
+}
+
+/*
  * Check file extent datasum/hole, update the size of the file extents,
  * check and update the last offset of the file extent.
  *
@@ -5222,9 +5250,14 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		error("root %llu EXTENT_DATA[%llu %llu] shouldn't be hole",
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (!no_holes && *end != fkey->offset) {
-		err |= FILE_EXTENT_ERROR;
-		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
-		      root->objectid, fkey->objectid, fkey->offset);
+		if (repair)
+			ret = punch_extent_hole(root, fkey->objectid,
+						*end, fkey->offset - *end);
+		if (!!repair || ret) {
+			err |= FILE_EXTENT_ERROR;
+			error("root %llu EXTENT_DATA[%llu %llu] interrupt",
+			      root->objectid, fkey->objectid, fkey->offset);
+		}
 	}
 
 	*end += extent_num_bytes;
@@ -5724,9 +5757,15 @@ out:
 		}
 
 		if (!nbytes && !no_holes && extent_end < isize) {
-			err |= NBYTES_ERROR;
-			error("root %llu INODE[%llu] size (%llu) should have a file extent hole",
-			      root->objectid, inode_id, isize);
+			if (repair)
+				ret = punch_extent_hole(root, inode_id,
+							extent_end,
+							isize-extent_end);
+			if (!repair || ret) {
+				err |= NBYTES_ERROR;
+				error("root %llu INODE[%llu] size (%llu) should have a file extent hole",
+				      root->objectid, inode_id, isize);
+			}
 		}
 
 		if (nbytes != extent_size) {
-- 
2.11.1



