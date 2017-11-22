Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:56555 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdKVJER (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:04:17 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 07/11] btrfs-progs: lowmem check: Fix function call stack overflow caused by wrong tree reloc tree detection
Date: Wed, 22 Nov 2017 17:03:21 +0800
Message-Id: <20171122090325.29458-8-wqu@suse.com>
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
References: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For tree reloc tree root, its backref points to it self.
So for such case, we should finish the lookup.

Previous end condition is to ensure it's tree reloc tree *and* needs its
root bytenr to match the bytenr passed in.

However the @root passed in can be other tree, e.g. other tree reloc
tree which shares the node/leaf.
This makes any check based on @root passed in invalid.

The patch removes the unreliable root objectid detection, and only use
root->bytenr check.
For the possibility of invalid self-pointing backref, extent tree
checker should have already handled it, so we don't need to bother in
fs tree checker.

Fixes: 54c8f9152fd9 ("btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 452e715bf245..7eb08b6cb962 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11700,16 +11700,12 @@ static int check_tree_block_ref(struct btrfs_root *root,
 	u32 nodesize = root->fs_info->nodesize;
 	u32 item_size;
 	u64 offset;
-	int tree_reloc_root = 0;
 	int found_ref = 0;
 	int err = 0;
 	int ret;
 	int strict = 1;
 	int parent = 0;
 
-	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID &&
-	    btrfs_header_bytenr(root->node) == bytenr)
-		tree_reloc_root = 1;
 	btrfs_init_path(&path);
 	key.objectid = bytenr;
 	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
@@ -11817,8 +11813,12 @@ static int check_tree_block_ref(struct btrfs_root *root,
 			/*
 			 * Backref of tree reloc root points to itself, no need
 			 * to check backref any more.
+			 *
+			 * This may be an error of loop backref, but extent tree
+			 * checker should have already handled it.
+			 * Here we only need to avoid infinite iteration.
 			 */
-			if (tree_reloc_root) {
+			if (offset == bytenr) {
 				found_ref = 1;
 			} else {
 				/*
-- 
2.15.0

