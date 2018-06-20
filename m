Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753989AbeFTMtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:22 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E507AF7E
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/34] btrfs: Remove fs_info from lookup_inline_extent_backref
Date: Wed, 20 Jun 2018 15:48:48 +0300
Message-Id: <1529498956-4241-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where the fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8891eea6fa2c..211a9d0a94dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1596,13 +1596,13 @@ static int find_next_key(struct btrfs_path *path, int level,
  */
 static noinline_for_stack
 int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref **ref_ret,
 				 u64 bytenr, u64 num_bytes,
 				 u64 parent, u64 root_objectid,
 				 u64 owner, u64 offset, int insert)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -1868,9 +1868,9 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	ret = lookup_inline_extent_backref(trans, fs_info, path, ref_ret,
-					   bytenr, num_bytes, parent,
-					   root_objectid, owner, offset, 0);
+	ret = lookup_inline_extent_backref(trans, path, ref_ret, bytenr,
+					   num_bytes, parent, root_objectid,
+					   owner, offset, 0);
 	if (ret != -ENOENT)
 		return ret;
 
@@ -1972,9 +1972,9 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	int ret;
 
-	ret = lookup_inline_extent_backref(trans, fs_info, path, &iref,
-					   bytenr, num_bytes, parent,
-					   root_objectid, owner, offset, 1);
+	ret = lookup_inline_extent_backref(trans, path, &iref, bytenr,
+					   num_bytes, parent, root_objectid,
+					   owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
 		update_inline_extent_backref(fs_info, path, iref,
-- 
2.7.4

