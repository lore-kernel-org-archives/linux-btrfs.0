Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbcF3JaY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:30:24 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id B13214056409
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:33 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v9 5/5] btrfs-progs: dedupe: introduce reconfigure subcommand
Date: Thu, 30 Jun 2016 17:24:31 +0800
Message-Id: <20160630092431.27636-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
References: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce reconfigure subcommand to co-operate with new kernel ioctl
modification.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc |  7 +++
 cmds-dedupe-ib.c                           | 74 +++++++++++++++++++++++-------
 2 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index df068c3..5fc4bb0 100644
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
 
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index c9085ac..0c3ef4b 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -68,7 +68,6 @@ static const char * const cmd_dedupe_ib_enable_usage[] = {
 	NULL
 };
 
-
 #define report_fatal_parameter(dargs, old, member, type, err_val, fmt)	\
 if (dargs->member != old->member && dargs->member == (type)(err_val)) {	\
 	error("unsupported dedupe "#member": %"#fmt"", old->member);	\
@@ -91,6 +90,10 @@ static void report_parameter_error(struct btrfs_ioctl_dedupe_args *dargs,
 		}
 		report_option_parameter(dargs, old, flags, u8, -1, x);
 	}
+	if (dargs->status == 0 && old->cmd == BTRFS_DEDUPE_CTL_RECONF) {
+		error("must enable dedupe before reconfiguration");
+		return;
+	}
 	report_fatal_parameter(dargs, old, cmd, u16, -1, u);
 	report_fatal_parameter(dargs, old, blocksize, u64, -1, llu);
 	report_fatal_parameter(dargs, old, backend, u16, -1, u);
@@ -101,14 +104,17 @@ static void report_parameter_error(struct btrfs_ioctl_dedupe_args *dargs,
 	return;
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
@@ -130,20 +136,22 @@ static int cmd_dedupe_ib_enable(int argc, char **argv)
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "s:b:a:l:m:", long_options, NULL);
+		c = getopt_long(argc, argv, "s:b:a:l:m:f", long_options, NULL);
 		if (c < 0)
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
@@ -151,6 +159,7 @@ static int cmd_dedupe_ib_enable(int argc, char **argv)
 				      optarg);
 				return 1;
 			}
+			hash_algo = 1;
 			break;
 		case 'l':
 			limit_nr = parse_size(optarg);
@@ -221,26 +230,40 @@ static int cmd_dedupe_ib_enable(int argc, char **argv)
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
-		error("failed to enable inband deduplication: %s",
+		error("failed to (%s) inband deduplication: %s",
+		      reconf ? "reconfigure" : "enable",
 		      strerror(errno));
 		report_parameter_error(&dargs, &backup);
 		ret = 1;
 		goto out;
 	}
+	report_parameter_error(&dargs, &backup);
 	ret = 0;
 mem_check:
 	if (!force && dargs.limit_mem > sys_mem / 4) {
@@ -255,6 +278,10 @@ out:
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static int cmd_dedupe_ib_enable(int argc, char **argv)
+{
+	return enable_reconfig_dedupe(argc, argv, 0);
+}
 
 static const char * const cmd_dedupe_ib_disable_usage[] = {
 	"btrfs dedupe disable <path>",
@@ -375,6 +402,19 @@ out:
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
@@ -383,6 +423,8 @@ const struct cmd_group dedupe_ib_cmd_group = {
 		  NULL, 0},
 		{ "status", cmd_dedupe_ib_status, cmd_dedupe_ib_status_usage,
 		  NULL, 0},
+		{ "reconfigure", cmd_dedupe_ib_reconf,
+		  cmd_dedupe_ib_reconf_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.9.0



