Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaFICyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 22:54:21 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: [PATCH v2] Btrfs: fix scrub_print_warning to handle skinny metadata extents
Date: Mon,  9 Jun 2014 10:54:07 +0800
Message-Id: <1402282447-1545-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The skinny extents are intepreted incorrectly in scrub_print_warning(),
and end up hitting the BUG() in btrfs_extent_inline_ref_size.

Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Add a 'Reported-by' tag.

 fs/btrfs/backref.c | 30 +++++++++++++++++++-----------
 fs/btrfs/backref.h |  4 ++--
 fs/btrfs/scrub.c   |  5 +++--
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 10db21f..e9d9e52 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1404,9 +1404,10 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
  * returns <0 on error
  */
 static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				struct btrfs_extent_inline_ref **out_eiref,
-				int *out_type)
+				   struct btrfs_key *key,
+				   struct btrfs_extent_item *ei, u32 item_size,
+				   struct btrfs_extent_inline_ref **out_eiref,
+				   int *out_type)
 {
 	unsigned long end;
 	u64 flags;
@@ -1416,9 +1417,16 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 		/* first call */
 		flags = btrfs_extent_flags(eb, ei);
 		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-			info = (struct btrfs_tree_block_info *)(ei + 1);
-			*out_eiref =
-				(struct btrfs_extent_inline_ref *)(info + 1);
+			if (key->type == BTRFS_METADATA_ITEM_KEY) {
+				/* a skinny metadata extent */
+				*out_eiref =
+				     (struct btrfs_extent_inline_ref *)(ei + 1);
+			} else {
+				WARN_ON(key->type != BTRFS_EXTENT_ITEM_KEY);
+				info = (struct btrfs_tree_block_info *)(ei + 1);
+				*out_eiref =
+				   (struct btrfs_extent_inline_ref *)(info + 1);
+			}
 		} else {
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
@@ -1428,7 +1436,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 	}
 
 	end = (unsigned long)ei + item_size;
-	*out_eiref = (struct btrfs_extent_inline_ref *)*ptr;
+	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
 	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
@@ -1447,8 +1455,8 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
  * <0 on error.
  */
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				u64 *out_root, u8 *out_level)
+			    struct btrfs_key *key, struct btrfs_extent_item *ei,
+			    u32 item_size, u64 *out_root, u8 *out_level)
 {
 	int ret;
 	int type;
@@ -1459,8 +1467,8 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 		return 1;
 
 	while (1) {
-		ret = __get_extent_inline_ref(ptr, eb, ei, item_size,
-						&eiref, &type);
+		ret = __get_extent_inline_ref(ptr, eb, key, ei, item_size,
+					      &eiref, &type);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index a910b27..519b49e 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -40,8 +40,8 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 			u64 *flags);
 
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				u64 *out_root, u8 *out_level);
+			    struct btrfs_key *key, struct btrfs_extent_item *ei,
+			    u32 item_size, u64 *out_root, u8 *out_level);
 
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0be7799..12afb0d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -588,8 +588,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
-			ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
-							&ref_root, &ref_level);
+			ret = tree_backref_for_extent(&ptr, eb, &found_key, ei,
+						      item_size, &ref_root,
+						      &ref_level);
 			printk_in_rcu(KERN_WARNING
 				"BTRFS: %s at logical %llu on dev %s, "
 				"sector %llu: metadata %s (level %d) in tree "
-- 
1.8.1.4

