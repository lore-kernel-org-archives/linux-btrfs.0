From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH] btrfs-progs: Check mount status of multidevice filesystems
Date: Sat, 14 Nov 2009 19:44:51 +0100
Message-ID: <200911141944.51824.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some programs like btrfsck should not be run on a mounted filesystem.
This patch adds a check in btrfs_open_devices() for the mount status
of every device belonging to the filesystem. The function check_mount()
gets improved support for loopback devices. It now detects if the
program is run on the file that is being used by the loopback device.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..1e0ef9f 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -169,7 +169,7 @@ int main(int ac, char **av)
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
-	root = open_ctree(dev, 0, 0);
+	root = open_ctree(dev, 0, 0, 0);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..1434791 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2821,7 +2821,7 @@ int main(int ac, char **av)
 
 	radix_tree_init();
 	cache_tree_init(&root_cache);
-	root = open_ctree(av[1], 0, 0);
+	root = open_ctree(av[1], 0, 0, 1);
 
 	if (root == NULL)
 		return 1;
diff --git a/debug-tree.c b/debug-tree.c
index 1d47519..a8e85f4 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -137,7 +137,7 @@ int main(int ac, char **av)
 	if (ac != 1)
 		print_usage();
 
-	root = open_ctree(av[optind], 0, 0);
+	root = open_ctree(av[optind], 0, 0, 0);
 	if (!root) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/disk-io.c b/disk-io.c
index addebe1..f8e623b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -570,7 +570,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	return root;
 }
 
-struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
+struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes, int check_mount)
 {
 	int fp;
 	struct btrfs_root *root;
@@ -584,14 +584,14 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 		fprintf (stderr, "Could not open %s\n", filename);
 		return NULL;
 	}
-	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
+	root = open_ctree_fd(fp, filename, sb_bytenr, writes, check_mount);
 	close(fp);
 
 	return root;
 }
 
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 int writes)
+				 int writes, int check_mount)
 {
 	u32 sectorsize;
 	u32 nodesize;
@@ -657,9 +657,9 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	if (writes)
-		ret = btrfs_open_devices(fs_devices, O_RDWR);
+		ret = btrfs_open_devices(fs_devices, O_RDWR, check_mount);
 	else
-		ret = btrfs_open_devices(fs_devices, O_RDONLY);
+		ret = btrfs_open_devices(fs_devices, O_RDONLY, check_mount);
 	BUG_ON(ret);
 
 	fs_info->super_bytenr = sb_bytenr;
@@ -725,7 +725,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 		 BTRFS_UUID_SIZE);
 
 	if (!(btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)) {
-		ret = btrfs_read_chunk_tree(chunk_root);
+		ret = btrfs_read_chunk_tree(chunk_root, check_mount);
 		BUG_ON(ret);
 	}
 
diff --git a/disk-io.h b/disk-io.h
index 49e5692..1d6519e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -43,9 +43,9 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 int clean_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root, struct extent_buffer *buf);
-struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
+struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes, int check_mount);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 int writes);
+				 int writes, int check_mount);
 int close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
diff --git a/kerncompat.h b/kerncompat.h
index e4c8ce0..46236cd 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -42,7 +42,11 @@
 #define GFP_NOFS 0
 #define __read_mostly
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#ifndef ULONG_MAX
 #define ULONG_MAX       (~0UL)
+#endif
+
 #define BUG() abort()
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..f226661 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -456,7 +456,7 @@ int main(int ac, char **av)
 		fprintf(stderr, "error during mkfs %d\n", ret);
 		exit(1);
 	}
-	root = open_ctree(file, 0, O_RDWR);
+	root = open_ctree(file, 0, O_RDWR, 1);
 	root->fs_info->alloc_start = alloc_start;
 
 	ret = make_root_dir(root);
