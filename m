Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43567 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbcLEJKX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:10:23 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/4] btrfs-progs: check: Fix assert when using lowmem on fs with tree reloc tree
Date: Mon,  5 Dec 2016 17:07:53 +0800
Message-Id: <20161205090756.7960-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
References: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using lowmem mode, btrfs check will report ASSERT for calling
btrfs_read_fs_root() on tree reloc tree.

Fix it by checking objectid and call btrfs_read_fs_root_no_cache() for
tree reloc tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 30eabb2..30847a0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11411,7 +11411,11 @@ static int check_chunks_and_extents_v2(struct btrfs_root *root)
 			goto next;
 		key.offset = (u64)-1;
 
-		cur_root = btrfs_read_fs_root(root->fs_info, &key);
+		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			cur_root = btrfs_read_fs_root_no_cache(root->fs_info,
+					&key);
+		else
+			cur_root = btrfs_read_fs_root(root->fs_info, &key);
 		if (IS_ERR(cur_root) || !cur_root) {
 			error("failed to read tree: %lld", key.objectid);
 			goto next;
@@ -11420,6 +11424,8 @@ static int check_chunks_and_extents_v2(struct btrfs_root *root)
 		ret = traverse_tree_block(cur_root, cur_root->node);
 		err |= ret;
 
+		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			btrfs_free_fs_root(cur_root);
 next:
 		ret = btrfs_next_item(root1, &path);
 		if (ret)
-- 
2.10.2



