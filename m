From: Chris Ball <cjb@laptop.org>
Subject: [PATCH] Add a "-v" flag for verbose scanning, and ignore floppy devices.
Date: Sun, 29 Mar 2009 21:22:03 -0400
Message-ID: <m3vdprby9w.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user on IRC reported that btrfsctl -a appeared to hang -- this was
because it was trying to read the fd0 floppy device, and getting I/O
errors back.  This patch introduces "btrfsctl -a -v" to print device
names as they are scanned, and ignores devices with the floppy major
device ID (2).

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 btrfs-show.c |    2 +-
 btrfsctl.c   |   11 ++++++++---
 utils.c      |   17 +++++++++++++++--
 utils.h      |    2 +-
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/btrfs-show.c b/btrfs-show.c
index c49626c..91e0e43 100644
--- a/btrfs-show.c
+++ b/btrfs-show.c
@@ -133,7 +133,7 @@ int main(int ac, char **av)
 		search = av[optind];
 	}
 
-	ret = btrfs_scan_one_dir("/dev", 0);
+	ret = btrfs_scan_one_dir("/dev", 0, 0);
 	if (ret)
 		fprintf(stderr, "error %d while scanning\n", ret);
 
diff --git a/btrfsctl.c b/btrfsctl.c
index b323818..e0193f2 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -46,7 +46,7 @@ static inline int ioctl(int fd, int define, void *arg) { return 0; }
 static void print_usage(void)
 {
 	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
-	printf("                [-r size] [-A device] [-a] [-c]\n");
+	printf("                [-r size] [-A device] [-a] [-c] [-v]\n");
 	printf("\t-d filename: defragments one file\n");
 	printf("\t-d directory: defragments the entire Btree\n");
 	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
@@ -55,6 +55,7 @@ static void print_usage(void)
 	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
+	printf("\t-v: verbose output while scanning devices\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -100,10 +101,14 @@ int main(int ac, char **av)
 	unsigned long command = 0;
 	int len;
 	char *fullpath;
+	int verbose = 0;
 
-	if (ac == 2 && strcmp(av[1], "-a") == 0) {
+	if (ac == 3 && strcmp(av[2], "-v") == 0)
+		verbose = 1;
+
+	if ((ac == 2 || ac == 3) && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
-		btrfs_scan_one_dir("/dev", 1);
+		btrfs_scan_one_dir("/dev", 1, verbose);
 		exit(0);
 	}
 	for (i = 1; i < ac; i++) {
diff --git a/utils.c b/utils.c
index a87c5a8..1f38a82 100644
--- a/utils.c
+++ b/utils.c
@@ -41,6 +41,8 @@
 #include "volumes.h"
 #include "ioctl.h"
 
+#define MAJOR(x) (((x)>>8)&0xff)
+
 #ifdef __CHECKER__
 #define BLKGETSIZE64 0
 static inline int ioctl(int fd, int define, u64 *size) { return 0; }
@@ -663,7 +665,7 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
+int btrfs_scan_one_dir(char *dirname, int run_ioctl, int verbose)
 {
 	DIR *dirp = NULL;
 	struct dirent *dirent;
@@ -735,6 +737,17 @@ again:
 			fprintf(stderr, "failed to read %s\n", fullpath);
 			continue;
 		}
+
+		if (MAJOR(st.st_rdev) == 2) {
+			if (verbose)
+				fprintf(stderr, "Skipping floppy device %s\n",
+					fullpath);
+			continue;
+		}
+
+		if (verbose)
+			fprintf(stderr, "Scanning %s\n", fullpath);
+
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
@@ -762,7 +775,7 @@ fail:
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 			int run_ioctls)
 {
-	return btrfs_scan_one_dir("/dev", run_ioctls);
+	return btrfs_scan_one_dir("/dev", run_ioctls, 0);
 }
 
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
diff --git a/utils.h b/utils.h
index 7ff542b..a85ba41 100644
--- a/utils.h
+++ b/utils.h
@@ -35,7 +35,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 			int run_ioctls);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
+int btrfs_scan_one_dir(char *dirname, int run_ioctl, int verbose);
 int check_mounted(char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
-- 
1.6.2
