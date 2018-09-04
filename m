Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23831 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725977AbeIDLb3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:31:29 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.5 5/5] btrfs-progs: dedupe: introduce reconfigure subcommand
Date: Tue, 4 Sep 2018 15:07:28 +0800
Message-ID: <20180904070728.5495-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904070728.5495-1-lufq.fnst@cn.fujitsu.com>
References: <20180904070728.5495-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce reconfigure subcommand to co-operate with new kernel ioctl
modification.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc |  7 +++
 btrfs-completion                           |  2 +-
 cmds-dedupe-ib.c                           | 73 +++++++++++++++++-----
 3 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index 6096389cb0b4..78c806f772d6 100644
--- a/Documentation/btrfs-dedupe-inband.asciidoc
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -86,6 +86,13 @@ And compression has higher priority than in-band de-duplication, means if
 compression and de-duplication is enabled at the same time, only compression
 will work.
 
+*reconfigure* [options] <path>::
+Re-configure in-band de-duplication parameters of a filesystem.
++
+In-band de-duplication must be enbaled first before re-configuration.
++
+[Options] are the same with 'btrfs dedupe-inband enable'.
+
 *status* <path>::
 Show current in-band de-duplication status of a filesystem.
 
diff --git a/btrfs-completion b/btrfs-completion
index 62a7bdd4d0d5..6ff48e4c2f6a 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -41,7 +41,7 @@ _btrfs()
 	commands_quota='enable disable rescan'
 	commands_qgroup='assign remove create destroy show limit'
 	commands_replace='start status cancel'
-	commands_dedupe_inband='enable disable status'
+	commands_dedupe_inband='enable disable status reconfigure'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
 		COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index e778457e25a8..e52f939c9ced 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -56,7 +56,6 @@ static const char * const cmd_dedupe_ib_enable_usage[] = {
 	NULL
 };
 
