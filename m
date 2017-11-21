Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48763 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751555AbdKUKLx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 05:11:53 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 98948487F163
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 18:11:48 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: check: do not reset ret after try_repair_inode
Date: Tue, 21 Nov 2017 18:15:23 +0800
Message-ID: <20171121101524.2014-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After failure of try_repair_inode(), the value @ret will be reseted
anyway. Then counter @error won't be incremented.

So do not reset @ret after try_repair_inode().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5c15dfb60b9a..68348ae94c8b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3968,7 +3968,6 @@ static int check_inode_recs(struct btrfs_root *root,
 				free_inode_rec(rec);
 				continue;
 			}
-			ret = 0;
 		}
 
 		if (!(repair && ret == 0))
-- 
2.15.0



