Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47425 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2KEMni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 07:43:38 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA5ChbMr006905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 12:43:38 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA5Chbot019651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 12:43:37 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA5ChbRL021623
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Nov 2012 06:43:37 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix a deadlock in aborting transaction due to ENOSPC
Date: Mon,  5 Nov 2012 20:42:08 +0800
Message-Id: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When committing a transaction, we may bail out of running delayed refs
due to ENOSPC, and then abort the current transaction to flip into readonly.

But we'll hit a deadlock on ref head's lock since we forget to release
its lock and other cleanup stuff.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..e0c4809 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2314,6 +2314,9 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 				kfree(extent_op);
 
 				if (ret) {
+					list_del_init(&locked_ref->cluster);
+					mutex_unlock(&locked_ref->mutex);
+
 					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
 					spin_lock(&delayed_refs->lock);
 					return ret;
@@ -2356,6 +2359,10 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		count++;
 
 		if (ret) {
+			if (locked_ref) {
+				list_del_init(&locked_ref->cluster);
+				mutex_unlock(&locked_ref->mutex);
+			}
 			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
 			spin_lock(&delayed_refs->lock);
 			return ret;
-- 
1.7.7.6

