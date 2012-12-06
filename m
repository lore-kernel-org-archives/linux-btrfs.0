Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422860Ab2LFJrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:47:32 -0500
Message-ID: <50C069C9.5030209@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:47:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 5/9] Btrfs-progs: introduce '-e' option to print max exclusive
 size of qgroups
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
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
index a0156a6..e020335 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -199,11 +199,12 @@ static int cmd_qgroup_destroy(int argc, char **argv)
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
 
@@ -216,7 +217,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcl");
+		c = getopt(argc, argv, "pcle");
 		if (c < 0)
 			break;
 
@@ -233,6 +234,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_MAX_RFER);
 			break;
+		case 'e':
+			btrfs_qgroup_setup_print_column(
+						BTRFS_QGROUP_MAX_EXCL);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index 31f3a16..94cd202 100644
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
@@ -170,6 +175,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_MAX_RFER:
 		printf("%llu", qgroup->max_rfer);
 		break;
+	case BTRFS_QGROUP_MAX_EXCL:
+		printf("%llu", qgroup->max_excl);
+		break;
 	case BTRFS_QGROUP_PARENT:
 		print_parent_column(qgroup);
 		break;
diff --git a/qgroup.h b/qgroup.h
index a212913..a23da83 100644
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
1.7.11.7

