From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 4/7] speed classes (needed for profiles) for device add. subsequent patch needed to fix mkfs
Date: Tue,  1 Feb 2011 14:54:47 +0100
Message-ID: <1296568490-13264-5-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs.c      |    2 +-
 btrfs_cmds.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++----------
 ctree.h      |   20 +++++++++++++++++
 ioctl-test.c |    1 +
 ioctl.h      |    8 +++++-
 utils.c      |   22 ++++++++++++++++--
 utils.h      |    8 ++++++-
 7 files changed, 109 insertions(+), 19 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..b66202c 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -101,7 +101,7 @@ static struct Command commands[] = {
 		"filesystem."
 	},
 	{ do_add_volume, -2,
-	  "device add", "<dev> [<dev>..] <path>\n"
+	  "device add", "[-c <class>] <dev> [[-c <class>] <dev> ...] <path>\n"
 		"Add a device to a filesystem."
 	},
 	{ do_remove_volume, -2,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index d707a7d..639debd 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -666,7 +666,10 @@ int do_add_volume(int nargs, char **args)
 
 	char	*mntpnt = args[nargs-1];
 	int	i, fdmnt, ret=0;
-
+	int	devcnt = 0;
+	int	alloc_dev = 0;
+	int	class = BTRFS_DEVCLASS_ALL;
+	struct btrfs_class_dev *devs = NULL;
 
 	fdmnt = open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
@@ -674,46 +677,86 @@ int do_add_volume(int nargs, char **args)
 		return 12;
 	}
 
-	for(i=1 ; i < (nargs-1) ; i++ ){
-		struct btrfs_ioctl_vol_args ioctl_args;
+	optind = 1;
+	while(1) {
+		int c = getopt(nargs, args, "-c:");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 1:
+			if (devcnt >= alloc_dev) {
+				alloc_dev += 10;
+				devs = realloc(devs,
+					alloc_dev*sizeof(*devs));
+			}
+			devs[devcnt].file = args[optind-1];
+			devs[devcnt].class = class;
+			devcnt++;
+			break;
+		case 'c':
+			class = parse_class(optarg);
+			if (class == -1) {
+				fprintf(stderr, "Unknown class %s\n", optarg);
+				return 1;
+			}
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for add\n");
+			return 1;
+		}
+	}
+	if (!devcnt) {
+		fprintf(stderr, "Invalid arguments for add\n");
+		return 1;
+	}
+	for(i=0 ; i < devcnt ; i++ ){
+		struct btrfs_ioctl_vol_args_v2 ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
 		struct stat st;
 
-		devfd = open(args[i], O_RDWR);
+		devfd = open(devs[i].file, O_RDWR);
 		if (!devfd) {
-			fprintf(stderr, "ERROR: Unable to open device '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to open device '%s'\n",
+				devs[i].file);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		ret = fstat(devfd, &st);
 		if (ret) {
-			fprintf(stderr, "ERROR: Unable to stat '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to stat '%s'\n",
+				devs[i].file);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "ERROR: '%s' is not a block device\n", args[i]);
+			fprintf(stderr, "ERROR: '%s' is not a block device\n",
+				devs[i].file);
 			close(devfd);
 			ret++;
 			continue;
 		}
 
-		res = btrfs_prepare_device(devfd, args[i], 1, &dev_block_count);
+		res = btrfs_prepare_device(devfd, devs[i].file, 1,
+		                           &dev_block_count, devs[i].class);
 		if (res) {
-			fprintf(stderr, "ERROR: Unable to init '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to init '%s'\n",
+				devs[i].file);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		close(devfd);
 
-		strcpy(ioctl_args.name, args[i]);
-		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
+		memset(&ioctl_args, 0, sizeof(ioctl_args));
+		ioctl_args.seek_speed = devs[i].class;
+		strcpy(ioctl_args.name, devs[i].file);
+		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV_V2, &ioctl_args);
 		if(res<0){
-			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: error adding the device '%s'\n",
+				devs[i].file);
 			ret++;
 		}
 
