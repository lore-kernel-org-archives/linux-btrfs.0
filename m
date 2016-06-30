Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51225 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbcF3Ayz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 20:54:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5U0smZI004745
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 00:54:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u5U0smaE006930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 00:54:48 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u5U0sltG029297
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 00:54:47 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: remove BUG() in raid56
Date: Wed, 29 Jun 2016 17:57:56 -0700
Message-Id: <1467248276-12310-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This BUG() has been triggered by a fuzz testing image, but in fact
btrfs can handle this gracefully by returning -EIO.

Thus, use btrfs_warn to give us more debugging information than a 
single BUG() and return error properly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: - use btrfs_warn with more debugging information instead of WARN_ONCE.
    - change the patch title.

 fs/btrfs/raid56.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f8b6d41..5f4712c 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2139,7 +2139,10 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-		BUG();
+		btrfs_warn(root->fs_info,
+	"rbio->faila is -1: (bio has logical %llu len %llu, bbio has map_type %llu)",
+			   (u64)bio->bi_iter.bi_sector << 9,
+			   (u64)bio->bi_iter.bi_size, bbio->map_type);
 		if (generic_io)
 			btrfs_put_bbio(bbio);
 		kfree(rbio);
-- 
2.5.5

