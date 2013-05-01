Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38022 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3EAQ1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 12:27:50 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r41GRmkK028310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:49 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r41GRmMq000868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:48 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r41GRlLQ002240
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add dedup register
Date: Thu,  2 May 2013 00:27:39 +0800
Message-Id: <1367425659-10803-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This aims to add 'btrfs filesystem dedup-register', and it can be used
to enable dedup on a filesystem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-filesystem.c |   36 ++++++++++++++++++++++++++++++++++++
 ioctl.h           |    1 +
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 3f386e2..aa21cf6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -515,6 +515,41 @@ static int cmd_label(int argc, char **argv)
 		return get_label(argv[1]);
 }
 
+static const char * const cmd_dedup_usage[] = {
+	"btrfs filesystem dedup-register <path>",
+	"Register a dedup tree",
+	NULL
+};
+
+static int cmd_dedup(int argc, char **argv)
+{
+	int 	fd, res, e;
+	char	*path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	printf("register dedup on '%s'\n", path);
+	res = ioctl(fd, BTRFS_IOC_DEDUP_REGISTER);
+	e = errno;
+	close(fd);
+	if( res < 0 ){
+		fprintf(stderr, "ERROR: unable to register dedup '%s' - %s\n", 
+			path, strerror(e));
+		return 32;
+	}
+
+	return 0;
+}
+
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
@@ -524,6 +559,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "dedup-register", cmd_dedup, cmd_dedup_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index e841913..1bea98a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -528,6 +528,7 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_DEDUP_REGISTER	 _IO(BTRFS_IOCTL_MAGIC, 54)
 
 #ifdef __cplusplus
 }
-- 
1.7.7

