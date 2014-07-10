Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47567 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755433AbaGJDFS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 23:05:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6A35EKL026108
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:05:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: Fix wrong indent in btrfs-progs.
Date: Thu, 10 Jul 2014 11:05:12 +0800
Message-ID: <1404961513-14614-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When editing cmds-filesystem.c, I found cmd_filesystem_df() uses 7
spaces as indent instead of 1 tab (or 8 spaces). which makes indent
quite embarrassing.
Such problem is especillay hard to detect when reviewing patches,
since the leading '+' makes a tab only 7 spaces long, makeing 7 spaces
look the same with a tab.

This patch fixes all the 7 spaces indent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 79 +++++++++++++++++++++++++++----------------------------
 ctree.h           | 15 ++++++-----
 utils.c           | 10 +++----
 3 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4b2d27e..0a9b62a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -114,23 +114,23 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_filesystem_df_usage[] = {
-       "btrfs filesystem df <path>",
-       "Show space usage information for a mount point",
-       NULL
+	"btrfs filesystem df <path>",
+	"Show space usage information for a mount point",
+	NULL
 };
 
 static void print_df(struct btrfs_ioctl_space_args *sargs)
 {
-       u64 i;
-       struct btrfs_ioctl_space_info *sp = sargs->spaces;
-
-       for (i = 0; i < sargs->total_spaces; i++, sp++) {
-               printf("%s, %s: total=%s, used=%s\n",
-                       group_type_str(sp->flags),
-                       group_profile_str(sp->flags),
-                       pretty_size(sp->total_bytes),
-                       pretty_size(sp->used_bytes));
-       }
+	u64 i;
+	struct btrfs_ioctl_space_info *sp = sargs->spaces;
+
+	for (i = 0; i < sargs->total_spaces; i++, sp++) {
+		printf("%s, %s: total=%s, used=%s\n",
+		       group_type_str(sp->flags),
+		       group_profile_str(sp->flags),
+		       pretty_size(sp->total_bytes),
+		       pretty_size(sp->used_bytes));
+	}
 }
 
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
@@ -183,33 +183,32 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 
 static int cmd_filesystem_df(int argc, char **argv)
 {
-       struct btrfs_ioctl_space_args *sargs = NULL;
-       int ret;
-       int fd;
-       char *path;
-       DIR *dirstream = NULL;
-
-       if (check_argc_exact(argc, 2))
-               usage(cmd_filesystem_df_usage);
-
-       path = argv[1];
-
-       fd = open_file_or_dir(path, &dirstream);
-       if (fd < 0) {
-               fprintf(stderr, "ERROR: can't access '%s'\n", path);
-               return 1;
-       }
-       ret = get_df(fd, &sargs);
-
-       if (!ret && sargs) {
-               print_df(sargs);
-               free(sargs);
-       } else {
-               fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
-       }
-
-       close_file_or_dir(fd, dirstream);
-       return !!ret;
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+	DIR *dirstream = NULL;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_filesystem_df_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 1;
+	}
+	ret = get_df(fd, &sargs);
+	if (!ret && sargs) {
+		print_df(sargs);
+		free(sargs);
+	} else {
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
+	}
+
+	close_file_or_dir(fd, dirstream);
+	return !!ret;
 }
 
 static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
diff --git a/ctree.h b/ctree.h
index 35d3633..83d85b3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -939,10 +939,10 @@ struct btrfs_block_group_cache {
 };
 
 struct btrfs_extent_ops {
-       int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
-		           u64 hint_byte, struct btrfs_key *ins);
-       int (*free_extent)(struct btrfs_root *root, u64 bytenr,
-		          u64 num_bytes);
+	int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
+			    u64 hint_byte, struct btrfs_key *ins);
+	int (*free_extent)(struct btrfs_root *root, u64 bytenr,
+			   u64 num_bytes);
 };
 
 struct btrfs_device;
@@ -2117,9 +2117,10 @@ BTRFS_SETGET_STACK_FUNCS(stack_qgroup_limit_rsv_exclusive,
 static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 						    struct btrfs_item *e)
 {
-       unsigned long offset;
-       offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
-       return btrfs_item_size(eb, e) - offset;
+	unsigned long offset;
+
+	offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
+	return btrfs_item_size(eb, e) - offset;
 }
 
 /* this returns the number of file bytes represented by the inline item.
diff --git a/utils.c b/utils.c
index 07173ee..356bdce 100644
--- a/utils.c
+++ b/utils.c
@@ -1485,15 +1485,15 @@ char *__strncpy__null(char *dest, const char *src, size_t n)
  */
 static int check_label(const char *input)
 {
-       int len = strlen(input);
+	int len = strlen(input);
 
-       if (len > BTRFS_LABEL_SIZE - 1) {
+	if (len > BTRFS_LABEL_SIZE - 1) {
 		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
 			input, BTRFS_LABEL_SIZE - 1);
-               return -1;
-       }
+		return -1;
+	}
 
-       return 0;
+	return 0;
 }
 
 static int set_label_unmounted(const char *dev, const char *label)
-- 
2.0.1

