From: Michael Tharp <gxti@partiallystapled.com>
Subject: [PATCH] btrfs-progs: Fix implicit strndup() and other warnings on RHEL 5
Date: Thu, 20 May 2010 11:25:04 -0400
Message-ID: <201005201707.o4KH7EB5002815@logo.rdu.rpath.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Michael Tharp <gxti@partiallystapled.com>
---
 btrfs-list.c |    7 ++++---
 btrfs.c      |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 7741705..112bed2 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define _GNU_SOURCE
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -662,9 +663,9 @@ static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 			    char **cache_dir_name, u64 *cache_ino,
 			    char **cache_full_name)
 {
-	u64 len;
-	u64 disk_start;
-	u64 disk_offset;
+	u64 len = 0;
+	u64 disk_start = 0;
+	u64 disk_offset = 0;
 	u8 type;
 	int compressed = 0;
 	int flags = 0;
diff --git a/btrfs.c b/btrfs.c
index ab5e57f..672ffe2 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -15,6 +15,7 @@
  */
 
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
1.6.6.1

