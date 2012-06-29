Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29759 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2F2JvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:51:18 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9pCUM012719
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:51:15 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs-progs: add 's' option for 'btrfs subvolume list'
Date: Fri, 29 Jun 2012 18:00:38 +0800
Message-Id: <1340964038-32584-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want 'btrfs subvolume list' to act as 'ls', which means that
we can not only list out all the subvolumes we have, but also list
each single one.

So this patch add 's' option to show a single one:

$ ./btrfs sub list /mnt/btrfs/
ID 256 top level 5 path subvol (Readonly,)
ID 257 top level 5 path snapshot
ID 258 top level 5 path subvol2
ID 259 top level 5 path subvol2/subvol3

$ ./btrfs sub list -s /mnt/btrfs/subvol
ID 256 top level 5 path subvol (Readonly,)

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfs-list.c     |   41 ++++++++++++++++++++++++++++++++++++++++-
 cmds-subvolume.c |   15 ++++++++++-----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index f1baa52..3e79239 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -312,6 +312,30 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	return 0;
 }
 
+/*
+ * helper function for getting the root which the file is belonged to.
+ */
+static int lookup_ino_rootid(int fd, u64 *rootid)
+{
+	struct btrfs_ioctl_ino_lookup_args args;
+	int ret, e;
+
+	memset(&args, 0, sizeof(args));
+	args.treeid = 0;
+	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	e = errno;
+	if (ret) {
+		fprintf(stderr, "ERROR: Failed to lookup root id - %s\n",
+			strerror(e));
+		return ret;
+	}
+
+	*rootid = args.treeid;
+	return 0;
+}
+
 /* finding the generation for a given path is a two step process.
  * First we use the inode loookup routine to find out the root id
  *
@@ -704,11 +728,12 @@ int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent, int get_default)
+int list_subvols(int fd, int print_parent, int print_self, int get_default)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
 	int ret;
+	u64 subvolid = 0;
 
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret) {
@@ -725,6 +750,9 @@ int list_subvols(int fd, int print_parent, int get_default)
 	if (ret < 0)
 		return ret;
 
+	if (print_self)
+		lookup_ino_rootid(fd, &subvolid);
+
 	/* now that we have all the subvol-relative paths filled in,
 	 * we have to string the subvols together so that we can get
 	 * a path all the way back to the FS root
@@ -739,6 +767,14 @@ int list_subvols(int fd, int print_parent, int get_default)
 		entry = rb_entry(n, struct root_info, rb_node);
 		resolve_root(&root_lookup, entry, &root_id, &parent_id,
 				&level, &path);
+
+		/* print this subvolume only */
+		if (print_self && subvolid != root_id) {
+			free(path);
+			n = rb_prev(n);
+			continue;
+		}
+
 		if (print_parent) {
 			printf("ID %llu parent %llu top level %llu path %s",
 				(unsigned long long)root_id,
@@ -753,6 +789,9 @@ int list_subvols(int fd, int print_parent, int get_default)
 			printf("\n");
 		free(path);
 		n = rb_prev(n);
+
+		if (print_self)
+			break;
 	}
 
 	return ret;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8783e67..f779b78 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -30,7 +30,7 @@
 #include "commands.h"
 
 /* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int get_default);
+int list_subvols(int fd, int print_parent, int print_self, int get_default);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id);
 
@@ -218,10 +218,11 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-p] <path>",
+	"btrfs subvolume list [-ps] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p     print parent ID",
+	"-s     print this subvolume only",
 	NULL
 };
 
@@ -230,11 +231,12 @@ static int cmd_subvol_list(int argc, char **argv)
 	int fd;
 	int ret;
 	int print_parent = 0;
+	int print_self = 0;
 	char *subvol;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "p");
+		int c = getopt(argc, argv, "ps");
 		if (c < 0)
 			break;
 
@@ -242,6 +244,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'p':
 			print_parent = 1;
 			break;
+		case 's':
+			print_self = 1;
+			break;
 		default:
 			usage(cmd_subvol_list_usage);
 		}
@@ -267,7 +272,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, print_parent, 0);
+	ret = list_subvols(fd, print_parent, print_self, 0);
 	if (ret)
 		return 19;
 	return 0;
@@ -426,7 +431,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1);
+	ret = list_subvols(fd, 0, 0, 1);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.6.5.2

