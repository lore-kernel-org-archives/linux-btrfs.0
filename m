Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750917AbeC0Idx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 04:33:53 -0400
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C382183B
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 08:33:52 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix copy_items() return value when logging an inode
Date: Mon, 26 Mar 2018 23:59:12 +0100
Message-Id: <20180326225912.10049-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When logging an inode, at tree-log.c:copy_items(), if we call
btrfs_next_leaf() at the loop which checks for the need to log holes, we
need to make sure copy_items() returns the value 1 to its caller and
not 0 (on success). This is because the path the caller passed was
released and is now different from what is was before, and the caller
expects a return value of 0 to mean both success and that the path
has not changed, while a return value of 1 means both success and
signals the caller that it can not reuse the path, it has to perform
another tree search.

Even though this is a case that should not be triggered on normal
circumstances or very rare at least, its consequences can be very
unpredictable (especially when replaying a log tree).

Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole extents")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d738ff5c41b..abd9fd81cd1c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3960,6 +3960,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			ASSERT(ret == 0);
 			src = src_path->nodes[0];
 			i = 0;
+			need_find_last_extent = true;
 		}
 
 		btrfs_item_key_to_cpu(src, &key, i);
-- 
2.11.0

