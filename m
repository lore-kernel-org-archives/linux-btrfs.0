Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947450AbeCBSrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:16 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 225BFAE8D
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:15 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
Date: Fri,  2 Mar 2018 13:47:02 -0500
Message-Id: <20180302184704.22399-7-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The only mechanism we have in the progs for searching qgroups is to load
all of them and filter the results.  This works for qgroup show but
to add quota information to 'btrfs subvoluem show' it's pretty wasteful.

This patch splits out setting up the search and performing the search so
we can search for a single qgroupid more easily.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 qgroup.c | 98 +++++++++++++++++++++++++++++++++++++++++++++-------------------
 qgroup.h |  7 +++++
 2 files changed, 77 insertions(+), 28 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index b1be3311..2d0a6947 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1146,11 +1146,11 @@ static inline void print_status_flag_warning(u64 flags)
 		warning("qgroup data inconsistent, rescan recommended");
 }
 
-static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
+static int __qgroups_search(int fd, struct btrfs_ioctl_search_args *args,
+			    struct qgroup_lookup *qgroup_lookup)
 {
 	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_key *sk = &args->key;
 	struct btrfs_ioctl_search_header *sh;
 	unsigned long off = 0;
 	unsigned int i;
@@ -1161,30 +1161,12 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	u64 qgroupid;
 	u64 qgroupid1;
 
-	memset(&args, 0, sizeof(args));
-
-	sk->tree_id = BTRFS_QUOTA_TREE_OBJECTID;
-	sk->max_type = BTRFS_QGROUP_RELATION_KEY;
-	sk->min_type = BTRFS_QGROUP_STATUS_KEY;
-	sk->max_objectid = (u64)-1;
-	sk->max_offset = (u64)-1;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 4096;
-
 	qgroup_lookup_init(qgroup_lookup);
 
 	while (1) {
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, args);
 		if (ret < 0) {
-			if (errno == ENOENT) {
-				error("can't list qgroups: quotas not enabled");
-				ret = -ENOTTY;
-			} else {
-				error("can't list qgroups: %s",
-				       strerror(errno));
-				ret = -errno;
-			}
-
+			ret = -errno;
 			break;
 		}
 
@@ -1198,14 +1180,14 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 		 * read the root_ref item it contains
 		 */
 		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+			sh = (struct btrfs_ioctl_search_header *)(args->buf +
 								  off);
 			off += sizeof(*sh);
 
 			switch (btrfs_search_header_type(sh)) {
 			case BTRFS_QGROUP_STATUS_KEY:
 				si = (struct btrfs_qgroup_status_item *)
-				     (args.buf + off);
+				     (args->buf + off);
 				flags = btrfs_stack_qgroup_status_flags(si);
 
 				print_status_flag_warning(flags);
@@ -1213,7 +1195,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 			case BTRFS_QGROUP_INFO_KEY:
 				qgroupid = btrfs_search_header_offset(sh);
 				info = (struct btrfs_qgroup_info_item *)
-				       (args.buf + off);
+				       (args->buf + off);
 
 				ret = update_qgroup_info(fd, qgroup_lookup,
 							 qgroupid, info);
@@ -1221,7 +1203,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 			case BTRFS_QGROUP_LIMIT_KEY:
 				qgroupid = btrfs_search_header_offset(sh);
 				limit = (struct btrfs_qgroup_limit_item *)
-					(args.buf + off);
+					(args->buf + off);
 
 				ret = update_qgroup_limit(fd, qgroup_lookup,
 							  qgroupid, limit);
@@ -1267,6 +1249,66 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	return ret;
 }
 
+static int qgroups_search_all(int fd, struct qgroup_lookup *qgroup_lookup)
+{
+	struct btrfs_ioctl_search_args args = {
+		.key = {
+			.tree_id = BTRFS_QUOTA_TREE_OBJECTID,
+			.max_type = BTRFS_QGROUP_RELATION_KEY,
+			.min_type = BTRFS_QGROUP_STATUS_KEY,
+			.max_objectid = (u64)-1,
+			.max_offset = (u64)-1,
+			.max_transid = (u64)-1,
+			.nr_items = 4096,
+		},
+	};
+	int ret;
+
+	ret = __qgroups_search(fd, &args, qgroup_lookup);
+	if (ret == -ENOTTY)
+		error("can't list qgroups: quotas not enabled");
+	else if (ret < 0)
+		error("can't list qgroups: %s", strerror(-ret));
+	return ret;
+}
+
+int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_stats *stats)
+{
+	struct btrfs_ioctl_search_args args = {
+		.key = {
+			.tree_id = BTRFS_QUOTA_TREE_OBJECTID,
+			.min_type = BTRFS_QGROUP_INFO_KEY,
+			.max_type = BTRFS_QGROUP_LIMIT_KEY,
+			.max_objectid = 0,
+			.max_offset = qgroupid,
+			.max_transid = (u64)-1,
+			.nr_items = 4096, /* should be 2, i think */
+		},
+	};
+	struct qgroup_lookup qgroup_lookup;
+	struct btrfs_qgroup *qgroup;
+	struct rb_node *n;
+	int ret;
+
+	ret = __qgroups_search(fd, &args, &qgroup_lookup);
+	if (ret < 0)
+		return ret;
+
+	ret = -ENODATA;
+	n = rb_first(&qgroup_lookup.root);
+	if (n) {
+		qgroup = rb_entry(n, struct btrfs_qgroup, rb_node);
+		stats->qgroupid = qgroup->qgroupid;
+		stats->info = qgroup->info;
+		stats->limit = qgroup->limit;
+
+		ret = 0;
+	}
+
+	__free_all_qgroups(&qgroup_lookup);
+	return ret;
+}
+
 static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, bool verbose)
 {
 
@@ -1293,7 +1335,7 @@ int btrfs_show_qgroups(int fd,
 	struct qgroup_lookup sort_tree;
 	int ret;
 
-	ret = __qgroups_search(fd, &qgroup_lookup);
+	ret = qgroups_search_all(fd, &qgroup_lookup);
 	if (ret)
 		return ret;
 	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
diff --git a/qgroup.h b/qgroup.h
index 5e71349c..688f92b2 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -87,6 +87,12 @@ struct btrfs_qgroup_info {
 	u64 exclusive_compressed;
 };
 
+struct btrfs_qgroup_stats {
+	u64 qgroupid;
+	struct btrfs_qgroup_info info;
+	struct btrfs_qgroup_limit limit;
+};
+
 int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
@@ -105,4 +111,5 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
 int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
 			    int type);
 
+int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_stats *stats);
 #endif
-- 
2.15.1

