Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13967 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934360AbeE3DAr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 23:00:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D4D8F4B41E6D
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 11:00:41 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: drop useless member qgroup_reserved of btrfs_pending_snapshot
Date: Wed, 30 May 2018 11:00:39 +0800
Message-ID: <1527649239-22774-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1527649239-22774-1-git-send-email-gujx@cn.fujitsu.com>
References: <1527649239-22774-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Since there is no more use of qgroup_reserved member in struct
btrfs_pending_snapshot, remove it.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/transaction.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8c0826bc2c7..94439482a0ec 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -139,7 +139,6 @@ struct btrfs_pending_snapshot {
 	struct btrfs_path *path;
 	/* block reservation for the operation */
 	struct btrfs_block_rsv block_rsv;
-	u64 qgroup_reserved;
 	/* extra metadata reservation for relocation */
 	int error;
 	bool readonly;
-- 
2.17.0



