From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Subvolume listing feature for btrfsctl.
Date: Wed, 18 Nov 2009 14:43:36 +0900
Message-ID: <4B038988.7050808@jp.fujitsu.com>
References: <4B00ADE8.4090205@jp.fujitsu.com> <3d0408630911160015t79044d72u3489a42d57c6f844@mail.gmail.com> <4B011435.2080005@jp.fujitsu.com> <4B038897.3000605@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: yanzheng@21cn.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B038897.3000605@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

New feature to list up subvolume/snapshots under
specified tree of file is introduced to btrfsctl.

This patch should apply with corresponding patch
for kernel.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 btrfsctl.c |  191 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h    |   32 ++++++++++
 2 files changed, 223 insertions(+)

Index: b/btrfsctl.c
===================================================================
--- a/btrfsctl.c	2009-11-16 11:18:57.000000000 +0900
+++ b/btrfsctl.c	2009-11-18 12:09:37.000000000 +0900
@@ -47,6 +47,7 @@ static void print_usage(void)
 {
 	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
 	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
+	printf("                [-l dir]\n");
 	printf("\t-d filename: defragments one file\n");
 	printf("\t-d directory: defragments the entire Btree\n");
 	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
@@ -56,6 +57,7 @@ static void print_usage(void)
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
 	printf("\t-c: forces a single FS sync\n");
 	printf("\t-D: delete snapshot\n");
+	printf("\t-l file: listing snapshot/subvolume under a subvolume\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -88,6 +90,169 @@ static int open_file_or_dir(const char *
 	}
 	return fd;
 }
