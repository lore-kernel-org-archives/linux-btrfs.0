From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 64/65] btrfs: copy_for_split should return void
Date: Mon, 03 Oct 2011 23:23:34 -0400
Message-ID: <20111004032307.249944442@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 copy_for_split has no error conditions and should return void. We
 return 0 from split_leaf instead of ret since ret would have been
 set using the return value from copy_for_split which would have been 0.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2695,12 +2695,12 @@ out:
  *
  * returns 0 if all went well and < 0 on failure.
  */
-static noinline int copy_for_split(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct btrfs_path *path,
-			       struct extent_buffer *l,
-			       struct extent_buffer *right,
-			       int slot, int mid, int nritems)
+static noinline void copy_for_split(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct extent_buffer *l,
+				    struct extent_buffer *right,
+				    int slot, int mid, int nritems)
 {
 	int data_copy_size;
 	int rt_data_off;
@@ -2752,8 +2752,6 @@ static noinline int copy_for_split(struc
 	}
 
 	BUG_ON(path->slots[0] < 0);
-
-	return 0;
 }
 
 /*
@@ -2965,8 +2963,7 @@ again:
 		return ret;
 	}
 
-	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
-	BUG_ON(ret);
+	copy_for_split(trans, root, path, l, right, slot, mid, nritems);
 
 	if (split == 2) {
 		BUG_ON(num_doubles != 0);
@@ -2974,7 +2971,7 @@ again:
 		goto again;
 	}
 
-	return ret;
+	return 0;
 
 push_for_double:
 	push_for_double_split(trans, root, path, data_size);


