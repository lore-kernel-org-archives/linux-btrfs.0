From: Dan Carpenter <error27@gmail.com>
Subject: [patch 6/11] btrfs: cleanup btrfs_dec_test_ordered_pending()
Date: Sat, 29 May 2010 11:46:06 +0200
Message-ID: <20100529094606.GG5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Yan Zheng <zheng.yan@oracle.com>,
	Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
	kernel-janitors@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

"ret" was used in a confusing way because instead of returning "ret" we
returned the opposite of ret.  I refactored it.  Also if ret is non-zero
in the new code then entry is clearly non-null so I removed that check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..0a37019 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -270,13 +270,13 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 	spin_lock(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node) {
-		ret = 1;
+		ret = 0;
 		goto out;
 	}
 
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 	if (!offset_in_entry(entry, file_offset)) {
-		ret = 1;
+		ret = 0;
 		goto out;
 	}
 
@@ -286,17 +286,19 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 		       (unsigned long long)io_size);
 	}
 	entry->bytes_left -= io_size;
-	if (entry->bytes_left == 0)
+	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
-	else
-		ret = 1;
+		ret = !ret;
+	} else {
+		ret = 0;
+	}
 out:
-	if (!ret && cached && entry) {
+	if (ret && cached) {
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
 	spin_unlock(&tree->lock);
-	return ret == 0;
+	return ret;
 }
 
 /*