diff --git a/utils.c b/utils.c
index 2f4c6e1..60c3f24 100644
--- a/utils.c
+++ b/utils.c
@@ -31,6 +31,8 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <mntent.h>
+#include <linux/loop.h>
+#include <limits.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -586,46 +588,105 @@ error:
 	return ret;
 }
 
+int is_loop_device (const char *device) {
+	struct stat statbuf;
+
+	if(stat(device, &statbuf) < 0)
+		return -errno;
+
+	return (S_ISBLK(statbuf.st_mode) &&
+		major(statbuf.st_rdev) == LOOP_MAJOR);
+}
+
+int is_same_blk_file(const char* a, const char* b)
+{
+	struct stat st_buf_a, st_buf_b;
+	char real_a[PATH_MAX];
+	char real_b[PATH_MAX];
+
+	if(!realpath(a, real_a) ||
+	   !realpath(b, real_b))
+	{
+		return -errno;
+	}
+
+	/* Identical path? */
+	if(strcmp(real_a, real_b) == 0)
+		return 1;
+
+	if(stat(a, &st_buf_a) < 0 ||
+	   stat(b, &st_buf_b) < 0)
+	{
+		return -errno;
+	}
+
+	/* Same blockdevice? */
+	if(S_ISBLK(st_buf_a.st_mode) &&
+	   S_ISBLK(st_buf_b.st_mode) &&
+	   st_buf_a.st_rdev == st_buf_b.st_rdev)
+	{
+		return 1;
+	}
+
+	/* Hardlink? */
+	if (st_buf_a.st_dev == st_buf_b.st_dev &&
+	    st_buf_a.st_ino == st_buf_b.st_ino)
+	{
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * returns 1 if the device was mounted, < 0 on error or 0 if everything
- * is safe to continue.  TODO, this should also scan multi-device filesystems
+ * is safe to continue.
  */
 int check_mounted(char *file)
 {
 	struct mntent *mnt;
-	struct stat st_buf;
-	dev_t file_dev = 0;
-	dev_t file_rdev = 0;
-	ino_t file_ino = 0;
 	FILE *f;
 	int ret = 0;
 
-	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
-		return -errno;
+	int loop_fd;
+	struct loop_info loopinfo;
 
-	if (stat(file, &st_buf) < 0) {
+	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
 		return -errno;
-	} else {
-		if (S_ISBLK(st_buf.st_mode)) {
-			file_rdev = st_buf.st_rdev;
-		} else {
-			file_dev = st_buf.st_dev;
-			file_ino = st_buf.st_ino;
-		}
-	}
 
 	while ((mnt = getmntent (f)) != NULL) {
-		if (strcmp(file, mnt->mnt_fsname) == 0)
-			break;
+		/* Only check btrfs filesystems */
+		if(strcmp(mnt->mnt_type, "btrfs") != 0)
+			continue;
 
-		if (stat(mnt->mnt_fsname, &st_buf) == 0) {
-			if (S_ISBLK(st_buf.st_mode)) {
-				if (file_rdev && (file_rdev == st_buf.st_rdev))
-					break;
-			} else if (file_dev && ((file_dev == st_buf.st_dev) &&
-						(file_ino == st_buf.st_ino))) {
+		ret = is_loop_device(mnt->mnt_fsname);
+
+		if(ret < 0)
+			goto out_err;
+
+		if(ret) {
+			/* Current entry is a loop device */
+			if ((loop_fd = open(mnt->mnt_fsname, O_RDONLY)) < 0) {
+				ret = -errno;
+				goto out_err;
+			}
+
+			/* Get loop device info and check */
+			if (ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo) == 0) {
+				ret = is_same_blk_file(file, loopinfo.lo_name);
+
+				if(ret < 0)
+					goto out_err;
+				else if(ret)
 					break;
+			} else {
+				ret = -errno;
+				goto out_err;
 			}
+		} else {
+			/* normal block device */
+			if(is_same_blk_file(file, mnt->mnt_fsname) > 0)
+				break;
 		}
 	}
 
@@ -634,6 +695,7 @@ int check_mounted(char *file)
 		ret = 1;
 	}
 
+out_err:
 	endmntent (f);
 	return ret;
 }
diff --git a/utils.h b/utils.h
index 7ff542b..695686b 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,12 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#define LOOP_MAJOR 7
+
+#ifndef major
+#define major(dev)	((dev) >> 8)
+#endif
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
diff --git a/volumes.c b/volumes.c
index 7671855..467f552 100644
--- a/volumes.c
+++ b/volumes.c
@@ -29,6 +29,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -164,7 +165,7 @@ again:
 	return 0;
 }
 
-int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
+int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags, int check_mount)
 {
 	int fd;
 	struct list_head *head = &fs_devices->devices;
@@ -175,6 +176,19 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 	list_for_each(cur, head) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 
+		if(check_mount) {
+			ret = check_mounted(device->name);
+			if (ret < 0) {
+				fprintf(stderr, "error checking %s mount status\n", device->name);
+				goto fail;
+			}
+			if (ret == 1) {
+				fprintf(stderr, "Error: %s is currently mounted.\n", device->name);
+				ret = -EBUSY;
+				goto fail;
+			}
+		}
+
 		fd = open(device->name, flags);
 		if (fd < 0) {
 			ret = -errno;
@@ -1240,7 +1254,7 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 	return 0;
 }
 
-static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
+static int open_seed_devices(struct btrfs_root *root, u8 *fsid, int check_mount)
 {
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
@@ -1260,7 +1274,7 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 		goto out;
 	}
 
-	ret = btrfs_open_devices(fs_devices, O_RDONLY);
+	ret = btrfs_open_devices(fs_devices, O_RDONLY, check_mount);
 	if (ret)
 		goto out;
 
@@ -1272,7 +1286,8 @@ out:
 
 static int read_one_dev(struct btrfs_root *root,
 			struct extent_buffer *leaf,
-			struct btrfs_dev_item *dev_item)
+			struct btrfs_dev_item *dev_item,
+			int check_mount)
 {
 	struct btrfs_device *device;
 	u64 devid;
@@ -1289,7 +1304,7 @@ static int read_one_dev(struct btrfs_root *root,
 			   BTRFS_UUID_SIZE);
 
 	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
-		ret = open_seed_devices(root, fs_uuid);
+		ret = open_seed_devices(root, fs_uuid, check_mount);
 		if (ret)
 			return ret;
 	}
