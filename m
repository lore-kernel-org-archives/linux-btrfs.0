Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbcFQBDB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:03:01 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 1CA8A4056409
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 09:02:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 4/4] btrfs-progs: dedupe: Add status subcommand
Date: Fri, 17 Jun 2016 09:02:44 +0800
Message-Id: <20160617010244.6996-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160617010244.6996-1-quwenruo@cn.fujitsu.com>
References: <20160617010244.6996-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add status subcommand for dedupe command group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc |  3 ++
 btrfs-completion                           |  2 +-
 cmds-dedupe-ib.c                           | 81 ++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index b2b0e82..767e46c 100644
--- a/Documentation/btrfs-dedupe-inband.asciidoc
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -78,6 +78,9 @@ And compression has higher priority than in-band de-duplication, means if
 compression and de-duplication is enabled at the same time, only compression
 will work.
 
+*status* <path>::
+Show current in-band de-duplication status of a filesystem.
+
 BACKENDS
 --------
 Btrfs in-band de-duplication will support different storage backends, with
diff --git a/btrfs-completion b/btrfs-completion
index 9a6c73b..fbaae0c 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -40,7 +40,7 @@ _btrfs()
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
-    commands_dedupe='enable disable'
+    commands_dedupe='enable disable status'
     commands_replace='start status cancel'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index e3497b5..9dd155e 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -222,12 +222,93 @@ out:
 	return 0;
 }
 
+static const char * const cmd_dedupe_ib_status_usage[] = {
+	"btrfs dedupe status <path>",
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
+	if (dargs.hash_type == BTRFS_DEDUPE_HASH_SHA256)
+		printf("Hash algorithm:\t\tSHA-256\n");
+	else
+		printf("Hash algorithm:\t\tUnrecognized(%x)\n",
+			dargs.hash_type);
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
2.8.3



