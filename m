Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197FFC43613
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D8A21741
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbeL0HNp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:13:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:35052 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727225AbeL0HNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:13:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15F34AC6F
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 07:13:42 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
Date:   Thu, 27 Dec 2018 15:13:33 +0800
Message-Id: <20181227071333.10964-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181227071333.10964-1-wqu@suse.com>
References: <20181227071333.10964-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
creates uuid tree at mkfs time.

However it doesn't populate uuid tree correctly nor just create an empty
root.
It uses create_tree(), which just copies the content of fs root,
containing meaningless INODE_ITEM:

v4.15 mkfs (no uuid tree creation) + kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
  leaf 30572544 flags 0x1(WRITTEN) backref revision 1
  fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
  chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
		subvol_id 5

v4.19.1 mkfs (incorrect one), no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
  chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..

This patchset will fix it by populuating uuid tree properly:
(NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so we
 can only fix it by populating uuid tree correctly)

w/ this patchset, no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
  chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
	item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL 0x86cde09cb78bcca0) itemoff 16275 itemsize 8
		subvol_id 5

For kernel, except tree-checker needs an non-empty uuid tree, both all
above behavior won't cause problem, but it's always better to keep a
good standardized behavior.

Furthermore, to avoid such problem from happening again, rename the
function create_tree() to create_empty_tree() and create_inode_tree(),
without an @root parameter to avoid such problem.

Fixes: 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c     |   4 ++
 mkfs/common.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/common.h |   3 ++
 mkfs/main.c   |  36 +-----------------
 4 files changed, 112 insertions(+), 34 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 5fafa144c0d3..2cb7f2097fc9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -694,6 +694,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->quota_root)
 		free(fs_info->quota_root);
+	if (fs_info->uuid_root)
+		free(fs_info->uuid_root);
 
 	free(fs_info->tree_root);
 	free(fs_info->extent_root);
@@ -964,6 +966,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
 		free_extent_buffer(fs_info->log_root_tree->node);
 	if (fs_info->chunk_root)
 		free_extent_buffer(fs_info->chunk_root->node);
+	if (fs_info->uuid_root)
+		free_extent_buffer(fs_info->uuid_root->node);
 }
 
 static void free_map_lookup(struct cache_extent *ce)
diff --git a/mkfs/common.c b/mkfs/common.c
index f7e3badcf2b9..1f5e1d03a6e3 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -23,6 +23,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "utils.h"
+#include "transaction.h"
 #include "mkfs/common.h"
 
 static u64 reference_root_table[] = {
@@ -822,4 +823,106 @@ int test_minimum_size(const char *file, u64 min_dev_size)
 	return 0;
 }
 
+/*
+ * Create a tree with all its content copied from @source
+ *
+ * Caller must ensure @source only has one leaf.
+ */
+static int __create_tree(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root, u64 objectid)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_key location;
+	struct btrfs_root_item root_item;
+	struct extent_buffer *tmp;
+	u8 uuid[BTRFS_UUID_SIZE] = {0};
+	int ret;
+
+	ASSERT(btrfs_header_level(root->node) == 0);
+
+	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
+	if (ret)
+		return ret;
+
+	memcpy(&root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_root_generation(&root_item, trans->transid);
+	/* clear uuid and o/ctime of source tree */
+	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
+	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
+	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
+	free_extent_buffer(tmp);
+
+	location.objectid = objectid;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = 0;
+	ret = btrfs_insert_root(trans, fs_info->tree_root,
+				&location, &root_item);
+
+	return ret;
+}
+
+/*
+ * Create an *EMPTY* tree
+ *
+ * Caller must ensure at the time of calling, csum tree is still empty
+ */
+static int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid)
+{
+	struct btrfs_root *csum_root = trans->fs_info->csum_root;
+
+	ASSERT(btrfs_header_level(csum_root->node) == 0 &&
+	       btrfs_header_nritems(csum_root->node) == 0);
+	return __create_tree(trans, csum_root, objectid);
+}
 
+/*
+ * Create a tree containing an root inode
+ *
+ * Caller must ensure at the time of calling, fs tree only contains 2 items
+ * (one for INODE_ITEM and one for INODE_REF)
+ */
+int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)
+{
+	struct btrfs_root *fs_root = trans->fs_info->fs_root;
+
+	ASSERT(btrfs_header_level(fs_root->node) == 0 &&
+	       btrfs_header_nritems(fs_root->node) == 2);
+	return __create_tree(trans, fs_root, objectid);
+}
+
+int create_uuid_tree(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *uuid_root = fs_info->uuid_root;
+	struct btrfs_key key;
+	int ret;
+
+	if (!uuid_root) {
+		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
+		if (ret < 0) {
+			errno = -ret;
+			error("failed to create uuid root: %m");
+			return ret;
+		}
+		key.objectid = BTRFS_UUID_TREE_OBJECTID;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = 0;
+		uuid_root = btrfs_read_fs_root_no_cache(fs_info, &key);
+		if (IS_ERR(uuid_root)) {
+			errno = -PTR_ERR(uuid_root);
+			error("failed to read uuid root: %m");
+			return PTR_ERR(uuid_root);
+		}
+		fs_info->uuid_root = uuid_root;
+	}
+	ret = btrfs_uuid_tree_add(trans, fs_info->fs_root->root_item.uuid,
+				  BTRFS_UUID_KEY_SUBVOL,
+				  fs_info->fs_root->root_key.objectid);
+	if (ret < 0) {
+		errno = -ret;
+		error("failed to add uuid tree entry for fs root: %m");
+	}
+	return ret;
+}
diff --git a/mkfs/common.h b/mkfs/common.h
index 28912906d0a9..adb5d561c38d 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -75,4 +75,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 int test_status_for_mkfs(const char *file, bool force_overwrite);
 int test_dev_for_mkfs(const char *file, int force_overwrite);
 
+int create_uuid_tree(struct btrfs_trans_handle *trans);
+int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid);
+
 #endif
diff --git a/mkfs/main.c b/mkfs/main.c
index b6748f7fe853..ea3d1ae80e5e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -309,38 +309,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int create_tree(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, u64 objectid)
-{
-	struct btrfs_key location;
-	struct btrfs_root_item root_item;
-	struct extent_buffer *tmp;
-	u8 uuid[BTRFS_UUID_SIZE] = {0};
-	int ret;
-
-	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
-	if (ret)
-		return ret;
-
-	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
-	/* clear uuid and o/ctime of source tree */
-	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
-	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
-	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
-	free_extent_buffer(tmp);
-
-	location.objectid = objectid;
-	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = 0;
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
-				&location, &root_item);
-
-	return ret;
-}
-
 static void print_usage(int ret)
 {
 	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
@@ -1203,13 +1171,13 @@ raid_groups:
 		goto out;
 	}
 
-	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
+	ret = create_inode_tree(trans, BTRFS_DATA_RELOC_TREE_OBJECTID);
 	if (ret) {
 		error("unable to create data reloc tree: %d", ret);
 		goto out;
 	}
 
-	ret = create_tree(trans, root, BTRFS_UUID_TREE_OBJECTID);
+	ret = create_uuid_tree(trans);
 	if (ret)
 		warning(
 	"unable to create uuid tree, will be created after mount: %d", ret);
-- 
2.20.1

