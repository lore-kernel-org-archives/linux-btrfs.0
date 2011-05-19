From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: return error code to caller when btrfs_del_item fails
Date: Thu, 19 May 2011 13:37:44 +0900
Message-ID: <201105190437.AA00020@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The error code is returned instead of calling BUG_ON when
btrfs_del_item returns the error.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/file-item.c |   10 ++++++----
 fs/btrfs/root-tree.c |    6 +++++-
 fs/btrfs/tree-log.c  |   10 +++++++---
 fs/btrfs/volumes.c   |    4 +---
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..6e7556a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -551,10 +551,10 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0) {
 			if (path->slots[0] == 0)
-				goto out;
+				break;
 			path->slots[0]--;
 		} else if (ret < 0) {
-			goto out;
+			break;
 		}
 
 		leaf = path->nodes[0];
@@ -579,7 +579,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		/* delete the entire item, it is inside our range */
 		if (key.offset >= bytenr && csum_end <= end_byte) {
 			ret = btrfs_del_item(trans, root, path);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -633,9 +634,10 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		}
 		btrfs_release_path(root, path);
 	}
+	ret = 0;
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 6928bff..2cf5f51 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -385,7 +385,10 @@ again:
 		*sequence = btrfs_root_ref_sequence(leaf, ref);
 
 		ret = btrfs_del_item(trans, tree_root, path);
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
 	} else
 		err = -ENOENT;
 
@@ -397,6 +400,7 @@ again:
 		goto again;
 	}
 
+out:
 	btrfs_free_path(path);
 	return err;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f997ec0..cf2baeb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1050,7 +1050,8 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 			break;
 
 		ret = btrfs_del_item(trans, root, path);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 
 		btrfs_release_path(root, path);
 		inode = read_one_inode(root, key.offset);
@@ -1068,8 +1069,10 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 		 */
 		key.offset = (u64)-1;
 	}
+	ret = 0;
+out:
 	btrfs_release_path(root, path);
-	return 0;
+	return ret;
 }
 
 
@@ -2587,7 +2590,8 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 			break;
 
 		ret = btrfs_del_item(trans, log, path);
-		BUG_ON(ret);
+		if (ret)
+			break;
 		btrfs_release_path(log, path);
 	}
 	btrfs_release_path(log, path);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..fa0f32f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1001,7 +1001,6 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 	if (device->bytes_used > 0)
 		device->bytes_used -= btrfs_dev_extent_length(leaf, extent);
 	ret = btrfs_del_item(trans, root, path);
-	BUG_ON(ret);
 
 	btrfs_free_path(path);
 	return ret;
@@ -1803,10 +1802,9 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	ret = btrfs_del_item(trans, root, path);
-	BUG_ON(ret);
 
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64


