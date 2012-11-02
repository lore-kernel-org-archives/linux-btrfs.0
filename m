Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38078 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934501Ab2KBKPG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:06 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719924eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:06 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/8] Add btrfs device disk-usage command
Date: Fri,  2 Nov 2012 11:15:38 +0100
Message-Id: <1351851339-19150-8-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-device.c        |    3 ++
 cmds-fi-disk_usage.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |    4 ++
 3 files changed, 147 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index 4787aca..873c39c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -27,6 +27,7 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
+#include "cmds-fi-disk_usage.h"
 
 #include "commands.h"
 
@@ -255,6 +256,8 @@ const struct cmd_group device_cmd_group = {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
 		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
+		{ "disk-usage", cmd_device_disk_usage,
+			cmd_device_disk_usage_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 4bec167..0c8af9d 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -989,4 +989,144 @@ int cmd_filesystem_disk_usage(int argc, char **argv)
 	return 0;
 }
 
+static void print_disk_chunks(int fd,
+				u64 devid,
+				u64 total_size,
+				struct chunk_info *chunks_info_ptr,
+				int chunks_info_count,
+				int mode)
+{
+	int i;
+	u64 allocated = 0;
+	char *s;
+
+	for (i = 0 ; i < chunks_info_count ; i++) {
+		char *description = "";
+		char *r_mode;
+		u64 flags;
+
+		if (chunks_info_ptr[i].devid != devid)
+			continue;
+
+		flags = chunks_info_ptr[i].type;
+
+		btrfs_flags2description(flags, &description);
+		btrfs_flags2profile(flags, &r_mode);
+
+		s = df_pretty_sizes(chunks_info_ptr[i].size, mode);
+		printf("   %s,%s:%*s%10s\n",
+			description,
+			r_mode,
+			(int)(20 - strlen(description) - strlen(r_mode)), "",
+			s);
+
+		allocated += chunks_info_ptr[i].size;
+
+	}
+	s = df_pretty_sizes(total_size - allocated, mode);
+	printf("   Unallocated: %*s%10s\n",
+		(int)(20 - strlen("Unallocated")), "",
+		s);
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
+		char *s;
+
+		s = df_pretty_sizes(disks_info_ptr[i].size, mode);
+		printf("%s\t%10s\n", disks_info_ptr[i].path, s);
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
+	free_strings_to_free();
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
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i]);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_device_disk_usage(fd, argv[i], flags);
+		close(fd);
+
+		if (r)
+			return r;
+		more_than_one = 1;
+
+	}
+
+	return 0;
+}
+
 
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index ae11570..c315004 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -21,7 +21,11 @@
 
 extern const char * const cmd_filesystem_df_usage[];
 int cmd_filesystem_df(int argc, char **argv);
+
 extern const char * const cmd_filesystem_disk_usage_usage[];
 int cmd_filesystem_disk_usage(int argc, char **argv);
 
+extern const char * const cmd_device_disk_usage_usage[];
+int cmd_device_disk_usage(int argc, char **argv);
+
 #endif
-- 
1.7.10.4

