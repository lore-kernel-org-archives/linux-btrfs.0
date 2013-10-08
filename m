Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25017 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3JHKTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 06:19:55 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r98AJrIN024357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:54 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJr8e028856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:53 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJrfl028802
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: kill unused code in btrfs_search_forward
Date: Tue,  8 Oct 2013 18:19:43 +0800
Message-Id: <1381227583-6873-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After commit de78b51a2852bddccd6535e9e12de65f92787a1e
(btrfs: remove cache only arguments from defrag path), @blockptr is no more
used.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 61b5bcd..ea20801 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4911,10 +4911,8 @@ again:
 		 * If it is too old, old, skip to the next one.
 		 */
 		while (slot < nritems) {
-			u64 blockptr;
 			u64 gen;
 
-			blockptr = btrfs_node_blockptr(cur, slot);
 			gen = btrfs_node_ptr_generation(cur, slot);
 			if (gen < min_trans) {
 				slot++;
-- 
1.8.1.4

