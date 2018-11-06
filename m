Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E59AC46464
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 277962081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 277962081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbeKFQF5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:57 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44359 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387624AbeKFQF5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:57 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417740"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:42:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D93764B71EA2;
        Tue,  6 Nov 2018 14:42:08 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:42:12 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.6 5/5] btrfs-progs: dedupe: introduce reconfigure subcommand
Date:   Tue, 6 Nov 2018 14:41:58 +0800
Message-ID: <20181106064158.6356-6-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064158.6356-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064158.6356-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: D93764B71EA2.A920E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

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
index 0808f9a14df9..a3e05b238eda 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -34,7 +34,7 @@ _btrfs()
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
2.19.1



