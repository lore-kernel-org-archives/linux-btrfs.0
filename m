Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbcAGBWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:22:41 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 44E964092575
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:22:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 4/7] btrfs-progs: dedup: Add status subcommand
Date: Thu, 7 Jan 2016 09:22:11 +0800
Message-ID: <1452129734-7261-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452129734-7261-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452129734-7261-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add status subcommand for dedup command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc |  3 ++
 cmds-dedup.c                       | 72 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 08d1050..8b605fb 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -54,6 +54,9 @@ If *LIMIT* is zero, there will be no limit at all. Use with caution as it can
 use up all the memory for dedup hash.
 Default value is 4096 if using 'inmemory' backend.
 
+*status* <path>::
+Show current in-band de-duplication status of a filesystem.
+
 BACKENDS
 --------
 Btrfs in-band de-duplication support two different backends with their own
diff --git a/cmds-dedup.c b/cmds-dedup.c
index f15c2c2..5792420 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -195,11 +195,83 @@ out:
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
+		printf("Status: Disabled\n");
+		goto out;
+	}
+	printf("Status: Enabled\n");
+
+	if (dargs.hash_type == BTRFS_DEDUP_HASH_SHA256)
+		printf("Hash algorithm: SHA-256\n");
+	else
+		printf("Hash algorithm: Unrecognized(%x)\n",
+			dargs.hash_type);
+
+	if (dargs.backend == BTRFS_DEDUP_BACKEND_INMEMORY) {
+		printf("Backend: In-memory\n");
+		print_limit = 1;
+	} else if (dargs.backend == BTRFS_DEDUP_BACKEND_ONDISK) {
+		printf("Backend: On-disk\n");
+		print_limit = 0;
+	} else  {
+		printf("Backend: Unrecognized(%x)\n",
+			dargs.backend);
+	}
+
+	printf("Dedup Blocksize: %llu\n", dargs.blocksize);
+
+	if (print_limit) {
+		printf("Current number of hash: %llu\n", dargs.current_nr);
+		printf("Max number of hash: %llu\n", dargs.limit_nr);
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
2.6.4



