From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Subvolume Listing feature for btrfsctl.
Date: Mon, 16 Nov 2009 10:45:37 +0900
Message-ID: <4B00AEC1.70008@jp.fujitsu.com>
References: <4B00ADE8.4090205@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	zheng.yan@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B00ADE8.4090205@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

New feature to list up subvolume/snapshots under
specified tree of file is introduced to btrfsctl.

This patch should apply with corresponding patch
for kernel.

---
 btrfsctl.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ioctl.h    |   17 +++++++++++++++++
 2 files changed, 74 insertions(+), 1 deletion(-)

Index: b/btrfsctl.c
===================================================================
--- a/btrfsctl.c	2009-11-13 01:48:04.000000000 +0900
+++ b/btrfsctl.c	2009-11-16 09:07:29.000000000 +0900
@@ -47,6 +47,7 @@ static void print_usage(void)
 {
 	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
 	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
+	printf("                [-l dir]\n");
 	printf("\t-d filename: defragments one file\n");
 	printf("\t-d directory: defragments the entire Btree\n");
 	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
@@ -56,6 +57,7 @@ static void print_usage(void)
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t-D: delete snapshot\n");
+	printf("\t-l file: listing snapshot/subvolume under a subvolume\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -96,8 +98,9 @@ int main(int ac, char **av)
 	int fd;
 	int ret;
 	struct btrfs_ioctl_vol_args args;
+	struct btrfs_ioctl_subvol_args *svargs = NULL;
 	char *name = NULL;
-	int i;
+	int i, n;
 	unsigned long command = 0;
 	int len;
 	char *fullpath;
@@ -191,6 +194,30 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_RESIZE;
 		} else if (strcmp(av[i], "-c") == 0) {
 			command = BTRFS_IOC_SYNC;
+		} else if (strcmp(av[i], "-l") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-l requires an arg\n");
+				print_usage();
+			}
+			fullpath = av[i + 1];
+			snap_location = strdup(fullpath);
+			snap_fd = open_file_or_dir(snap_location);
+
+			name = strdup(fullpath);
+			name = basename(name);
+			len = strlen(name);
+
+			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
+				fprintf(stderr,
+					"listing subvolume name zero length or too long\n");
+				exit(1);
+			}
+			if (strchr(name, '/')) {
+				fprintf(stderr,
+					"error: / not allowed in names\n");
+				exit(1);
+			}
+			command = BTRFS_IOC_SNAP_LISTING;
 		}
 	}
 	if (command == 0) {
@@ -219,6 +246,35 @@ int main(int ac, char **av)
 	if (command == BTRFS_IOC_SNAP_CREATE) {
 		args.fd = fd;
 		ret = ioctl(snap_fd, command, &args);
+	} else if (command == BTRFS_IOC_SNAP_LISTING) {
+		n = 0;
+		svargs = malloc(sizeof(*svargs));
+		svargs->seq = 0ULL;
+		svargs->nr = 0;
+		svargs->max = BTRFS_SUBVOL_LIST_MAX;
+		svargs->subvols =
+			malloc(sizeof(*svargs->subvols)*BTRFS_SUBVOL_LIST_MAX);
+		ret = ioctl(snap_fd, command, svargs);
+		while (ret >= 0) {
+			for(i = 0; i < svargs->nr; i++) {
+				if (i==0 && svargs->subvols->objectid == 0) {
+					printf("   Base path = %s\n",
+						(svargs->subvols + i)->name);
+					printf("   No.\t   Tree ID\tSubvolume Relative Path\n");
+				} else {
+					n++;
+					printf("%5d\t%10llu\t%s\n",
+								n,
+								(svargs->subvols + i)->objectid,
+								(svargs->subvols + i)->name);
+				}
+			}
+			if (svargs->subvols->objectid == 0 && svargs->nr == 1)
+				printf("\t\tNo Subvolumes\n");
+			if (ret == 0)
+				break;
+			ret = ioctl(snap_fd, command, svargs);
+		}
 	} else
 		ret = ioctl(fd, command, &args);
 	if (ret < 0) {
Index: b/ioctl.h
===================================================================
--- a/ioctl.h	2009-11-13 01:48:04.000000000 +0900
+++ b/ioctl.h	2009-11-16 09:07:29.000000000 +0900
@@ -20,16 +20,31 @@
 #define __IOCTL_
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include "kerncompat.h"
+#include "list.h"

 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
 #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_SUBVOL_LIST_MAX 3

 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };

+struct btrfs_ioctl_subvol_name {
+	u64 objectid;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
+struct btrfs_ioctl_subvol_args {
+	int max;
+	int nr;
+	u64 seq;
+	struct btrfs_ioctl_subvol_name *subvols;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -59,4 +74,6 @@ struct btrfs_ioctl_vol_args {

 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
+				   struct btrfs_ioctl_subvol_args)
 #endif

