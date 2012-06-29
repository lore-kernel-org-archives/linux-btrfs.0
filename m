Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19766 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2F2JvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:51:18 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9pEnr012720
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:51:14 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs-progs: make get default report correctly
Date: Fri, 29 Jun 2012 18:00:37 +0800
Message-Id: <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have both set-default and get-default, but actually our get-default
does not show which one is the default one.

This patch plus the kernel side patch fix this.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 Makefile         |    6 +++---
 btrfs-list.c     |   44 +++++++++++++++++++++++++++++++++++++++++---
 cmds-subvolume.c |   16 +++-------------
 ioctl.h          |    1 +
 4 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index 79818e6..5d10026 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o common.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o
 
@@ -39,8 +39,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
+btrfs: $(objects) btrfs.o help.o $(cmds_objects)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..f1baa52 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,7 @@
 #include "ctree.h"
 #include "transaction.h"
 #include "utils.h"
+#include "commands.h"
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
@@ -668,7 +669,42 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent)
+int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id)
+{
+	int ret = 0, e;
+	struct btrfs_ioctl_get_set_flags_args args;
+
+	memset(&args, 0, sizeof(args));
+
+	if (set && flags)
+		args.flags |= flags;
+	args.objectid = root_id;
+
+	if (set)
+		ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &args);
+	else
+		ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &args);
+	e = errno;
+	if( ret < 0 ){
+		fprintf(stderr, "ERROR: unable to %s a subvolume flags- %s\n",
+			(set) ? "set" : "get", strerror(e));
+		return 30;
+	} else if (!set) {
+		u64 flags_to_get = args.flags;
+		if (flags_to_get)
+			printf(" (");
+		if (flags_to_get & BTRFS_SUBVOL_RDONLY)
+			printf("Readonly,");
+		if (flags_to_get & BTRFS_SUBVOL_DEFAULT)
+			printf("Default,");
+		if (flags_to_get)
+			printf(")");
+		printf("\n");
+	}
+	return 0;
+}
+
+int list_subvols(int fd, int print_parent, int get_default)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -704,15 +740,17 @@ int list_subvols(int fd, int print_parent)
 		resolve_root(&root_lookup, entry, &root_id, &parent_id,
 				&level, &path);
 		if (print_parent) {
-			printf("ID %llu parent %llu top level %llu path %s\n",
+			printf("ID %llu parent %llu top level %llu path %s",
 				(unsigned long long)root_id,
 				(unsigned long long)parent_id,
 				(unsigned long long)level, path);
 		} else {
-			printf("ID %llu top level %llu path %s\n",
+			printf("ID %llu top level %llu path %s",
 				(unsigned long long)root_id,
 				(unsigned long long)level, path);
 		}
+		if (subvol_get_set_flags(fd, 0, 0, root_id))
+			printf("\n");
 		free(path);
 		n = rb_prev(n);
 	}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5ee31cb..8783e67 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -32,6 +32,7 @@
 /* btrfs-list.c */
 int list_subvols(int fd, int print_parent, int get_default);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id);
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
@@ -520,33 +521,22 @@ static const char * const cmd_subvol_set_ro_usage[] = {
 
 static int cmd_subvol_set_ro(int argc, char **argv)
 {
-	int	ret=0, fd, e;
+	int	ret=0, fd;
 	char	*path;
-	struct	btrfs_ioctl_get_set_flags_args args;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_set_ro_usage);
 
 	path = argv[1];
 
-	memset(&args, 0, sizeof(args));
-
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 
-	args.flags |= BTRFS_SUBVOL_RDONLY;
-	args.objectid = 0;
-	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &args);
-	e = errno;
+	ret = subvol_get_set_flags(fd, 1, BTRFS_SUBVOL_RDONLY, 0);
 	close(fd);
-	if( ret < 0 ){
-		fprintf(stderr, "ERROR: unable to set a subvolume RO- %s\n",
-			strerror(e));
-		return 30;
-	}
 	return 0;
 }
 
diff --git a/ioctl.h b/ioctl.h
index 9c066eb..936d075 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -32,6 +32,7 @@ struct btrfs_ioctl_vol_args {
 };
 
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_DEFAULT		(1ULL << 2)
 #define BTRFS_SUBVOL_NAME_MAX 4039
 
 struct btrfs_ioctl_vol_args_v2 {
-- 
1.6.5.2

