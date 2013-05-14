Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50400 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3ENCMd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 22:12:33 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4E2CV9H032048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 02:12:32 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4E2CUtO003078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 02:12:31 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4E2CUYG003069
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 02:12:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: return errno if possible when we fail to allocate memory
Date: Tue, 14 May 2013 10:12:15 +0800
Message-Id: <1368497535-15534-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to set return value explicitly, otherwise we'll lose the error
value.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1669c3b..99a9c25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -714,8 +714,10 @@ retry:
 					async_extent->ram_size - 1, 0);
 
 		em = alloc_extent_map();
-		if (!em)
+		if (!em) {
+			ret = -ENOMEM;
 			goto out_free_reserve;
+		}
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
 		em->orig_start = em->start;
@@ -922,8 +924,10 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		}
 
 		em = alloc_extent_map();
-		if (!em)
+		if (!em) {
+			ret = -ENOMEM;
 			goto out_reserve;
+		}
 		em->start = start;
 		em->orig_start = em->start;
 		ram_size = ins.offset;
-- 
1.7.7.6