+
+static noinline int btrfs_gather_under_one_subvolume(int fd,
+		unsigned long command,
+		struct btrfs_ioctl_subvol_args *svargs,
+		u64 tree_id,
+		struct list_head *list,
+		int len)
+{
+	u64 last_tree = 0ULL;
+	int i, ret = 1, local_size;
+
+	while (ret > 0) {
+
+		svargs->leaf = malloc(len);
+		if (!svargs->leaf)
+			return -1;
+		svargs->len = len;
+		svargs->leaf->len = len;
+		svargs->leaf->nritems = 0;
+		svargs->leaf->last_tree = last_tree;
+		svargs->leaf->parent_tree = tree_id;
+
+again:
+		ret = ioctl(fd, command, svargs);
+		if (ret < 0) {
+			free(svargs->leaf);
+			svargs->leaf = NULL;
+			return -1;
+		}
+		if (svargs->leaf->nritems == 0) {
+			free(svargs->leaf);
+			if (ret > 0) {
+				local_size = (svargs->next_len + 1) * 2 +
+					offsetof(struct btrfs_ioctl_subvol_leaf, items) +
+					sizeof(struct btrfs_ioctl_subvol_items)*2;
+				svargs->leaf = malloc(local_size);
+				if (!svargs->leaf)
+					return -1;
+				svargs->len = local_size;
+				svargs->leaf->len = local_size;
+				svargs->leaf->last_tree = last_tree;
+				svargs->leaf->parent_tree = tree_id;
+				goto again;
+			}
+		} else {
+			for (i = 0; i < svargs->leaf->nritems; i++)
+				 INIT_LIST_HEAD(&svargs->leaf->items[i].children);
+			list_add_tail(&svargs->leaf->brother, list);
+			last_tree = svargs->leaf->last_tree;
+		}
+	}
+	return 0;
+}
+
+int btrfs_gather_subvolumes(int fd, unsigned long command,
+		struct btrfs_ioctl_subvol_args *svargs,
+		u64 tree_id, struct list_head *list_top, int len)
+{
+	struct btrfs_ioctl_subvol_leaf *cur;
+	int i;
+
+	if (btrfs_gather_under_one_subvolume(fd, command, svargs, tree_id,
+		list_top, len))
+		return -1;
+	list_for_each_entry(cur, list_top, brother) {
+		for(i = 0; i < cur->nritems; i++) {
+			if (btrfs_gather_subvolumes( fd, command, svargs,
+				cur->items[i].tree_id, &cur->items[i].children, len))
+				return -1;
+		}
+	}
+	return 0;
+}
+
+int btrfs_free_subvolume_info(struct list_head *list_top)
+{
+	struct btrfs_ioctl_subvol_leaf *cur, *tmp;
+	int i;
+
+	list_for_each_entry_safe(cur, tmp, list_top, brother) {
+		for(i = 0; i < cur->nritems; i++) {
+			if (!list_empty(&cur->items[i].children))
+				btrfs_free_subvolume_info(&cur->items[i].children);
+		}
+		list_del(&cur->brother);
+		free(cur);
+	}
+	return 0;
+}
+
+int btrfs_show_subvolume(struct list_head *list_top, char *path,
+		int *seq)
+{
+	int nr = *seq, i;
+	int base_path_len, path_len;
+	struct btrfs_ioctl_subvol_leaf *cur;
+
+	base_path_len = strlen(path);
+	list_for_each_entry(cur, list_top, brother) {
+		for (i = 0; i < cur->nritems; i++) {
+			nr++;
+			path_len = strlen((char *)cur +
+				cur->items[i].path_offset);
+			if (base_path_len + path_len + 1 > BTRFS_PATH_NAME_MAX)
+				return -1;
+			strcpy(path+base_path_len,
+				(char *)cur+cur->items[i].path_offset);
+			strcat(path+base_path_len, "/");
+			printf("%5d\t%10llu\t%s\n", nr,
+				cur->items[i].tree_id, path);
+			if (!list_empty(&cur->items[i].children))
+				if (btrfs_show_subvolume(&cur->items[i].children,
+					path, &nr))
+					return -1;
+		}
+	}
+	*seq = nr;
+	return 0;
+}
+
+
+int btrfs_list_subvolumes(int fd, unsigned long command)
+{
+	struct btrfs_ioctl_subvol_args *svargs;
+	int len, seq = 0, ret = 0;
+	char *path;
+
+	svargs = malloc(sizeof(struct btrfs_ioctl_subvol_args)
+		+ BTRFS_PATH_NAME_MAX + 1);
+	if (!svargs)
+		return -1;
+	INIT_LIST_HEAD(&svargs->list_top);
+	svargs->base_path = (char *)(svargs+1);
+
+	len = (BTRFS_SUBVOL_LEAF_SIZE_MIN + getpagesize() - 1) &
+		~(getpagesize() - 1);
+
+	if (btrfs_gather_subvolumes(fd, command, svargs, 0,
+		&svargs->list_top, len)) {
+		ret = -1;
+		goto out;
+	}
+
+	printf("   Base path = %s\n", svargs->base_path);
+	printf("   No.\t   Tree ID\tSubvolume Relative Path\n");
+
+	path = malloc(BTRFS_PATH_NAME_MAX + 1);
+	if (!path) {
+		ret = -1;
+		goto out;
+	}
+	path[0]='\0';
+	if(btrfs_show_subvolume(&svargs->list_top, path, &seq)) {
+		ret = -1;
+		goto out;
+	}
+	if (seq == 0)
+		printf("\t\tNo Subvolumes\n");
+out:
+	btrfs_free_subvolume_info(&svargs->list_top);
+	return ret;
+}
+
 int main(int ac, char **av)
 {
 	char *fname = NULL;
@@ -191,6 +356,30 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_RESIZE;
 		} else if (strcmp(av[i], "-c") == 0) {
 			command = BTRFS_IOC_SYNC;
+		} else if (strcmp(av[i], "-l") == 0) {
+			if (i >= ac - 1) {
+				fprintf(stderr, "-l requires an arg\n");
+				print_usage();
+			}
+			fullpath = av[i + 1];
+			snap_location = strdup(fullpath);
+			snap_fd = open_file_or_dir(snap_location);
+
+			name = strdup(fullpath);
+			name = basename(name);
+			len = strlen(name);
+
+			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
+				fprintf(stderr,
+					"listing subvolume name zero length or too long\n");
+				exit(1);
+			}
+			if (strchr(name, '/')) {
+				fprintf(stderr,
+					"error: / not allowed in names\n");
+				exit(1);
+			}
+			command = BTRFS_IOC_SNAP_LISTING;
 		}
 	}
 	if (command == 0) {
@@ -219,6 +408,8 @@ int main(int ac, char **av)
 	if (command == BTRFS_IOC_SNAP_CREATE) {
 		args.fd = fd;
 		ret = ioctl(snap_fd, command, &args);
+	} else if (command == BTRFS_IOC_SNAP_LISTING) {
+		ret = btrfs_list_subvolumes(snap_fd, command);
 	} else
 		ret = ioctl(fd, command, &args);
 	if (ret < 0) {
Index: b/ioctl.h
===================================================================
--- a/ioctl.h	2009-11-16 11:18:57.000000000 +0900
+++ b/ioctl.h	2009-11-18 10:21:22.000000000 +0900
@@ -20,16 +20,46 @@
 #define __IOCTL_
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include "kerncompat.h"
+#include "list.h"

 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
 #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_SUBVOL_LIST_MAX 3

 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };

+struct btrfs_ioctl_subvol_args {
+	int len;
+	int next_len;
+	char *base_path;
+	struct btrfs_ioctl_subvol_leaf *leaf;
+	struct list_head list_top;
+};
+
+struct btrfs_ioctl_subvol_items {
+	u64 tree_id;
+	struct list_head children;
+	int path_offset;
+	int len;
+};
+
+struct btrfs_ioctl_subvol_leaf {
+	int len;
+	int nritems;
+	u64 parent_tree;
+	u64 last_tree;
+	struct list_head brother;
+	struct btrfs_ioctl_subvol_items items[];
+};
+
+#define BTRFS_SUBVOL_LEAF_SIZE_MIN sizeof(struct btrfs_ioctl_subvol_leaf) + \
+	sizeof(struct btrfs_ioctl_subvol_items)
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -59,4 +89,6 @@ struct btrfs_ioctl_vol_args {

 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
+				   struct btrfs_ioctl_subvol_args)
 #endif

