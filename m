Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaD2FII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 01:08:08 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s3T586uw011141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:07 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s3T585cF017699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:06 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3T585Wr002628
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 05:08:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not increment on bio_index one by one
Date: Tue, 29 Apr 2014 13:07:58 +0800
Message-Id: <1398748078-5832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'bio_index' is just a index, it's really not necessary to do increment
one by one.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9d84658..344b89c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -281,10 +281,10 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 found:
 		csum += count * csum_size;
 		nblocks -= count;
+		bio_index += count;
 		while (count--) {
 			disk_bytenr += bvec->bv_len;
 			offset += bvec->bv_len;
-			bio_index++;
 			bvec++;
 		}
 	}
-- 
1.8.1.4

