Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6052 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751289AbeEHFsT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 01:48:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D737D4B314A2
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 13:48:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] btrfs-progs: qgroup: swap the argument in the caller of update_qgroup_relation
Date: Tue, 8 May 2018 13:48:02 +0800
Message-ID: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The QGROUP_RELATION item is very special, it always exists in pairs
(objectid and offset exchange). Its objectid and offset are the ids of a
pair of parent and child qgroups, respectively. The larger one is
parent and the smaller one is child. After the following commit, the order
of the parameters is wrong and causes qgroup show to output the wrong
qgroup parent-child relationship.

Fixes: aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to reduce arguments")
Issue: #129
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V2: Rename variables instead of the comment to make it clear.

 qgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 11659e8394dd..267cd7f11a9c 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1051,7 +1051,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	struct btrfs_qgroup_limit_item *limit;
 	u64 flags;
 	u64 qgroupid;
-	u64 qgroupid1;
+	u64 child, parent;
 
 	memset(&args, 0, sizeof(args));
 
@@ -1119,14 +1119,14 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 							  qgroupid, limit);
 				break;
 			case BTRFS_QGROUP_RELATION_KEY:
-				qgroupid = btrfs_search_header_offset(sh);
-				qgroupid1 = btrfs_search_header_objectid(sh);
+				child = btrfs_search_header_offset(sh);
+				parent = btrfs_search_header_objectid(sh);
 
-				if (qgroupid < qgroupid1)
+				if (parent <= child)
 					break;
 
 				ret = update_qgroup_relation(qgroup_lookup,
-							qgroupid, qgroupid1);
+							     child, parent);
 				break;
 			default:
 				return ret;
-- 
2.17.0



