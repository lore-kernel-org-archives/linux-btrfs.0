Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38307 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3EQIqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 04:46:09 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4H8k724023446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 08:46:07 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4H8k76c011065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 08:46:08 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4H8k7j5003668
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 08:46:07 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leak in replace_path
Date: Fri, 17 May 2013 16:45:44 +0800
Message-Id: <1368780344-7157-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to unlock and free extent buffer before the return.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 704a1b8..5c5b8bb 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1773,7 +1773,7 @@ again:
 			if (!eb || !extent_buffer_uptodate(eb)) {
 				ret = (!eb) ? -ENOMEM : -EIO;
 				free_extent_buffer(eb);
-				return ret;
+				break;
 			}
 			btrfs_tree_lock(eb);
 			if (cow) {
-- 
1.7.7.6

