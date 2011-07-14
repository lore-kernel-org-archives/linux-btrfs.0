From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 08/16] Btrfs: make acl functions really no-op if acl is not
 enabled
Date: Thu, 14 Jul 2011 11:17:39 +0800
Message-ID: <4E1E5FD3.4020408@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

So there's no overhead for something we don't use.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/Makefile |    4 +++-
 fs/btrfs/acl.c    |   17 -----------------
 fs/btrfs/ctree.h  |   15 ++++++++++++---
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 9b72dcf..40e6ac0 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -6,5 +6,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
+	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o
+
+btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index f66fc99..b206d4c 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -28,8 +28,6 @@
 #include "btrfs_inode.h"
 #include "xattr.h"
 
-#ifdef CONFIG_BTRFS_FS_POSIX_ACL
-
 static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
 	int size;
@@ -318,18 +316,3 @@ const struct xattr_handler btrfs_xattr_acl_access_handler = {
 	.get	= btrfs_xattr_acl_get,
 	.set	= btrfs_xattr_acl_set,
 };
-
-#else /* CONFIG_BTRFS_FS_POSIX_ACL */
-
-int btrfs_acl_chmod(struct inode *inode)
-{
-	return 0;
-}
-
-int btrfs_init_acl(struct btrfs_trans_handle *trans,
-		   struct inode *inode, struct inode *dir)
-{
-	return 0;
-}
-
-#endif /* CONFIG_BTRFS_FS_POSIX_ACL */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 60e13ef..b5097e2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2644,12 +2644,21 @@ do {								\
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 int btrfs_check_acl(struct inode *inode, int mask, unsigned int flags);
-#else
-#define btrfs_check_acl NULL
-#endif
 int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		   struct inode *inode, struct inode *dir);
 int btrfs_acl_chmod(struct inode *inode);
+#else
+#define btrfs_check_acl NULL
+static inline int btrfs_init_acl(struct btrfs_trans_handle *trans,
+				 struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+static inline int btrfs_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+#endif
 
 /* relocation.c */
 int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
-- 
1.7.3.1
