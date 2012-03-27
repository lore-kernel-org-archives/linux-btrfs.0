From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 8/8] Btrfs: allow dup for data chunks in mixed mode
Date: Tue, 27 Mar 2012 18:04:28 +0300
Message-ID: <1332860668-27298-9-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Generally we don't allow dup for data, but mixed chunks are special and
people seem to think this has its use cases.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 28addea..bcc0acd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2650,6 +2650,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 {
 	struct btrfs_fs_info *fs_info = bctl->fs_info;
 	u64 allowed;
+	int mixed = 0;
 	int ret;
 
 	if (btrfs_fs_closing(fs_info) ||
@@ -2659,13 +2660,16 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		goto out;
 	}
 
+	allowed = btrfs_super_incompat_flags(fs_info->super_copy);
+	if (allowed & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = 1;
+
 	/*
 	 * In case of mixed groups both data and meta should be picked,
 	 * and identical options should be given for both of them.
 	 */
-	allowed = btrfs_super_incompat_flags(fs_info->super_copy);
-	if ((allowed & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
-	    (bctl->flags & (BTRFS_BALANCE_DATA | BTRFS_BALANCE_METADATA))) {
+	allowed = BTRFS_BALANCE_DATA | BTRFS_BALANCE_METADATA;
+	if (mixed && (bctl->flags & allowed)) {
 		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
 		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
@@ -2713,7 +2717,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		goto out;
 	}
 
-	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	/* allow dup'ed data chunks only in mixed mode */
+	if (!mixed && (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (bctl->data.target & BTRFS_BLOCK_GROUP_DUP)) {
 		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
 		ret = -EINVAL;
-- 
1.7.9.1

