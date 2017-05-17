Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24182 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752689AbdEQC4k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 22:56:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [RFC PATCH v3.2 1/6] btrfs: qgroup: Add quick exit for non-fs extents
Date: Wed, 17 May 2017 10:56:23 +0800
Message-ID: <20170517025628.303-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
References: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify btrfs_qgroup_account_extent() to exit quicker for non-fs extents.

The quick exit condition is:
1) The extent belongs to a non-fs tree
   Only fs-tree extents can affect qgroup numbers and is the only case
   where extent can be shared between different trees.

   Although strictly speaking extent in data-reloc or tree-reloc tree
   can be shared, data/tree-reloc root won't occur in the result of
   btrfs_find_all_roots(), so we can ignore such corner case.

   So we can check the first root in old_roots/new_roots ulist.
   If we find the 1st root is a not a fs/subvol root, then we can skip the
   extent.
   If we find the 1st root is a fs/subvol root, then we must continue
   calculation.

OR

2) both 'nr_old_roots' and 'nr_new_roots' are 0
   This means either such extent get allocated then freed in current
   transaction or it's a new reloc tree extent, whose nr_new_roots is 0.
   Either way it won't affect qgroup accounting and can be skipped
   safely.

Such quick exit can make trace output more quite and less confusing:
(example with fs uuid and time stamp removed)

Before:
------
add_delayed_tree_ref: bytenr=29556736 num_bytes=16384 action=ADD_DELAYED_REF parent=0(-) ref_root=2(EXTENT_TREE) level=0 type=TREE_BLOCK_REF seq=0
btrfs_qgroup_account_extent: bytenr=29556736 num_bytes=16384 nr_old_roots=0 nr_new_roots=1
------
Extent tree block will trigger btrfs_qgroup_account_extent() trace point
while no qgroup number is changed, as extent tree won't affect qgroup
accounting.

After:
------
add_delayed_tree_ref: bytenr=29556736 num_bytes=16384 action=ADD_DELAYED_REF parent=0(-) ref_root=2(EXTENT_TREE) level=0 type=TREE_BLOCK_REF seq=0
------
Now such unrelated extent won't trigger btrfs_qgroup_account_extent()
trace point, making the trace less noisy.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3f75b5cbbfef..905fed1ee0dd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1915,6 +1915,33 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+/*
+ * Helper to check if the @roots is a list of fs tree roots
+ * Return 0 for definitely not a fs/subvol tree roots ulist
+ * Return 1 for possible fs/subvol tree roots ulist(including empty)
+ */
+static int maybe_fs_roots(struct ulist *roots)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+
+	/* Empty one, still possible for fs roots */
+	if (!roots || roots->nnodes == 0)
+		return 1;
+
+	ULIST_ITER_INIT(&uiter);
+	unode = ulist_next(roots, &uiter);
+	if (!unode)
+		return 1;
+
+	/*
+	 * If it contains fs tree roots, then it must belongs to fs/subvol
+	 * trees.
+	 * If it contains non-fs tree, it won't be shared to fs/subvol trees.
+	 */
+	return is_fstree(unode->val);
+}
+
 int
 btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
@@ -1931,10 +1958,20 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return 0;
 
-	if (new_roots)
+	if (new_roots) {
+		if (!maybe_fs_roots(new_roots))
+			goto out_free;
 		nr_new_roots = new_roots->nnodes;
-	if (old_roots)
+	}
+	if (old_roots) {
+		if (!maybe_fs_roots(old_roots))
+			goto out_free;
 		nr_old_roots = old_roots->nnodes;
+	}
+
+	/* Quick exit, either not fs tree roots, or won't affect any qgroup */
+	if (nr_old_roots == 0 && nr_new_roots == 0)
+		goto out_free;
 
 	BUG_ON(!fs_info->quota_root);
 
-- 
2.13.0



