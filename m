Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56888 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S966728AbcJFJNq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 05:13:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Fix stack overflow for checking qgroup on tree reloc tree
Date: Thu,  6 Oct 2016 17:13:32 +0800
Message-Id: <20161006091332.12836-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For tree reloc tree whose level is >= 2, the root node's parent will
point to itself.
In this case it will make btrfsck overflow its stack and cause segfault.

While for tree reloc tree, it doesn't affect qgroup and kernel can
handle it well.

So add tree reloc tree check for qgroup-verify.c and fix the bug.

Test case will follow soon after I make a minimal image for it.
Current xz ziped image is still over 10M for a 512M fs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index df0e547..9a56f59 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -369,6 +369,11 @@ static int find_parent_roots(struct ulist *roots, u64 parent)
 				if (ret < 0)
 					goto out;
 			}
+		} else if (ref->parent == ref->bytenr) {
+			/*
+			 * Special loop case for tree reloc tree
+			 */
+			ref->root = BTRFS_TREE_RELOC_OBJECTID;
 		} else {
 			ret = find_parent_roots(roots, ref->parent);
 			if (ret < 0)
@@ -578,6 +583,8 @@ static u64 resolve_one_root(u64 bytenr)
 
 	if (ref->root)
 		return ref->root;
+	if (ref->parent == bytenr)
+		return BTRFS_TREE_RELOC_OBJECTID;
 	return resolve_one_root(ref->parent);
 }
 
@@ -748,6 +755,9 @@ static int add_refs_for_implied(struct btrfs_fs_info *info, u64 bytenr,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 
+	/* Tree reloc tree doesn't contribute qgroup, skip it */
+	if (root_id == BTRFS_TREE_RELOC_OBJECTID)
+		return 0;
 	key.objectid = root_id;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-- 
2.10.0



