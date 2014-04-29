Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbaD2P6F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 11:58:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C2398AC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 15:58:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 02/14] btrfs-progs: add original 'df' and rename 'disk_usage' to 'usage'
Date: Tue, 29 Apr 2014 17:57:07 +0200
Message-Id: <813f7f38a94e8741954bea5419e618c428ff5cea.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add back the original output of the 'btrfs fi df' command for backward
compatibility. The rich output is moved from 'disk_usage' to 'usage'.

Agreed in http://www.spinics.net/lists/linux-btrfs/msg31698.html

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 85 ++++++++++------------------------------------------
 cmds-fi-disk_usage.h |  7 ++---
 cmds-filesystem.c    | 55 ++++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 76 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 2bd591db0f8a..400863d9764f 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -328,6 +328,8 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 	return sargs;
 }
 
+/* Not used, keep for later */
+#if 0
 /*
  * This function computes the space occuped by a *single* RAID5/RAID6 chunk.
  * The computation is performed on the basis of the number of stripes
@@ -465,62 +467,7 @@ exit:
 
 	return ret;
 }
-
-const char * const cmd_filesystem_df_usage[] = {
-	"btrfs filesystem df [-b] <path> [<path>..]",
-	"Show space usage information for a mount point(s).",
-	"",
-	"-b\tSet byte as unit",
-	NULL
-};
-
-int cmd_filesystem_df(int argc, char **argv)
-{
-
-	int	flags = DF_HUMAN_UNIT;
-	int	i, more_than_one = 0;
-
-	optind = 1;
-	while (1) {
-		char	c = getopt(argc, argv, "b");
-		if (c < 0)
-			break;
-
-		switch (c) {
-		case 'b':
-			flags &= ~DF_HUMAN_UNIT;
-			break;
-		default:
-			usage(cmd_filesystem_df_usage);
-		}
-	}
-
-	if (check_argc_min(argc - optind, 1))
-		usage(cmd_filesystem_df_usage);
-
-	for (i = optind; i < argc ; i++) {
-		int r, fd;
-		DIR *dirstream = NULL;
-		if (more_than_one)
-			printf("\n");
-
-		fd = open_file_or_dir(argv[i], &dirstream);
-		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access to '%s'\n",
-				argv[1]);
-			return 12;
-		}
-		r = _cmd_disk_free(fd, argv[i], flags);
-		close_file_or_dir(fd, dirstream);
-
-		if (r)
-			return r;
-		more_than_one = 1;
-
-	}
-
-	return 0;
-}
+#endif
 
 /*
  *  Helper to sort the disk_info structure
@@ -612,10 +559,10 @@ static u64 calc_chunk_size(struct chunk_info *ci)
 }
 
 /*
- *  This function print the results of the command btrfs fi disk-usage
+ *  This function print the results of the command "btrfs fi usage"
  *  in tabular format
  */
