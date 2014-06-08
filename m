Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaFHLEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 07:04:22 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s58B4L1G029387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 8 Jun 2014 11:04:22 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s58B4KsW005191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 8 Jun 2014 11:04:21 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s58B4KIb005187
	for <linux-btrfs@vger.kernel.org>; Sun, 8 Jun 2014 11:04:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use right type to get real comparison
Date: Sun,  8 Jun 2014 19:04:13 +0800
Message-Id: <1402225453-24555-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to make sure the point is still within the extent item, not to verify
the memory it's pointing to.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e9d9e52..d5e8c43 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1431,7 +1431,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
 		*ptr = (unsigned long)*out_eiref;
-		if ((void *)*ptr >= (void *)ei + item_size)
+		if ((unsigned long)(*ptr) >= (unsigned long)ei + item_size)
 			return -ENOENT;
 	}
 
-- 
1.8.1.4

