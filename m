Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752437AbeAZIaz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:55 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 377F449F19BC
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:48 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 06/15] btrfs-progs: lowmem check: let check_dir_item() return if repaired
Date: Fri, 26 Jan 2018 16:35:10 +0800
Message-ID: <20180126083519.28373-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If repair_dir_item deleted the item, goto last checked then returns
instead of searching di_key again then returns -ENOENT.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index eb65a18fe64b..4ce6139b3ab1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5931,7 +5931,7 @@ begin:
 				path->slots[0]--;
 		}
 		if (ret)
-			goto out;
+			return err;
 	}
 
 	node = path->nodes[0];
@@ -6040,7 +6040,7 @@ next:
 			break;
 		}
 	}
-out:
+
 	/* research path */
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, di_key, path, 0, 0);
-- 
2.16.1



