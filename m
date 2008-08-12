From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] compile when posix acl's are disabled
Date: Tue, 12 Aug 2008 10:35:49 -0400
Message-ID: <20080812143549.GG29623@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch makes btrfs so it will compile properly when acls are disabled.  I
tested this and it worked with CONFIG_FS_POSIX_ACL off and on.  Thanks much,

Josef


diff -r 447f15493ff8 Makefile
--- a/Makefile	Thu Aug 07 11:19:43 2008 -0400
+++ b/Makefile	Tue Aug 12 17:23:53 2008 -0400
@@ -7,9 +7,8 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   ref-cache.o
+	   ref-cache.o acl.o
 
-btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
 
 # Normal Makefile
diff -r 447f15493ff8 acl.c
--- a/acl.c	Thu Aug 07 11:19:43 2008 -0400
+++ b/acl.c	Tue Aug 12 17:23:53 2008 -0400
@@ -26,6 +26,8 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "xattr.h"
+
+#ifdef CONFIG_FS_POSIX_ACL
 
 static void btrfs_update_cached_acl(struct inode *inode,
 				    struct posix_acl **p_acl,
@@ -329,3 +331,22 @@ struct xattr_handler btrfs_xattr_acl_acc
 	.get	= btrfs_xattr_acl_access_get,
 	.set	= btrfs_xattr_acl_access_set,
 };
+
+#else /* CONFIG_FS_POSIX_ACL */
+
+int btrfs_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+int btrfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+
+int btrfs_check_acl(struct inode *inode, int mask)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FS_POSIX_ACL */
