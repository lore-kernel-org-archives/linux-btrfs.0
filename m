From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfsctl: add snapshot/subvolume destroy ioctl
Date: Fri, 18 Sep 2009 20:31:36 +0800
Message-ID: <4AB37DA8.40606@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	aaron@merfinllc.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

resend Aaron Straus's patch

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff --git a/btrfsctl.c b/btrfsctl.c
index b323818..66c4e89 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -46,7 +46,7 @@ static inline int ioctl(int fd, int define, void *arg) { return 0; }
 static void print_usage(void)
 {
 	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
-	printf("                [-r size] [-A device] [-a] [-c]\n");
+	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
 	printf("\t-d filename: defragments one file\n");
 	printf("\t-d directory: defragments the entire Btree\n");
 	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
@@ -55,6 +55,7 @@ static void print_usage(void)
 	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
+	printf("\t-D: delete snapshot\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -158,6 +159,18 @@ int main(int ac, char **av)
 				print_usage();
 			}
 			command = BTRFS_IOC_DEFRAG;
+		} else if (strcmp(av[i], "-D") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-D requires an arg\n");
+				print_usage();
+			}
+			command = BTRFS_IOC_SNAP_DESTROY;
+			name = av[i + 1];
+			len = strlen(name);
+			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
+				fprintf(stderr, "-D size too long\n");
+				exit(1);
+			}
 		} else if (strcmp(av[i], "-A") == 0) {
 			if (i >= ac - 1) {
 				fprintf(stderr, "-A requires an arg\n");
diff --git a/ioctl.h b/ioctl.h
index a084f33..4410ac0 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -56,4 +56,7 @@ struct btrfs_ioctl_vol_args {
 /* 13 is for CLONE_RANGE */
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
+
+#define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
+				   struct btrfs_ioctl_vol_args)
 #endif
