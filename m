Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3IWGUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 02:20:07 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8N6K2iN012946
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 14:20:04 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/9] Btrfs-progs: introduces '-c' option to print the ID of the child qgroups
Date: Mon, 23 Sep 2013 14:17:22 +0800
Message-Id: <1379917048-9720-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-c' option to print the ID of the child qgroups.
You may use it like:
	btrfs qgroup show -c <path>

For Example:

                qgroupid(2/0)
                 /       \
                /         \
               /           \
            qgroupid(1/0) qgroupid(1/1)
               \            /
                \          /
		 qgroupid(0/1)

If we use the command:

	btrfs qgroup show -c <path>
The result will output
	0/1 -- -- --
	1/0 -- -- 0/1
	1/1 -- -- 0/1
	2/0 -- -- 1/0,1/1

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |  9 +++++++--
 qgroup.c      | 22 ++++++++++++++++++++++
 qgroup.h      |  1 +
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 96098c1..147bedc 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,9 +202,10 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -p <path>",
+	"btrfs qgroup show -pc <path>",
 	"Show all subvolume quota groups.",
 	"-p		print parent qgroup id",
+	"-c		print child qgroup id",
 	NULL
 };
 
@@ -219,7 +220,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "p");
+		c = getopt(argc, argv, "pc");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -227,6 +228,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_PARENT);
 			break;
+		case 'c':
+			btrfs_qgroup_setup_print_column(
+				BTRFS_QGROUP_CHILD);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index 0dbf28c..1592dd4 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -93,6 +93,11 @@ struct {
 		.need_print	= 0,
 	},
 	{
+		.name		= "child",
+		.column_name	= "Child",
+		.need_print	= 0,
+	},
+	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
@@ -127,6 +132,20 @@ static void print_parent_column(struct btrfs_qgroup *qgroup)
 		printf("---");
 }
 
+static void print_child_column(struct btrfs_qgroup *qgroup)
+{
+	struct btrfs_qgroup_list *list = NULL;
+
+	list_for_each_entry(list, &qgroup->members, next_member) {
+		printf("%llu/%llu", (list->member)->qgroupid >> 48,
+		      ((1ll << 48) - 1) & (list->member)->qgroupid);
+		if (!list_is_last(&list->next_member, &qgroup->members))
+			printf(",");
+	}
+	if (list_empty(&qgroup->members))
+		printf("---");
+}
+
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 				enum btrfs_qgroup_column_enum column)
 {
@@ -147,6 +166,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_PARENT:
 		print_parent_column(qgroup);
 		break;
+	case BTRFS_QGROUP_CHILD:
+		print_child_column(qgroup);
+		break;
 	default:
 		break;
 	}
diff --git a/qgroup.h b/qgroup.h
index cefdfe1..33682ae 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -27,6 +27,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_RFER,
 	BTRFS_QGROUP_EXCL,
 	BTRFS_QGROUP_PARENT,
+	BTRFS_QGROUP_CHILD,
 	BTRFS_QGROUP_ALL,
 };
 
-- 
1.8.3.1

