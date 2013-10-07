Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3JGHZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:03 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 02/12] Btrfs-progs: introduces '-p' option to print the ID of the parent qgroups
Date: Mon, 7 Oct 2013 15:21:38 +0800
Message-Id: <1381130508-8458-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-p' option to print the ID of the parent qgroups.
You may use it like:

	btrfs qgroup show -p <path>
For Example:
                qgroupid(2/0)
                /         \
               /           \
              /             \
        qgroupid(1/0)  qgroupid(1/1)
              \              /
               \            /
                qgroupid(0/1)

If we use the command:

	btrfs qgroup show -p <path>
The result will output
	0/1 -- -- 1/0,1/1
	1/0 -- -- 2/0
	1/1 -- -- 2/0
	2/0 -- -- --

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c | 23 ++++++++++++++++++++---
 qgroup.c      | 22 ++++++++++++++++++++++
 qgroup.h      |  1 +
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index d3c699f..96098c1 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,22 +202,39 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show <path>",
+	"btrfs qgroup show -p <path>",
 	"Show all subvolume quota groups.",
+	"-p		print parent qgroup id",
 	NULL
 };
 
 static int cmd_qgroup_show(int argc, char **argv)
 {
+	char *path;
 	int ret = 0;
 	int fd;
 	int e;
-	char *path = argv[1];
 	DIR *dirstream = NULL;
+	int c;
 
-	if (check_argc_exact(argc, 2))
+	optind = 1;
+	while (1) {
+		c = getopt(argc, argv, "p");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'p':
+			btrfs_qgroup_setup_print_column(
+				BTRFS_QGROUP_PARENT);
+			break;
+		default:
+			usage(cmd_qgroup_show_usage);
+		}
+	}
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_qgroup_show_usage);
 
+	path = argv[optind];
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
diff --git a/qgroup.c b/qgroup.c
index bd9658e..0dbf28c 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -88,6 +88,11 @@ struct {
 		.need_print	= 1,
 	},
 	{
+		.name		= "parent",
+		.column_name	= "Parent",
+		.need_print	= 0,
+	},
+	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
@@ -108,6 +113,20 @@ void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 		btrfs_qgroup_columns[i].need_print = 1;
 }
 
+static void print_parent_column(struct btrfs_qgroup *qgroup)
+{
+	struct btrfs_qgroup_list *list = NULL;
+
+	list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
+		printf("%llu/%llu", (list->qgroup)->qgroupid >> 48,
+		      ((1ll << 48) - 1) & (list->qgroup)->qgroupid);
+		if (!list_is_last(&list->next_qgroup, &qgroup->qgroups))
+			printf(",");
+	}
+	if (list_empty(&qgroup->qgroups))
+		printf("---");
+}
+
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 				enum btrfs_qgroup_column_enum column)
 {
@@ -125,6 +144,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_EXCL:
 		printf("%lld", qgroup->excl);
 		break;
+	case BTRFS_QGROUP_PARENT:
+		print_parent_column(qgroup);
+		break;
 	default:
 		break;
 	}
diff --git a/qgroup.h b/qgroup.h
index 8b34cd7..cefdfe1 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -26,6 +26,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_QGROUPID,
 	BTRFS_QGROUP_RFER,
 	BTRFS_QGROUP_EXCL,
+	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_ALL,
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
