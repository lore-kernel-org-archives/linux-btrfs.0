Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932890AbeCCAQG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 19:16:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w230G60V104045
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:06 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gfbt393pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Mar 2018 00:16:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w230G5lx022005
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w230G538013061
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: dev-replace: make sure target is identical to source when raid56 rebuild fails
Date: Fri,  2 Mar 2018 16:10:41 -0700
Message-Id: <20180302231041.10442-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the last step of scrub_handle_error_block, we try to combine good
copies on all possible mirrors, this works fine for raid1 and raid10,
but not for raid56 as it's doing parity rebuild.

If parity rebuild doesn't get back with correct data which matches its
checksum, in case of replace we'd rather write what is stored in the
source device than the data calculuated from parity.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1b5ce2f..f449dc6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1412,8 +1412,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		if (!page_bad->io_error && !sctx->is_dev_replace)
 			continue;
 
-		/* try to find no-io-error page in mirrors */
-		if (page_bad->io_error) {
+		if (scrub_is_page_on_raid56(sblock_bad->pagev[0])) {
+			/*
+			 * In case of dev replace, if raid56 rebuild process
+			 * didn't work out correct data, then copy the content
+			 * in sblock_bad to make sure target device is identical
+			 * to source device, instead of writing garbage data in
+			 * sblock_for_recheck array to target device.
+			 */
+			sblock_other = NULL;
+		} else if (page_bad->io_error) {
+			/* try to find no-io-error page in mirrors */
 			for (mirror_index = 0;
 			     mirror_index < BTRFS_MAX_MIRRORS &&
 			     sblocks_for_recheck[mirror_index].page_count > 0;
-- 
2.9.4

