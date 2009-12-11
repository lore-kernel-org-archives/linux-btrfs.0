From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: add command to set default subvol
Date: Fri, 11 Dec 2009 16:12:07 -0500
Message-ID: <20091211211207.GR2191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This introduces a new btrfsctl option, -m, to allow you to set the default'ly
mounted subvolume.  You can do

btrfsctl -m /your/subvolume

and that will make that subvolume the subvolume that is mounted by default, or
you can do

btrfsctl -m <treeid> /any/subvolume

and this will make the subvolume with tree id <treeid> the default'ly mounted
subvolume.  You can get the treeid by using the listing option.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 btrfsctl.c |   17 +++++++++++++++++
 ioctl.h    |    2 ++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 064c0d0..81d2a30 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -29,6 +29,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include <libgen.h>
+#include <stdlib.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "transaction.h"
@@ -58,6 +59,8 @@ static void print_usage(void)
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t-D: delete snapshot\n");
 	printf("\t-l file: listing snapshot/subvolume under a subvolume\n");
+	printf("\t-m [tree id] directory: set the default mounted subvolume"
+	       " to the [tree id] or the directory\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -266,6 +269,7 @@ int main(int ac, char **av)
 	unsigned long command = 0;
 	int len;
 	char *fullpath;
+	u64 objectid = 0;
 
 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
@@ -380,6 +384,16 @@ int main(int ac, char **av)
 				exit(1);
 			}
 			command = BTRFS_IOC_SNAP_LISTING;
+		} else if (strcmp(av[i], "-m") == 0) {
+			command = BTRFS_IOC_DEFAULT_SUBVOL;
+			if (i == ac - 3) {
+				objectid = (unsigned long long)
+					    strtoll(av[i + 1], NULL, 0);
+				if (errno == ERANGE) {
+					fprintf(stderr, "invalid tree id\n");
+					exit(1);
+				}
+			}
 		}
 	}
 	if (command == 0) {
@@ -410,6 +424,9 @@ int main(int ac, char **av)
 		ret = ioctl(snap_fd, command, &args);
 	} else if (command == BTRFS_IOC_SNAP_LISTING) {
 		ret = btrfs_list_subvolumes(snap_fd, command);
+	} else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
+		printf("objectid is %llu\n", objectid);
+		ret = ioctl(fd, command, &objectid);
 	} else
 		ret = ioctl(fd, command, &args);
 	if (ret < 0) {
diff --git a/ioctl.h b/ioctl.h
index 19020cb..70fc15d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -91,4 +91,6 @@ struct btrfs_ioctl_subvol_leaf {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
 				   struct btrfs_ioctl_subvol_args)
+#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 17, u64)
+
 #endif
-- 
1.5.4.3

