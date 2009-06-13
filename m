From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH 3/3] progs: Add BTRFS_IOC_NODATASUM ioctl to progs
Date: Fri, 12 Jun 2009 19:01:08 -0700
Message-ID: <4A330864.1040609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	"gud@ksu.edu" <gud@ksu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Add the new ioctl to progs.

Signed-off-by: Amit Gud <gud@ksu.edu>

Index: btrfs-progs-unstable/btrfsctl.c
===================================================================
--- btrfs-progs-unstable.orig/btrfsctl.c
+++ btrfs-progs-unstable/btrfsctl.c
@@ -57,6 +57,7 @@ static void print_usage(void)
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t--compress filename: sets compress flag on the file\n");
 	printf("\t--nodatacow filename: sets nodatacow flag on the file\n");
+	printf("\t--nodatasum filename: sets nodatasum flag on the file\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -192,6 +193,12 @@ int main(int ac, char **av)
 				print_usage();
 			}
 			command = BTRFS_IOC_NODATACOW;
+		} else if (strcmp(av[i], "--nodatasum") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-r requires an arg\n");
+				print_usage();
+			}
+			command = BTRFS_IOC_NODATASUM;
 		}
 	}
 	if (command == 0) {
Index: btrfs-progs-unstable/ioctl.h
===================================================================
--- btrfs-progs-unstable.orig/ioctl.h
+++ btrfs-progs-unstable/ioctl.h
@@ -60,4 +60,6 @@ struct btrfs_ioctl_vol_args {
 			   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_NODATACOW _IOW(BTRFS_IOCTL_MAGIC, 16, \
 			   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_NODATASUM _IOW(BTRFS_IOCTL_MAGIC, 17, \
+			   struct btrfs_ioctl_vol_args)
 #endif


-- 
May the source be with you.
http://www.cis.ksu.edu/~gud
