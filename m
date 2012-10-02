Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2JBSgV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2012 14:36:21 -0400
Received: by bkcjk13 with SMTP id jk13so5686825bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 11:36:20 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/2] Add btrfs filesystem disk-usage command
Date: Tue,  2 Oct 2012 20:36:09 +0200
Message-Id: <1349202970-6700-2-git-send-email-kreijack@gmail.com>
In-Reply-To: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The  command  btrfs  filesystem  disk-usage is used to query the
status of the chunks, how many space on the disk(s) are used  by
the  chunks,  how many space are available in the chunks, and an
estimation of the free space of the filesystem.
---
 cmds-filesystem.c |  282 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 282 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1457de..72f9b36 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,7 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <sys/vfs.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -153,6 +154,286 @@ static int cmd_df(int argc, char **argv)
 	return 0;
 }
 
+static u64 disk_size( char *path){
+	struct statfs	sfs;
+
+	if( statfs(path, &sfs) < 0 )
+		return 0;
+	else
+		return sfs.f_bsize * sfs.f_blocks;
+
+}
+
+
+static void print_string(char *s, int w)
+{
+	int	i;
+
+	printf("%s", s);
+	for( i = strlen(s) ; i < w ; i++ ) 
+		putchar(' ');
+}
+
+#define DF_SHOW_SUMMARY 	(1<<1)
+#define DF_SHOW_DETAIL		(1<<2)
+#define DF_HUMAN_UNIT		(1<<3)
+
+static void pretty_sizes_r(u64 size, int w, int mode)
+{
+	if( mode & DF_HUMAN_UNIT ){
+		char *s = pretty_sizes(size);
+		printf("%*s", w, s);
+		free(s);
+	} else {
+		printf("%*llu", w, size/1024);
+
+	}
+}
+
+static int _cmd_disk_usage(char *path, int mode)
+{
+	struct btrfs_ioctl_space_args *sargs;
+	u64 count = 0, i;
+	int ret;
+	int fd;
+	int e, width;
+	u64  total_disk;		/* fielsystem size == sum of
+					   disk sizes */
+	u64  total_chunks;		/* sum of chunks sizes on disk(s) */
+	u64  total_used;		/* logical space used */
+	u64  total_free;		/* logical space un-used */
+	double K;
+	
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	if (!sargs)
+		return -ENOMEM;
+
+	sargs->space_slots = 0;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+	if (ret) {
+		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		free(sargs);
+		return ret;
+	}
+	if (!sargs->total_spaces)
+		return 0;
+
+	count = sargs->total_spaces;
+
+	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
+			(count * sizeof(struct btrfs_ioctl_space_info)));
+	if (!sargs)
+		return -ENOMEM;
+
+	sargs->space_slots = count;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+	if (ret) {
+		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		close(fd);
+		free(sargs);
+		return ret;
+	}
+
+	total_disk = disk_size(path);
+	e = errno;
+	if( total_disk == 0 ){
+		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		close(fd);
+		free(sargs);
+		return ret;
+	}
+		
+	total_chunks = total_used = total_free = 0;
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		int  ratio=1;
+		u64  allocated;
+
+		u64 flags = sargs->spaces[i].flags;
+
+		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+			ratio=1;
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+			ratio=2;
+		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+			ratio=2;
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+			ratio=2;
+		} else {
+			ratio=1;
+		}
+
+		allocated = sargs->spaces[i].total_bytes * ratio;
+
+		total_chunks += allocated;
+		total_used += sargs->spaces[i].used_bytes;
+		total_free += (sargs->spaces[i].total_bytes - 
+					sargs->spaces[i].used_bytes);
+
+	}
+	K = ((double)total_used + (double)total_free) /
+	                (double)total_chunks;
+
+	if( mode & DF_HUMAN_UNIT )
+		width = 12;
+	else
+		width = 18;
+
+	printf("Path: %s\n", path);
+	if( mode & DF_SHOW_SUMMARY ){
+		printf("Summary:\n");
+		printf("  Disk_size:\t\t");
+		pretty_sizes_r(total_disk, width, mode);
+		printf("\n  Disk_allocated:\t");
+		pretty_sizes_r(total_chunks, width, mode);
+		printf("\n  Disk_unallocated:\t"); 
+		pretty_sizes_r(total_disk-total_chunks, width, mode);
+		printf("\n  Logical_size:\t\t"); 
+		pretty_sizes_r(total_used+total_free, width, mode);
+		printf("\n  Used:\t\t\t"); 
+		pretty_sizes_r(total_used, width, mode);
+		printf("\n  Free_(Estimated):\t");
+		pretty_sizes_r((u64)(K*total_disk-total_used), width, mode);
+		printf("\t(Max: ");
+		pretty_sizes_r(total_disk-total_chunks+total_free, 
+				0, mode );
+		printf(", Min: ");
+		pretty_sizes_r((total_disk-total_chunks)/2+total_free, 
+				0, mode );
+		printf(")\n  Data_to_disk_ratio:\t%*.0f %%\n",
+			width-2, K*100);
+	}
+
+	if( ( mode & DF_SHOW_DETAIL ) && ( mode & DF_SHOW_SUMMARY ) )
+		printf("\n");
+
+	if( mode & DF_SHOW_DETAIL ){
+		/* Remember: the terminals have maximum 80 columns
+		   do not believe to who says otherwise */
+		printf("Details:\n");
+		printf("  %-12s%-8s%*s%*s%*s\n",
+			"Chunk-type", 
+			"Mode",
+			width, "Chunk-size", 
+			1+width, "Logical-size", 
+			width, "Used"
+		);
+
+		for (i = 0; i < sargs->total_spaces; i++) {
+			char *description="";
+			int  ratio=1;
+			char *r_mode;
+			u64 allocated;
+
+			u64 flags = sargs->spaces[i].flags;
+
+			if (flags & BTRFS_BLOCK_GROUP_DATA) {
+				if (flags & BTRFS_BLOCK_GROUP_METADATA){
+					description = "Data+M.data";
+				} else {
+					description = "Data";
+				}
+			} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+				description = "System";
+			} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+				description = "Metadata";
+			}
+
+			if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+				r_mode = "RAID0";
+				ratio=1;
+			} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+				r_mode = "RAID1";
+				ratio=2;
+			} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+				r_mode = "DUP";
+				ratio=2;
+			} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+				r_mode = "RAID10";
+				ratio=2;
+			} else {
+				r_mode = "Single";
+				ratio=1;
+			}
+
+			allocated = sargs->spaces[i].total_bytes * ratio;
+
+			printf("  ");
+			print_string(description,12);
+			print_string(r_mode, 8);
+			pretty_sizes_r(allocated, width, mode);
+			pretty_sizes_r(sargs->spaces[i].total_bytes ,
+				    width+1, mode);
+	
+			pretty_sizes_r(sargs->spaces[i].used_bytes, 
+						width, mode);
+			printf("\n");
+
+		}
+	}
+	free(sargs);
+
+	return 0;
+}
+
+static const char * const cmd_disk_usage_usage[] = {
+	"btrfs filesystem disk-usage [-d][-s][-k] <path> [<path>..]",
+	"Show space usage information for a mount point(s).",
+	"",
+	"-k\tSet KB (1024 bytes) as unit",
+	"-s\tDon't show the summary section",
+	"-d\tDon't show the detail section",
+	NULL
+};
+
+static int cmd_disk_usage(int argc, char **argv)
+{
+
+	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
+	int	i, more_than_one=0;
+
+	if (check_argc_min(argc, 2))
+		usage(cmd_df_usage);
+
+	for(i=1; i< argc ; i++){
+		if(!strcmp(argv[i],"-d"))
+			flags &= ~DF_SHOW_DETAIL;
+		else if(!strcmp(argv[i],"-s"))
+			flags &= ~DF_SHOW_SUMMARY;
+		else if(!strcmp(argv[i],"-k"))
+			flags &= ~DF_HUMAN_UNIT;
+		else{
+			int r;
+			if(more_than_one)
+				printf("\n");
+			r = _cmd_disk_usage(argv[i], flags);
+			if( r ) return r;
+			more_than_one=1;
+		}
+
+	}
+
+	return 0;
+}	
+	
+
+	
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
 	char uuidbuf[37];
@@ -530,6 +811,7 @@ static int cmd_label(int argc, char **argv)
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
+		{ "disk-usage", cmd_disk_usage, cmd_disk_usage_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
-- 
1.7.10.4

