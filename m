Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbcBBDBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:01:31 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 9B1F94010D1A
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 11:01:25 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/8] btrfs-progs: dedup: Add disable support for inband deduplication
Date: Tue,  2 Feb 2016 10:59:08 +0800
Message-Id: <1454381953-29676-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add disable subcommand for dedup command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc |  5 +++++
 cmds-dedup.c                       | 42 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 1956436..99141cd 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -21,6 +21,11 @@ use with caution.
 
 SUBCOMMAND
 ----------
+*disable* <path>::
+Disable in-band de-duplication for a filesystem.
++
+This will trash all stored dedup hash.
++
 *enable* [options] <path>::
 Enable in-band de-duplication for a filesystem.
 +
diff --git a/cmds-dedup.c b/cmds-dedup.c
index 1da416f..c85bb5b 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -173,9 +173,51 @@ out:
 	return ret;
 }
 
+static const char * const cmd_dedup_disable_usage[] = {
+	"btrfs dedup disable <path>",
+	"Disable in-band(write time) de-duplication of a btrfs.",
+	NULL
+};
+
+static int cmd_dedup_disable(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+	DIR *dirstream;
+	char *path;
+	int fd;
+	int ret;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_disable_usage);
+
+	path = argv[1];
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		return 1;
+	}
+	memset(&dargs, 0, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUP_CTL_DISABLE;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, &dargs);
+	if (ret < 0) {
+		error("failed to disable inband deduplication: %s",
+		      strerror(errno));
+		ret = 1;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	close_file_or_dir(fd, dirstream);
+	return 0;
+}
+
 const struct cmd_group dedup_cmd_group = {
 	dedup_cmd_group_usage, dedup_cmd_group_info, {
 		{ "enable", cmd_dedup_enable, cmd_dedup_enable_usage, NULL, 0},
+		{ "disable", cmd_dedup_disable, cmd_dedup_disable_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.0



