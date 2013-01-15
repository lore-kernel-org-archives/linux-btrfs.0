Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3AOOvF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 09:51:05 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0FEp34a016281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 14:51:04 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0FEp3C1003747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 14:51:03 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0FEp32D019141
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 08:51:03 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix crash of starting balance
Date: Tue, 15 Jan 2013 22:47:57 +0800
Message-Id: <1358261277-3566-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We will crash on BUG_ON(ret == -EEXIST) when we do not resume the existing
balance but attempt to start a new one.

The steps can be:
1. start balance
2. pause balance
3. start balance

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cce6aa..3901654 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3100,7 +3100,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		goto out;
 
 	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
-		BUG_ON(ret == -EEXIST);
+		/*
+		 * This can happen when we do not resume the existing balance
+		 * but try to start a new one instead.
+		 */
+		if (ret == -EEXIST)
+			goto out;
 		set_balance_control(bctl);
 	} else {
 		BUG_ON(ret != -EEXIST);
-- 
1.7.7.6

