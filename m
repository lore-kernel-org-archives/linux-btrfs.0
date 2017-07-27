Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdG0Sw7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 14:52:59 -0400
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728C322C93
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 18:52:58 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid unnecessarily locking inode when clearing a range
Date: Thu, 27 Jul 2017 19:52:55 +0100
Message-Id: <20170727185255.5122-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If the range being cleared was not marked for defrag and we are not
about to clear the range from the defrag status, we don't need to
lock and unlock the inode.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eb495e956d53..51c45c0a8553 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1797,10 +1797,11 @@ static void btrfs_clear_bit_hook(void *private_data,
 	u64 len = state->end + 1 - state->start;
 	u32 num_extents = count_max_extents(len);
 
-	spin_lock(&inode->lock);
-	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
+	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
+		spin_lock(&inode->lock);
 		inode->defrag_bytes -= len;
-	spin_unlock(&inode->lock);
+		spin_unlock(&inode->lock);
+	}
 
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-- 
2.11.0

