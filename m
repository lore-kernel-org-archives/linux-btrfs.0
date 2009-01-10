From: Christian Hesse <mail@earthworm.de>
Subject: [PATCH] make btrfs acls selectable
Date: Sat, 10 Jan 2009 20:01:49 +0100
Message-ID: <200901102001.51596.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo everybody,

this patch adds a menu entry to kconfig to enable acls for btrfs.

Signed-off-by: Christian Hesse <mail@earthworm.de>
---
--- a/fs/Kconfig	2009-01-10 19:48:13.000000000 +0100
+++ b/fs/Kconfig	2009-01-10 19:48:34.000000000 +0100
@@ -288,6 +288,18 @@
 
 	  If unsure, say N.
 
+config BTRFS_FS_POSIX_ACL
+	bool "Btrfs POSIX Access Control Lists"
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
 endif # BLOCK
 
 source "fs/notify/Kconfig"
-- 
Regards,
Chris
