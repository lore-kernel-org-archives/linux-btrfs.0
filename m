Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33486 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdHARP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:56 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFtMt002174
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFtrH014008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFseA022953
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/14] Btrfs: raid56: use the readahead helper to get page
Date: Tue,  1 Aug 2017 10:14:33 -0600
Message-Id: <20170801161439.13426-11-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updates recovery code to use the readahead helper.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24f7cbb..8f47e56 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1608,7 +1608,9 @@ static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_recover_ctx *ctx)
 {
 	struct btrfs_r5l_meta_block *mb;
 
-	btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos >> 9), PAGE_SIZE, ctx->meta_page, REQ_OP_READ);
+	ret = btrfs_r5l_recover_read_page(ctx, ctx->meta_page, ctx->pos);
+	if (ret)
+		return ret;
 
 	mb = kmap(ctx->meta_page);
 #ifdef BTRFS_DEBUG_R5LOG
-- 
2.9.4

