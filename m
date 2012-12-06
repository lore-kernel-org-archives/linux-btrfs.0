Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422835Ab2LFJqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:46 -0500
Message-ID: <50C0699C.8000906@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:47:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 4/9] Btrfs-progs: introduce '-l' option to print max referenced
 size of qgroups
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
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
index f182c90..a0156a6 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -199,10 +199,11 @@ static int cmd_qgroup_destroy(int argc, char **argv)
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
 
@@ -215,7 +216,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pc");
+		c = getopt(argc, argv, "pcl");
 		if (c < 0)
 			break;
 
@@ -228,6 +229,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_CHILD);
 			break;
+		case 'l':
+			btrfs_qgroup_setup_print_column(
+						BTRFS_QGROUP_MAX_RFER);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index 3bfc408..31f3a16 100644
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
@@ -163,6 +167,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_EXCL:
 		printf("%llu", qgroup->excl);
 		break;
+	case BTRFS_QGROUP_MAX_RFER:
+		printf("%llu", qgroup->max_rfer);
+		break;
 	case BTRFS_QGROUP_PARENT:
 		print_parent_column(qgroup);
 		break;
diff --git a/qgroup.h b/qgroup.h
index 02c78be..a212913 100644
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
1.7.11.7

