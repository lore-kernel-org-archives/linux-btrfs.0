Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbbCSGEz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:55 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] Btrfs-progs: qgroup: add a opt for type of qgroup limit.
Date: Thu, 19 Mar 2015 14:00:58 +0800
Message-ID: <1426744864-7031-6-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add a support for user to limit the data, metadata,
or mixed of a qgroup. Even you can set these three limits at
one time for a qgroup.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 ioctl.h       | 13 +++++++++++++
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index c5082f7..1c42fc8 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -367,14 +367,46 @@ static const char * const cmd_qgroup_limit_usage[] = {
 	"-c   limit amount of data after compression. This is the default,",
 	"     it is currently not possible to turn off this option.",
 	"-e   limit space exclusively assigned to this qgroup",
+	"-t   limit space for data, metadata or mixed",
 	NULL
 };
 
+inline u8 get_limit_type(u64 flag)
+{
+	return (flag >> BTRFS_QGROUP_LIMIT_TYPE_SHIFT);
+}
+
+inline u64 set_limit_type(u64 flag, u8 type)
+{
+	u64 temp = (flag >> BTRFS_QGROUP_LIMIT_TYPE_SHIFT);
+
+	temp |= type;
+	flag |= (temp << BTRFS_QGROUP_LIMIT_TYPE_SHIFT);
+
+	return flag;
+}
+
+static int parse_limit_type(u8 *qgroup_type, char *arg)
+{
+	if (strcmp(arg, "data") == 0)
+		*qgroup_type = BTRFS_QGROUP_LIMIT_DATA;
+	else if (strcmp(arg, "metadata") == 0)
+		*qgroup_type = BTRFS_QGROUP_LIMIT_METADATA;
+	else if (strcmp(arg, "mixed") == 0) {
+		*qgroup_type = BTRFS_QGROUP_LIMIT_MIXED;
+	} else {
+		fprintf(stderr, "ERROR: Invalid qgroup type arguments given\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int cmd_qgroup_limit(int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
 	int e;
+	u8 type = BTRFS_QGROUP_LIMIT_MIXED;
 	char *path = NULL;
 	struct btrfs_ioctl_qgroup_limit_args args;
 	unsigned long long size;
@@ -384,7 +416,14 @@ static int cmd_qgroup_limit(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "ce");
+		int c;
+		static const struct option long_options[] = {
+			{"type", required_argument, NULL, 't'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "ce",
+			long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -394,6 +433,11 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		case 'e':
 			exclusive = 1;
 			break;
+		case 't':
+			ret = parse_limit_type(&type, optarg);
+			if (ret)
+				return -EINVAL;
+			break;
 		default:
 			usage(cmd_qgroup_limit_usage);
 		}
@@ -419,6 +463,8 @@ static int cmd_qgroup_limit(int argc, char **argv)
 			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
 			args.lim.max_referenced = size;
 		}
+
+		args.lim.flags = set_limit_type(args.lim.flags, type);
 	}
 
 	if (argc - optind == 2) {
diff --git a/ioctl.h b/ioctl.h
index d550ca6..a1ebbb5 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -45,6 +45,19 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
 
+/*
+ * As we can account and limit data and metadata in
+ * a qgroup separately. We use the first 8 bits in
+ * btrfs_qgroup_limit->flags to specify the type we
+ * want to limit. Currently, there are three choice:
+ * DATA, METADATA, MIXED.
+ */
+#define BTRFS_QGROUP_LIMIT_TYPE_SHIFT	56
+
+#define BTRFS_QGROUP_LIMIT_DATA		1
+#define BTRFS_QGROUP_LIMIT_METADATA	2
+#define BTRFS_QGROUP_LIMIT_MIXED	4
+
 struct btrfs_qgroup_limit {
 	__u64	flags;
 	__u64	max_referenced;
-- 
1.8.4.2

