From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 3/5] updated transaction fixes patch
Date: Fri, 18 Jul 2008 12:42:02 -0400
Message-ID: <20080718164202.GG15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here's an updated patch that fixes the exiting a function without stopping the
transaction problems.  Applies cleanly to the unstable tree.  Thanks,

Josef


diff -r f661d8fc8b9f extent-tree.c
--- a/extent-tree.c	Fri Jul 18 19:42:53 2008 -0400
+++ b/extent-tree.c	Fri Jul 18 19:44:06 2008 -0400
@@ -3191,8 +3191,10 @@ next:
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0)
 		ret = -EIO;
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_end_transaction(trans, root);
 		goto out;
+	}
 
 	clear_extent_bits(&info->block_group_cache, key.objectid,
 			  key.objectid + key.offset - 1,
diff -r f661d8fc8b9f ioctl.c
--- a/ioctl.c	Fri Jul 18 19:42:53 2008 -0400
+++ b/ioctl.c	Fri Jul 18 19:44:06 2008 -0400
@@ -78,8 +78,10 @@ static noinline int create_subvol(struct
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
 				      objectid, trans->transid, 0, 0,
 				      0, 0);
-	if (IS_ERR(leaf))
-		return PTR_ERR(leaf);
+	if (IS_ERR(leaf)) {
+		ret = PTR_ERR(leaf);
+		goto fail;
+	}
 
 	btrfs_set_header_nritems(leaf, 0);
 	btrfs_set_header_level(leaf, 0);
