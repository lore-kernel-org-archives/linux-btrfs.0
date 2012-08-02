Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2HBKOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 06:14:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q72AE0le032383
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Aug 2012 18:14:00 +0800
Message-ID: <501A52DD.7070307@cn.fujitsu.com>
Date: Thu, 02 Aug 2012 18:13:49 +0800
From: zhoubo <zhoub-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: enhance btrfs subvol list to show read-only
 snapshots
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

This patch enhances btrfs subvol list to show read-only snapshots.
You can use the -r option showing read-only snapshots, for example:
btrfs subvolume list -r <path>

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
 btrfs-list.c     |   68 +++++++++++++++++++++++++++++++++++++++++++++++------
 cmds-subvolume.c |   15 ++++++++----
 ctree.h          |    2 +
 3 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 693d241..9c10b9e 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -608,7 +608,46 @@ out:
 	return 0;
 }
 
-static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
+static int is_readonly_subvol(int fd, u64 objectid)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	int found = 0;
+	struct btrfs_root_item *item;
+
+	memset(&args, 0, sizeof(args));
+
+	/* search in the tree of tree roots */
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = objectid;
+	sk->max_objectid = objectid;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return ret;
+	if (sk->nr_items == 0) {
+		errno = -ENOENT;
+		found = -1;
+		goto out;
+	}
+	sh = (struct btrfs_ioctl_search_header *)args.buf;
+	off += sizeof(*sh);
+	item = (struct btrfs_root_item *)(args.buf + off);
+	if (item->flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY))
+		found = 1;
+out:
+	return found;
+}
+
+static int __list_subvol_search(int fd, struct root_lookup *root_lookup,
+					int list_ro)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -668,9 +707,23 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				name_len = btrfs_stack_root_ref_name_len(ref);
 				name = (char *)(ref + 1);
 				dir_id = btrfs_stack_root_ref_dirid(ref);
-
-				add_root(root_lookup, sh->objectid, sh->offset,
-					 dir_id, name, name_len);
+				if (list_ro) {
+					int subvol_readonly =
+						is_readonly_subvol(fd,
+								sh->objectid);
+					if (subvol_readonly < 0) {
+						return subvol_readonly;
+					} else if (subvol_readonly) {
+						add_root(root_lookup,
+							sh->objectid,
+							sh->offset, dir_id,
+							name, name_len);
+					}
+				} else {
+					add_root(root_lookup, sh->objectid,
+							sh->offset, dir_id,
+							name, name_len);
+				}
 			}
 
 			off += sh->len;
@@ -719,7 +772,7 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent, int get_default)
+int list_subvols(int fd, int print_parent, int get_default, int list_ro)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -745,7 +798,7 @@ int list_subvols(int fd, int print_parent, int get_default)
 		}
 	}
 
-	ret = __list_subvol_search(fd, &root_lookup);
+	ret = __list_subvol_search(fd, &root_lookup, list_ro);
 	if (ret) {
 		fprintf(stderr, "ERROR: can't perform the search - %s\n",
 				strerror(errno));
@@ -788,7 +841,6 @@ int list_subvols(int fd, int print_parent, int get_default)
 				(unsigned long long)entry->root_id,
 				(unsigned long long)level, path);
 		}
-
 		free(path);
 		n = rb_prev(n);
 	}
@@ -983,7 +1035,7 @@ char *path_for_root(int fd, u64 root)
 	char *ret_path = NULL;
 	int ret;
 
-	ret = __list_subvol_search(fd, &root_lookup);
+	ret = __list_subvol_search(fd, &root_lookup, 0);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3508ce6..791ac3f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -30,7 +30,7 @@
 #include "commands.h"
 
 /* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int get_default);
+int list_subvols(int fd, int print_parent, int get_default, int list_ro);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 
 static const char * const subvolume_cmd_group_usage[] = {
@@ -219,10 +219,11 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-p] <path>",
+	"btrfs subvolume list [-pr] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p     print parent ID",
+	"-r     list read-only snapshots",
 	NULL
 };
 
@@ -231,15 +232,19 @@ static int cmd_subvol_list(int argc, char **argv)
 	int fd;
 	int ret;
 	int print_parent = 0;
+	int list_ro = 0;
 	char *subvol;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "p");
+		int c = getopt(argc, argv, "pr");
 		if (c < 0)
 			break;
 
 		switch(c) {
+		case 'r':
+			list_ro = 1;
+			break;
 		case 'p':
 			print_parent = 1;
 			break;
@@ -268,7 +273,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, print_parent, 0);
+	ret = list_subvols(fd, print_parent, 0, list_ro);
 	if (ret)
 		return 19;
 	return 0;
@@ -428,7 +433,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1);
+	ret = list_subvols(fd, 0, 1, 0);
 	if (ret)
 		return 19;
 	return 0;
diff --git a/ctree.h b/ctree.h
index 71e387b..12da31a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -138,6 +138,8 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 #define BTRFS_FT_XATTR		8
 #define BTRFS_FT_MAX		9
 
+#define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
  * block layout.  objectid corresonds to the inode number.  The flags
-- 
1.6.0.6
