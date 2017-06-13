Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752609AbdFMJTx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:53 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 11/19] btrfs-progs: Refactor write_all_supers and its callers to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:27 +0800
Message-ID: <20170613091935.23277-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-select-super.c |  2 +-
 btrfstune.c          |  6 +++---
 disk-io.c            | 48 ++++++++++++++++++++++++------------------------
 disk-io.h            |  4 ++--
 super-recover.c      |  2 +-
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 0a899966..e021221e 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -93,7 +93,7 @@ int main(int argc, char **argv)
 
 	/* make the super writing code think we've read the first super */
 	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
-	ret = write_all_supers(root);
+	ret = write_all_supers(root->fs_info);
 
 	/* we don't close the ctree or anything, because we don't want a real
 	 * transaction commit.  We just want the super copy we pulled off the
diff --git a/btrfstune.c b/btrfstune.c
index 2d85b041..1ed73a92 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -242,7 +242,7 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 	btrfs_set_super_flags(fs_info->super_copy, flags);
 
 	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid, BTRFS_FSID_SIZE);
-	ret = write_all_supers(tree_root);
+	ret = write_all_supers(fs_info);
 	if (ret < 0)
 		return ret;
 
@@ -260,7 +260,7 @@ static int change_fsid_done(struct btrfs_fs_info *fs_info)
 	flags &= ~BTRFS_SUPER_FLAG_CHANGING_FSID;
 	btrfs_set_super_flags(fs_info->super_copy, flags);
 
-	return write_all_supers(fs_info->tree_root);
+	return write_all_supers(fs_info);
 }
 
 /*
@@ -354,7 +354,7 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	       BTRFS_FSID_SIZE);
 	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid,
 	       BTRFS_FSID_SIZE);
-	ret = write_all_supers(fs_info->tree_root);
+	ret = write_all_supers(fs_info);
 	if (ret < 0)
 		goto out;
 
diff --git a/disk-io.c b/disk-io.c
index 686c55e7..a11e6262 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -599,7 +599,7 @@ commit_tree:
 	BUG_ON(ret);
 	ret = __commit_transaction(trans, root);
 	BUG_ON(ret);
-	write_ctree_super(trans, root);
+	write_ctree_super(trans, fs_info);
 	btrfs_finish_extent_commit(trans, fs_info->extent_root,
 			           &fs_info->pinned_extents);
 	kfree(trans);
@@ -1631,7 +1631,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	return transid > 0 ? 0 : -1;
 }
 
-static int write_dev_supers(struct btrfs_root *root,
+static int write_dev_supers(struct btrfs_fs_info *fs_info,
 			    struct btrfs_super_block *sb,
 			    struct btrfs_device *device)
 {
@@ -1639,8 +1639,8 @@ static int write_dev_supers(struct btrfs_root *root,
 	u32 crc;
 	int i, ret;
 
-	if (root->fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		btrfs_set_super_bytenr(sb, root->fs_info->super_bytenr);
+	if (fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
+		btrfs_set_super_bytenr(sb, fs_info->super_bytenr);
 		crc = ~(u32)0;
 		crc = btrfs_csum_data((char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
@@ -1650,9 +1650,9 @@ static int write_dev_supers(struct btrfs_root *root,
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
 		 * zero filled, we can use it directly
 		 */
-		ret = pwrite64(device->fd, root->fs_info->super_copy,
+		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE,
-				root->fs_info->super_bytenr);
+				fs_info->super_bytenr);
 		if (ret != BTRFS_SUPER_INFO_SIZE)
 			goto write_err;
 		return 0;
@@ -1674,7 +1674,7 @@ static int write_dev_supers(struct btrfs_root *root,
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
 		 * zero filled, we can use it directly
 		 */
-		ret = pwrite64(device->fd, root->fs_info->super_copy,
+		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE, bytenr);
 		if (ret != BTRFS_SUPER_INFO_SIZE)
 			goto write_err;
@@ -1691,17 +1691,17 @@ write_err:
 	return ret;
 }
 
