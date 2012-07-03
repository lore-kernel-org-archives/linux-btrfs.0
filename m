Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42000 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2GCEI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 00:08:59 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q6348vHl031142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 04:08:58 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q6348vKO027541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 04:08:57 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q6348v6q011214
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Jul 2012 23:08:57 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] btrfs read error corrected message floods the console during recovery
Date: Tue,  3 Jul 2012 12:05:21 +0800
Message-Id: <1341288321-2749-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Changing printk_in_rcu to printk_ratelimited_in_rcu will suffice
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aaa12c1..5ad8743 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1918,7 +1918,7 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 		return -EIO;
 	}
 
-	printk_in_rcu(KERN_INFO "btrfs read error corrected: ino %lu off %llu "
+	printk_ratelimited_in_rcu(KERN_INFO "btrfs read error corrected: ino %lu off %llu "
 		      "(dev %s sector %llu)\n", page->mapping->host->i_ino,
 		      start, rcu_str_deref(dev->name), sector);
 
-- 
1.7.1

