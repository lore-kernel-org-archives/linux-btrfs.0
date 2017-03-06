Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:22999 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753891AbdCFVvk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 16:51:40 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26LpCTQ000825
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Mar 2017 21:51:12 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: update comments in cache_save_setup
Date: Mon,  6 Mar 2017 13:49:02 -0800
Message-Id: <1488836942-5191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We also don't bother to flush free space cache while with free space
tree.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be54776..ff45060 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3443,7 +3443,8 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 		/*
 		 * don't bother trying to write stuff out _if_
 		 * a) we're not cached,
-		 * b) we're with nospace_cache mount option.
+		 * b) we're with nospace_cache mount option,
+		 * c) we're with v2 space_cache (FREE_SPACE_TREE).
 		 */
 		dcs = BTRFS_DC_WRITTEN;
 		spin_unlock(&block_group->lock);
-- 
2.5.5

