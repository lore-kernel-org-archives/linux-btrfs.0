Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:33308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbeHHQTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 12:19:35 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 1/3] fs/btrfs/disk-io: change btrfs_destroy_delayed_refs to be void function
Date: Wed, 8 Aug 2018 21:47:53 +0800
Message-ID: <1533736075-8691-2-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_destroy_delayed_refs defines the variable "ret" for return value, but
it is not modified after initialization. Further, I find that any of the
callees do not handle the return value.  So it is safe to drop the
unneeded value "ret".

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/disk-io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5124c15..f972fdd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -53,8 +53,8 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info);
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				       struct btrfs_fs_info *fs_info);
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
 					struct extent_io_tree *dirty_pages,
@@ -4186,13 +4186,12 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->ordered_root_lock);
 }
 
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info)
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				       struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -4200,7 +4199,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (atomic_read(&delayed_refs->num_entries) == 0) {
 		spin_unlock(&delayed_refs->lock);
 		btrfs_info(fs_info, "delayed_refs has NO entry");
-		return ret;
+		return;
 	}
 
 	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
@@ -4254,8 +4253,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	}
 
 	spin_unlock(&delayed_refs->lock);
-
-	return ret;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
-- 
1.7.12.4

