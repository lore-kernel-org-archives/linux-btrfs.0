Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31983 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751543AbdFFJz1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:27 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 3/9] btrfs: Check name_len on add_inode_ref call path
Date: Tue, 6 Jun 2017 17:57:02 +0800
Message-ID: <20170606095708.494-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'replay_one_buffer' first reads buffers and dispatches items accroding
item type.
In this patch, 'add_inode_ref' handles inode_ref and inode_extref.
Then 'add_inode_ref' calls 'ref_get_fields' and 'extref_get_fields' to read
ref/extref name for the first time.
So Checking name_len before read in those two is fine.

'add_inode_ref' also calls 'inode_in_dir' to match inode_ref/extef in
parent_dir.
The call graph includes 'btrfs_match_dir_item_name' to read dir_item name
in the parent dir.
Checking first dir_item is not enough. Change it to verify every
dir_item while doing matches.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/dir-item.c |  4 ++--
 fs/btrfs/tree-log.c | 27 ++++++++++++++++++---------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 806b9fe0178a..dc42066cbaeb 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -395,8 +395,6 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
-	if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
-		return NULL;
 
 	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
 	while (cur < total_len) {
@@ -405,6 +403,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
+		if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
+			return NULL;
 		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
 		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
 			return dir_item;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1930f28edcdd..11cf38fb3a49 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1175,15 +1175,19 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
-			     u32 *namelen, char **name, u64 *index,
-			     u64 *parent_objectid)
+static int extref_get_fields(struct extent_buffer *eb, int slot,
+			     unsigned long ref_ptr, u32 *namelen, char **name,
+			     u64 *index, u64 *parent_objectid)
 {
 	struct btrfs_inode_extref *extref;
 
 	extref = (struct btrfs_inode_extref *)ref_ptr;
 
 	*namelen = btrfs_inode_extref_name_len(eb, extref);
+	if (!btrfs_is_name_len_valid(eb, slot, (unsigned long)&extref->name,
+				     *namelen))
+		return -EIO;
+
 	*name = kmalloc(*namelen, GFP_NOFS);
 	if (*name == NULL)
 		return -ENOMEM;
@@ -1198,14 +1202,19 @@ static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
 	return 0;
 }
 
-static int ref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
-			  u32 *namelen, char **name, u64 *index)
+static int ref_get_fields(struct extent_buffer *eb, int slot,
+			  unsigned long ref_ptr, u32 *namelen, char **name,
+			  u64 *index)
 {
 	struct btrfs_inode_ref *ref;
 
 	ref = (struct btrfs_inode_ref *)ref_ptr;
 
 	*namelen = btrfs_inode_ref_name_len(eb, ref);
+	if (!btrfs_is_name_len_valid(eb, slot, (unsigned long)(ref + 1),
+				     *namelen))
+		return -EIO;
+
 	*name = kmalloc(*namelen, GFP_NOFS);
 	if (*name == NULL)
 		return -ENOMEM;
@@ -1280,8 +1289,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 	while (ref_ptr < ref_end) {
 		if (log_ref_ver) {
-			ret = extref_get_fields(eb, ref_ptr, &namelen, &name,
-						&ref_index, &parent_objectid);
+			ret = extref_get_fields(eb, slot, ref_ptr, &namelen,
+					  &name, &ref_index, &parent_objectid);
 			/*
 			 * parent object can change from one array
 			 * item to another.
@@ -1293,8 +1302,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				goto out;
 			}
 		} else {
-			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
-					     &ref_index);
+			ret = ref_get_fields(eb, slot, ref_ptr, &namelen,
+					     &name, &ref_index);
 		}
 		if (ret)
 			goto out;
-- 
2.13.0