-int write_all_supers(struct btrfs_root *root)
+int write_all_supers(struct btrfs_fs_info *fs_info)
 {
 	struct list_head *cur;
-	struct list_head *head = &root->fs_info->fs_devices->devices;
+	struct list_head *head = &fs_info->fs_devices->devices;
 	struct btrfs_device *dev;
 	struct btrfs_super_block *sb;
 	struct btrfs_dev_item *dev_item;
 	int ret;
 	u64 flags;
 
-	sb = root->fs_info->super_copy;
+	sb = fs_info->super_copy;
 	dev_item = &sb->dev_item;
 	list_for_each(cur, head) {
 		dev = list_entry(cur, struct btrfs_device, dev_list);
@@ -1722,36 +1722,36 @@ int write_all_supers(struct btrfs_root *root)
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
-		ret = write_dev_supers(root, sb, dev);
+		ret = write_dev_supers(fs_info, sb, dev);
 		BUG_ON(ret);
 	}
 	return 0;
 }
 
 int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root)
+		      struct btrfs_fs_info *fs_info)
 {
 	int ret;
-	struct btrfs_root *tree_root = root->fs_info->tree_root;
-	struct btrfs_root *chunk_root = root->fs_info->chunk_root;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
 
-	if (root->fs_info->readonly)
+	if (fs_info->readonly)
 		return 0;
 
-	btrfs_set_super_generation(root->fs_info->super_copy,
+	btrfs_set_super_generation(fs_info->super_copy,
 				   trans->transid);
-	btrfs_set_super_root(root->fs_info->super_copy,
+	btrfs_set_super_root(fs_info->super_copy,
 			     tree_root->node->start);
-	btrfs_set_super_root_level(root->fs_info->super_copy,
+	btrfs_set_super_root_level(fs_info->super_copy,
 				   btrfs_header_level(tree_root->node));
-	btrfs_set_super_chunk_root(root->fs_info->super_copy,
+	btrfs_set_super_chunk_root(fs_info->super_copy,
 				   chunk_root->node->start);
-	btrfs_set_super_chunk_root_level(root->fs_info->super_copy,
+	btrfs_set_super_chunk_root_level(fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
-	btrfs_set_super_chunk_root_generation(root->fs_info->super_copy,
+	btrfs_set_super_chunk_root_generation(fs_info->super_copy,
 				btrfs_header_generation(chunk_root->node));
 
-	ret = write_all_supers(root);
+	ret = write_all_supers(fs_info);
 	if (ret)
 		fprintf(stderr, "failed to write new super block err %d\n", ret);
 	return ret;
@@ -1773,14 +1773,14 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 		BUG_ON(ret);
 		ret = __commit_transaction(trans, root);
 		BUG_ON(ret);
-		write_ctree_super(trans, root);
+		write_ctree_super(trans, fs_info);
 		kfree(trans);
 	}
 
 	if (fs_info->finalize_on_close) {
 		btrfs_set_super_magic(fs_info->super_copy, BTRFS_MAGIC);
 		root->fs_info->finalize_on_close = 0;
-		ret = write_all_supers(root);
+		ret = write_all_supers(fs_info);
 		if (ret)
 			fprintf(stderr,
 				"failed to write new super block err %d\n", ret);
diff --git a/disk-io.h b/disk-io.h
index b834fea4..dfe4cf01 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -161,9 +161,9 @@ static inline int close_ctree(struct btrfs_root *root)
 	return close_ctree_fs_info(root->fs_info);
 }
 
-int write_all_supers(struct btrfs_root *root);
+int write_all_supers(struct btrfs_fs_info *fs_info);
 int write_ctree_super(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root);
+		      struct btrfs_fs_info *fs_info);
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		unsigned sbflags);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
diff --git a/super-recover.c b/super-recover.c
index 5298d46c..6b80416f 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -302,7 +302,7 @@ int btrfs_recover_superblocks(const char *dname,
 	}
 	/* reset super_bytenr in order that we will rewrite all supers */
 	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
-	ret = write_all_supers(root);
+	ret = write_all_supers(root->fs_info);
 	if (!ret)
 		ret = 2;
 	else
-- 
2.13.1



