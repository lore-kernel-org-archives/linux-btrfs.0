Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23831 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725977AbeIDLb1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:31:27 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.5 4/5] btrfs-progs: dedupe: Add status subcommand
Date: Tue, 4 Sep 2018 15:07:27 +0800
Message-ID: <20180904070728.5495-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904070728.5495-1-lufq.fnst@cn.fujitsu.com>
References: <20180904070728.5495-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Add status subcommand for dedupe command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc |  3 +
 btrfs-completion                           |  2 +-
 cmds-dedupe-ib.c                           | 80 ++++++++++++++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index 3452f690e3e5..6096389cb0b4 100644
--- a/Documentation/btrfs-dedupe-inband.asciidoc
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -86,6 +86,9 @@ And compression has higher priority than in-band de-duplication, means if
 compression and de-duplication is enabled at the same time, only compression
 will work.
 
+*status* <path>::
+Show current in-band de-duplication status of a filesystem.
+
 BACKENDS
 --------
 Btrfs in-band de-duplication will support different storage backends, with
diff --git a/btrfs-completion b/btrfs-completion
index a74a23f42022..62a7bdd4d0d5 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -41,7 +41,7 @@ _btrfs()
 	commands_quota='enable disable rescan'
 	commands_qgroup='assign remove create destroy show limit'
 	commands_replace='start status cancel'
-	commands_dedupe_inband='enable disable'
+	commands_dedupe_inband='enable disable status'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
 		COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index 91b6fe234043..e778457e25a8 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -298,12 +298,92 @@ out:
 	return 0;
 }
 
+static const char * const cmd_dedupe_ib_status_usage[] = {
+	"btrfs dedupe-inband status <path>",
+	"Show current in-band(write time) de-duplication status of a btrfs.",
+	NULL
+};
+
+static int cmd_dedupe_ib_status(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedupe_args dargs;
+	DIR *dirstream;
+	char *path;
+	int fd;
+	int ret;
+	int print_limit = 1;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedupe_ib_status_usage);
+
+	path = argv[1];
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		ret = 1;
+		goto out;
+	}
+	memset(&dargs, 0, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUPE_CTL_STATUS;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUPE_CTL, &dargs);
+	if (ret < 0) {
+		error("failed to get inband deduplication status: %m");
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
+	if (dargs.hash_algo == BTRFS_DEDUPE_HASH_SHA256)
+		printf("Hash algorithm:\t\tSHA-256\n");
+	else
+		printf("Hash algorithm:\t\tUnrecognized(%x)\n",
+			dargs.hash_algo);
+
+	if (dargs.backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		printf("Backend:\t\tIn-memory\n");
+		print_limit = 1;
+	} else  {
+		printf("Backend:\t\tUnrecognized(%x)\n",
+			dargs.backend);
+	}
+
+	printf("Dedup Blocksize:\t%llu\n", dargs.blocksize);
+
+	if (print_limit) {
+		u64 cur_mem;
+
+		/* Limit nr may be 0 */
+		if (dargs.limit_nr)
+			cur_mem = dargs.current_nr * (dargs.limit_mem /
+					dargs.limit_nr);
+		else
+			cur_mem = 0;
+
+		printf("Number of hash: \t[%llu/%llu]\n", dargs.current_nr,
+			dargs.limit_nr);
+		printf("Memory usage: \t\t[%s/%s]\n",
+			pretty_size(cur_mem),
+			pretty_size(dargs.limit_mem));
+	}
+out:
+	close_file_or_dir(fd, dirstream);
+	return ret;
+}
+
 const struct cmd_group dedupe_ib_cmd_group = {
 	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
 		{ "enable", cmd_dedupe_ib_enable, cmd_dedupe_ib_enable_usage,
 		  NULL, 0},
 		{ "disable", cmd_dedupe_ib_disable, cmd_dedupe_ib_disable_usage,
 		  NULL, 0},
+		{ "status", cmd_dedupe_ib_status, cmd_dedupe_ib_status_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.18.0
