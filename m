Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18144 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731051AbeHAFQM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:12 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D57724B6ADE7
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:42 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/7] btrfs: Remove redundant btrfs_release_path from btrfs_unlink_subvol
Date: Wed, 1 Aug 2018 11:32:31 +0800
Message-ID: <20180801033231.23166-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although it is safe to call this on paths that no locks or extent buffers
held, removing the redundant btrfs_release_path is reasonable.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b8c131b82978..7e56a203c109 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4137,7 +4137,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		btrfs_release_path(path);
 		index = key.offset;
 	}
 	btrfs_release_path(path);
-- 
2.18.0



