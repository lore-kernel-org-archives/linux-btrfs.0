Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3HGBFg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 21:05:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7715a4e032531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Aug 2013 21:05:36 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7715ZAc014675
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Aug 2013 21:05:36 -0400
Message-ID: <52019D5F.3070301@redhat.com>
Date: Tue, 06 Aug 2013 20:05:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: mark static & remove unused from non-kernel
 code
References: <52019C6D.9050308@redhat.com>
In-Reply-To: <52019C6D.9050308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark many functions as static, and remove any resulting dead code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 btrfs-convert.c     |    8 ++++----
 btrfs-find-root.c   |    2 +-
 btrfs-list.c        |   10 +++++-----
 btrfs-list.h        |    3 ---
 btrfs-map-logical.c |    4 ++--
 btrfs.c             |    5 +++--
 btrfstune.c         |    6 +++---
 cmds-chunk.c        |    5 +++--
 cmds-qgroup.c       |    4 ++--
 cmds-quota.c        |    2 +-
 cmds-receive.c      |    4 ++--
 cmds-restore.c      |    2 +-
 cmds-scrub.c        |    2 +-
 ioctl-test.c        |    2 +-
 quick-test.c        |    2 +-
 send-test.c         |    2 +-
 send-utils.c        |    9 ---------
 send-utils.h        |    2 --
 utils.c             |   18 ++++++++++--------
 utils.h             |    3 ---
 20 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a9ac9a5..7eaa478 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1418,8 +1418,8 @@ fail:
 	return ret;
 }
 
-struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
-			       u64 root_objectid)
+static struct btrfs_root *
+link_subvol(struct btrfs_root *root, const char *base, u64 root_objectid)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -2277,7 +2277,7 @@ err:
 	return ret;
 }
 
-int do_convert(const char *devname, int datacsum, int packing, int noxattr)
+static int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 {
 	int i, ret;
 	int fd = -1;
@@ -2456,7 +2456,7 @@ fail:
 	return -1;
 }
 
-int do_rollback(const char *devname, int force)
+static int do_rollback(const char *devname, int force)
 {
 	int fd = -1;
 	int ret;
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 989535f..1912f9d 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -46,7 +46,7 @@ static void usage()
 		"[ -g search_generation ] [ -l search_level ] <device>\n");
 }
 
-int csum_block(void *buf, u32 len)
+static int csum_block(void *buf, u32 len)
 {
 	char *result;
 	u32 crc = ~(u32)0;
diff --git a/btrfs-list.c b/btrfs-list.c
index a6902c3..0a9c52c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -46,7 +46,7 @@ struct root_lookup {
 	struct rb_root root;
 };
 
-struct {
+static struct {
 	char	*name;
 	char	*column_name;
 	int	need_print;
@@ -240,7 +240,7 @@ void btrfs_list_free_comparer_set(struct btrfs_list_comparer_set *comp_set)
 	free(comp_set);
 }
 
-int btrfs_list_setup_comparer(struct btrfs_list_comparer_set  **comp_set,
+static int btrfs_list_setup_comparer(struct btrfs_list_comparer_set  **comp_set,
 			      enum btrfs_list_comp_enum comparer,
 			      int is_descending)
 {
@@ -820,7 +820,7 @@ static char *__ino_resolve(int fd, u64 dirid)
  * simple string builder, returning a new string with both
  * dirid and name
  */
-char *build_name(char *dirid, char *name)
+static char *build_name(char *dirid, char *name)
 {
 	char *full;
 	if (!dirid)
@@ -1477,7 +1477,7 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
 	}
 }
 
-int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
+static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 {
 	int ret;
 
@@ -1522,7 +1522,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	return 0;
 }
 
-char *strdup_or_null(const char *s)
+static char *strdup_or_null(const char *s)
 {
 	if (!s)
 		return NULL;
diff --git a/btrfs-list.h b/btrfs-list.h
index d3fd9e2..5164467 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -150,9 +150,6 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 			    enum btrfs_list_filter_enum filter, u64 data);
 struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void);
 void btrfs_list_free_comparer_set(struct btrfs_list_comparer_set *comp_set);
-int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
-			      enum btrfs_list_comp_enum comparer,
-			      int is_descending);
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index b9635f7..f17d2a0 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -37,8 +37,8 @@
  * */
 static FILE *info_file;
 
-struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
-				     u32 blocksize, int copy)
+static struct extent_buffer *
+debug_read_block(struct btrfs_root *root, u64 bytenr, u32 blocksize, int copy)
 {
 	int ret;
 	struct extent_buffer *eb;
diff --git a/btrfs.c b/btrfs.c
index 4e93e13..9e212ce 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -106,8 +106,9 @@ parse_command_token(const char *arg, const struct cmd_group *grp)
 	return cmd;
 }
 
