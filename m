From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Drop dirty roots created by log replay immediately when mount
 -o ro
Date: Thu, 20 Nov 2008 13:52:57 +0800
Message-ID: <4924FB39.3030502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The log replay products dirty roots. These dirty roots
should be dropped immediately if the fs is mounted as
ro. Otherwise they can be added to the dirty root list
again when remounting the fs as rw. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/disk-io.c 2/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2008-11-20 10:17:50.000000000 +0800
+++ 2/fs/btrfs/disk-io.c	2008-11-20 12:24:36.000000000 +0800
@@ -1756,6 +1756,11 @@ struct btrfs_root *open_ctree(struct sup
 						      generation + 1);
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
+
+		if (sb->s_flags & MS_RDONLY) {
+			ret =  btrfs_commit_super(tree_root);
+			BUG_ON(ret);
+		}
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
