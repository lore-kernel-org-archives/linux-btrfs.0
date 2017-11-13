Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19224 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751534AbdKMFeQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:34:16 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 2/2] btrfs-progs: qgroup: cleanup __qgroup_search
Date: Mon, 13 Nov 2017 13:33:16 +0800
Message-ID: <20171113053316.14573-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171113053316.14573-1-lufq.fnst@cn.fujitsu.com>
References: <20171113053316.14573-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the if statement with the switch statement, and return the
appropriate value for the future use rather than directly exit.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---

Changelog:
v2:
1. revoke incorrect goto pattern
2. split the error handler movement to another patch

 qgroup.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 23463d8a..b5b893f4 100644
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
 
@@ -1092,44 +1094,47 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 								  off);
 			off += sizeof(*sh);
 
-			if (btrfs_search_header_type(sh)
-			    == BTRFS_QGROUP_STATUS_KEY) {
-				struct btrfs_qgroup_status_item *si;
-				u64 flags;
-
+			switch (btrfs_search_header_type(sh)) {
+			case BTRFS_QGROUP_STATUS_KEY:
 				si = (struct btrfs_qgroup_status_item *)
 				     (args.buf + off);
 				flags = btrfs_stack_qgroup_status_flags(si);
+
 				print_status_flag_warning(flags);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_INFO_KEY) {
+				break;
+			case BTRFS_QGROUP_INFO_KEY:
 				qgroupid = btrfs_search_header_offset(sh);
 				info = (struct btrfs_qgroup_info_item *)
 				       (args.buf + off);
 
-				update_qgroup_info(qgroup_lookup, qgroupid,
-						   info);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_LIMIT_KEY) {
+				ret = update_qgroup_info(qgroup_lookup,
+							 qgroupid, info);
+				break;
+			case BTRFS_QGROUP_LIMIT_KEY:
 				qgroupid = btrfs_search_header_offset(sh);
 				limit = (struct btrfs_qgroup_limit_item *)
 					(args.buf + off);
 
-				update_qgroup_limit(qgroup_lookup, qgroupid,
-						    limit);
-			} else if (btrfs_search_header_type(sh)
-				   == BTRFS_QGROUP_RELATION_KEY) {
+				ret = update_qgroup_limit(qgroup_lookup,
+							  qgroupid, limit);
+				break;
+			case BTRFS_QGROUP_RELATION_KEY:
 				qgroupid = btrfs_search_header_offset(sh);
 				qgroupid1 = btrfs_search_header_objectid(sh);
 
 				if (qgroupid < qgroupid1)
-					goto skip;
+					break;
+
+				ret = update_qgroup_relation(qgroup_lookup,
+							qgroupid, qgroupid1);
+				break;
+			default:
+				return ret;
+			}
+
+			if (ret)
+				return ret;
 
-				update_qgroup_relation(qgroup_lookup, qgroupid,
-						       qgroupid1);
-			} else
-				goto done;
-skip:
 			off += btrfs_search_header_len(sh);
 
 			/*
@@ -1151,7 +1156,6 @@ skip:
 			break;
 	}
 
-done:
 	return ret;
 }
 
-- 
2.15.0



