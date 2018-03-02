Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51352 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932890AbeCCAQv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 19:16:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w230Gomb019882
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:51 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2gf4g1uadg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Mar 2018 00:16:50 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w230G5CI008516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w230G5Ei006158
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: scrub: remove unnecessary variable set
Date: Fri,  2 Mar 2018 16:10:40 -0700
Message-Id: <20180302231041.10442-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable "success" is only checked when !sctx->is_dev_replace.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3203a1..1b5ce2f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1444,7 +1444,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 							    page_num) != 0) {
 				btrfs_dev_replace_stats_inc(
 					&fs_info->dev_replace.num_write_errors);
-				success = 0;
 			}
 		} else if (sblock_other) {
 			ret = scrub_repair_page_from_good_copy(sblock_bad,
-- 
2.9.4

