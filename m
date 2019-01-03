Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2685BC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8DF2073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfACHcb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:32:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:46036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729890AbfACHcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:32:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4D35B00D
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 07:32:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/5] btrfs-progs: mkfs: Create data reloc tree from scratch
Date:   Thu,  3 Jan 2019 15:32:18 +0800
Message-Id: <20190103073221.10525-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103073221.10525-1-wqu@suse.com>
References: <20190103073221.10525-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For data reloc tree creation, we copy its content from fs tree just for
its INODE_ITEM, INODE_REF and dirid.

This hides the detail and is not obvious for why we're copying from fs
root.

This patch will create data reloc tree from scratch by:
- Create root
  Including root item and new tree root.
- Change dirid to BTRFS_FIRST_FREE_OBJECTID
- Insert root INODE_ITEM and INODE_REF

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c   |  3 +--
 disk-io.h   |  1 +
 mkfs/main.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 0668031b974b..e3a3c5fbe492 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -638,8 +638,7 @@ static int btrfs_fs_roots_compare_objectids(struct rb_node *node,
 		return 0;
 }
 
-static int btrfs_fs_roots_compare_roots(struct rb_node *node1,
-					struct rb_node *node2)
+int btrfs_fs_roots_compare_roots(struct rb_node *node1, struct rb_node *node2)
 {
 	struct btrfs_root *root;
 
diff --git a/disk-io.h b/disk-io.h
index c4a6a020dd88..4138dfbdf8a6 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -197,6 +197,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info,
 		     struct extent_buffer *eb);
 int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb);
+int btrfs_fs_roots_compare_roots(struct rb_node *node1, struct rb_node *node2);
 struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 				     struct btrfs_fs_info *fs_info,
 				     u64 objectid);
diff --git a/mkfs/main.c b/mkfs/main.c
index b6748f7fe853..0a13e8d83e4d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -39,6 +39,7 @@
 #include "utils.h"
 #include "list_sort.h"
 #include "help.h"
+#include "rbtree-utils.h"
 #include "mkfs/common.h"
 #include "mkfs/rootdir.h"
 #include "fsfeatures.h"
@@ -709,6 +710,73 @@ static void update_chunk_allocation(struct btrfs_fs_info *fs_info,
 	}
 }
 
+static int create_data_reloc_tree(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_inode_item *inode;
+	struct btrfs_root *root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	u64 ino = BTRFS_FIRST_FREE_OBJECTID;
+	char *name = "..";
+	int ret;
+
+	root = btrfs_create_tree(trans, fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
+	/* Update dirid as created tree has default dirid 0 */
+	btrfs_set_root_dirid(&root->root_item, ino);
+	ret = btrfs_update_root(trans, fs_info->tree_root, &root->root_key,
+				&root->root_item);
+	if (ret < 0)
+		goto out;
+
+	/* Cache this tree so it can be cleaned up at close_ctree() */
+	ret = rb_insert(&fs_info->fs_root_tree, &root->rb_node,
+			btrfs_fs_roots_compare_roots);
+	if (ret < 0)
+		goto out;
+
+	/* Insert INODE_ITEM */
+	ret = btrfs_new_inode(trans, root, ino, 0755 | S_IFDIR);
+	if (ret < 0)
+		goto out;
+
+	/* then INODE_REF */
+	ret = btrfs_insert_inode_ref(trans, root, name, strlen(name), ino, ino,
+				     0);
+	if (ret < 0)
+		goto out;
+
+	/* Update nlink of that inode item */
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		btrfs_release_path(&path);
+		goto out;
+	}
+	if (ret < 0) {
+		btrfs_release_path(&path);
+		goto out;
+	}
+	inode = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			       struct btrfs_inode_item);
+	btrfs_set_inode_nlink(path.nodes[0], inode, 1);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	btrfs_release_path(&path);
+	return 0;
+out:
+	btrfs_abort_transaction(trans, ret);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
@@ -1203,7 +1271,7 @@ raid_groups:
 		goto out;
 	}
 
-	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
+	ret = create_data_reloc_tree(trans);
 	if (ret) {
 		error("unable to create data reloc tree: %d", ret);
 		goto out;
-- 
2.20.1

