From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] btrfs-progs: make several functions static
Date: Mon, 19 Jan 2009 22:47:16 +0800
Message-ID: <20090119144716.GA8856@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Make several functions static, and make one argument const.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/btrfsck.c b/btrfsck.c
index 4a41e6d..c50de7d 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1254,7 +1254,7 @@ static int fs_root_objectid(u64 objectid)
 	return 0;
 }
 
-int check_fs_roots(struct btrfs_root *root)
+static int check_fs_roots(struct btrfs_root *root)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -1937,7 +1937,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 	return 0;
 }
 
-int check_extent_refs(struct btrfs_root *root,
+static int check_extent_refs(struct btrfs_root *root,
 		      struct cache_tree *extent_cache)
 {
 	struct extent_record *rec;
@@ -1972,7 +1972,7 @@ int check_extent_refs(struct btrfs_root *root,
 	return err;
 }
 
-int check_extents(struct btrfs_root *root)
+static int check_extents(struct btrfs_root *root)
 {
 	struct cache_tree extent_cache;
 	struct cache_tree seen;
@@ -2057,7 +2057,7 @@ int check_extents(struct btrfs_root *root)
 	return ret;
 }
 
-void print_usage(void)
+static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfsck dev\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
diff --git a/btrfsctl.c b/btrfsctl.c
index e049799..6891d66 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -43,7 +43,7 @@ struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
 #endif
 
-void print_usage(void)
+static void print_usage(void)
 {
 	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
 	printf("                [-r size] [-A device] [-a] [-c]\n");
@@ -59,7 +59,7 @@ void print_usage(void)
 	exit(1);
 }
 
-int open_file_or_dir(char *fname)
+static int open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;


