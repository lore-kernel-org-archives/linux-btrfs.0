From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: add error processing for btrfs_register_one_device
Date: Wed, 07 Jan 2009 14:51:54 +0800
Message-ID: <4964510A.9020601@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Now btrfsctl -a will do nothing and no error is output 
if btrfs.ko is not inserted.

Since no caller do error processing for btrfs_register_one_device,
make its return void and do error processing inside.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 utils.c |   15 +++++++++++----
 utils.h |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index 1f99ea3..694a92f 100644
--- a/utils.c
+++ b/utils.c
@@ -645,19 +645,26 @@ struct pending_dir {
 	char name[256];
 };
 
-int btrfs_register_one_device(char *fname)
+void btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
 	int fd;
 	int ret;
 
 	fd = open("/dev/btrfs-control", O_RDONLY);
-	if (fd < 0)
-		return -EINVAL;
+	if (fd < 0) {
+		fprintf(stderr, "failed to open"
+			"/dev/btrfs-control\n");
+		exit(1);
+	}
 	strcpy(args.name, fname);
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	close(fd);
-	return ret;
+	if (ret < 0) {
+		fprintf(stderr, "failed to register device %s\n",
+			fname);
+		exit(1);
+	}
 }
 
 int btrfs_scan_one_dir(char *dirname, int run_ioctl)
diff --git a/utils.h b/utils.h
index 55eb079..7ff542b 100644
--- a/utils.h
+++ b/utils.h
@@ -34,7 +34,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 			int run_ioctls);
-int btrfs_register_one_device(char *fname);
+void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
-- 
1.6.0.6



