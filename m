Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:43711 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbdCGExO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 23:53:14 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v272ODdY006622
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 02:24:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] Btrfs: fix regression in lock_delalloc_pages
Date: Mon,  6 Mar 2017 18:20:56 -0800
Message-Id: <1488853256-10867-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug is a regression after commit
(da2c7009f6ca "btrfs: teach __process_pages_contig about PAGE_LOCK operation")
and commit
(76c0021db8fd "Btrfs: use helper to simplify lock/unlock pages").

So if the dirty pages which are under writeback got truncated partially
before we lock the dirty pages, we couldn't find all pages mapping to the
delalloc range, and the bug didn't return an error so it kept going on and
found that the delalloc range got truncated and got to unlock the dirty
pages, and then the ASSERT could caught the error, and showed

-----------------------------------------------------------------------------
assertion failed: page_ops & PAGE_LOCK, file: fs/btrfs/extent_io.c, line: 1716
-----------------------------------------------------------------------------

This fixes the bug by returning the proper -EAGAIN.

Cc: David Sterba <dsterba@suse.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28e8192..8df7974 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1714,7 +1714,8 @@ static int __process_pages_contig(struct address_space *mapping,
 			 * can we find nothing at @index.
 			 */
 			ASSERT(page_ops & PAGE_LOCK);
-			return ret;
+			err = -EAGAIN;
+			goto out;
 		}
 
 		for (i = 0; i < ret; i++) {
-- 
2.5.5

