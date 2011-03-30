From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 3/5] added check_mounted_where
Date: Wed, 30 Mar 2011 18:53:11 +0200
Message-ID: <487f14a23fc63dce0aec24c7830d709357da4498.1301503683.git.list.btrfs@jan-o-sch.net>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

new version of check_mounted() returning more information gathered while
searching. check_mounted() is now a wrapper for check_mounted_where(). the new
version is needed by scrub.c

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 utils.c |   29 ++++++++++++++++++++++-------
 utils.h |    2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/utils.c b/utils.c
index fd894f3..bea36ce 100644
--- a/utils.c
+++ b/utils.c
@@ -749,13 +749,8 @@ int blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices, const char* file)
  */
 int check_mounted(const char* file)
 {
-	int ret;
 	int fd;
-	u64 total_devs = 1;
-	int is_btrfs;
-	struct btrfs_fs_devices* fs_devices_mnt = NULL;
-	FILE *f;
-	struct mntent *mnt;
+	int ret;
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
@@ -763,11 +758,26 @@ int check_mounted(const char* file)
 		return -errno;
 	}
 
+	ret =  check_mounted_where(fd, file, NULL, 0, NULL);
+	close(fd);
+
+	return ret;
+}
+
+int check_mounted_where(int fd, const char* file, char *where, int size,
+			struct btrfs_fs_devices **fs_dev_ret)
+{
+	int ret;
+	u64 total_devs = 1;
+	int is_btrfs;
+	struct btrfs_fs_devices* fs_devices_mnt = NULL;
+	FILE *f;
+	struct mntent *mnt;
+
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
 				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
 	is_btrfs = (ret >= 0);
-	close(fd);
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
@@ -803,6 +813,11 @@ int check_mounted(const char* file)
 	}
 
 	/* Did we find an entry in mnt table? */
+	if (mnt && size && where)
+		strncpy(where, mnt->mnt_dir, size);
+	if (fs_dev_ret)
+		*fs_dev_ret = fs_devices_mnt;
+
 	ret = (mnt != NULL);
 
 out_mntloop_err:
diff --git a/utils.h b/utils.h
index 9dce5b0..d2c9626 100644
--- a/utils.h
+++ b/utils.h
@@ -37,6 +37,8 @@ int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(const char *devicename);
+int check_mounted_where(int fd, const char* file, char *where, int size,
+			struct btrfs_fs_devices **fs_devices_mnt);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
-- 
1.7.3.4

