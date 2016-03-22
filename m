Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbcCVHVv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 03:21:51 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 795D84056407
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 15:21:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 3/8] btrfs-progs: dedupe: Add disable support for inband dedupelication
Date: Tue, 22 Mar 2016 15:19:16 +0800
Message-Id: <1458631161-19036-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add disable subcommand for dedupe command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe.asciidoc |  5 +++++
 btrfs-completion                    |  2 +-
 cmds-dedupe.c                       | 42 +++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedupe.asciidoc b/Documentation/btrfs-dedupe.asciidoc
index 8ab40ab..28fe05f 100644
--- a/Documentation/btrfs-dedupe.asciidoc
+++ b/Documentation/btrfs-dedupe.asciidoc
@@ -21,6 +21,11 @@ use with caution.
 
 SUBCOMMAND
 ----------
+*disable* <path>::
+Disable in-band de-duplication for a filesystem.
++
+This will trash all stored dedupe hash.
++
 *enable* [options] <path>::
 Enable in-band de-duplication for a filesystem.
 +
diff --git a/btrfs-completion b/btrfs-completion
index 50f7ea2..9a6c73b 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -40,7 +40,7 @@ _btrfs()
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
-    commands_dedupe='enable'
+    commands_dedupe='enable disable'
     commands_replace='start status cancel'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
diff --git a/cmds-dedupe.c b/cmds-dedupe.c
index d9dcb10..64ac0f2 100644
--- a/cmds-dedupe.c
+++ b/cmds-dedupe.c
@@ -190,9 +190,51 @@ out:
 	return ret;
 }
 
+static const char * const cmd_dedupe_disable_usage[] = {
+	"btrfs dedupe disable <path>",
+	"Disable in-band(write time) de-duplication of a btrfs.",
+	NULL
+};
+
+static int cmd_dedupe_disable(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedupe_args dargs;
+	DIR *dirstream;
+	char *path;
+	int fd;
+	int ret;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedupe_disable_usage);
+
+	path = argv[1];
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		return 1;
+	}
+	memset(&dargs, 0, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUPE_CTL_DISABLE;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUPE_CTL, &dargs);
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
 const struct cmd_group dedupe_cmd_group = {
 	dedupe_cmd_group_usage, dedupe_cmd_group_info, {
 		{ "enable", cmd_dedupe_enable, cmd_dedupe_enable_usage, NULL, 0},
+		{ "disable", cmd_dedupe_disable, cmd_dedupe_disable_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.4



