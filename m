Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO2D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:28:03 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 70361AD69
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:28:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] btrfs-progs: unify unit mode parameters and variables
Date: Thu, 18 Dec 2014 15:28:00 +0100
Message-Id: <182f41909fe2121d8e605441713d8d7fc8ded70a.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use unsigned type and a common name everywhere.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        |  6 ++---
 cmds-fi-disk_usage.c | 69 ++++++++++++++++++++++++++--------------------------
 cmds-fi-disk_usage.h |  4 +--
 3 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 13458d850c26..9dd52a4b9fac 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -465,7 +465,7 @@ const char * const cmd_device_usage_usage[] = {
 	NULL
 };
 
-static int _cmd_device_usage(int fd, char *path, int mode)
+static int _cmd_device_usage(int fd, char *path, unsigned unit_mode)
 {
 	int i;
 	int ret = 0;
@@ -481,9 +481,9 @@ static int _cmd_device_usage(int fd, char *path, int mode)
 
 	for (i = 0; i < devcount; i++) {
 		printf("%s, ID: %llu\n", devinfo[i].path, devinfo[i].devid);
-		print_device_sizes(fd, &devinfo[i], mode);
+		print_device_sizes(fd, &devinfo[i], unit_mode);
 		print_device_chunks(fd, &devinfo[i], chunkinfo, chunkcount,
-				mode);
+				unit_mode);
 		printf("\n");
 	}
 
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index b3b70cc23fd1..d81f01155e6c 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -310,7 +310,7 @@ static void get_raid56_used(int fd, struct chunk_info *chunks, int chunkcount,
 #define	MIN_UNALOCATED_THRESH	(16 * 1024 * 1024)
 static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
-		char *path, int mode)
+		char *path, unsigned unit_mode)
 {
 	struct btrfs_ioctl_space_args *sargs = 0;
 	int i;
@@ -450,30 +450,30 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		free_min += r_total_unused / max_data_ratio;
 	}
 
-	if (mode != UNITS_HUMAN)
+	if (unit_mode != UNITS_HUMAN)
 		width = 18;
 
 	printf("Overall:\n");
 
 	printf("    Device size:\t\t%*s\n", width,
-		pretty_size_mode(r_total_size, mode));
+		pretty_size_mode(r_total_size, unit_mode));
 	printf("    Device allocated:\t\t%*s\n", width,
-		pretty_size_mode(r_total_chunks, mode));
+		pretty_size_mode(r_total_chunks, unit_mode));
 	printf("    Device unallocated:\t\t%*s\n", width,
-		pretty_size_mode(r_total_unused, mode));
+		pretty_size_mode(r_total_unused, unit_mode));
 	printf("    Used:\t\t\t%*s\n", width,
-		pretty_size_mode(r_total_used, mode));
+		pretty_size_mode(r_total_used, unit_mode));
 	printf("    Free (estimated):\t\t%*s\t(",
 		width,
-		pretty_size_mode(free_estimated, mode));
-	printf("min: %s)\n", pretty_size_mode(free_min, mode));
+		pretty_size_mode(free_estimated, unit_mode));
+	printf("min: %s)\n", pretty_size_mode(free_min, unit_mode));
 	printf("    Data ratio:\t\t\t%*.2f\n",
 		width, data_ratio);
 	printf("    Metadata ratio:\t\t%*.2f\n",
 		width, metadata_ratio);
 	printf("    Global reserve:\t\t%*s\t(used: %s)\n", width,
-		pretty_size_mode(l_global_reserve, mode),
-		pretty_size_mode(l_global_reserve_used, mode));
+		pretty_size_mode(l_global_reserve, unit_mode),
+		pretty_size_mode(l_global_reserve_used, unit_mode));
 
 exit:
 
@@ -601,7 +601,7 @@ static u64 calc_chunk_size(struct chunk_info *ci)
  *  This function print the results of the command "btrfs fi usage"
  *  in tabular format
  */
-static void _cmd_filesystem_usage_tabular(int mode,
+static void _cmd_filesystem_usage_tabular(unsigned unit_mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *chunks_info_ptr,
 					int chunks_info_count,
@@ -678,7 +678,7 @@ static void _cmd_filesystem_usage_tabular(int mode,
 
 			if (size)
 				table_printf(matrix, col, i+3,
-					">%s", pretty_size_mode(size, mode));
+					">%s", pretty_size_mode(size, unit_mode));
 			else
 				table_printf(matrix, col, i+3, ">-");
 
@@ -690,7 +690,7 @@ static void _cmd_filesystem_usage_tabular(int mode,
 				- total_allocated;
 
 		table_printf(matrix, sargs->total_spaces + 1, i + 3,
-			       ">%s", pretty_size_mode(unused, mode));
+			       ">%s", pretty_size_mode(unused, unit_mode));
 		total_unused += unused;
 
 	}
@@ -702,15 +702,15 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	table_printf(matrix, 0, device_info_count + 4, "<Total");
 	for (i = 0; i < sargs->total_spaces; i++)
 		table_printf(matrix, 1 + i, device_info_count + 4, ">%s",
-			pretty_size_mode(sargs->spaces[i].total_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].total_bytes, unit_mode));
 
 	table_printf(matrix, sargs->total_spaces + 1, device_info_count + 4,
-			">%s", pretty_size_mode(total_unused, mode));
+			">%s", pretty_size_mode(total_unused, unit_mode));
 
 	table_printf(matrix, 0, device_info_count + 5, "<Used");
 	for (i = 0; i < sargs->total_spaces; i++)
 		table_printf(matrix, 1 + i, device_info_count+5, ">%s",
-			pretty_size_mode(sargs->spaces[i].used_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].used_bytes, unit_mode));
 
 	table_dump(matrix);
 	table_free(matrix);
