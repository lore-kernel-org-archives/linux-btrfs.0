Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:62993 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751930AbdJaJOg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:14:36 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs-progs: qgroup: cleanup __qgroup_search, no functional change
Date: Tue, 31 Oct 2017 17:13:45 +0800
Message-ID: <20171031091345.9325-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. Use goto instead of while (1) to reduce the level of indentation
2. Replace the if statement with the switch statement
3. move the BTRFS_IOC_TREE_SEARCH ioctl error handler to __qgroup_search

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |   4 --
 qgroup.c      | 152 +++++++++++++++++++++++++++++++---------------------------
 2 files changed, 81 insertions(+), 75 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea9..d07bb0c0 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -399,10 +399,6 @@ static int cmd_qgroup_show(int argc, char **argv)
 					qgroupid);
 	}
 	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
-	if (ret == -ENOENT)
-		error("can't list qgroups: quotas not enabled");
-	else if (ret < 0)
-		error("can't list qgroups: %s", strerror(-ret));
 	close_file_or_dir(fd, dirstream);
 
 out:
diff --git a/qgroup.c b/qgroup.c
index 10059e71..b4602b2e 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1046,8 +1046,10 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	struct btrfs_ioctl_search_header *sh;
 	unsigned long off = 0;
 	unsigned int i;
+	struct btrfs_qgroup_status_item *si;
 	struct btrfs_qgroup_info_item *info;
 	struct btrfs_qgroup_limit_item *limit;
+	u64 flags;
 	u64 qgroupid;
 	u64 qgroupid1;
 
@@ -1063,85 +1065,93 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 
 	qgroup_lookup_init(qgroup_lookup);
 
-	while (1) {
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		if (ret < 0)
-			return -errno;
+next:
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0) {
+		if (errno == ENOENT) {
+			error("can't list qgroups: quotas not enabled");
+			ret = -ENOTTY;
+		} else {
+			error("can't list qgroups: %s", strerror(errno));
+			ret = -errno;
+		}
 
-		/* the ioctl returns the number of item it found in nr_items */
-		if (sk->nr_items == 0)
+		return ret;
+	}
+
+	/* the ioctl returns the number of item it found in nr_items */
+	if (sk->nr_items == 0)
+		return ret;
+
+	off = 0;
+	/*
+	 * for each item, pull the key out of the header and then
+	 * read the root_ref item it contains
+	 */
+	for (i = 0; i < sk->nr_items; i++) {
+		sh = (struct btrfs_ioctl_search_header *)(args.buf + off);
+		off += sizeof(*sh);
+
+		switch (btrfs_search_header_type(sh)) {
+		case BTRFS_QGROUP_STATUS_KEY:
+			si = (struct btrfs_qgroup_status_item *)
+				(args.buf + off);
+			flags = btrfs_stack_qgroup_status_flags(si);
+
+			print_status_flag_warning(flags);
 			break;
+		case BTRFS_QGROUP_INFO_KEY:
+			qgroupid = btrfs_search_header_offset(sh);
+			info = (struct btrfs_qgroup_info_item *)
+			       (args.buf + off);
 
-		off = 0;
-		/*
-		 * for each item, pull the key out of the header and then
-		 * read the root_ref item it contains
-		 */
-		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
-			off += sizeof(*sh);
-
-			if (btrfs_search_header_type(sh)
-			    == BTRFS_QGROUP_STATUS_KEY) {
-				struct btrfs_qgroup_status_item *si;
-				u64 flags;
-
-				si = (struct btrfs_qgroup_status_item *)
-				     (args.buf + off);
-				flags = btrfs_stack_qgroup_status_flags(si);
-				print_status_flag_warning(flags);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_INFO_KEY) {
-				qgroupid = btrfs_search_header_offset(sh);
-				info = (struct btrfs_qgroup_info_item *)
-				       (args.buf + off);
-
-				update_qgroup_info(qgroup_lookup, qgroupid,
-						   info);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_LIMIT_KEY) {
-				qgroupid = btrfs_search_header_offset(sh);
-				limit = (struct btrfs_qgroup_limit_item *)
-					(args.buf + off);
-
-				update_qgroup_limit(qgroup_lookup, qgroupid,
-						    limit);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_RELATION_KEY) {
-				qgroupid = btrfs_search_header_offset(sh);
-				qgroupid1 = btrfs_search_header_objectid(sh);
-
-				if (qgroupid < qgroupid1)
-					goto skip;
-
-				update_qgroup_relation(qgroup_lookup, qgroupid,
-						       qgroupid1);
-			} else
-				goto done;
-skip:
-			off += btrfs_search_header_len(sh);
-
-			/*
-			 * record the mins in sk so we can make sure the
-			 * next search doesn't repeat this root
-			 */
-			sk->min_type = btrfs_search_header_type(sh);
-			sk->min_offset = btrfs_search_header_offset(sh);
-			sk->min_objectid = btrfs_search_header_objectid(sh);
+			ret = update_qgroup_info(qgroup_lookup, qgroupid, info);
+			break;
+		case BTRFS_QGROUP_LIMIT_KEY:
+			qgroupid = btrfs_search_header_offset(sh);
+			limit = (struct btrfs_qgroup_limit_item *)
+				(args.buf + off);
+
+			ret = update_qgroup_limit(qgroup_lookup, qgroupid,
+						  limit);
+			break;
+		case BTRFS_QGROUP_RELATION_KEY:
+			qgroupid = btrfs_search_header_offset(sh);
+			qgroupid1 = btrfs_search_header_objectid(sh);
+
+			if (qgroupid < qgroupid1)
+				break;
+
+			ret = update_qgroup_relation(qgroup_lookup, qgroupid,
+						     qgroupid1);
+			break;
+		default:
+			return ret;
 		}
-		sk->nr_items = 4096;
+
+		if (ret)
+			return ret;
+
+		off += btrfs_search_header_len(sh);
+
 		/*
-		 * this iteration is done, step forward one qgroup for the next
-		 * ioctl
+		 * record the mins in sk so we can make sure the
+		 * next search doesn't repeat this root
 		 */
-		if (sk->min_offset < (u64)-1)
-			sk->min_offset++;
-		else
-			break;
+		sk->min_type = btrfs_search_header_type(sh);
+		sk->min_offset = btrfs_search_header_offset(sh);
+		sk->min_objectid = btrfs_search_header_objectid(sh);
+	}
+	sk->nr_items = 4096;
+	/*
+	 * this iteration is done, step forward one qgroup for the next
+	 * ioctl
+	 */
+	if (sk->min_offset < (u64)-1) {
+		sk->min_offset++;
+		goto next;
 	}
 
-done:
 	return ret;
 }
 
-- 
2.14.3



