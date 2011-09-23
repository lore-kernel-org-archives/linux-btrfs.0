From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/file.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:41:46 -0700
Message-ID: <201109221841.46578.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the sparse noise:

warning: symbol 'btrfs_find_defrag_inode' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..08e2aa0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -159,8 +159,8 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 /*
  * must be called with the defrag_inodes lock held
  */
-struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info, u64 ino,
-					     struct rb_node **next)
+static struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
+						u64 ino, struct rb_node **next)
 {
 	struct inode_defrag *entry = NULL;
 	struct rb_node *p;
