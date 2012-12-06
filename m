Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422797Ab2LFJqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:02 -0500
Message-ID: <50C06970.7080502@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:46:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 3/9] Btrfs-progs: introduces '-c' option to print the ID of
 the child qgroups
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
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
index f402587..f182c90 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -199,9 +199,10 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -p <path>",
+	"btrfs qgroup show -pc <path>",
 	"Show all subvolume quota groups.",
 	"-p		print parent qgroup id",
+	"-c		print child qgroup id",
 	NULL
 };
 
@@ -214,7 +215,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "p");
+		c = getopt(argc, argv, "pc");
 		if (c < 0)
 			break;
 
@@ -223,6 +224,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_PARENT);
 			break;
+		case 'c':
+			btrfs_qgroup_setup_print_column(
+						BTRFS_QGROUP_CHILD);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index ebe7d17..3bfc408 100644
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
index e1de675..02c78be 100644
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
1.7.11.7

