From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix null dereference in relocation.c
Date: Mon, 31 May 2010 16:58:47 +0800
Message-ID: <4C037A47.4030305@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, error27@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix a potential null dereference in relocation.c

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
--- 1/fs/btrfs/relocation.c	2010-05-26 00:13:07.227605825 +0800
+++ 2/fs/btrfs/relocation.c	2010-05-31 16:35:23.489829633 +0800
@@ -784,16 +784,17 @@ again:
 				struct btrfs_extent_ref_v0 *ref0;
 				ref0 = btrfs_item_ptr(eb, path1->slots[0],
 						struct btrfs_extent_ref_v0);
-				root = find_tree_root(rc, eb, ref0);
-				if (!root->ref_cows)
-					cur->cowonly = 1;
 				if (key.objectid == key.offset) {
+					root = find_tree_root(rc, eb, ref0);
 					if (root && !should_ignore_root(root))
 						cur->root = root;
 					else
 						list_add(&cur->list, &useless);
 					break;
 				}
+				if (is_cowonly_root(btrfs_ref_root_v0(eb,
+								      ref0)))
+					cur->cowonly = 1;
 			}
 #else
 		BUG_ON(key.type == BTRFS_EXTENT_REF_V0_KEY);
