Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4407 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbbLNFYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 00:24:10 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 9E4B141887F2
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:22:06 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Format change for btrfs fi df
Date: Mon, 14 Dec 2015 13:19:56 +0800
Message-ID: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The GlobalReserve space in 'btrfs fi df' is always confusing for a lot
of users.
As it is not a special chunk type like DATA or METADATA, it's in fact a
sub-type of METADATA.

So change the output to skip GlobalReserve by default, and adding its
total to metadata used.
And add a new option '-r|--reserve' to show the GlobalReserve, but skip
the profile of GlobalReserve.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-filesystem.asciidoc |  8 ++++++
 cmds-filesystem.c                       | 51 ++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 31cd51b..510c23f 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -22,6 +22,14 @@ Show space usage information for a mount point.
 +
 `Options`
 +
+-r|--reserve::::
+also show Global Reserve space info.
++
+Global Reserve space is reserved space from metadata. It's reserved for Btrfs
+metadata COW.
++
+It will be counted as 'used' space in metadata space info.
++
 -b|--raw::::
 raw numbers in bytes, without the 'B' suffix
 -h|--human-readable::::
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 25317fa..26e62e0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -123,6 +123,8 @@ static const char * const filesystem_cmd_group_usage[] = {
 static const char * const cmd_filesystem_df_usage[] = {
 	"btrfs filesystem df [options] <path>",
 	"Show space usage information for a mount point",
+	"",
+	"-r|--reserve   show global reserve space info"
 	HELPINFO_UNITS_SHORT_LONG,
 	NULL
 };
@@ -175,12 +177,32 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	return 0;
 }
 
-static void print_df(struct btrfs_ioctl_space_args *sargs, unsigned unit_mode)
+static void print_df(struct btrfs_ioctl_space_args *sargs, unsigned unit_mode,
+		     int show_reserve)
 {
 	u64 i;
+	u64 global_reserve = 0;
 	struct btrfs_ioctl_space_info *sp = sargs->spaces;
 
+	/* First iterate to get global reserve space size */
 	for (i = 0; i < sargs->total_spaces; i++, sp++) {
+		if (sp->flags & BTRFS_SPACE_INFO_GLOBAL_RSV)
+			global_reserve = sp->total_bytes;
+	}
+
+	for (i = 0, sp = sargs->spaces; i < sargs->total_spaces; i++, sp++) {
+		if (sp->flags & BTRFS_SPACE_INFO_GLOBAL_RSV) {
+			if (!show_reserve)
+				continue;
+			printf(" \\- %s: reserved=%s, used=%s\n",
+				btrfs_group_type_str(sp->flags),
+				pretty_size_mode(sp->total_bytes, unit_mode),
+				pretty_size_mode(sp->used_bytes, unit_mode));
+			continue;
+		}
+
+		if (sp->flags & BTRFS_BLOCK_GROUP_METADATA)
+			sp->used_bytes += global_reserve;
 		printf("%s, %s: total=%s, used=%s\n",
 			btrfs_group_type_str(sp->flags),
 			btrfs_group_profile_str(sp->flags),
@@ -196,14 +218,35 @@ static int cmd_filesystem_df(int argc, char **argv)
 	int fd;
 	char *path;
 	DIR *dirstream = NULL;
+	int show_reserve = 0;
 	unsigned unit_mode;
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
-	if (argc != 2 || argv[1][0] == '-')
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "reserve", no_argument, NULL, 'r'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "r", long_options, NULL);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'r':
+			show_reserve = 1;
+			break;
+		default:
+			usage(cmd_filesystem_df_usage);
+		}
+	}
+
+	argc = argc - optind;
+	if (check_argc_exact(argc, 1))
 		usage(cmd_filesystem_df_usage);
 
-	path = argv[1];
+	path = argv[optind];
 
 	fd = btrfs_open_dir(path, &dirstream, 1);
 	if (fd < 0)
@@ -212,7 +255,7 @@ static int cmd_filesystem_df(int argc, char **argv)
 	ret = get_df(fd, &sargs);
 
 	if (ret == 0) {
-		print_df(sargs, unit_mode);
+		print_df(sargs, unit_mode, show_reserve);
 		free(sargs);
 	} else {
 		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
-- 
2.6.3



