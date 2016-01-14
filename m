Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751976AbcANGAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id D528A41896E6
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:52 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 3/8] btrfs-progs: dedup: Add disable support for inban deduplication
Date: Thu, 14 Jan 2016 13:57:45 +0800
Message-ID: <1452751070-2460-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add disable subcommand for dedup command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc |  5 +++++
 cmds-dedup.c                       | 42 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 652f22d..08d1050 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -19,6 +19,11 @@ use with caution.
 
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
index e116f4c..f15c2c2 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -155,9 +155,51 @@ out:
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



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
