From: Dan Carpenter <error27@gmail.com>
Subject: [patch 3/11] btrfs: handle kzalloc() failure in open_ctree()
Date: Sat, 29 May 2010 11:43:07 +0200
Message-ID: <20100529094307.GD5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Unwind and return -ENOMEM if the allocation fails here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f3b287c..73895ba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1941,8 +1941,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		     btrfs_level_size(tree_root,
 				      btrfs_super_log_root_level(disk_super));
 
-		log_tree_root = kzalloc(sizeof(struct btrfs_root),
-						      GFP_NOFS);
+		log_tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
+		if (!log_tree_root) {
+			err = -ENOMEM;
+			goto fail_trans_kthread;
+		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
