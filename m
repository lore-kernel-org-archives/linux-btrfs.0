Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaD2QCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D6EEFAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 12/14] btrfs-progs: replace df_pretty_sizes with pretty_size_mode
Date: Tue, 29 Apr 2014 18:02:49 +0200
Message-Id: <601271cd6ae32df6cc67a345eff92e608956e7b0.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        |  8 +++----
 cmds-fi-disk_usage.c | 63 ++++++++++++++++++++++------------------------------
 cmds-fi-disk_usage.h |  3 ---
 3 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 29eeaf6bbd0f..b2773f249cba 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -465,19 +465,19 @@ exit:
 int cmd_device_usage(int argc, char **argv)
 {
 
-	int	flags = DF_HUMAN_UNIT;
+	int mode = UNITS_HUMAN;
 	int	i, more_than_one = 0;
 
 	optind = 1;
 	while (1) {
-		char	c = getopt(argc, argv, "b");
+		int c = getopt(argc, argv, "b");
 
 		if (c < 0)
 			break;
 
 		switch (c) {
 		case 'b':
-			flags &= ~DF_HUMAN_UNIT;
+			mode = UNITS_RAW;
 			break;
 		default:
 			usage(cmd_device_usage_usage);
@@ -500,7 +500,7 @@ int cmd_device_usage(int argc, char **argv)
 			return 12;
 		}
 
-		r = _cmd_device_usage(fd, argv[i], flags);
+		r = _cmd_device_usage(fd, argv[i], mode);
 		close_file_or_dir(fd, dirstream);
 
 		if (r)
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index c823223ee8a8..632ded0d21ab 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -32,17 +32,6 @@
 #include "version.h"
 
 /*
- * Pretty print the size
- */
-char *df_pretty_sizes(u64 size, int mode)
-{
-	if (mode & DF_HUMAN_UNIT)
-		return pretty_size_mode(size, UNITS_HUMAN);
-	else
-		return pretty_size_mode(size, UNITS_RAW);
-}
-
-/*
  * Add the chunk info to the chunk_info list
  */
 static int add_info_to_list(struct chunk_info **info_ptr,
@@ -389,7 +378,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 
 	K = ((double)total_used + (double)total_free) /	(double)total_chunks;
 
-	if (mode & DF_HUMAN_UNIT)
+	if (mode == UNITS_HUMAN)
 		width = 10;
 	else
 		width = 18;
@@ -397,22 +386,22 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	printf("Overall:\n");
 
 	printf("    Device size:\t\t%*s\n", width,
-		df_pretty_sizes(total_disk, mode));
+		pretty_size_mode(total_disk, mode));
 	printf("    Device allocated:\t\t%*s\n", width,
-		df_pretty_sizes(total_chunks, mode));
+		pretty_size_mode(total_chunks, mode));
 	printf("    Device unallocated:\t\t%*s\n", width,
-		df_pretty_sizes(total_disk-total_chunks, mode));
+		pretty_size_mode(total_disk - total_chunks, mode));
 	printf("    Used:\t\t\t%*s\n", width,
-		df_pretty_sizes(total_used, mode));
+		pretty_size_mode(total_used, mode));
 	printf("    Free (Estimated):\t\t%*s\t(",
 		width,
-		df_pretty_sizes((u64)(K*total_disk-total_used), mode));
+		pretty_size_mode((u64)(K * total_disk - total_used), mode));
 	printf("Max: %s, ",
-		df_pretty_sizes(total_disk-total_chunks+total_free, mode));
+		pretty_size_mode(total_disk - total_chunks + total_free, mode));
 	printf("min: %s)\n",
-		df_pretty_sizes((total_disk-total_chunks)/2+total_free, mode));
+		pretty_size_mode((total_disk-total_chunks) / 2 + total_free, mode));
 	printf("    Data to device ratio:\t%*.0f %%\n",
-		width-2, K*100);
+		width - 2, K * 100);
 
 exit:
 
@@ -612,7 +601,7 @@ static void _cmd_filesystem_usage_tabular(int mode,
 
 			if (size)
 				table_printf(matrix, col, i+3,
-					">%s", df_pretty_sizes(size, mode));
+					">%s", pretty_size_mode(size, mode));
 			else
 				table_printf(matrix, col, i+3, ">-");
 
@@ -624,7 +613,7 @@ static void _cmd_filesystem_usage_tabular(int mode,
 				- total_allocated;
 
 		table_printf(matrix, sargs->total_spaces + 1, i + 3,
-			       ">%s", df_pretty_sizes(unused, mode));
+			       ">%s", pretty_size_mode(unused, mode));
 		total_unused += unused;
 
 	}
