From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [PATCH] New fs-specific Kconfig options should go in fs/$FS/Kconfig, not fs/Kconfig.
Date: Tue,  3 Feb 2009 21:58:28 -0500
Message-ID: <1233716308-19702-1-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Commit 699b6faa2ab283219914501d5117f8a93c7e441b allowed btrfs ACLs to
 be selectable, but put the option in the main fs/Kconfig, and didn't
 make it depend on btrfs.

 This patch moves the option and adds the dependency.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/Kconfig       |   13 -------------
 fs/btrfs/Kconfig |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6198082..ef81718 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -51,19 +51,6 @@ source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
 source "fs/btrfs/Kconfig"
-
-config BTRFS_FS_POSIX_ACL
-	bool "Btrfs POSIX Access Control Lists"
-	select FS_POSIX_ACL
-	help
-	  POSIX Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
-
-	  To learn more about Access Control Lists, visit the POSIX ACLs for
-	  Linux website <http://acl.bestbits.at/>.
-
-	  If you don't know what Access Control Lists are, say N
-
 endif # BLOCK
 
 source "fs/notify/Kconfig"
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index f8fcf99..42e91e3 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -16,3 +16,18 @@ config BTRFS_FS
 	  module will be called btrfs.
 
 	  If unsure, say N.
+
+config BTRFS_FS_POSIX_ACL
+	bool "Btrfs POSIX Access Control Lists"
+	depends on BTRFS_FS
+	select FS_POSIX_ACL
+	help
+	  POSIX Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
+
+
-- 
1.6.0.2

