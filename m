Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46436 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2JRHLd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 03:11:33 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9I7BVO7020298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 07:11:32 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9I7BVR4029721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 07:11:31 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9I7BUo7021951
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 02:11:30 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup for __merge_refs
Date: Thu, 18 Oct 2012 15:10:42 +0800
Message-Id: <1350544242-2271-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parents must be same after going through ref_for_same_block.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f318793..9aaa38e6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -469,11 +469,6 @@ static int __merge_refs(struct list_head *head, int mode)
 			if (mode == 1) {
 				if (!ref_for_same_block(ref1, ref2))
 					continue;
-				if (!ref1->parent && ref2->parent) {
-					xchg = ref1;
-					ref1 = ref2;
-					ref2 = xchg;
-				}
 				ref1->count += ref2->count;
 			} else {
 				if (ref1->parent != ref2->parent)
@@ -483,7 +478,6 @@ static int __merge_refs(struct list_head *head, int mode)
 			list_del(&ref2->list);
 			kfree(ref2);
 		}
-
 	}
 	return 0;
 }
-- 
1.7.7.6

