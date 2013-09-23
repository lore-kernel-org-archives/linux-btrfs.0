Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3IWGUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 02:20:07 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8N6K3T7012949
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 14:20:04 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/9] Btrfs-progs: introduce '-l' option to print max referenced size of qgroups
Date: Mon, 23 Sep 2013 14:17:23 +0800
Message-Id: <1379917048-9720-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-l' option to print max referenced size of qgroups.
You may use it like:

		btrfs qgroup show -l <path>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c | 9 +++++++--
 qgroup.c      | 7 +++++++
 qgroup.h      | 1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 147bedc..32537f9 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,10 +202,11 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pc <path>",
+	"btrfs qgroup show -pcl <path>",
 	"Show all subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
+	"-l		print max referenced size of qgroup",
 	NULL
 };
 
@@ -220,7 +221,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pc");
+		c = getopt(argc, argv, "pcl");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -232,6 +233,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_CHILD);
 			break;
+		case 'l':
+			btrfs_qgroup_setup_print_column(
+				BTRFS_QGROUP_MAX_RFER);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index 1592dd4..f9eb52d 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -87,6 +87,10 @@ struct {
 		.column_name	= "Excl",
 		.need_print	= 1,
 	},
+	{	.name		= "max_rfer",
+		.column_name	= "Max_rfer",
+		.need_print	= 0,
+	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
@@ -166,6 +170,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_PARENT:
 		print_parent_column(qgroup);
 		break;
+	case BTRFS_QGROUP_MAX_RFER:
+		printf("%llu", qgroup->max_rfer);
+		break;
 	case BTRFS_QGROUP_CHILD:
 		print_child_column(qgroup);
 		break;
diff --git a/qgroup.h b/qgroup.h
index 33682ae..168fac0 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -26,6 +26,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_QGROUPID,
 	BTRFS_QGROUP_RFER,
 	BTRFS_QGROUP_EXCL,
+	BTRFS_QGROUP_MAX_RFER,
 	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_CHILD,
 	BTRFS_QGROUP_ALL,
-- 
1.8.3.1

