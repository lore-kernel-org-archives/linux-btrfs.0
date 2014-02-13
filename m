Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:48598 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaBMTUI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:20:08 -0500
Received: from venice.bhome (151.28.65.181) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA6A19031033F9 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:20:07 +0100
Message-ID: <52FD1AEC.1020700@libero.it>
Date: Thu, 13 Feb 2014 20:20:12 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] Add btrfs device disk-usage command
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-device.c        |   3 ++
 cmds-fi-disk_usage.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |   3 ++
 3 files changed, 142 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index bc4a8dc..f25dbfa 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -28,6 +28,7 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
+#include "cmds-fi-disk_usage.h"
 
 #include "commands.h"
 
@@ -401,6 +402,8 @@ const struct cmd_group device_cmd_group = {
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
 		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
+		{ "disk-usage", cmd_device_disk_usage,
+			cmd_device_disk_usage_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 16b3ab2..e4eb72b 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -942,3 +942,139 @@ int cmd_filesystem_disk_usage(int argc, char **argv)
 
 	return 0;
 }
+
+static void print_disk_chunks(int fd,
+				u64 devid,
+				u64 total_size,
+				struct chunk_info *chunks_info_ptr,
+				int chunks_info_count,
+				int mode)
+{
+	int i;
+	u64 allocated = 0;
+
+	for (i = 0 ; i < chunks_info_count ; i++) {
+		const char *description;
+		const char *r_mode;
+		u64 flags;
+		u64 size;
+
+		if (chunks_info_ptr[i].devid != devid)
+			continue;
+
+		flags = chunks_info_ptr[i].type;
+
+		description = group_type_str(flags);
+		r_mode = group_profile_str(flags);
+		size = calc_chunk_size(chunks_info_ptr+i);
+		printf("   %s,%s:%*s%10s\n",
+			description,
+			r_mode,
+			(int)(20 - strlen(description) - strlen(r_mode)), "",
+			df_pretty_sizes(size, mode));
+
+		allocated += size;
+
+	}
+	printf("   Unallocated: %*s%10s\n",
+		(int)(20 - strlen("Unallocated")), "",
+		df_pretty_sizes(total_size - allocated, mode));
+
+}
+
+static int _cmd_device_disk_usage(int fd, char *path, int mode)
+{
+	int i;
+	int ret = 0;
+	int info_count = 0;
+	struct chunk_info *info_ptr = 0;
+	struct disk_info *disks_info_ptr = 0;
+	int disks_info_count = 0;
+
+	if (load_chunk_info(fd, &info_ptr, &info_count) ||
+	    load_disks_info(fd, &disks_info_ptr, &disks_info_count)) {
+		ret = -1;
+		goto exit;
+	}
+
+	for (i = 0 ; i < disks_info_count ; i++) {
+		printf("%s\t%10s\n", disks_info_ptr[i].path,
+			df_pretty_sizes(disks_info_ptr[i].size, mode));
+
+		print_disk_chunks(fd, disks_info_ptr[i].devid,
+				disks_info_ptr[i].size,
+				info_ptr, info_count,
+				mode);
+		printf("\n");
+
+	}
+
+
+exit:
+
+	if (disks_info_ptr)
+		free(disks_info_ptr);
+	if (info_ptr)
+		free(info_ptr);
+
+	return ret;
+}
+
+const char * const cmd_device_disk_usage_usage[] = {
+	"btrfs device disk-usage [-b] <path> [<path>..]",
+	"Show which chunks are in a device.",
+	"",
+	"-b\tSet byte as unit",
+	NULL
+};
+
+int cmd_device_disk_usage(int argc, char **argv)
+{
+
+	int	flags = DF_HUMAN_UNIT;
+	int	i, more_than_one = 0;
+
+	optind = 1;
+	while (1) {
+		char	c = getopt(argc, argv, "b");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'b':
+			flags &= ~DF_HUMAN_UNIT;
+			break;
+		default:
+			usage(cmd_device_disk_usage_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1)) {
+		usage(cmd_device_disk_usage_usage);
+		return 21;
+	}
+
+	for (i = optind; i < argc ; i++) {
+		int r, fd;
+		DIR	*dirstream = NULL;
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i], &dirstream);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_device_disk_usage(fd, argv[i], flags);
+		close_file_or_dir(fd, dirstream);
+
+		if (r)
+			return r;
+		more_than_one = 1;
+
+	}
+
+	return 0;
+}
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index c7459b1..c315004 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -25,4 +25,7 @@ int cmd_filesystem_df(int argc, char **argv);
 extern const char * const cmd_filesystem_disk_usage_usage[];
 int cmd_filesystem_disk_usage(int argc, char **argv);
 
+extern const char * const cmd_device_disk_usage_usage[];
+int cmd_device_disk_usage(int argc, char **argv);
+
 #endif
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