-void handle_help_options_next_level(const struct cmd_struct *cmd,
-				    int argc, char **argv)
+static void
+handle_help_options_next_level(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	if (argc < 2)
 		return;
diff --git a/btrfstune.c b/btrfstune.c
index 4db1767..1cf6a68 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -34,7 +34,7 @@
 
 static char *device;
 
-int update_seeding_flag(struct btrfs_root *root, int set_flag)
+static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_super_block *disk_super;
@@ -65,7 +65,7 @@ int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	return 0;
 }
 
-int enable_extrefs_flag(struct btrfs_root *root)
+static int enable_extrefs_flag(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_super_block *disk_super;
@@ -81,7 +81,7 @@ int enable_extrefs_flag(struct btrfs_root *root)
 	return 0;
 }
 
-int enable_skinny_metadata(struct btrfs_root *root)
+static int enable_skinny_metadata(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_super_block *disk_super;
diff --git a/cmds-chunk.c b/cmds-chunk.c
index c20234b..c8234d5 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -188,7 +188,8 @@ static struct btrfs_chunk *create_chunk_item(struct chunk_record *record)
 	return ret;
 }
 
-void init_recover_control(struct recover_control *rc, int verbose, int yes)
+static void
+init_recover_control(struct recover_control *rc, int verbose, int yes)
 {
 	memset(rc, 0, sizeof(struct recover_control));
 	cache_tree_init(&rc->chunk);
@@ -204,7 +205,7 @@ void init_recover_control(struct recover_control *rc, int verbose, int yes)
 	rc->yes = yes;
 }
 
-void free_recover_control(struct recover_control *rc)
+static void free_recover_control(struct recover_control *rc)
 {
 	free_block_group_tree(&rc->bg);
 	free_chunk_cache_tree(&rc->chunk);
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 95aca9b..bf659ab 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -104,7 +104,7 @@ static int qgroup_create(int create, int argc, char **argv)
 	return 0;
 }
 
-void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
+static void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
 {
 	printf("%llu/%llu %lld %lld\n", objectid >> 48,
 		objectid & ((1ll << 48) - 1),
@@ -112,7 +112,7 @@ void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
 		btrfs_stack_qgroup_info_exclusive(info));
 }
 
-int list_qgroups(int fd)
+static int list_qgroups(int fd)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
diff --git a/cmds-quota.c b/cmds-quota.c
index 2e2971a..3357780 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -30,7 +30,7 @@ static const char * const quota_cmd_group_usage[] = {
 	NULL
 };
 
-int quota_ctl(int cmd, int argc, char **argv)
+static int quota_ctl(int cmd, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
diff --git a/cmds-receive.c b/cmds-receive.c
index 7abce76..1630f64 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -787,7 +787,7 @@ out:
 }
 
 
