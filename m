From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs: change/remove typedef
Date: Tue, 13 Jan 2009 16:03:49 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131559420.27565@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


parent cc46eb3e855b7c1f628e934e01b97f4f2642973e (v2.6.29-rc1-22-gcc46eb3)
commit 1589ccc2c3734c3dfbfa8e7504cd8336aeab9bff
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 13 16:03:41 2009 +0100

btrfs: change/remove typedef

Change one typedef to a regular enum, and remove an unused one.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/btrfs/ctree.h |   10 ++--------
 fs/btrfs/x       |    1 +
 2 files changed, 3 insertions(+), 8 deletions(-)
 create mode 100644 fs/btrfs/x

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eee060f..e1fec63 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -454,17 +454,11 @@ struct btrfs_timespec {
 	__le32 nsec;
 } __attribute__ ((__packed__));
 
-typedef enum {
+enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE = 0,
 	BTRFS_COMPRESS_ZLIB = 1,
 	BTRFS_COMPRESS_LAST = 2,
-} btrfs_compression_type;
-
-/* we don't understand any encryption methods right now */
-typedef enum {
-	BTRFS_ENCRYPTION_NONE = 0,
-	BTRFS_ENCRYPTION_LAST = 1,
-} btrfs_encryption_type;
+};
 
 struct btrfs_inode_item {
 	/* nfs style generation number */
diff --git a/fs/btrfs/x b/fs/btrfs/x
new file mode 100644
index 0000000..fbb1101
--- /dev/null
+++ b/fs/btrfs/x
@@ -0,0 +1 @@
+BINO
-- 
# Created with git-export-patch

