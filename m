From: Basavanagowda Kanur <gowda@kanur.in>
Subject: [PATCH] btrfsctl: scan device and exit without using ioctl
Date: Mon, 21 Dec 2009 21:20:46 +0530
Message-ID: <20091221154140.GA26204@shift>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


'btrfsctl -A /path/to/device/file' would only scan for a valid btrfs
on the device using volume recognition helpers.
---
 btrfsctl.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..61020de 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -34,6 +34,8 @@
 #include "transaction.h"
 #include "utils.h"
 #include "version.h"
+#include "disk-io.h"
+#include "volumes.h"
 
 #ifdef __CHECKER__
 #define BLKGETSIZE64 0
@@ -88,6 +90,30 @@ static int open_file_or_dir(const char *fname)
 	}
 	return fd;
 }
+
+int btrfs_scan_file (const char *path)
+{
+        int ret = -1;
+        struct btrfs_fs_devices *fs_devices = NULL;
+        u64 dev_count = 0;
+        int fd = -1;
+
+        fd = open (path, O_RDONLY);
+        if (fd < 0) {
+                fprintf (stderr, "failed to open %s: %s\n",
+                         path, strerror (errno));
+        } else {
+
+                ret = btrfs_scan_one_device (fd, path, &fs_devices,
+                                             &dev_count,
+                                             BTRFS_SUPER_INFO_OFFSET);
+
+                close (fd);
+        }
+
+        return ret;
+}
+
 int main(int ac, char **av)
 {
 	char *fname = NULL;
@@ -201,12 +227,16 @@ int main(int ac, char **av)
 	fname = av[ac - 1];
 
 	if (command == BTRFS_IOC_SCAN_DEV) {
-		fd = open("/dev/btrfs-control", O_RDWR);
-		if (fd < 0) {
-			perror("failed to open /dev/btrfs-control");
-			exit(1);
-		}
-		name = fname;
+                ret = btrfs_scan_file (fname);
+                if (ret < 0) {
+                        fprintf (stdout, "could not find a btrfs volume on "
+                                 "%s\n", fname);
+                } else {
+                        fprintf (stdout, "found a btrfs volume on %s\n",
+                                 fname);
+                }
+
+                exit (1);
 	 } else {
 		fd = open_file_or_dir(fname);
 	 }
-- 
1.6.4

