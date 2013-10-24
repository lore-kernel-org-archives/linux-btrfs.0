Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:45612 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab3JXN3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 09:29:38 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, dustymabe@gmail.com
Subject: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting (bug #61951)
Date: Thu, 24 Oct 2013 15:22:06 +0200
Message-Id: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
tracking is based on delayed refs. The owner of a tree block is set when a
tree block is allocated, it is never updated.

When you allocate a tree block and then remove the subvolume that did the
allocation, the qgroup accounting for that removal is correct. However, the
removal was accounted again for each subvolume deletion that also referenced
the tree block, because accounting was erroneously based on the owner.

Instead of queueing delayed refs for the non-existent owner, we now
queue delayed refs for the root being removed. This fixes the qgroup
accounting.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Tested-by: <dustymabe@gmail.com>
---
 fs/btrfs/extent-tree.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..7846cae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3004,12 +3004,11 @@ out:
 static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   int full_backref, int inc, int for_cow)
+			   int full_backref, u64 ref_root, int inc, int for_cow)
 {
 	u64 bytenr;
 	u64 num_bytes;
 	u64 parent;
-	u64 ref_root;
 	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
@@ -3019,7 +3018,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64, int);
 
-	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
 
@@ -3075,13 +3073,19 @@ fail:
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 1, for_cow);
+	u64 ref_root;
+
+	ref_root = btrfs_header_owner(buf);
+
+	return __btrfs_mod_ref(trans, root, buf, full_backref, ref_root,
+			       1, for_cow);
 }
 
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 0, for_cow);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, root->objectid,
+			       0, for_cow);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
-- 
1.7.2.2

