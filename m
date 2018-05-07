Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18537 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752265AbeEGIuh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 04:50:37 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2F3624B34D23
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 16:50:36 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: qgroup: swap the argument in the caller of update_qgroup_relation
Date: Mon, 7 May 2018 16:50:27 +0800
Message-ID: <20180507085027.23059-1-lufq.fnst@cn.fujitsu.com>
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
 qgroup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 11659e8394dd..e7e127daf5ce 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1122,11 +1122,16 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				qgroupid = btrfs_search_header_offset(sh);
 				qgroupid1 = btrfs_search_header_objectid(sh);
 
-				if (qgroupid < qgroupid1)
+				if (qgroupid <= qgroupid1)
 					break;
 
+				/*
+				 * because of qgroupid > qgroupid1, qgroupid is
+				 * the id of parent, and qgroupid1 is the id of
+				 * child.
+				 */
 				ret = update_qgroup_relation(qgroup_lookup,
-							qgroupid, qgroupid1);
+							qgroupid1, qgroupid);
 				break;
 			default:
 				return ret;
-- 
2.17.0



