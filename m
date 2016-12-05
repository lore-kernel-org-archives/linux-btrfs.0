Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24505 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751418AbcLEJKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:10:18 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/4] btrfs-progs: check: Fix lowmem false alert on tree reloc tree
Date: Mon,  5 Dec 2016 17:07:55 +0800
Message-Id: <20161205090756.7960-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
References: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem mode will report false alert if the fs has tree reloc tree like:
ERROR: shared extent[30011392 4096] lost its parent (parent: 30011392,
level: 1)

The problem is check_shared_block_backref() can't handle tree reloc
tree's self-pointing backref.

And still try to read out the tree block then seeking for the
referencer.

The correct method for it is to check if it's tree reloc root.
In that case, we should check found the ROOT_ITEM of tree reloc tree in
root tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index ef90d87..d0e1977 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10465,6 +10465,34 @@ out:
 }
 
 /*
+ * Check if tree block @eb is tree reloc root.
+ * Return 0 if it's not or any problem happens
+ * Return 1 if it's a tree reloc root
+ */
+static int is_tree_reloc_root(struct btrfs_fs_info *fs_info,
+				 struct extent_buffer *eb)
+{
+	struct btrfs_root *tree_reloc_root;
+	struct btrfs_key key;
+	u64 bytenr = btrfs_header_bytenr(eb);
+	u64 owner = btrfs_header_owner(eb);
+	int ret = 0;
+
+	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
+	key.offset = owner;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	tree_reloc_root = btrfs_read_fs_root_no_cache(fs_info, &key);
+	if (IS_ERR(tree_reloc_root))
+		return 0;
+
+	if (bytenr == btrfs_header_bytenr(tree_reloc_root->node))
+		ret = 1;
+	btrfs_free_fs_root(tree_reloc_root);
+	return ret;
+}
+
+/*
  * Check referencer for shared block backref
  * If level == -1, this function will resolve the level.
  */
@@ -10486,6 +10514,13 @@ static int check_shared_block_backref(struct btrfs_fs_info *fs_info,
 	if (level < 0)
 		goto out;
 
+	/* It's possible it's a tree reloc root */
+	if (parent == bytenr) {
+		if (is_tree_reloc_root(fs_info, eb))
+			found_parent = 1;
+		goto out;
+	}
+
 	if (level + 1 != btrfs_header_level(eb))
 		goto out;
 
-- 
2.10.2



