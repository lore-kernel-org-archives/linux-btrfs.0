Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbeHDPLx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:11:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 45C3C4B6ADEE
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:11:06 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs: remove a useless return statement in btrfs_block_rsv_add
Date: Sat, 4 Aug 2018 21:10:56 +0800
Message-ID: <20180804131057.9967-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since ret must be 0 here, don't have to return separately in advance.

No functional change.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4fb20f77d6b1..8bebf122d4b3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5539,10 +5539,8 @@ int btrfs_block_rsv_add(struct btrfs_root *root,
 		return 0;
 
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
-	if (!ret) {
+	if (!ret)
 		block_rsv_add_bytes(block_rsv, num_bytes, true);
-		return 0;
-	}
 
 	return ret;
 }
-- 
2.18.0



