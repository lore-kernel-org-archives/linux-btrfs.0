Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3JGHZG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:06 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 05/12] Btrfs-progs: introduce '-e' option to print max exclusive size of qgroups
Date: Mon, 7 Oct 2013 15:21:41 +0800
Message-Id: <1381130508-8458-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
index 213cbde..fc9ad2f 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,11 +202,12 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcr <path>",
+	"btrfs qgroup show -pcre <path>",
 	"Show all subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
 	"-r		print max referenced size of qgroup",
+	"-e		print max exclusive size of qgroup",
 	NULL
 };
 
@@ -221,7 +222,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcr");
+		c = getopt(argc, argv, "pcre");
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
