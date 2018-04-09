Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751886AbeDIGk5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 02:40:57 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 520374D0EFE7
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 14:40:52 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: print-tree: remove dead code from btrfs_print_tree
Date: Mon, 9 Apr 2018 14:40:44 +0800
Message-ID: <20180409064044.1699-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the out label has been deleted, this free_extent_buffer will never
be executed.

Fixes: f37ae8d275c2 ("btrfs-progs: print-tree: Enhance warning on tree block level mismatch and error handling")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 print-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a2f6bfc027c9..44e9b40a9874 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1416,6 +1416,4 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 	}
 
 	return;
-
-	free_extent_buffer(next);
 }
-- 
2.16.3



