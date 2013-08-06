Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3HFCbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 22:31:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r762VI6T032144
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Aug 2013 10:31:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: pass gfp_t to __add_prelim_ref() to avoid always using GFP_ATOMIC
Date: Tue, 6 Aug 2013 10:29:54 +0800
Message-Id: <1375756194-5143-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, only add_delayed_refs have to allocate with GFP_ATOMIC,
So just pass arg 'gfp_t' to decide which allocation mode.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bc5e8c..cb73a12 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -160,12 +160,12 @@ struct __prelim_ref {
 
 static int __add_prelim_ref(struct list_head *head, u64 root_id,
 			    struct btrfs_key *key, int level,
-			    u64 parent, u64 wanted_disk_byte, int count)
+			    u64 parent, u64 wanted_disk_byte, int count,
+			    gfp_t gfp_mask)
 {
 	struct __prelim_ref *ref;
 
-	/* in case we're adding delayed refs, we're holding the refs spinlock */
-	ref = kmalloc(sizeof(*ref), GFP_ATOMIC);
+	ref = kmalloc(sizeof(*ref), gfp_mask);
 	if (!ref)
 		return -ENOMEM;
 
@@ -548,7 +548,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = __add_prelim_ref(prefs, ref->root, &op_key,
 					       ref->level + 1, 0, node->bytenr,
-					       node->ref_mod * sgn);
+					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_BLOCK_REF_KEY: {
@@ -558,7 +558,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			ret = __add_prelim_ref(prefs, ref->root, NULL,
 					       ref->level + 1, ref->parent,
 					       node->bytenr,
-					       node->ref_mod * sgn);
+					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_EXTENT_DATA_REF_KEY: {
@@ -570,7 +570,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.offset = ref->offset;
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
-					       node->ref_mod * sgn);
+					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_DATA_REF_KEY: {
@@ -583,7 +583,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.offset = ref->offset;
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0,
 					       ref->parent, node->bytenr,
-					       node->ref_mod * sgn);
+					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
 		}
 		default:
@@ -657,7 +657,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			ret = __add_prelim_ref(prefs, 0, NULL,
 						*info_level + 1, offset,
-						bytenr, 1);
+						bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			struct btrfs_shared_data_ref *sdref;
@@ -666,13 +666,13 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			sdref = (struct btrfs_shared_data_ref *)(iref + 1);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
 			ret = __add_prelim_ref(prefs, 0, NULL, 0, offset,
-					       bytenr, count);
+					       bytenr, count, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			ret = __add_prelim_ref(prefs, offset, NULL,
 					       *info_level + 1, 0,
-					       bytenr, 1);
+					       bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -687,7 +687,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
-					       bytenr, count);
+					       bytenr, count, GFP_NOFS);
 			break;
 		}
 		default:
@@ -738,7 +738,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			ret = __add_prelim_ref(prefs, 0, NULL,
 						info_level + 1, key.offset,
-						bytenr, 1);
+						bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			struct btrfs_shared_data_ref *sdref;
@@ -748,13 +748,13 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 					      struct btrfs_shared_data_ref);
 			count = btrfs_shared_data_ref_count(leaf, sdref);
 			ret = __add_prelim_ref(prefs, 0, NULL, 0, key.offset,
-						bytenr, count);
+						bytenr, count, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			ret = __add_prelim_ref(prefs, key.offset, NULL,
 					       info_level + 1, 0,
-					       bytenr, 1);
+					       bytenr, 1, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -770,7 +770,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
-					       bytenr, count);
+					       bytenr, count, GFP_NOFS);
 			break;
 		}
 		default:
-- 
1.8.0.1

