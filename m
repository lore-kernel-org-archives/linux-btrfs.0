Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbcBBDBd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:01:33 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 0C5D54010D1B
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 11:01:25 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 4/8] btrfs-progs: dedup: Add status subcommand
Date: Tue,  2 Feb 2016 10:59:09 +0800
Message-Id: <1454381953-29676-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add status subcommand for dedup command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc |  3 ++
 cmds-dedup.c                       | 76 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 99141cd..fd0550f 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -59,6 +59,9 @@ Specify maximum memory used for hashes.
 Only works for 'inmemory' backend.
 No default value.
 
+*status* <path>::
+Show current in-band de-duplication status of a filesystem.
+
 BACKENDS
 --------
 Btrfs in-band de-duplication support two different backends with their own
diff --git a/cmds-dedup.c b/cmds-dedup.c
index c85bb5b..64f898b 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -213,11 +213,87 @@ out:
 	return 0;
 }
 
+static const char * const cmd_dedup_status_usage[] = {
+	"btrfs dedup status <path>",
+	"Show current in-band(write time) de-duplication status of a btrfs.",
+	NULL
+};
+
+static int cmd_dedup_status(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+	DIR *dirstream;
+	char *path;
+	int fd;
+	int ret;
+	int print_limit = 1;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_status_usage);
+
+	path = argv[1];
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		ret = 1;
+		goto out;
+	}
+	memset(&dargs, 0, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUP_CTL_STATUS;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, &dargs);
+	if (ret < 0) {
+		error("failed to get inband deduplication status: %s",
+		      strerror(errno));
+		ret = 1;
+		goto out;
+	}
+	ret = 0;
+	if (dargs.status == 0) {
+		printf("Status: \t\t\tDisabled\n");
+		goto out;
+	}
+	printf("Status:\t\t\tEnabled\n");
+
+	if (dargs.hash_type == BTRFS_DEDUP_HASH_SHA256)
+		printf("Hash algorithm:\t\tSHA-256\n");
+	else
+		printf("Hash algorithm:\t\tUnrecognized(%x)\n",
+			dargs.hash_type);
+
+	if (dargs.backend == BTRFS_DEDUP_BACKEND_INMEMORY) {
+		printf("Backend:\t\tIn-memory\n");
+		print_limit = 1;
+	} else if (dargs.backend == BTRFS_DEDUP_BACKEND_ONDISK) {
+		printf("Backend:\t\tOn-disk\n");
+		print_limit = 0;
+	} else  {
+		printf("Backend:\t\tUnrecognized(%x)\n",
+			dargs.backend);
+	}
+
+	printf("Dedup Blocksize:\t%llu\n", dargs.blocksize);
+
+	if (print_limit) {
+		printf("Number of hash: \t[%llu/%llu]\n", dargs.current_nr,
+			dargs.limit_nr);
+		printf("Memory usage: \t\t[%s/%s]\n",
+			pretty_size(dargs.current_nr *
+				(dargs.limit_mem / dargs.limit_nr)),
+			pretty_size(dargs.limit_mem));
+	}
+out:
+	close_file_or_dir(fd, dirstream);
+	return ret;
+}
+
 const struct cmd_group dedup_cmd_group = {
 	dedup_cmd_group_usage, dedup_cmd_group_info, {
 		{ "enable", cmd_dedup_enable, cmd_dedup_enable_usage, NULL, 0},
 		{ "disable", cmd_dedup_disable, cmd_dedup_disable_usage,
 		  NULL, 0},
+		{ "status", cmd_dedup_status, cmd_dedup_status_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.0