@@ -1311,13 +1326,13 @@ static int read_one_dev(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf)
+int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf, int check_mount)
 {
 	struct btrfs_dev_item *dev_item;
 
 	dev_item = (struct btrfs_dev_item *)offsetof(struct btrfs_super_block,
 						     dev_item);
-	return read_one_dev(root, buf, dev_item);
+	return read_one_dev(root, buf, dev_item, check_mount);
 }
 
 int btrfs_read_sys_array(struct btrfs_root *root)
@@ -1378,7 +1393,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	return 0;
 }
 
-int btrfs_read_chunk_tree(struct btrfs_root *root)
+int btrfs_read_chunk_tree(struct btrfs_root *root, int check_mount)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -1421,7 +1436,7 @@ again:
 				struct btrfs_dev_item *dev_item;
 				dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
-				ret = read_one_dev(root, leaf, dev_item);
+				ret = read_one_dev(root, leaf, dev_item, check_mount);
 				BUG_ON(ret);
 			}
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
diff --git a/volumes.h b/volumes.h
index bb78751..baf12ff 100644
--- a/volumes.h
+++ b/volumes.h
@@ -103,16 +103,16 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_root *root);
-int btrfs_read_chunk_tree(struct btrfs_root *root);
+int btrfs_read_chunk_tree(struct btrfs_root *root, int check_mount);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
 		      u64 *num_bytes, u64 type);
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
+int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf, int check_mount);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_device *device);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
-		       int flags);
+		       int flags, int check_mount);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