-struct btrfs_send_ops send_ops = {
+static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
 	.mkfile = process_mkfile,
@@ -810,7 +810,7 @@ struct btrfs_send_ops send_ops = {
 	.utimes = process_utimes,
 };
 
-int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
+static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 {
 	int ret;
 	char *dest_dir_full_path;
diff --git a/cmds-restore.c b/cmds-restore.c
index 0871366..38dfcc9 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -154,7 +154,7 @@ static int decompress(char *inbuf, char *outbuf, u64 compress_len,
 	return -1;
 }
 
-int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
+static int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
 	int slot;
 	int level = 1;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index bf50650..97b93ce 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1007,7 +1007,7 @@ static struct scrub_file_record *last_dev_scrub(
 	return NULL;
 }
 
-int mkdir_p(char *path)
+static int mkdir_p(char *path)
 {
 	int i;
 	int ret;
diff --git a/ioctl-test.c b/ioctl-test.c
index 1c27d61..54fc013 100644
--- a/ioctl-test.c
+++ b/ioctl-test.c
@@ -3,7 +3,7 @@
 #include "kerncompat.h"
 #include "ioctl.h"
 
-unsigned long ioctls[] = {
+static unsigned long ioctls[] = {
 	BTRFS_IOC_SNAP_CREATE,
 	BTRFS_IOC_DEFRAG,
 	BTRFS_IOC_RESIZE,
diff --git a/quick-test.c b/quick-test.c
index aaedd19..b12b9ef 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -27,7 +27,7 @@
 #include "transaction.h"
 
 /* for testing only */
-int next_key(int i, int max_key) {
+static int next_key(int i, int max_key) {
 	return rand() % max_key;
 	// return i;
 }
diff --git a/send-test.c b/send-test.c
index 4a53ae2..cb1f57d 100644
--- a/send-test.c
+++ b/send-test.c
@@ -325,7 +325,7 @@ static int print_update_extent(const char *path, u64 offset, u64 len,
 	return 0;
 }
 
-struct btrfs_send_ops send_ops_print = {
+static struct btrfs_send_ops send_ops_print = {
 	.subvol = print_subvol,
 	.snapshot = print_snapshot,
 	.mkfile = print_mkfile,
diff --git a/send-utils.c b/send-utils.c
index 874f8a5..3d562a4 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -255,15 +255,6 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 	return 0;
 }
 
-void subvol_uuid_search_add(struct subvol_uuid_search *s,
-			    struct subvol_info *si)
-{
-	if (si) {
-		free(si->path);
-		free(si);
-	}
-}
-
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 				       u64 root_id, const u8 *uuid, u64 transid,
 				       const char *path,
diff --git a/send-utils.h b/send-utils.h
index ed1a40e..2607647 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -60,8 +60,6 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 				       u64 root_id, const u8 *uuid, u64 transid,
 				       const char *path,
 				       enum subvol_search_type type);
-void subvol_uuid_search_add(struct subvol_uuid_search *s,
-			    struct subvol_info *si);
 
 int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id);
 
diff --git a/utils.c b/utils.c
index e522361..71bb73e 100644
--- a/utils.c
+++ b/utils.c
@@ -751,7 +751,7 @@ int open_path_or_dev_mnt(const char *path)
 }
 
 /* checks if a device is a loop device */
-int is_loop_device (const char* device) {
+static int is_loop_device (const char* device) {
 	struct stat statbuf;
 
 	if(stat(device, &statbuf) < 0)
@@ -764,7 +764,8 @@ int is_loop_device (const char* device) {
 
 /* Takes a loop device path (e.g. /dev/loop0) and returns
  * the associated file (e.g. /images/my_btrfs.img) */
-int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
+static int
+resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
 {
 	int ret;
 	FILE *f;
@@ -790,7 +791,7 @@ int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
 /* Checks whether a and b are identical or device
  * files associated with the same block device
  */
-int is_same_blk_file(const char* a, const char* b)
+static int is_same_blk_file(const char* a, const char* b)
 {
 	struct stat st_buf_a, st_buf_b;
 	char real_a[PATH_MAX];
@@ -837,7 +838,7 @@ int is_same_blk_file(const char* a, const char* b)
  * if one file is a loop device that uses the other
  * file.
  */
-int is_same_loop_file(const char* a, const char* b)
+static int is_same_loop_file(const char* a, const char* b)
 {
 	char res_a[PATH_MAX];
 	char res_b[PATH_MAX];
@@ -877,7 +878,7 @@ int is_same_loop_file(const char* a, const char* b)
 }
 
 /* Checks if a file exists and is a block or regular file*/
-int is_existing_blk_or_reg_file(const char* filename)
+static int is_existing_blk_or_reg_file(const char* filename)
 {
 	struct stat st_buf;
 
@@ -894,7 +895,8 @@ int is_existing_blk_or_reg_file(const char* filename)
 /* Checks if a file is used (directly or indirectly via a loop device)
  * by a device in fs_devices
  */
-int blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices, const char* file)
+static int
+blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices, const char* file)
 {
 	int ret;
 	struct list_head *head;
@@ -1524,7 +1526,7 @@ int open_file_or_dir(const char *fname)
 	return fd;
 }
 
-int get_device_info(int fd, u64 devid,
+static int get_device_info(int fd, u64 devid,
 		    struct btrfs_ioctl_dev_info_args *di_args)
 {
 	int ret;
@@ -1648,7 +1650,7 @@ static inline void translate(char *f, char *t)
  * Checks if the swap device.
  * Returns 1 if swap device, < 0 on error or 0 if not swap device.
  */
-int is_swap_device(const char *file)
+static int is_swap_device(const char *file)
 {
 	FILE	*f;
 	struct stat	st_buf;
diff --git a/utils.h b/utils.h
index d20f97f..693c5ad 100644
--- a/utils.h
+++ b/utils.h
@@ -57,8 +57,6 @@ int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
 int open_file_or_dir(const char *fname);
-int get_device_info(int fd, u64 devid,
-		    struct btrfs_ioctl_dev_info_args *di_args);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 int get_label(const char *btrfs_dev);
@@ -67,7 +65,6 @@ int set_label(const char *btrfs_dev, const char *label);
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int open_path_or_dev_mnt(const char *path);
-int is_swap_device(const char *file);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))


