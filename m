Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59689 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751581AbdLLGeR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 01:34:17 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.1 3/5] btrfs-progs: dedupe: Add disable support for inband dedupelication
Date: Tue, 12 Dec 2017 14:32:55 +0800
Message-ID: <20171212063257.31451-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171212063257.31451-1-lufq.fnst@cn.fujitsu.com>
References: <20171212063257.31451-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Add disable subcommand for dedupe command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc |  5 ++++
 btrfs-completion                           |  2 +-
 cmds-dedupe-ib.c                           | 42 ++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index 82f970a6..de32eb97 100644
--- a/Documentation/btrfs-dedupe-inband.asciidoc
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -22,6 +22,11 @@ use with caution.
 
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
index 69e02ad1..2f113e01 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -41,7 +41,7 @@ _btrfs()
 	commands_quota='enable disable rescan'
 	commands_qgroup='assign remove create destroy show limit'
 	commands_replace='start status cancel'
-	commands_dedupe='enable'
+	commands_dedupe='enable disable'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
 		COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index 937585f0..a96e8599 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -260,10 +260,52 @@ out:
 	return ret;
 }
 
+static const char * const cmd_dedupe_ib_disable_usage[] = {
+	"btrfs dedupe disable <path>",
+	"Disable in-band(write time) de-duplication of a btrfs.",
+	NULL
+};
+
+static int cmd_dedupe_ib_disable(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedupe_args dargs;
+	DIR *dirstream;
+	char *path;
+	int fd;
+	int ret;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedupe_ib_disable_usage);
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
 const struct cmd_group dedupe_ib_cmd_group = {
 	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
 		{ "enable", cmd_dedupe_ib_enable, cmd_dedupe_ib_enable_usage,
 		  NULL, 0},
+		{ "disable", cmd_dedupe_ib_disable, cmd_dedupe_ib_disable_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.15.1



