Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58578 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752763AbeAIHsd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 02:48:33 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 2/3 v2] btrfs-progs: check: do not reset ret after try_repair_inode
Date: Tue, 9 Jan 2018 15:52:51 +0800
Message-ID: <20180109075251.17264-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If repair is enabled and try_repair_inode() failed in
check_inode_recs(), then value @ret will be reset to 0 anyway.
Then counter @error won't be incremented.

In other words, if previous check of the root directory is fine,
check_inode_recs() always returns 0 even it failed to repair inodes.

So do not reset @ret after try_repair_inode().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changlog:
v1->v2:
	Add more detailed commit message.
---
 cmds-check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 635c1c44ff6f..00cbc0114b22 100644
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
2.15.1



