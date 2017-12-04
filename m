Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753382AbdLDKWC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 05:22:02 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7BFA848A1711
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 18:21:56 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/4] btrfs-progs: qgroup: show subvol path when qgroup show
Date: Mon, 4 Dec 2017 18:20:43 +0800
Message-ID: <20171204102044.25702-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171204102044.25702-1-lufq.fnst@cn.fujitsu.com>
References: <20171204102044.25702-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Show the absolute subvol path for the associated level-0 qgroup.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
Changelog:
v2:
rebase on the qgroup cleanup

 qgroup.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 qgroup.h |   1 +
 2 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index b5b893f4..cfaed5ba 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -62,6 +62,9 @@ struct btrfs_qgroup {
 	struct list_head qgroups;
 	/*qgroups that are members of this group*/
 	struct list_head members;
+
+	/* level-0 qgroup's subvolume path */
+	char *path;
 };
 
 /*
@@ -133,6 +136,13 @@ static struct {
 		.unit_mode	= 0,
 		.max_len	= 5,
 	},
+	{
+		.name		= "path",
+		.column_name	= "Path",
+		.need_print	= 1,
+		.unit_mode	= 0,
+		.max_len	= 4,
+	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
@@ -253,6 +263,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		len = print_child_column(qgroup);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
 		break;
+	case BTRFS_QGROUP_PATH:
+		len = printf("%s", qgroup->path ? qgroup->path : "---");
+		print_qgroup_column_add_blank(BTRFS_QGROUP_PATH, len);
 	default:
 		break;
 	}
@@ -267,7 +280,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
 			continue;
 		print_qgroup_column(qgroup, i);
 
-		if (i != BTRFS_QGROUP_CHILD)
+		if (i != BTRFS_QGROUP_ALL - 1)
 			printf(" ");
 	}
 	printf("\n");
@@ -284,7 +297,7 @@ static void print_table_head(void)
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
 		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
-			(i == BTRFS_QGROUP_CHILD))
+			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_PATH))
 			printf("%-*s", max_len, btrfs_qgroup_columns[i].name);
 		else
 			printf("%*s", max_len, btrfs_qgroup_columns[i].name);
@@ -296,7 +309,7 @@ static void print_table_head(void)
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
 		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
-			(i == BTRFS_QGROUP_CHILD)) {
+			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_PATH)) {
 			len = strlen(btrfs_qgroup_columns[i].name);
 			while (len--)
 				printf("-");
@@ -619,8 +632,86 @@ static struct btrfs_qgroup *get_or_add_qgroup(
 	return bq;
 }
 
-static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-			      struct btrfs_qgroup_info_item *info)
+/*
+ * Construct subvolume path for level-0 qgroup according to qgroupid.
+ *
+ * Return a potiner to the path string on success.
+ * Return NULL on error or qgroup level > 0.
+ */
+static char *qgroups_path_lookup(int fd, struct qgroup_lookup *qgroup_lookup,
+				 u64 qgroupid)
+{
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_root_ref *ref;
+	struct btrfs_ioctl_search_header sh;
+	struct btrfs_qgroup *bq;
+	char *name, *path;
+	u64 subvol_id;
+	int name_len;
+	int ret;
+
+	/* only level-0 qgroup has the corresponding subvolume*/
+	if (btrfs_qgroup_level(qgroupid))
+		return NULL;
+
+	subvol_id = btrfs_qgroup_subvid(qgroupid);
+	if (subvol_id < BTRFS_FIRST_FREE_OBJECTID ||
+			subvol_id > BTRFS_LAST_FREE_OBJECTID)
+		return NULL;
+
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
+	sk->min_type = BTRFS_ROOT_BACKREF_KEY;
+	sk->max_objectid = subvol_id;
+	sk->min_objectid = subvol_id;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	sk->nr_items = 4096;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return NULL;
+	if (!sk->nr_items)
+		return NULL;
+
+	/* resolve the ROOT_BACKREF to get the subvolume name*/
+	memcpy(&sh, args.buf, sizeof(sh));
+	ref = (struct btrfs_root_ref *)(args.buf + sizeof(sh));
+	name_len = btrfs_stack_root_ref_name_len(ref);
+	name = (char *)(ref + 1);
+
+	/*
+	 * directly return subvolume name if top level is the initial subvolume
+	 */
+	if (sh.offset == BTRFS_FS_TREE_OBJECTID)
+		return strndup(name, name_len);
+
+	/*
+	 * construct path based on the upper subvolume path and the subvolume
+	 * name
+	 */
+	bq = qgroup_tree_search(qgroup_lookup, sh.offset);
+	if (!bq || bq->qgroupid != sh.offset)
+		return NULL;
+
+	/*
+	 * 2 means the path delimiter '/' and the terminating null byte ('\0')
+	 */
+	path = malloc(strlen(name) + strlen(bq->path) + 2);
+	if (!path) {
+		perror("malloc failed");
+		exit(1);
+	}
+	sprintf(path, "%s/%s", bq->path, name);
+
+	return path;
+}
+
+static int update_qgroup_info(int fd, struct qgroup_lookup *qgroup_lookup,
+			      u64 qgroupid, struct btrfs_qgroup_info_item *info)
 {
 	struct btrfs_qgroup *bq;
 
@@ -633,6 +724,7 @@ static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	bq->rfer_cmpr = btrfs_stack_qgroup_info_referenced_compressed(info);
 	bq->excl = btrfs_stack_qgroup_info_exclusive(info);
 	bq->excl_cmpr = btrfs_stack_qgroup_info_exclusive_compressed(info);
+	bq->path = qgroups_path_lookup(fd, qgroup_lookup, qgroupid);
 
 	return 0;
 }
@@ -712,6 +804,8 @@ static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
 		list_del(&list->next_member);
 		free(list);
 	}
+	if (bq->path)
+		free(bq->path);
 	free(bq);
 }
 
@@ -985,6 +1079,11 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
+	case BTRFS_QGROUP_PATH:
+		len = bq->path ? strlen(bq->path) : 0;
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
 	default:
 		break;
 	}
@@ -1107,7 +1206,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				info = (struct btrfs_qgroup_info_item *)
 				       (args.buf + off);
 
-				ret = update_qgroup_info(qgroup_lookup,
+				ret = update_qgroup_info(fd, qgroup_lookup,
 							 qgroupid, info);
 				break;
 			case BTRFS_QGROUP_LIMIT_KEY:
diff --git a/qgroup.h b/qgroup.h
index 875fbdf3..2003f834 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -59,6 +59,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_MAX_EXCL,
 	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_CHILD,
+	BTRFS_QGROUP_PATH,
 	BTRFS_QGROUP_ALL,
 };
 
-- 
2.14.3



