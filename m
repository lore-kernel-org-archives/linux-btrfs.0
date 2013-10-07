Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3JGHZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:07 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 07/12] Btrfs-progs: list all qgroups impact given path(exclude ancestral qgroups)
Date: Mon, 7 Oct 2013 15:21:43 +0800
Message-Id: <1381130508-8458-8-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-f' option which can help you filter the qgroups
by the path name, you may use it like:

	btrfs qgroup show -f <path>
For example:

                         qgroupid(2/0)
                          /     \
                         /       \
                        qgroupid(1/0)
                        /         \
                       /           \
                      /             \
                  qgroupid(0/1)   qgroupid(0/2)
                  sub1              sub2
                  /  \
                 /    \
		dir1  file1

If we use the command:
	btrfs qgroup show -f sub1/dir1
The result will output
	0/1	--	--

'-f' option helps you list all qgroups impact given path.
(exclude ancestral qgroups)

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c | 20 +++++++++++++++-----
 qgroup.c      | 16 +++++++++++++++-
 qgroup.h      |  1 +
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 7c6c917..5f1550a 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,7 +202,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcreF <path>",
+	"btrfs qgroup show -pcreFf <path>",
 	"Show subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
@@ -210,6 +210,8 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"-e		print max exclusive size of qgroup",
 	"-F		list all qgroups which impact the given path"
 	"(include ancestral qgroups)",
+	"-f		list all qgroups which impact the given path"
+	"(exclude ancestral qgroups)",
 	NULL
 };
 
@@ -229,7 +231,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcreF");
+		c = getopt(argc, argv, "pcreFf");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -252,6 +254,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'F':
 			filter_flag |= 0x1;
 			break;
+		case 'f':
+			filter_flag |= 0x2;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -268,9 +273,14 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	if (filter_flag) {
 		qgroupid = btrfs_get_path_rootid(fd);
-		btrfs_qgroup_setup_filter(&filter_set,
-				BTRFS_QGROUP_FILTER_ALL_PARENT,
-				qgroupid);
+		if (filter_flag & 0x1)
+			btrfs_qgroup_setup_filter(&filter_set,
+					BTRFS_QGROUP_FILTER_ALL_PARENT,
+					qgroupid);
+		if (filter_flag & 0x2)
+			btrfs_qgroup_setup_filter(&filter_set,
+					BTRFS_QGROUP_FILTER_PARENT,
+					qgroupid);
 	}
 	ret = btrfs_show_qgroups(fd, filter_set);
 	e = errno;
diff --git a/qgroup.c b/qgroup.c
index 306b638..28772d6 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -468,6 +468,18 @@ static int filter_all_parent_insert(struct qgroup_lookup *sort_tree,
 	return 0;
 }
 
+static int filter_by_parent(struct btrfs_qgroup *bq, u64 data)
+{
+	struct btrfs_qgroup *qgroup =
+		(struct btrfs_qgroup *)(unsigned long)data;
+
+	if (data == 0)
+		return 0;
+	if (qgroup->qgroupid == bq->qgroupid)
+		return 1;
+	return 0;
+}
+
 static int filter_by_all_parent(struct btrfs_qgroup *bq, u64 data)
 {
 	struct qgroup_lookup lookup;
@@ -502,6 +514,7 @@ static int filter_by_all_parent(struct btrfs_qgroup *bq, u64 data)
 }
 
 static btrfs_qgroup_filter_func all_filter_funcs[] = {
+	[BTRFS_QGROUP_FILTER_PARENT]		= filter_by_parent,
 	[BTRFS_QGROUP_FILTER_ALL_PARENT]	= filter_by_all_parent,
 };
 
@@ -586,7 +599,8 @@ static void pre_process_filter_set(struct qgroup_lookup *lookup,
 
 	for (i = 0; i < set->nfilters; i++) {
 
-		if (set->filters[i].filter_func == filter_by_all_parent) {
+		if (set->filters[i].filter_func == filter_by_all_parent
+		    || set->filters[i].filter_func == filter_by_parent) {
 			qgroup_for_filter = qgroup_tree_search(lookup,
 					    set->filters[i].data);
 			set->filters[i].data =
diff --git a/qgroup.h b/qgroup.h
index bcc2b4b..5fcdd8a 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -49,6 +49,7 @@ enum btrfs_qgroup_column_enum {
 };
 
 enum btrfs_qgroup_filter_enum {
+	BTRFS_QGROUP_FILTER_PARENT,
 	BTRFS_QGROUP_FILTER_ALL_PARENT,
 	BTRFS_QGROUP_FILTER_MAX,
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
