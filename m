From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH 2/3] progs: Add BTRFS_IOC_NODATACOW ioctl to progs
Date: Fri, 12 Jun 2009 19:00:34 -0700
Message-ID: <4A330842.3070400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	"gud@ksu.edu" <gud@ksu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Add the new ioctl to progs.

Signed-off-by: Amit Gud <gud@ksu.edu>

Index: btrfs-progs-unstable/ioctl.h
===================================================================
--- btrfs-progs-unstable.orig/ioctl.h
+++ btrfs-progs-unstable/ioctl.h
@@ -58,4 +58,6 @@ struct btrfs_ioctl_vol_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_COMPRESS _IOW(BTRFS_IOCTL_MAGIC, 15, \
 			   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_NODATACOW _IOW(BTRFS_IOCTL_MAGIC, 16, \
+			   struct btrfs_ioctl_vol_args)
 #endif
Index: btrfs-progs-unstable/btrfsctl.c
===================================================================
--- btrfs-progs-unstable.orig/btrfsctl.c
+++ btrfs-progs-unstable/btrfsctl.c
@@ -56,6 +56,7 @@ static void print_usage(void)
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t--compress filename: sets compress flag on the file\n");
+	printf("\t--nodatacow filename: sets nodatacow flag on the file\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -185,6 +186,12 @@ int main(int ac, char **av)
 				print_usage();
 			}
 			command = BTRFS_IOC_COMPRESS;
+		} else if (strcmp(av[i], "--nodatacow") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-r requires an arg\n");
+				print_usage();
+			}
+			command = BTRFS_IOC_NODATACOW;
 		}
 	}
 	if (command == 0) {


-- 
May the source be with you.
http://www.cis.ksu.edu/~gud
