Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59414 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752452AbeAZIa6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:58 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 728E649F19AF
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:50 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 10/15] btrfs-progs: check: clear I_ERR_FILE_EXTENT_DISCOUNT after repair
Date: Fri, 26 Jan 2018 16:35:14 +0800
Message-ID: <20180126083519.28373-11-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original check forgets to clear bit I_ERR_FILE_EXTENT_DISCOUNT
in rec->errors after repair.

So just do it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index ae0a9e146399..d8d9a3227c06 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3978,6 +3978,7 @@ static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
 		if (ret < 0)
 			goto out;
 	}
+	rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
 	printf("Fixed discount file extents for inode: %llu in root: %llu\n",
 	       rec->ino, root->objectid);
 out:
-- 
2.16.1



