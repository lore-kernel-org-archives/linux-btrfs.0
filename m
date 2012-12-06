Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422895Ab2LFJtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:49:46 -0500
Message-ID: <50C06A50.2040500@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:50:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 7/9] Btrfs-progs: list all qgroups impact given path(exclude
 ancestral qgroups)
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
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

Signed-off-by: Wang shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c | 14 ++++++++++++--
 qgroup.c      | 16 +++++++++++++++-
 qgroup.h      |  1 +
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index b6cdb53..9447179 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -207,6 +207,8 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"-e		print max exclusive size of qgroup",
 	"-F		list all qgroups which impact the given path"
 	"(include ancestral qgroups)",
+	"-f		list all qgroups which impact the given path"
+	"(exclude ancestral qgroups)",
 	NULL
 };
 
@@ -224,7 +226,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcleF");
+		c = getopt(argc, argv, "pcleFf");
 		if (c < 0)
 			break;
 
@@ -248,6 +250,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'F':
 			filter_flag |= 0x1;
 			break;
+		case 'f':
+			filter_flag |= 0x2;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -263,9 +268,14 @@ static int cmd_qgroup_show(int argc, char **argv)
 	}
 	if (filter_flag) {
 		qgroupid = btrfs_get_path_rootid(fd);
-		btrfs_qgroup_setup_filter(&filter_set,
+		if (filter_flag & 0x1)
+			btrfs_qgroup_setup_filter(&filter_set,
 					  BTRFS_QGROUP_FILTER_ALL_PARENT,
 					  qgroupid);
+		if (filter_flag & 0x2)
+			btrfs_qgroup_setup_filter(&filter_set,
+					  BTRFS_QGROUP_FILTER_PARENT,
+					  qgroupid);
 	}
 	ret = btrfs_show_qgroups(fd, filter_set);
 	if (ret < 0) {
diff --git a/qgroup.c b/qgroup.c
index 6cb71e9..b8640dc 100644
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
index 30844fe..d1165fd 100644
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
1.7.11.7

