Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29031 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdF1Waq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 18:30:46 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5SMUjsm010654
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 22:30:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v5SMUiBe000825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 22:30:45 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v5SMUgIM023574
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 22:30:43 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: convert: do not clear nodatasum flag in inode item
Date: Wed, 28 Jun 2017 15:29:49 -0600
Message-Id: <20170628212949.25403-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the current btrfs-convert, if we convert a ext4 without data checksum,
it'd not set nodatasum flag in inode item, nor create csum item, reading
file ends up with checksum errors.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 convert/source-ext2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index 1b0576b..64b95c5 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -742,7 +742,7 @@ static int ext2_check_state(struct btrfs_convert_context *cctx)
 static void ext2_convert_inode_flags(struct btrfs_inode_item *dst,
 				     struct ext2_inode *src)
 {
-	u64 flags = 0;
+	u64 flags = btrfs_stack_inode_flags(dst);
 
 	COPY_ONE_EXT2_FLAG(flags, src, APPEND);
 	COPY_ONE_EXT2_FLAG(flags, src, SYNC);
-- 
2.5.0

