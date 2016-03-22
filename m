Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbcCVBiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:50 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 69A99405641A
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 09:37:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 21/27] btrfs: Fix a memory leak in inband dedupe hash
Date: Tue, 22 Mar 2016 09:35:46 +0800
Message-Id: <1458610552-9845-22-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We allocate a dedupe hash into async_extent, but forget to free it.
Fix it by freeing the hash before freeing async_extent.

Reported-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 979811c..81b19193 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -751,6 +751,7 @@ retry:
 						  WB_SYNC_ALL);
 			else if (ret)
 				unlock_page(async_cow->locked_page);
+			kfree(hash);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -876,6 +877,7 @@ retry:
 			free_async_extent_pages(async_extent);
 		}
 		alloc_hint = ins.objectid + ins.offset;
+		kfree(hash);
 		kfree(async_extent);
 		cond_resched();
 	}
@@ -892,6 +894,7 @@ out_free:
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
 				     PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
+	kfree(hash);
 	kfree(async_extent);
 	goto again;
 }
-- 
2.7.3



