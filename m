Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49700 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2GTWQ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 18:16:58 -0400
Received: by yenl2 with SMTP id l2so4473869yen.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 15:16:58 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH v3 1/1] Btrfs: Check INCOMPAT flags on remount and add helper function
Date: Fri, 20 Jul 2012 17:16:41 -0500
Message-Id: <1342822601-18340-2-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1342822601-18340-1-git-send-email-mitch.harder@sabayonlinux.org>
References: <1342822601-18340-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In support of the recently added capability to remount with lzo
compression, provide a helper function to check the compression
INCOMPAT flags when remounting with lzo compression, and set
the flags if necessary.

Also, implement the new helper function when defragmenting with
explicit lzo compression.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---

v1->v2
- Remove extraneous formatting change.
v2->v3
- Consolidate into a single patch
- Convert helper function to a static inline function.

 fs/btrfs/ctree.h |   13 +++++++++++++
 fs/btrfs/ioctl.c |    7 +------
 fs/btrfs/super.c |    1 +
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0ee2f8..3a1a700 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3103,6 +3103,19 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
 
+static inline void btrfs_chk_lzo_incompat(struct btrfs_root *root)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = root->fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (!(features & BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+}
+
 #define btrfs_abort_transaction(trans, root, errno)		\
 do {								\
 	__btrfs_abort_transaction(trans, root, __func__,	\
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 17facea..d5fd69e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1042,11 +1042,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      u64 newer_than, unsigned long max_to_defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_super_block *disk_super;
 	struct file_ra_state *ra = NULL;
 	unsigned long last_index;
 	u64 isize = i_size_read(inode);
-	u64 features;
 	u64 last_len = 0;
 	u64 skip = 0;
 	u64 defrag_end = 0;
@@ -1233,11 +1231,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		mutex_unlock(&inode->i_mutex);
 	}
 
-	disk_super = root->fs_info->super_copy;
-	features = btrfs_super_incompat_flags(disk_super);
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-		btrfs_set_super_incompat_flags(disk_super, features);
+		btrfs_chk_lzo_incompat(root);
 	}
 
 	ret = defrag_count;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 26da344..32c2bd9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -401,6 +401,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_chk_lzo_incompat(root);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				info->compress_type = BTRFS_COMPRESS_NONE;
-- 
1.7.8.6

