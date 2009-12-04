From: Josef Bacik <josef@redhat.com>
Subject: [RFC] Btrfs-progs: add command to set default subvol
Date: Fri, 4 Dec 2009 16:57:53 -0500
Message-ID: <20091204215752.GE7441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Again this is just a proof of concept, though it does work in the basic case of
just

btrfsctl -m /mnt/point

I'd just like to make sure this is an acceptable approach.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 btrfsctl.c |    7 +++++++
 ioctl.h    |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 064c0d0..8fc78ba 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -58,6 +58,8 @@ static void print_usage(void)
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t-D: delete snapshot\n");
 	printf("\t-l file: listing snapshot/subvolume under a subvolume\n");
+	printf("\t-m [tree id] directory: set the default mounted subvolume"
+	       " to the [tree id] or the directory\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -266,6 +268,7 @@ int main(int ac, char **av)
 	unsigned long command = 0;
 	int len;
 	char *fullpath;
+	u64 objectid = 0;
 
 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
@@ -380,6 +383,8 @@ int main(int ac, char **av)
 				exit(1);
 			}
 			command = BTRFS_IOC_SNAP_LISTING;
+		} else if (strcmp(av[1], "-m") == 0) {
+			command = BTRFS_IOC_DEFAULT_SUBVOL;
 		}
 	}
 	if (command == 0) {
@@ -410,6 +415,8 @@ int main(int ac, char **av)
 		ret = ioctl(snap_fd, command, &args);
 	} else if (command == BTRFS_IOC_SNAP_LISTING) {
 		ret = btrfs_list_subvolumes(snap_fd, command);
+	} else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
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

