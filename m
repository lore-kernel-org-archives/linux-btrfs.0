Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:61050 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752029AbeFVILx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 04:11:53 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 30B534B41EDC
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2018 16:11:46 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: return EUCLEAN if extent_inline_ref type is invalid
Date: Fri, 22 Jun 2018 16:18:01 +0800
Message-ID: <20180622081801.19891-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
References: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If type of extent_inline_ref found is not expected, filesystem may have
been corrupted, should return EUCLEAN instead of EINVAL.
No functional changes.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:
 Add changes in build_backref_tree, get_extent_inline_ref and
   add_inline_refs.
   
 fs/btrfs/backref.c     | 4 ++--
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/relocation.c  | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0a8e2e29a66b..60f4afa8ecbc 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -925,7 +925,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 		type = btrfs_get_extent_inline_ref_type(leaf, iref,
 							BTRFS_REF_TYPE_ANY);
 		if (type == BTRFS_REF_TYPE_INVALID)
-			return -EINVAL;
+			return -EUCLEAN;
 
 		offset = btrfs_extent_inline_ref_offset(leaf, iref);
 
@@ -1793,7 +1793,7 @@ static int get_extent_inline_ref(unsigned long *ptr,
 	*out_type = btrfs_get_extent_inline_ref_type(eb, *out_eiref,
 						     BTRFS_REF_TYPE_ANY);
 	if (*out_type == BTRFS_REF_TYPE_INVALID)
-		return -EINVAL;
+		return -EUCLEAN;
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
 	WARN_ON(*ptr > end);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..05d50c3a594e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1727,7 +1727,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_get_extent_inline_ref_type(leaf, iref, needed);
 		if (type == BTRFS_REF_TYPE_INVALID) {
-			err = -EINVAL;
+			err = -EUCLEAN;
 			goto out;
 		}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..2c13e7761440 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -792,7 +792,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			type = btrfs_get_extent_inline_ref_type(eb, iref,
 							BTRFS_REF_TYPE_BLOCK);
 			if (type == BTRFS_REF_TYPE_INVALID) {
-				err = -EINVAL;
+				err = -EUCLEAN;
 				goto out;
 			}
 			key.type = type;
@@ -3801,7 +3801,7 @@ int add_data_references(struct reloc_control *rc,
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
 		} else {
-			ret = -EINVAL;
+			ret = -EUCLEAN;
 			btrfs_err(rc->extent_root->fs_info,
 		     "extent %llu slot %d has an invalid inline ref type",
 			     eb->start, path->slots[0]);
-- 
2.17.1