diff --git a/ctree.h b/ctree.h
index b79e238..192e8e8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -130,6 +130,24 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 #define BTRFS_FT_MAX		9
 
 /*
+ * default device classes (seek_speed indices)
+ * system chunks are considered metadata for this classification
+ */
+
+#define BTRFS_DEVCLASS_LOG	75	/* dedicated to log data */
+#define BTRFS_DEVCLASS_META	45	/* metadata or log data */
+#define BTRFS_DEVCLASS_DATA	35	/* dedicated to user data */
+#define BTRFS_DEVCLASS_ALL	30 	/* data, metadata or log data */
+
+#define BTRFS_DEVCLASS_ALLOW_LOG(x) ((x) == BTRFS_DEVCLASS_LOG || \
+                                     (x) == BTRFS_DEVCLASS_META || \
+                                     (x) == BTRFS_DEVCLASS_ALL)
+#define BTRFS_DEVCLASS_ALLOW_META(x) ((x) == BTRFS_DEVCLASS_META || \
+                                      (x) == BTRFS_DEVCLASS_ALL)
+#define BTRFS_DEVCLASS_ALLOW_DATA(x) ((x) == BTRFS_DEVCLASS_DATA || \
+                                      (x) == BTRFS_DEVCLASS_ALL)
+
+/*
  * the key defines the order in the tree, and so it also defines (optimal)
  * block layout.  objectid corresonds to the inode number.  The flags
  * tells us things about the object, and is a kind of stream selector.
@@ -755,6 +773,8 @@ struct btrfs_root {
 	/* leaf allocations are done in leafsize units */
 	u32 stripesize;
 
+	int seek_speed;
+
 	int ref_cows;
 	int track_dirty;
 
diff --git a/ioctl-test.c b/ioctl-test.c
index 7cf3bc2..c47469a 100644
--- a/ioctl-test.c
+++ b/ioctl-test.c
@@ -22,6 +22,7 @@ unsigned long ioctls[] = {
 	BTRFS_IOC_INO_LOOKUP,
 	BTRFS_IOC_DEFAULT_SUBVOL,
 	BTRFS_IOC_SPACE_INFO,
+	BTRFS_IOC_ADD_DEV_V2,
 	0 };
 
 int main(int ac, char **av)
diff --git a/ioctl.h b/ioctl.h
index b66cc29..2f38725 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -39,8 +39,10 @@ struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
 	__u64 flags;
-	__u64 unused[4];
-	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+	__u8  seek_speed;
+	__u8  unused_u8[3];
+	__u64 unused_u64[3];
+	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
@@ -204,4 +206,6 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_ADD_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 27, \
+				   struct btrfs_ioctl_vol_args_v2)
 #endif
diff --git a/utils.c b/utils.c
index 5fb82dc..f1477f3 100644
--- a/utils.c
+++ b/utils.c
@@ -522,12 +522,14 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret)
+int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
+                         int class)
 {
 	u64 block_count;
 	u64 bytenr;
 	struct stat st;
 	int i, ret;
+	int mb_min = class == BTRFS_DEVCLASS_LOG ? 32 : 256;
 
 	ret = fstat(fd, &st);
 	if (ret < 0) {
@@ -542,9 +544,9 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret)
 	}
 	zero_end = 1;
 
-	if (block_count < 256 * 1024 * 1024) {
+	if (block_count < mb_min * 1024 * 1024) {
 		fprintf(stderr, "device %s is too small "
-		        "(must be at least 256 MB)\n", file);
+		        "(must be at least %d MB)\n", file, mb_min);
 		exit(1);
 	}
 	ret = zero_dev_start(fd);
@@ -1029,3 +1031,17 @@ u64 parse_size(char *s)
 	}
 	return atoll(s) * mult;
 }
+
+int parse_class(const char *s)
+{
+	if (strcmp(s, "data") == 0) {
+		return BTRFS_DEVCLASS_DATA;
+	} else if (strcmp(s, "meta") == 0) {
+		return BTRFS_DEVCLASS_META;
+	} else if (strcmp(s, "all") == 0) {
+		return BTRFS_DEVCLASS_ALL;
+	} else if (strcmp(s, "log") == 0) {
+		return BTRFS_DEVCLASS_LOG;
+	}
+	return -1;
+}
diff --git a/utils.h b/utils.h
index dc1b41d..981ffdb 100644
--- a/utils.h
+++ b/utils.h
@@ -27,7 +27,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end,
-			 u64 *block_count_ret);
+			 u64 *block_count_ret, int class);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
@@ -41,4 +41,10 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 u64 parse_size(char *s);
+int parse_class(const char *s);
+struct btrfs_class_dev {
+	char *file;
+	int class;
+};
+
 #endif
-- 
1.7.2.2

