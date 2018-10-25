Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A2AECDE46
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F982054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:44:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51F982054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbeJYQQa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 12:16:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:58212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbeJYQQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 12:16:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26382AE02
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 07:44:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: lowmem check: Add ability to repair dir item with mismatch hash
Date:   Thu, 25 Oct 2018 15:44:46 +0800
Message-Id: <20181025074449.32469-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>
References: <20181025074449.32469-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For DIR_ITEM with mismatch hash, we could just remove the offending dir
item.

Lowmem mode will handle the rest part (either re-create the correct
dir_item or move the orphan inode to lost+found).

This is especially important for old btrfs, since later kernel
introduces restrict tree-checker, which could detect such hash mismatch
and refuse to read the corrupted leaf.

With this repair ability, user could repair with btrfs check
--mode=lowmem --repair.

Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1111991
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 check/mode-common.h |  5 ++++-
 check/mode-lowmem.c | 46 +++++++++++++++++++++++++++++++++++-----
 check/mode-lowmem.h |  1 +
 ctree.h             |  3 +++
 dir-item.c          |  6 +-----
 6 files changed, 101 insertions(+), 11 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index 15e2bbd1f30f..8660f43f6b20 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -742,3 +742,54 @@ void cleanup_excluded_extents(struct btrfs_fs_info *fs_info)
 	}
 	fs_info->excluded_extents = NULL;
 }
+
+/*
+ * Delete one corrupted dir item whose hash doesn't match its name.
+ *
+ * Since its hash is incorrect, we can't use btrfs_name_hash() to calculate
+ * the search key, but relie on @di_key parameter to do the search.
+ */
+int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_key *di_key, char *namebuf,
+			      u32 namelen)
+{
+	struct btrfs_dir_item *di_item;
+	struct btrfs_path path;
+	int ret;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(trans, root, di_key, &path, 0, 1);
+	if (ret > 0) {
+		error("key (%llu %u %llu) doesn't exist in root %llu",
+			di_key->objectid, di_key->type, di_key->offset,
+			root->root_key.objectid);
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0) {
+		error("failed to search root %llu: %d",
+			root->root_key.objectid, ret);
+		goto out;
+	}
+
+	di_item = btrfs_match_dir_item_name(root, &path, namebuf, namelen);
+	if (!di_item) {
+		/*
+		 * This is possible if the dir_item has incorrect namelen.
+		 * But in that case, we shouldn't reach repair path here.
+		 */
+		error("no dir item named '%s' found with key (%llu %u %llu)",
+			namebuf, di_key->objectid, di_key->type,
+			di_key->offset);
+		ret = -ENOENT;
+		goto out;
+	}
+	ret = btrfs_delete_one_dir_name(trans, root, &path, di_item);
+	if (ret < 0)
+		error("failed to delete one dir name: %d", ret);
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/check/mode-common.h b/check/mode-common.h
index 6b05f8baf474..fda319267b04 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -121,5 +121,8 @@ void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
 int exclude_metadata_blocks(struct btrfs_fs_info *fs_info);
 void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
-
+int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct btrfs_key *di_key, char *namebuf,
+			      u32 namelen);
 #endif
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..fe3d5940faf0 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1464,17 +1464,52 @@ out:
 	return ret;
 }
 
+/*
+ * A wrapper for delete_corrupted_dir_item(), with support part like
+ * start/commit transaction.
+ */
+static int lowmem_delete_corrupted_dir_item(struct btrfs_root *root,
+					    struct btrfs_key *di_key,
+					    char *namebuf, u32 name_len)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %d", ret);
+		return ret;
+	}
+
+	ret = delete_corrupted_dir_item(trans, root, di_key, namebuf, name_len);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+	} else {
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret < 0)
+			error("failed to commit transaction: %d", ret);
+	}
+	return ret;
+}
 /*
  * Call repair_inode_item_missing and repair_ternary_lowmem to repair
  *
  * Returns error after repair
  */
-static int repair_dir_item(struct btrfs_root *root, u64 dirid, u64 ino,
-			   u64 index, u8 filetype, char *namebuf, u32 name_len,
-			   int err)
+static int repair_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
+			   u64 ino, u64 index, u8 filetype, char *namebuf,
+			   u32 name_len, int err)
 {
+	u64 dirid = di_key->objectid;
 	int ret;
 
+	if (err & (DIR_ITEM_HASH_MISMATCH)) {
+		ret = lowmem_delete_corrupted_dir_item(root, di_key, namebuf,
+						       name_len);
+		if (!ret)
+			err &= ~(DIR_ITEM_HASH_MISMATCH);
+	}
 	if (err & INODE_ITEM_MISSING) {
 		ret = repair_inode_item_missing(root, ino, filetype);
 		if (!ret)
@@ -1622,11 +1657,12 @@ begin:
 
 		if (di_key->type == BTRFS_DIR_ITEM_KEY &&
 		    di_key->offset != btrfs_name_hash(namebuf, len)) {
-			err |= -EIO;
 			error("root %llu DIR_ITEM[%llu %llu] name %s namelen %u filetype %u mismatch with its hash, wanted %llu have %llu",
 			root->objectid, di_key->objectid, di_key->offset,
 			namebuf, len, filetype, di_key->offset,
 			btrfs_name_hash(namebuf, len));
+			tmp_err |= DIR_ITEM_HASH_MISMATCH;
+			goto next;
 		}
 
 		btrfs_dir_item_key_to_cpu(node, di, &location);
@@ -1674,7 +1710,7 @@ begin:
 next:
 
 		if (tmp_err && repair) {
-			ret = repair_dir_item(root, di_key->objectid,
+			ret = repair_dir_item(root, di_key,
 					      location.objectid, index,
 					      imode_to_type(mode), namebuf,
 					      name_len, tmp_err);
diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
index 91f7b6b1db53..afd376ad7d5d 100644
--- a/check/mode-lowmem.h
+++ b/check/mode-lowmem.h
@@ -45,6 +45,7 @@
 #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
 #define FATAL_ERROR             (1<<22) /* Fatal bit for errno */
 #define INODE_FLAGS_ERROR	(1<<23) /* Invalid inode flags */
+#define DIR_ITEM_HASH_MISMATCH	(1<<24) /* Dir item hash mismatch */
 
 /*
  * Error bit for low memory mode check.
diff --git a/ctree.h b/ctree.h
index 4719962df67d..be0dacbe351d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2691,6 +2691,9 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, const char *name,
 			    u16 name_len, const void *data, u16 data_len,
 			    u64 dir);
+struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      const char *name, int name_len);
 /* inode-map.c */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *fs_root,
diff --git a/dir-item.c b/dir-item.c
index d64f71e306e0..fa69dd1de185 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -22,10 +22,6 @@
 #include "hash.h"
 #include "transaction.h"
 
-static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len);
-
 static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 						   *trans,
 						   struct btrfs_root *root,
@@ -323,7 +319,7 @@ static int verify_dir_item(struct btrfs_root *root,
 	return 0;
 }
 
-static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 			      struct btrfs_path *path,
 			      const char *name, int name_len)
 {
-- 
2.19.1

