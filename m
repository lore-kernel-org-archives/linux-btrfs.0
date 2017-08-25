Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50405 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753911AbdHYBWi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 21:22:38 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7P1Mbn1000656
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 01:22:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7P1Mb40000826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 01:22:37 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7P1MbOR018178
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 01:22:37 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use the new helper wbc_to_write_flags
Date: Thu, 24 Aug 2017 18:19:48 -0600
Message-Id: <20170825001948.7759-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updates btrfs to use the helper wbc_to_write_flags which has been
applied in ext4/xfs/f2fs/block.

Please note that, with this, btrfs's dirty pages written by a
writeback job will carry the flag REQ_BACKGROUND, which is currently
used by writeback-throttle to determine whether it should go to get a
request or wait.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a454a10..825fad6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3467,8 +3467,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	int write_flags = 0;
 	unsigned long nr_written = 0;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		write_flags = REQ_SYNC;
+	write_flags = wbc_to_write_flags(wbc);
 
 	trace___extent_writepage(page, inode, wbc);
 
@@ -3713,7 +3712,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	u32 nritems;
 	unsigned long i, num_pages;
 	unsigned long start, end;
-	int write_flags = (epd->sync_io ? REQ_SYNC : 0) | REQ_META;
+	int write_flags = wbc_to_write_flags(wbc) | REQ_META;
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
-- 
2.9.4