-static void _cmd_filesystem_disk_usage_tabular(int mode,
+static void _cmd_filesystem_usage_tabular(int mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *chunks_info_ptr,
 					int chunks_info_count,
@@ -795,10 +742,10 @@ static void print_chunk_disks(u64 chunk_type,
 }
 
 /*
- *  This function print the results of the command btrfs fi disk-usage
+ *  This function print the results of the command "btrfs fi usage"
  *  in linear format
  */
-static void _cmd_filesystem_disk_usage_linear(int mode,
+static void _cmd_filesystem_usage_linear(int mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *info_ptr,
 					int info_count,
@@ -839,7 +786,7 @@ static void _cmd_filesystem_disk_usage_linear(int mode,
 
 }
 
-static int _cmd_filesystem_disk_usage(int fd, char *path, int mode, int tabular)
+static int _cmd_filesystem_usage(int fd, char *path, int mode, int tabular)
 {
 	struct btrfs_ioctl_space_args *sargs = 0;
 	int info_count = 0;
@@ -860,11 +807,11 @@ static int _cmd_filesystem_disk_usage(int fd, char *path, int mode, int tabular)
 	}
 
 	if (tabular)
-		_cmd_filesystem_disk_usage_tabular(mode, sargs,
+		_cmd_filesystem_usage_tabular(mode, sargs,
 					info_ptr, info_count,
 					disks_info_ptr, disks_info_count);
 	else
-		_cmd_filesystem_disk_usage_linear(mode, sargs,
+		_cmd_filesystem_usage_linear(mode, sargs,
 					info_ptr, info_count,
 					disks_info_ptr, disks_info_count);
 
@@ -880,8 +827,8 @@ exit:
 	return ret;
 }
 
-const char * const cmd_filesystem_disk_usage_usage[] = {
-	"btrfs filesystem disk-usage [-b][-t] <path> [<path>..]",
+const char * const cmd_filesystem_usage_usage[] = {
+	"btrfs filesystem usage [-b][-t] <path> [<path>..]",
 	"Show in which disk the chunks are allocated.",
 	"",
 	"-b\tSet byte as unit",
@@ -889,7 +836,7 @@ const char * const cmd_filesystem_disk_usage_usage[] = {
 	NULL
 };
 
-int cmd_filesystem_disk_usage(int argc, char **argv)
+int cmd_filesystem_usage(int argc, char **argv)
 {
 
 	int	flags =	DF_HUMAN_UNIT;
@@ -909,12 +856,12 @@ int cmd_filesystem_disk_usage(int argc, char **argv)
 			tabular = 1;
 			break;
 		default:
-			usage(cmd_filesystem_disk_usage_usage);
+			usage(cmd_filesystem_usage_usage);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_filesystem_disk_usage_usage);
+		usage(cmd_filesystem_usage_usage);
 
 	for (i = optind; i < argc ; i++) {
 		int r, fd;
@@ -928,7 +875,7 @@ int cmd_filesystem_disk_usage(int argc, char **argv)
 				argv[1]);
 			return 12;
 		}
-		r = _cmd_filesystem_disk_usage(fd, argv[i], flags, tabular);
+		r = _cmd_filesystem_usage(fd, argv[i], flags, tabular);
 		close_file_or_dir(fd, dirstream);
 
 		if (r)
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index c315004cd806..95cf4aabefb4 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -19,11 +19,8 @@
 #ifndef __CMDS_FI_DISK_USAGE__
 #define __CMDS_FI_DISK_USAGE__
 
-extern const char * const cmd_filesystem_df_usage[];
-int cmd_filesystem_df(int argc, char **argv);
-
-extern const char * const cmd_filesystem_disk_usage_usage[];
-int cmd_filesystem_disk_usage(int argc, char **argv);
+extern const char * const cmd_filesystem_usage_usage[];
+int cmd_filesystem_usage(int argc, char **argv);
 
 extern const char * const cmd_device_disk_usage_usage[];
 int cmd_device_disk_usage(int argc, char **argv);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 214a0cda518c..9340cb61cabe 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -113,6 +113,26 @@ static const char * const filesystem_cmd_group_usage[] = {
 	NULL
 };
 
+static const char * const cmd_filesystem_df_usage[] = {
+       "btrfs filesystem df <path>",
+       "Show space usage information for a mount point",
+       NULL
+};
+
+static void print_df(struct btrfs_ioctl_space_args *sargs)
+{
+       u64 i;
+       struct btrfs_ioctl_space_info *sp = sargs->spaces;
+
+       for (i = 0; i < sargs->total_spaces; i++, sp++) {
+               printf("%s, %s: total=%s, used=%s\n",
+                       group_type_str(sp->flags),
+                       group_profile_str(sp->flags),
+                       pretty_size(sp->total_bytes),
+                       pretty_size(sp->used_bytes));
+       }
+}
+
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 {
 	u64 count = 0;
@@ -161,6 +181,37 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	return 0;
 }
 
+static int cmd_filesystem_df(int argc, char **argv)
+{
+       struct btrfs_ioctl_space_args *sargs = NULL;
+       int ret;
+       int fd;
+       char *path;
+       DIR *dirstream = NULL;
+
+       if (check_argc_exact(argc, 2))
+               usage(cmd_filesystem_df_usage);
+
+       path = argv[1];
+
+       fd = open_file_or_dir(path, &dirstream);
+       if (fd < 0) {
+               fprintf(stderr, "ERROR: can't access '%s'\n", path);
+               return 1;
+       }
+       ret = get_df(fd, &sargs);
+
+       if (!ret && sargs) {
+               print_df(sargs);
+               free(sargs);
+       } else {
+               fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
+       }
+
+       close_file_or_dir(fd, dirstream);
+       return !!ret;
+}
+
 static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
 					char *search)
 {
@@ -918,8 +969,8 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
-		{ "disk-usage", cmd_filesystem_disk_usage,
-			cmd_filesystem_disk_usage_usage, NULL, 0 },
+		{ "usage", cmd_filesystem_usage,
+			cmd_filesystem_usage_usage, NULL, 0 },
 
 		NULL_CMD_STRUCT
 	}
-- 
1.9.0

