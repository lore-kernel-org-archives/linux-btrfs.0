From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 10/20] btrfs: go readonly on insert error in btrfs_add_root_ref()
Date: Thu, 15 Sep 2011 10:34:49 -0700
Message-ID: <1316108099-5099-11-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

In btrfs_add_root_ref() we BUG if an error is encountered during
REF/BACKREF insertion. This does not look like a logic error, thus the BUG
is not called for. However, I don't think there's a simple way to recover
from such an error at that point, so we mark the fs readonly instead.

At the same time, we can update the following caller of
btrfs_add_root_ref() which BUG_ON from an error:

- create_subvol: now passes the return code back to userspace

- create_pending_snapshot: goes readonly on any error from
  btrfs_add_root_ref().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c       |    4 ++--
 fs/btrfs/root-tree.c   |    8 ++++++--
 fs/btrfs/transaction.c |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cf0133..8adb220 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -430,8 +430,8 @@ static noinline int create_subvol(struct btrfs_root *root,
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 btrfs_ino(dir), index, name, namelen);
-
-	BUG_ON(ret);
+	if (ret)
+		goto fail;
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index f409990..02f2bf3 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -407,7 +407,10 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 again:
 	ret = btrfs_insert_empty_item(trans, tree_root, path, &key,
 				      sizeof(*ref) + name_len);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_std_error(tree_root->fs_info, ret);
+		goto out_free;
+	}
 
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
@@ -426,8 +429,9 @@ again:
 		goto again;
 	}
 
+out_free:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dc36fa..7c46ece 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -991,7 +991,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
-	BUG_ON(ret);
+	btrfs_std_error(fs_info, ret);
 	dput(parent);
 
 	key.offset = (u64)-1;
-- 
1.7.6

