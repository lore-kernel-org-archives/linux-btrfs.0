Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35595 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3C1Icc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 04:32:32 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2S8WVV0028496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:32:32 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2S8WVKK004042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:32:31 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2S8WVjr015168
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 03:32:31 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: pass NULL instead of 0
Date: Thu, 28 Mar 2013 16:30:28 +0800
Message-Id: <1364459428-5444-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

set_extent_bit()'s (u64 *failed_start) expects NULL not 0.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f173c5a..f22243f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1189,7 +1189,7 @@ int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, 0,
+	return set_extent_bit(tree, start, end, EXTENT_UPTODATE, NULL,
 			      cached_state, mask);
 }
 
-- 
1.7.7.6

