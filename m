From: Chris Ball <cjb@laptop.org>
Subject: [PATCH 1/2] Btrfs: Use CONFIG_BTRFS_POSIX_ACL to enable ACL code
Date: Thu, 17 Sep 2009 01:40:15 -0400
Message-ID: <m3skemjfi8.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've already defined CONFIG_BTRFS_POSIX_ACL in Kconfig, but we're
currently not using it and are testing CONFIG_FS_POSIX_ACL instead.
CONFIG_FS_POSIX_ACL states "Never use this symbol for ifdefs".

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 fs/btrfs/acl.c   |    6 +++---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/xattr.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index f128427..69b355a 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -27,7 +27,7 @@
 #include "btrfs_inode.h"
 #include "xattr.h"
 
-#ifdef CONFIG_FS_POSIX_ACL
+#ifdef CONFIG_BTRFS_POSIX_ACL
 
 static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
@@ -313,7 +313,7 @@ struct xattr_handler btrfs_xattr_acl_access_handler = {
 	.set	= btrfs_xattr_acl_access_set,
 };
 
-#else /* CONFIG_FS_POSIX_ACL */
+#else /* CONFIG_BTRFS_POSIX_ACL */
 
 int btrfs_acl_chmod(struct inode *inode)
 {
@@ -325,4 +325,4 @@ int btrfs_init_acl(struct inode *inode, struct inode *dir)
 	return 0;
 }
 
-#endif /* CONFIG_FS_POSIX_ACL */
+#endif /* CONFIG_BTRFS_POSIX_ACL */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 837435c..22b9a84 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2317,7 +2317,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
 /* acl.c */
-#ifdef CONFIG_FS_POSIX_ACL
+#ifdef CONFIG_BTRFS_POSIX_ACL
 int btrfs_check_acl(struct inode *inode, int mask);
 #else
 #define btrfs_check_acl NULL
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index a9d3bf4..b0fc93f 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -260,7 +260,7 @@ err:
  * attributes are handled directly.
  */
 struct xattr_handler *btrfs_xattr_handlers[] = {
-#ifdef CONFIG_FS_POSIX_ACL
+#ifdef CONFIG_BTRFS_POSIX_ACL
 	&btrfs_xattr_acl_access_handler,
 	&btrfs_xattr_acl_default_handler,
 #endif
-- 
1.6.4


-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
