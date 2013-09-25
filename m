Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab3IYNr2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 09:47:28 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8PDlMZP026984
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 21:47:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: fix oops caused by the space balance and dead roots
Date: Wed, 25 Sep 2013 21:47:44 +0800
Message-Id: <1380116865-23406-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com>
References: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing space balance and subvolume destroy at the same time, we met
the following oops:

kernel BUG at fs/btrfs/relocation.c:2247!
RIP: 0010: [<ffffffffa04cec16>] prepare_to_merge+0x154/0x1f0 [btrfs]
Call Trace:
 [<ffffffffa04b5ab7>] relocate_block_group+0x466/0x4e6 [btrfs]
 [<ffffffffa04b5c7a>] btrfs_relocate_block_group+0x143/0x275 [btrfs]
 [<ffffffffa0495c56>] btrfs_relocate_chunk.isra.27+0x5c/0x5a2 [btrfs]
 [<ffffffffa0459871>] ? btrfs_item_key_to_cpu+0x15/0x31 [btrfs]
 [<ffffffffa048b46a>] ? btrfs_get_token_64+0x7e/0xcd [btrfs]
 [<ffffffffa04a3467>] ? btrfs_tree_read_unlock_blocking+0xb2/0xb7 [btrfs]
 [<ffffffffa049907d>] btrfs_balance+0x9c7/0xb6f [btrfs]
 [<ffffffffa049ef84>] btrfs_ioctl_balance+0x234/0x2ac [btrfs]
 [<ffffffffa04a1e8e>] btrfs_ioctl+0xd87/0x1ef9 [btrfs]
 [<ffffffff81122f53>] ? path_openat+0x234/0x4db
 [<ffffffff813c3b78>] ? __do_page_fault+0x31d/0x391
 [<ffffffff810f8ab6>] ? vma_link+0x74/0x94
 [<ffffffff811250f5>] vfs_ioctl+0x1d/0x39
 [<ffffffff811258c8>] do_vfs_ioctl+0x32d/0x3e2
 [<ffffffff811259d4>] SyS_ioctl+0x57/0x83
 [<ffffffff813c3bfa>] ? do_page_fault+0xe/0x10
 [<ffffffff813c73c2>] system_call_fastpath+0x16/0x1b

It is because we returned the error number if the reference of the root was 0
when doing space relocation. It was not right here, because though the root
was dead(refs == 0), but the space it held still need be relocated, or we
could not remove the block group. So in this case, we should return the root
no matter it is dead or not.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c    |  9 +++++----
 fs/btrfs/disk-io.h    | 13 +++++++++++--
 fs/btrfs/relocation.c |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4cbb00a..65eddf7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1560,8 +1560,9 @@ int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
-					      struct btrfs_key *location)
+struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
+				     struct btrfs_key *location,
+				     bool check_ref)
 {
 	struct btrfs_root *root;
 	int ret;
@@ -1585,7 +1586,7 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
-		if (btrfs_root_refs(&root->root_item) == 0)
+		if (check_ref && btrfs_root_refs(&root->root_item) == 0)
 			return ERR_PTR(-ENOENT);
 		return root;
 	}
@@ -1594,7 +1595,7 @@ again:
 	if (IS_ERR(root))
 		return root;
 
-	if (btrfs_root_refs(&root->root_item) == 0) {
+	if (check_ref && btrfs_root_refs(&root->root_item) == 0) {
 		ret = -ENOENT;
 		goto fail;
 	}
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index b71acd6e..5ce2a7d 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -68,8 +68,17 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 int btrfs_init_fs_root(struct btrfs_root *root);
 int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 			 struct btrfs_root *root);
-struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
-					      struct btrfs_key *location);
+
+struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
+				     struct btrfs_key *key,
+				     bool check_ref);
+static inline struct btrfs_root *
+btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
+			   struct btrfs_key *location)
+{
+	return btrfs_get_fs_root(fs_info, location, true);
+}
+
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root);
 void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index aacc212..1ba09d1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -588,7 +588,7 @@ static struct btrfs_root *read_fs_root(struct btrfs_fs_info *fs_info,
 	else
 		key.offset = (u64)-1;
 
-	return btrfs_read_fs_root_no_name(fs_info, &key);
+	return btrfs_get_fs_root(fs_info, &key, false);
 }
 
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-- 
1.8.3.1

