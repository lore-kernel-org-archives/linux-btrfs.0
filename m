Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41997 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3KVQxF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 11:53:05 -0500
Received: by mail-wi0-f173.google.com with SMTP id hm4so1012466wib.12
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 08:53:03 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: avoid unnecessary ordered extent cache resets
Date: Fri, 22 Nov 2013 16:52:43 +0000
Message-Id: <1385139163-7539-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After an ordered extent completes, don't blindly reset the
inode's ordered tree last accessed ordered extent pointer.

While running the xfstests I noticed that about 29% of the
time the ordered extent to which tree->last pointed was not
the same as our just completed ordered extent. After that I
ran the following sysbench test (after a prepare phase) and
noticed that about 68% of the time tree->last pointed to
a different ordered extent too.

sysbench --test=fileio --file-num=32 --file-total-size=4G \
    --file-test-mode=rndwr --num-threads=512 \
    --file-block-size=32768 --max-time=60 --max-requests=0 run

Therefore reset tree->last on ordered extent removal only if
it pointed to the ordered extent we're removing from the tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ordered-data.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 69582d5..b8c2ded 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -520,7 +520,8 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	spin_lock_irq(&tree->lock);
 	node = &entry->rb_node;
 	rb_erase(node, &tree->tree);
-	tree->last = NULL;
+	if (tree->last == node)
+		tree->last = NULL;
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 	spin_unlock_irq(&tree->lock);
 
-- 
1.7.9.5