@@ -723,7 +723,7 @@ static void print_unused(struct chunk_info *info_ptr,
 			  int info_count,
 			  struct device_info *device_info_ptr,
 			  int device_info_count,
-			  int mode)
+			  unsigned unit_mode)
 {
 	int i;
 	for (i = 0; i < device_info_count; i++) {
@@ -736,7 +736,8 @@ static void print_unused(struct chunk_info *info_ptr,
 
 		printf("   %s\t%10s\n",
 			device_info_ptr[i].path,
-			pretty_size_mode(device_info_ptr[i].size - total, mode));
+			pretty_size_mode(device_info_ptr[i].size - total,
+				unit_mode));
 	}
 }
 
@@ -748,7 +749,7 @@ static void print_chunk_device(u64 chunk_type,
 				int chunks_info_count,
 				struct device_info *device_info_ptr,
 				int device_info_count,
-				int mode)
+				unsigned unit_mode)
 {
 	int i;
 
@@ -770,7 +771,7 @@ static void print_chunk_device(u64 chunk_type,
 		if (total > 0)
 			printf("   %s\t%10s\n",
 				device_info_ptr[i].path,
-				pretty_size_mode(total, mode));
+				pretty_size_mode(total, unit_mode));
 	}
 }
 
@@ -778,7 +779,7 @@ static void print_chunk_device(u64 chunk_type,
  *  This function print the results of the command "btrfs fi usage"
  *  in linear format
  */
-static void _cmd_filesystem_usage_linear(int mode,
+static void _cmd_filesystem_usage_linear(unsigned unit_mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *info_ptr,
 					int info_count,
@@ -802,23 +803,23 @@ static void _cmd_filesystem_usage_linear(int mode,
 			description,
 			r_mode,
 			pretty_size_mode(sargs->spaces[i].total_bytes,
-			    mode));
+				unit_mode));
 		printf("Used:%s\n",
-			pretty_size_mode(sargs->spaces[i].used_bytes, mode));
+			pretty_size_mode(sargs->spaces[i].used_bytes, unit_mode));
 		print_chunk_device(flags, info_ptr, info_count,
-				device_info_ptr, device_info_count, mode);
+				device_info_ptr, device_info_count, unit_mode);
 		printf("\n");
 	}
 
 	printf("Unallocated:\n");
 	print_unused(info_ptr, info_count, device_info_ptr, device_info_count,
-			mode);
+			unit_mode);
 }
 
 static int print_filesystem_usage_by_chunk(int fd,
 		struct chunk_info *chunkinfo, int chunkcount,
 		struct device_info *devinfo, int devcount,
-		char *path, int mode, int tabular)
+		char *path, unsigned unit_mode, int tabular)
 {
 	struct btrfs_ioctl_space_args *sargs;
 	int ret = 0;
@@ -833,10 +834,10 @@ static int print_filesystem_usage_by_chunk(int fd,
 	}
 
 	if (tabular)
-		_cmd_filesystem_usage_tabular(mode, sargs, chunkinfo,
+		_cmd_filesystem_usage_tabular(unit_mode, sargs, chunkinfo,
 				chunkcount, devinfo, devcount);
 	else
-		_cmd_filesystem_usage_linear(mode, sargs, chunkinfo,
+		_cmd_filesystem_usage_linear(unit_mode, sargs, chunkinfo,
 				chunkcount, devinfo, devcount);
 
 	free(sargs);
@@ -969,7 +970,7 @@ out:
 
 void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
-		int chunks_info_count, int mode)
+		int chunks_info_count, unsigned unit_mode)
 {
 	int i;
 	u64 allocated = 0;
@@ -992,21 +993,21 @@ void print_device_chunks(int fd, struct device_info *devinfo,
 			description,
 			r_mode,
 			(int)(20 - strlen(description) - strlen(r_mode)), "",
-			pretty_size_mode(size, mode));
+			pretty_size_mode(size, unit_mode));
 
 		allocated += size;
 
 	}
 	printf("   Unallocated: %*s%10s\n",
 		(int)(20 - strlen("Unallocated")), "",
-		pretty_size_mode(devinfo->size - allocated, mode));
+		pretty_size_mode(devinfo->size - allocated, unit_mode));
 }
 
-void print_device_sizes(int fd, struct device_info *devinfo, int mode)
+void print_device_sizes(int fd, struct device_info *devinfo, unsigned unit_mode)
 {
 	printf("   Device size: %*s%10s\n",
 		(int)(20 - strlen("Device size")), "",
-		pretty_size_mode(devinfo->device_size, mode));
+		pretty_size_mode(devinfo->device_size, unit_mode));
 #if 0
 	/*
 	 * The term has not seen an agreement and we don't want to change it
@@ -1014,6 +1015,6 @@ void print_device_sizes(int fd, struct device_info *devinfo, int mode)
 	 */
 	printf("   FS occupied: %*s%10s\n",
 		(int)(20 - strlen("FS occupied")), "",
-		pretty_size_mode(devinfo->size, mode));
+		pretty_size_mode(devinfo->size, unit_mode));
 #endif
 }
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index 8a0c60f011e4..a76e77bf8c31 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -48,7 +48,7 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 		int *chunkcount, struct device_info **devinfo, int *devcount);
 void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
-		int chunks_info_count, int mode);
-void print_device_sizes(int fd, struct device_info *devinfo, int mode);
+		int chunks_info_count, unsigned unit_mode);
+void print_device_sizes(int fd, struct device_info *devinfo, unsigned unit_mode);
 
 #endif
-- 
2.1.3

