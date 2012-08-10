Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5472 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab2HJIy4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 04:54:56 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7A8sqHf011865
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2012 16:54:53 +0800
Message-ID: <5024CC33.2040901@cn.fujitsu.com>
Date: Fri, 10 Aug 2012 16:54:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 3/3] Btrfs-progs: fix unresolved ref root message
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfsck misinformed "unresolved ref root" message when there were several
snapshots in the file system. The patch(commit cfdd42686c70) tried to fix
this bug, but didn't fix it completely. If the metadata was stored in a
shared leaf of the tree, the problem would happen again. This patch fixes
it by another way, we don't check the relationship of the trees when we
traverse the fs/file tree, we just do the check when we merge the snapshot
records to the root cache.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- new patch.
---
 btrfsck.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index bb1aa76..4e91769 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -857,13 +857,10 @@ static int process_dir_item(struct btrfs_root *root,
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
 		} else if (location.type == BTRFS_ROOT_ITEM_KEY) {
-			u64 parent = root->objectid;
-
-			if (is_child_root(root, parent, location.objectid))
-				add_inode_backref(root_cache, location.objectid,
-						  key->objectid, key->offset,
-						  namebuf, len, filetype,
-						  key->type, error);
+			add_inode_backref(root_cache, location.objectid,
+					  key->objectid, key->offset,
+					  namebuf, len, filetype,
+					  key->type, error);
 		} else {
 			fprintf(stderr, "warning line %d\n", __LINE__);
 		}
@@ -1489,6 +1486,9 @@ static int merge_root_recs(struct btrfs_root *root,
 		remove_cache_extent(src_cache, &node->cache);
 		free(node);
 
+		if (!is_child_root(root, root->objectid, rec->ino))
+			goto skip;
+
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			BUG_ON(backref->found_inode_ref);
 			if (backref->found_dir_item)
@@ -1504,6 +1504,7 @@ static int merge_root_recs(struct btrfs_root *root,
 					backref->namelen, BTRFS_DIR_INDEX_KEY,
 					backref->errors);
 		}
+skip:
 		free_inode_rec(rec);
 	}
 	return 0;
-- 
1.7.6.5
