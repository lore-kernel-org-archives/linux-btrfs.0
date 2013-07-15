Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39009 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3GOF0R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:17 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 09/11] btrfs-progs: move out print in cmd_df to another function
Date: Mon, 15 Jul 2013 13:30:55 +0800
Message-Id: <1373866257-10519-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

This is a prepatory work for the following btrfs fi show command
fixes. So that we have a function get_df to get the fs sizes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   96 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0f5a30a..b1e105b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -38,31 +38,12 @@ static const char * const filesystem_cmd_group_usage[] = {
 	NULL
 };
 
-static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
-	"Show space usage information for a mount point",
-	NULL
-};
-
-static int cmd_df(int argc, char **argv)
+static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 {
-	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
-	u64 count = 0, i;
-	int ret;
-	int fd;
-	int e;
-	char *path;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_df_usage);
-
-	path = argv[1];
-
-	fd = open_file_or_dir(path);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
-	}
+	u64 count = 0;
+	int ret, e;
+	struct btrfs_ioctl_space_args *sargs_orig;
+	struct btrfs_ioctl_space_args *sargs;
 
 	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
 	if (!sargs)
@@ -74,14 +55,10 @@ static int cmd_df(int argc, char **argv)
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
 		free(sargs);
-		return ret;
+		return -e;
 	}
 	if (!sargs->total_spaces) {
-		close(fd);
 		free(sargs);
 		return 0;
 	}
@@ -91,7 +68,6 @@ static int cmd_df(int argc, char **argv)
 	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
 	if (!sargs) {
-		close(fd);
 		free(sargs_orig);
 		return -ENOMEM;
 	}
@@ -102,15 +78,20 @@ static int cmd_df(int argc, char **argv)
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
 		free(sargs);
-		return ret;
+		return -e;
 	}
+	*sargs_ret = sargs;
+	return ret;
+}
 
+static void print_df(struct btrfs_ioctl_space_args *sargs)
+{
+	u64 i;
 	for (i = 0; i < sargs->total_spaces; i++) {
 		char description[80];
+		char *total_bytes;
+		char *used_bytes;
 		int written = 0;
 		u64 flags = sargs->spaces[i].flags;
 
@@ -153,14 +134,49 @@ static int cmd_df(int argc, char **argv)
 			written += 7;
 		}
 
-		printf("%s: total=%s, used=%s\n", description,
-			pretty_size(sargs->spaces[i].total_bytes),
-			pretty_size(sargs->spaces[i].used_bytes));
+		total_bytes = pretty_size(sargs->spaces[i].total_bytes);
+		used_bytes = pretty_size(sargs->spaces[i].used_bytes);
+		printf("%s: total=%s, used=%s\n", description, total_bytes,
+		       used_bytes);
 	}
-	close(fd);
-	free(sargs);
+}
 
-	return 0;
+
+static const char * const cmd_df_usage[] = {
+	"btrfs filesystem df <path>",
+	"Show space usage information for a mount point",
+	NULL
+};
+
+static int cmd_df(int argc, char **argv)
+{
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_df_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+	ret = get_df(fd, &sargs);
+
+	if (!ret) {
+		if (sargs) {
+			print_df(sargs);
+			free(sargs);
+		}
+	} else
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(ret));
+
+	close(fd);
+	return ret;
 }
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
-- 
1.7.7.6

