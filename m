From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7/8] Btrfs: validate target profiles only if we are going to use them
Date: Tue, 27 Mar 2012 18:04:27 +0300
Message-ID: <1332860668-27298-8-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Do not run sanity checks on all target profiles unless they all will be
used.  This came up because alloc_profile_is_valid() is now more strict
than it used to be.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index def9e25..28addea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2676,14 +2676,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	}
 
-	/*
-	 * Profile changing sanity checks.  Skip them if a simple
-	 * balance is requested.
-	 */
-	if (!((bctl->data.flags | bctl->sys.flags | bctl->meta.flags) &
-	      BTRFS_BALANCE_ARGS_CONVERT))
-		goto do_balance;
-
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	if (fs_info->fs_devices->num_devices == 1)
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
@@ -2693,24 +2685,27 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID10);
 
-	if (!alloc_profile_is_valid(bctl->data.target, 1) ||
-	    bctl->data.target & ~allowed) {
+	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
+	     (bctl->data.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "data profile %llu\n",
 		       (unsigned long long)bctl->data.target);
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!alloc_profile_is_valid(bctl->meta.target, 1) ||
-	    bctl->meta.target & ~allowed) {
+	if ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	    (!alloc_profile_is_valid(bctl->meta.target, 1) ||
+	     (bctl->meta.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "metadata profile %llu\n",
 		       (unsigned long long)bctl->meta.target);
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!alloc_profile_is_valid(bctl->sys.target, 1) ||
-	    bctl->sys.target & ~allowed) {
+	if ((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	    (!alloc_profile_is_valid(bctl->sys.target, 1) ||
+	     (bctl->sys.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "system profile %llu\n",
 		       (unsigned long long)bctl->sys.target);
@@ -2718,7 +2713,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		goto out;
 	}
 
-	if (bctl->data.target & BTRFS_BLOCK_GROUP_DUP) {
+	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	    (bctl->data.target & BTRFS_BLOCK_GROUP_DUP)) {
 		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
 		ret = -EINVAL;
 		goto out;
@@ -2744,7 +2740,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	}
 
-do_balance:
 	ret = insert_balance_item(fs_info->tree_root, bctl);
 	if (ret && ret != -EEXIST)
 		goto out;
-- 
1.7.9.1

