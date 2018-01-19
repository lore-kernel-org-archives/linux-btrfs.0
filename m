Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41076 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753958AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 10/16] btrfs-progs: check: Move link_inode_to_lostfound function to common.c
Date: Fri, 19 Jan 2018 13:37:25 +0800
Message-Id: <20180119053731.10795-11-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 check/common.h |  5 ++++
 check/main.c   | 92 ---------------------------------------------------------
 3 files changed, 98 insertions(+), 92 deletions(-)

diff --git a/check/common.c b/check/common.c
index 6a7d86dfd8f7..9051936a61cb 100644
--- a/check/common.c
+++ b/check/common.c
@@ -19,6 +19,7 @@
 #include "internal.h"
 #include "messages.h"
 #include "transaction.h"
+#include "utils.h"
 #include "check/common.h"
 
 /*
@@ -144,3 +145,95 @@ int insert_inode_item(struct btrfs_trans_handle *trans,
 
 	return 0;
 }
+
+static int get_highest_inode(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, struct btrfs_path *path,
+			     u64 *highest_ino)
+{
+	struct btrfs_key key, found_key;
+	int ret;
+
+	btrfs_init_path(path);
+	key.objectid = BTRFS_LAST_FREE_OBJECTID;
+	key.offset = -1;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret == 1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				path->slots[0] - 1);
+		*highest_ino = found_key.objectid;
+		ret = 0;
+	}
+	if (*highest_ino >= BTRFS_LAST_FREE_OBJECTID)
+		ret = -EOVERFLOW;
+	btrfs_release_path(path);
+	return ret;
+}
+
+/*
+ * Link inode to dir 'lost+found'. Increase @ref_count.
+ *
+ * Returns 0 means success.
+ * Returns <0 means failure.
+ */
+int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    u64 ino, char *namebuf, u32 name_len,
+			    u8 filetype, u64 *ref_count)
+{
+	char *dir_name = "lost+found";
+	u64 lost_found_ino;
+	int ret;
+	u32 mode = 0700;
+
+	btrfs_release_path(path);
+	ret = get_highest_inode(trans, root, path, &lost_found_ino);
+	if (ret < 0)
+		goto out;
+	lost_found_ino++;
+
+	ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
+			  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
+			  mode);
+	if (ret < 0) {
+		error("failed to create '%s' dir: %s", dir_name, strerror(-ret));
+		goto out;
+	}
+	ret = btrfs_add_link(trans, root, ino, lost_found_ino,
+			     namebuf, name_len, filetype, NULL, 1, 0);
+	/*
+	 * Add ".INO" suffix several times to handle case where
+	 * "FILENAME.INO" is already taken by another file.
+	 */
+	while (ret == -EEXIST) {
+		/*
+		 * Conflicting file name, add ".INO" as suffix * +1 for '.'
+		 */
+		if (name_len + count_digits(ino) + 1 > BTRFS_NAME_LEN) {
+			ret = -EFBIG;
+			goto out;
+		}
+		snprintf(namebuf + name_len, BTRFS_NAME_LEN - name_len,
+			 ".%llu", ino);
+		name_len += count_digits(ino) + 1;
+		ret = btrfs_add_link(trans, root, ino, lost_found_ino, namebuf,
+				     name_len, filetype, NULL, 1, 0);
+	}
+	if (ret < 0) {
+		error("failed to link the inode %llu to %s dir: %s",
+		      ino, dir_name, strerror(-ret));
+		goto out;
+	}
+
+	++*ref_count;
+	printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
+	       name_len, namebuf, dir_name);
+out:
+	btrfs_release_path(path);
+	if (ret)
+		error("failed to move file '%.*s' to '%s' dir", name_len,
+				namebuf, dir_name);
+	return ret;
+}
+
diff --git a/check/common.h b/check/common.h
index efab05ad6b68..9a3488ae365a 100644
--- a/check/common.h
+++ b/check/common.h
@@ -85,5 +85,10 @@ int count_csum_range(struct btrfs_fs_info *fs_info, u64 start,
 int insert_inode_item(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, u64 ino, u64 size,
 		      u64 nbytes, u64 nlink, u32 mode);
+int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    u64 ino, char *namebuf, u32 name_len,
+			    u8 filetype, u64 *ref_count);
 
 #endif
diff --git a/check/main.c b/check/main.c
index e594b5986a47..0da25c460336 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2960,98 +2960,6 @@ out:
 	return ret;
 }
 
-static int get_highest_inode(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct btrfs_path *path,
-				u64 *highest_ino)
-{
-	struct btrfs_key key, found_key;
-	int ret;
-
-	btrfs_init_path(path);
-	key.objectid = BTRFS_LAST_FREE_OBJECTID;
-	key.offset = -1;
-	key.type = BTRFS_INODE_ITEM_KEY;
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret == 1) {
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-				path->slots[0] - 1);
-		*highest_ino = found_key.objectid;
-		ret = 0;
-	}
-	if (*highest_ino >= BTRFS_LAST_FREE_OBJECTID)
-		ret = -EOVERFLOW;
-	btrfs_release_path(path);
-	return ret;
-}
-
-/*
- * Link inode to dir 'lost+found'. Increase @ref_count.
- *
- * Returns 0 means success.
- * Returns <0 means failure.
- */
-static int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
-				   struct btrfs_path *path,
-				   u64 ino, char *namebuf, u32 name_len,
-				   u8 filetype, u64 *ref_count)
-{
-	char *dir_name = "lost+found";
-	u64 lost_found_ino;
-	int ret;
-	u32 mode = 0700;
-
-	btrfs_release_path(path);
-	ret = get_highest_inode(trans, root, path, &lost_found_ino);
-	if (ret < 0)
-		goto out;
-	lost_found_ino++;
-
-	ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
-			  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
-			  mode);
-	if (ret < 0) {
-		error("failed to create '%s' dir: %s", dir_name, strerror(-ret));
-		goto out;
-	}
-	ret = btrfs_add_link(trans, root, ino, lost_found_ino,
-			     namebuf, name_len, filetype, NULL, 1, 0);
-	/*
-	 * Add ".INO" suffix several times to handle case where
-	 * "FILENAME.INO" is already taken by another file.
-	 */
-	while (ret == -EEXIST) {
-		/*
-		 * Conflicting file name, add ".INO" as suffix * +1 for '.'
-		 */
-		if (name_len + count_digits(ino) + 1 > BTRFS_NAME_LEN) {
-			ret = -EFBIG;
-			goto out;
-		}
-		snprintf(namebuf + name_len, BTRFS_NAME_LEN - name_len,
-			 ".%llu", ino);
-		name_len += count_digits(ino) + 1;
-		ret = btrfs_add_link(trans, root, ino, lost_found_ino, namebuf,
-				     name_len, filetype, NULL, 1, 0);
-	}
-	if (ret < 0) {
-		error("failed to link the inode %llu to %s dir: %s",
-		      ino, dir_name, strerror(-ret));
-		goto out;
-	}
-
-	++*ref_count;
-	printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
-	       name_len, namebuf, dir_name);
-out:
-	btrfs_release_path(path);
-	if (ret)
-		error("failed to move file '%.*s' to '%s' dir", name_len,
-				namebuf, dir_name);
-	return ret;
-}
-
 static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_path *path,
-- 
2.15.1

