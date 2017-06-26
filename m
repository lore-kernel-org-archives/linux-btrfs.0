Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48267 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbdF0A4B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 20:56:01 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5R0txhG005991
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 00:55:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v5R0twYR021993
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 00:55:59 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5R0twJB019346
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 00:55:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: convert: do not clear header rev
Date: Mon, 26 Jun 2017 17:55:02 -0600
Message-Id: <20170626235502.26267-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So btrfs_set_header_flags() vs btrfs_set_header_flag, the difference is sort of
similar to "=" vs "|=", when creating and initialising a new extent buffer,
convert uses the former one which clears header_rev by accident.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 convert/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/convert/common.c b/convert/common.c
index 40bf32c..f0dd2cf 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -167,7 +167,7 @@ static int setup_temp_extent_buffer(struct extent_buffer *buf,
 	btrfs_set_header_generation(buf, 1);
 	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(buf, owner);
-	btrfs_set_header_flags(buf, BTRFS_HEADER_FLAG_WRITTEN);
+	btrfs_set_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN);
 	write_extent_buffer(buf, chunk_uuid, btrfs_header_chunk_tree_uuid(buf),
 			    BTRFS_UUID_SIZE);
 	write_extent_buffer(buf, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
-- 
2.5.0

