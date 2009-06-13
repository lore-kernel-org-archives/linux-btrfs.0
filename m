From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH 1/3] progs: Add BTRFS_IOC_COMPRESS ioctl to progs
Date: Fri, 12 Jun 2009 18:58:42 -0700
Message-ID: <4A3307D2.1030504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	"gud@ksu.edu" <gud@ksu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Add the new ioctl to progs.

Signed-off-by: Amit Gud <gud@ksu.edu>

Index: btrfs-progs-unstable/btrfsctl.c
===================================================================
--- btrfs-progs-unstable.orig/btrfsctl.c
+++ btrfs-progs-unstable/btrfsctl.c
@@ -55,6 +55,7 @@ static void print_usage(void)
 	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
+	printf("\t--compress filename: sets compress flag on the file\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -178,6 +179,12 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_RESIZE;
 		} else if (strcmp(av[i], "-c") == 0) {
 			command = BTRFS_IOC_SYNC;
+		} else if (strcmp(av[i], "--compress") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-r requires an arg\n");
+				print_usage();
+			}
+			command = BTRFS_IOC_COMPRESS;
 		}
 	}
 	if (command == 0) {
Index: btrfs-progs-unstable/ioctl.h
===================================================================
--- btrfs-progs-unstable.orig/ioctl.h
+++ btrfs-progs-unstable/ioctl.h
@@ -56,4 +56,6 @@ struct btrfs_ioctl_vol_args {
 /* 13 is for CLONE_RANGE */
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_COMPRESS _IOW(BTRFS_IOCTL_MAGIC, 15, \
+			   struct btrfs_ioctl_vol_args)
 #endif


-- 
May the source be with you.
http://www.cis.ksu.edu/~gud
