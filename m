From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH] btrfs: Remove BUG_ON's from btrfs_update_root
Date: Tue, 28 Jun 2011 15:07:41 -0700
Message-ID: <20110628220741.GE20816@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Instead, have it pass those errors back to the callers. Most callers right
now actually BUG_ON the return code anyway so behavior hasn't really changed
in those cases. Others (such as btrfs_sync_log()) try to handle the error
returned. btrfs_ioctl_subvol_setflags() ignores the error today. In order to
maintain behavior I placed a BUG_ON clause there - at least though it's now
at a higher level in the code.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/ioctl.c     |    1 +
 fs/btrfs/root-tree.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..6ebd282 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1437,6 +1437,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
+	BUG_ON(ret);
 
 	btrfs_commit_transaction(trans, root);
 out_reset:
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ebe4544..ea96ab8 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -94,7 +94,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
@@ -104,7 +106,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		printk(KERN_CRIT "unable to update root key %llu %u %llu\n",
 		       (unsigned long long)key->objectid, key->type,
 		       (unsigned long long)key->offset);
-		BUG_ON(1);
+		goto out;
 	}
 
 	l = path->nodes[0];
-- 
1.7.5.3

