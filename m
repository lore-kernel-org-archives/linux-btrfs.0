From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] Btrfs: double unlock bug in error handling
Date: Wed, 18 Apr 2012 09:59:03 +0300
Message-ID: <20120418065903.GE12831@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The caller expects this function to return with the lock held and
releases it immediately on error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2b35f8d..a0bb9dc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2301,6 +2301,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 				if (ret) {
 					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
+					spin_lock(&delayed_refs->lock);
 					return ret;
 				}
 
@@ -2331,6 +2332,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 		if (ret) {
 			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
+			spin_lock(&delayed_refs->lock);
 			return ret;
 		}
 
