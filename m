Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56679 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbaA1LPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 06:15:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0SBEvvM006860
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 19:14:57 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leaks on walking backrefs failure
Date: Tue, 28 Jan 2014 19:13:38 +0800
Message-Id: <1390907618-2105-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390907618-2105-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390907618-2105-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When walking backrefs, we may iterate every inode's extent
and add/merge them into ulist, and the caller will free memory
from ulist.

However, if we fail to allocate inode's extents element
memory or ulist_add() fail to allocate memory, we won't
add allocated memory into ulist, and the caller won't
free some allocated memory thus memory leaks happen.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1b6e003..e4e15a8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -66,6 +66,16 @@ static int check_extent_in_eb(struct btrfs_key *key, struct extent_buffer *eb,
 	return 0;
 }
 
+static void free_inode_elem_list(struct extent_inode_elem *eie)
+{
+	struct extent_inode_elem *eie_next;
+
+	for (; eie; eie = eie_next) {
+		eie_next = eie->next;
+		kfree(eie);
+	}
+}
+
 static int find_extent_in_eb(struct extent_buffer *eb, u64 wanted_disk_byte,
 				u64 extent_item_pos,
 				struct extent_inode_elem **eie)
@@ -275,6 +285,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 					old = old->next;
 				old->next = eie;
 			}
+			eie = NULL;
 		}
 next:
 		ret = btrfs_next_old_item(root, path, time_seq);
@@ -282,6 +293,8 @@ next:
 
 	if (ret > 0)
 		ret = 0;
+	else if (ret < 0)
+		free_inode_elem_list(eie);
 	return ret;
 }
 
@@ -846,6 +859,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	struct list_head prefs_delayed;
 	struct list_head prefs;
 	struct __prelim_ref *ref;
+	struct extent_inode_elem *eie = NULL;
 
 	INIT_LIST_HEAD(&prefs);
 	INIT_LIST_HEAD(&prefs_delayed);
@@ -959,7 +973,6 @@ again:
 				goto out;
 		}
 		if (ref->count && ref->parent) {
-			struct extent_inode_elem *eie = NULL;
 			if (extent_item_pos && !ref->inode_list) {
 				u32 bsz;
 				struct extent_buffer *eb;
@@ -994,6 +1007,7 @@ again:
 					eie = eie->next;
 				eie->next = ref->inode_list;
 			}
+			eie = NULL;
 		}
 		list_del(&ref->list);
 		kmem_cache_free(btrfs_prelim_ref_cache, ref);
@@ -1012,7 +1026,8 @@ out:
 		list_del(&ref->list);
 		kmem_cache_free(btrfs_prelim_ref_cache, ref);
 	}
-
+	if (ret < 0)
+		free_inode_elem_list(eie);
 	return ret;
 }
 
@@ -1020,7 +1035,6 @@ static void free_leaf_list(struct ulist *blocks)
 {
 	struct ulist_node *node = NULL;
 	struct extent_inode_elem *eie;
-	struct extent_inode_elem *eie_next;
 	struct ulist_iterator uiter;
 
 	ULIST_ITER_INIT(&uiter);
@@ -1028,10 +1042,7 @@ static void free_leaf_list(struct ulist *blocks)
 		if (!node->aux)
 			continue;
 		eie = (struct extent_inode_elem *)(uintptr_t)node->aux;
-		for (; eie; eie = eie_next) {
-			eie_next = eie->next;
-			kfree(eie);
-		}
+		free_inode_elem_list(eie);
 		node->aux = 0;
 	}
 
-- 
1.8.3.1

