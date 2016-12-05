Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24505 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbcLEJKW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:10:22 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/4] btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023
Date: Mon,  5 Dec 2016 17:07:54 +0800
Message-Id: <20161205090756.7960-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
References: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem mode fsck will overflow its stack since it will do infinite
backref check for tree reloc root.
We should not check backref if it's pointing to itself for tree reloc
root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 30847a0..ef90d87 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9999,10 +9999,15 @@ static int check_tree_block_ref(struct btrfs_root *root,
 	u32 nodesize = root->nodesize;
 	u32 item_size;
 	u64 offset;
+	int tree_reloc_root = 0;
 	int found_ref = 0;
 	int err = 0;
 	int ret;
 
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID &&
+	    btrfs_header_bytenr(root->node) == bytenr)
+		tree_reloc_root = 1;
+
 	btrfs_init_path(&path);
 	key.objectid = bytenr;
 	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
@@ -10090,9 +10095,16 @@ static int check_tree_block_ref(struct btrfs_root *root,
 			(offset == root->objectid || offset == owner)) {
 			found_ref = 1;
 		} else if (type == BTRFS_SHARED_BLOCK_REF_KEY) {
+			/*
+			 * Backref of tree reloc root points to itself, no need
+			 * to check backref any more.
+			 */
+			if (tree_reloc_root)
+				found_ref = 1;
+			else
 			/* Check if the backref points to valid referencer */
-			found_ref = !check_tree_block_ref(root, NULL, offset,
-							  level + 1, owner);
+				found_ref = !check_tree_block_ref(root, NULL,
+						offset, level + 1, owner);
 		}
 
 		if (found_ref)
-- 
2.10.2