-
 #define report_fatal_parameter(dargs, old, member, type, err_val, fmt)	\
 ({									\
 	if (dargs->member != old->member &&				\
@@ -88,6 +87,12 @@ static void report_parameter_error(struct btrfs_ioctl_dedupe_args *dargs,
 		}
 		report_option_parameter(dargs, old, flags, u8, -1, x);
 	}
+
+	if (dargs->status == 0 && old->cmd == BTRFS_DEDUPE_CTL_RECONF) {
+		error("must enable dedupe before reconfiguration");
+		return;
+	}
+
 	if (report_fatal_parameter(dargs, old, cmd, u16, -1, u) ||
 	    report_fatal_parameter(dargs, old, blocksize, u64, -1, llu) ||
 	    report_fatal_parameter(dargs, old, backend, u16, -1, u) ||
@@ -100,14 +105,17 @@ static void report_parameter_error(struct btrfs_ioctl_dedupe_args *dargs,
 		old->limit_nr, old->limit_mem);
 }
 
-static int cmd_dedupe_ib_enable(int argc, char **argv)
+static int enable_reconfig_dedupe(int argc, char **argv, int reconf)
 {
 	int ret;
 	int fd = -1;
 	char *path;
 	u64 blocksize = BTRFS_DEDUPE_BLOCKSIZE_DEFAULT;
+	int blocksize_set = 0;
 	u16 hash_algo = BTRFS_DEDUPE_HASH_SHA256;
+	int hash_algo_set = 0;
 	u16 backend = BTRFS_DEDUPE_BACKEND_INMEMORY;
+	int backend_set = 0;
 	u64 limit_nr = 0;
 	u64 limit_mem = 0;
 	u64 sys_mem = 0;
@@ -134,15 +142,17 @@ static int cmd_dedupe_ib_enable(int argc, char **argv)
 			break;
 		switch (c) {
 		case 's':
-			if (!strcasecmp("inmemory", optarg))
+			if (!strcasecmp("inmemory", optarg)) {
 				backend = BTRFS_DEDUPE_BACKEND_INMEMORY;
-			else {
+				backend_set = 1;
+			} else {
 				error("unsupported dedupe backend: %s", optarg);
 				exit(1);
 			}
 			break;
 		case 'b':
 			blocksize = parse_size(optarg);
+			blocksize_set = 1;
 			break;
 		case 'a':
 			if (strcmp("sha256", optarg)) {
@@ -224,26 +234,40 @@ static int cmd_dedupe_ib_enable(int argc, char **argv)
 		return 1;
 	}
 	memset(&dargs, -1, sizeof(dargs));
-	dargs.cmd = BTRFS_DEDUPE_CTL_ENABLE;
-	dargs.blocksize = blocksize;
-	dargs.hash_algo = hash_algo;
-	dargs.limit_nr = limit_nr;
-	dargs.limit_mem = limit_mem;
-	dargs.backend = backend;
-	if (force)
-		dargs.flags |= BTRFS_DEDUPE_FLAG_FORCE;
-	else
-		dargs.flags = 0;
+	if (reconf) {
+		dargs.cmd = BTRFS_DEDUPE_CTL_RECONF;
+		if (blocksize_set)
+			dargs.blocksize = blocksize;
+		if (hash_algo_set)
+			dargs.hash_algo = hash_algo;
+		if (backend_set)
+			dargs.backend = backend;
+		dargs.limit_nr = limit_nr;
+		dargs.limit_mem = limit_mem;
+	} else {
+		dargs.cmd = BTRFS_DEDUPE_CTL_ENABLE;
+		dargs.blocksize = blocksize;
+		dargs.hash_algo = hash_algo;
+		dargs.limit_nr = limit_nr;
+		dargs.limit_mem = limit_mem;
+		dargs.backend = backend;
+		if (force)
+			dargs.flags |= BTRFS_DEDUPE_FLAG_FORCE;
+		else
+			dargs.flags = 0;
+	}
 
 	memcpy(&backup, &dargs, sizeof(dargs));
 	ret = ioctl(fd, BTRFS_IOC_DEDUPE_CTL, &dargs);
 	if (ret < 0) {
-		error("failed to enable inband deduplication: %m");
+		error("failed to (%s) inband deduplication: %m",
+		      reconf ? "reconfigure" : "enable");
 		report_parameter_error(&dargs, &backup);
 		ret = 1;
 		goto out;
 	}
 
+	report_parameter_error(&dargs, &backup);
 mem_check:
 	if (!force && dargs.limit_mem > sys_mem / 4) {
 		ret = 1;
@@ -258,6 +282,10 @@ out:
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static int cmd_dedupe_ib_enable(int argc, char **argv)
+{
+	return enable_reconfig_dedupe(argc, argv, 0);
+}
 
 static const char * const cmd_dedupe_ib_disable_usage[] = {
 	"btrfs dedupe-inband disable <path>",
@@ -376,6 +404,19 @@ out:
 	return ret;
 }
 
+static int cmd_dedupe_ib_reconf(int argc, char **argv)
+{
+	return enable_reconfig_dedupe(argc, argv, 1);
+}
+
+static const char * const cmd_dedupe_ib_reconf_usage[] = {
+	"btrfs dedupe-inband reconfigure [options] <path>",
+	"Reconfigure in-band(write time) de-duplication of a btrfs.",
+	"",
+	"Options are the same as 'btrfs dedupe-inband enable'",
+	NULL
+};
+
 const struct cmd_group dedupe_ib_cmd_group = {
 	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
 		{ "enable", cmd_dedupe_ib_enable, cmd_dedupe_ib_enable_usage,
@@ -384,6 +425,8 @@ const struct cmd_group dedupe_ib_cmd_group = {
 		  NULL, 0},
 		{ "status", cmd_dedupe_ib_status, cmd_dedupe_ib_status_usage,
 		  NULL, 0},
+		{ "reconfigure", cmd_dedupe_ib_reconf,
+		  cmd_dedupe_ib_reconf_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.18.0
