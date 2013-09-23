Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3IWGUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 02:20:07 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8N6K2iO012946
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 14:20:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/9] Btrfs-progs: introduce '-e' option to print max exclusive size of qgroups
Date: Mon, 23 Sep 2013 14:17:24 +0800
Message-Id: <1379917048-9720-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduce '-e' option to print max exclusive size of qgroups.
You may use it like this:
		btrfs qgroup -e <path>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c | 9 +++++++--
 qgroup.c      | 8 ++++++++
 qgroup.h      | 1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 32537f9..0bfca33 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,11 +202,12 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcl <path>",
+	"btrfs qgroup show -pcle <path>",
 	"Show all subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
 	"-l		print max referenced size of qgroup",
+	"-e		print max exclusive size of qgroup",
 	NULL
 };
 
@@ -221,7 +222,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcl");
+		c = getopt(argc, argv, "pcle");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -237,6 +238,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_MAX_RFER);
 			break;
+		case 'e':
+			btrfs_qgroup_setup_print_column(
+				BTRFS_QGROUP_MAX_EXCL);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index f9eb52d..2cd37b1 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -92,6 +92,11 @@ struct {
 		.need_print	= 0,
 	},
 	{
+		.name		= "max_excl",
+		.column_name	= "Max_excl",
+		.need_print	= 0,
+	},
+	{
 		.name		= "parent",
 		.column_name	= "Parent",
 		.need_print	= 0,
@@ -173,6 +178,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_MAX_RFER:
 		printf("%llu", qgroup->max_rfer);
 		break;
+	case BTRFS_QGROUP_MAX_EXCL:
+		printf("%llu", qgroup->max_excl);
+		break;
 	case BTRFS_QGROUP_CHILD:
 		print_child_column(qgroup);
 		break;
diff --git a/qgroup.h b/qgroup.h
index 168fac0..e7a65ba 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -27,6 +27,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_RFER,
 	BTRFS_QGROUP_EXCL,
 	BTRFS_QGROUP_MAX_RFER,
+	BTRFS_QGROUP_MAX_EXCL,
 	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_CHILD,
 	BTRFS_QGROUP_ALL,
-- 
1.8.3.1