@@ -636,15 +625,15 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	table_printf(matrix, 0, device_info_count + 4, "<Total");
 	for (i = 0; i < sargs->total_spaces; i++)
 		table_printf(matrix, 1 + i, device_info_count + 4, ">%s",
-			df_pretty_sizes(sargs->spaces[i].total_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].total_bytes, mode));
 
 	table_printf(matrix, sargs->total_spaces + 1, device_info_count + 4,
-			">%s", df_pretty_sizes(total_unused, mode));
+			">%s", pretty_size_mode(total_unused, mode));
 
 	table_printf(matrix, 0, device_info_count + 5, "<Used");
 	for (i = 0; i < sargs->total_spaces; i++)
 		table_printf(matrix, 1 + i, device_info_count+5, ">%s",
-			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].used_bytes, mode));
 
 	table_dump(matrix);
 	table_free(matrix);
@@ -670,7 +659,7 @@ static void print_unused(struct chunk_info *info_ptr,
 
 		printf("   %s\t%10s\n",
 			device_info_ptr[i].path,
-			df_pretty_sizes(device_info_ptr[i].size - total, mode));
+			pretty_size_mode(device_info_ptr[i].size - total, mode));
 	}
 }
 
@@ -704,7 +693,7 @@ static void print_chunk_device(u64 chunk_type,
 		if (total > 0)
 			printf("   %s\t%10s\n",
 				device_info_ptr[i].path,
-				df_pretty_sizes(total, mode));
+				pretty_size_mode(total, mode));
 	}
 }
 
@@ -732,10 +721,10 @@ static void _cmd_filesystem_usage_linear(int mode,
 		printf("%s,%s: Size:%s, ",
 			description,
 			r_mode,
-			df_pretty_sizes(sargs->spaces[i].total_bytes ,
+			pretty_size_mode(sargs->spaces[i].total_bytes,
 			    mode));
 		printf("Used:%s\n",
-			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].used_bytes, mode));
 		print_chunk_device(flags, info_ptr, info_count,
 				device_info_ptr, device_info_count, mode);
 		printf("\n");
@@ -787,7 +776,7 @@ const char * const cmd_filesystem_usage_usage[] = {
 
 int cmd_filesystem_usage(int argc, char **argv)
 {
-	int	flags =	DF_HUMAN_UNIT;
+	int mode = UNITS_HUMAN;
 	int	i, more_than_one = 0;
 	int	tabular = 0;
 
@@ -800,7 +789,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 
 		switch (c) {
 		case 'b':
-			flags &= ~DF_HUMAN_UNIT;
+			mode = UNITS_RAW;
 			break;
 		case 't':
 			tabular = 1;
@@ -837,12 +826,12 @@ int cmd_filesystem_usage(int argc, char **argv)
 			goto cleanup;
 
 		ret = print_filesystem_usage_overall(fd, chunkinfo, chunkcount,
-				devinfo, devcount, argv[i], flags);
+				devinfo, devcount, argv[i], mode);
 		if (ret)
 			goto cleanup;
 		printf("\n");
 		ret = print_filesystem_usage_by_chunk(fd, chunkinfo, chunkcount,
-				devinfo, devcount, argv[i], flags, tabular);
+				devinfo, devcount, argv[i], mode, tabular);
 cleanup:
 		close_file_or_dir(fd, dirstream);
 		free(chunkinfo);
@@ -881,22 +870,22 @@ void print_device_chunks(int fd, struct device_info *devinfo,
 			description,
 			r_mode,
 			(int)(20 - strlen(description) - strlen(r_mode)), "",
-			df_pretty_sizes(size, mode));
+			pretty_size_mode(size, mode));
 
 		allocated += size;
 
 	}
 	printf("   Unallocated: %*s%10s\n",
 		(int)(20 - strlen("Unallocated")), "",
-		df_pretty_sizes(devinfo->size - allocated, mode));
+		pretty_size_mode(devinfo->size - allocated, mode));
 }
 
 void print_device_sizes(int fd, struct device_info *devinfo, int mode)
 {
 	printf("   Device size: %*s%10s\n",
 		(int)(20 - strlen("Device size")), "",
-		df_pretty_sizes(devinfo->device_size, mode));
+		pretty_size_mode(devinfo->device_size, mode));
 	printf("   FS occuppied:%*s%10s\n",
 		(int)(20 - strlen("FS occupied")), "",
-		df_pretty_sizes(devinfo->size, mode));
+		pretty_size_mode(devinfo->size, mode));
 }
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index 0779defc71db..8a0c60f011e4 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -19,8 +19,6 @@
 #ifndef __CMDS_FI_DISK_USAGE__
 #define __CMDS_FI_DISK_USAGE__
 
-#define DF_HUMAN_UNIT		(1<<0)
-
 extern const char * const cmd_filesystem_usage_usage[];
 int cmd_filesystem_usage(int argc, char **argv);
 
@@ -48,7 +46,6 @@ struct chunk_info {
 
 int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 		int *chunkcount, struct device_info **devinfo, int *devcount);
-char *df_pretty_sizes(u64 size, int mode);
 void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
 		int chunks_info_count, int mode);
-- 
1.9.0

