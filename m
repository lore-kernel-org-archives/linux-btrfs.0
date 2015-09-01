Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21284 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755290AbbIAIwa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 04:52:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t818qIdg027663
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 16:52:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 10/14] btrfs: delayed_ref: release and free qgroup reserved at proper timing
Date: Tue, 1 Sep 2015 16:50:23 +0800
Message-ID: <1441097425-8919-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qgroup reserved space needs to be released from inode dirty map and get
freed at different timing:

1) Release when the metadata is written into tree
After corresponding metadata is written into tree, any newer write will
be COWed(don't include NOCOW case yet).
So we must release its range from inode dirty range map, or we will
forget to reserve needed range, causing accounting exceeding the limit.

2) Free reserved bytes when delayed ref is run
When delayed refs are run, qgroup accounting will follow soon and turn
the reserved bytes into rfer/excl numbers.
As run_delayed_refs and qgroup accounting are all done at
commit_transaction() time, we are safe to free reserved space in
run_delayed_ref time().

With these timing to release/free reserved space, we should be able to
resolve the long existing qgroup reserve space leak problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  4 ++++
 fs/btrfs/inode.c       | 10 ++++++++++
 fs/btrfs/qgroup.c      |  5 ++---
 fs/btrfs/qgroup.h      |  8 +++++++-
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 38b76cc..4d9b01b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2277,6 +2277,10 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 						      node->num_bytes);
 			}
 		}
+
+		/* Also free its reserved qgroup space */
+		btrfs_qgroup_free_refroot(root->fs_info, head->qgroup_ref_root,
+					  head->qgroup_reserved);
 		return ret;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 763197f..37e45d5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2112,6 +2112,16 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
 					btrfs_ino(inode), file_pos, &ins);
+	if (ret < 0)
+		goto out;
+	/*
+	 * Release the reserved range from inode dirty range map, and
+	 * move it to delayed ref codes, as now accounting only happens at
+	 * commit_transaction() time.
+	 */
+	btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
+	ret = btrfs_add_delayed_qgroup_reserve(root->fs_info, trans,
+			root->objectid, disk_bytenr, ram_bytes);
 out:
 	btrfs_free_path(path);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7ccbd4c..4ac2f84 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2141,14 +2141,13 @@ out:
 	return ret;
 }
 
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
+			       u64 ref_root, u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
-	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
 
 	if (!is_fstree(ref_root))
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 8e69dc1..49fa15e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -75,7 +75,13 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
+void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
+			       u64 ref_root, u64 num_bytes);
+static inline void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+{
+	return btrfs_qgroup_free_refroot(root->fs_info, root->objectid,
+					 num_bytes);
+}
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
-- 
2.5.1

