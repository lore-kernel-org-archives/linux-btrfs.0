Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35470 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbcGKLQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:16:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 232762020F
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:16:33 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 02F2C201F4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:16:31 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] Btrfs: send, avoid incorrect leaf accesses when sending utimes operations
Date: Sat,  2 Jul 2016 13:31:03 +0100
Message-Id: <1467462663-14443-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The caller of send_utimes() is supposed to be sure that the inode number
it passes to this function does actually exists in the send snapshot.
However due to logic/algorithm bugs (such as the one fixed by the patch
titled "Btrfs: send, fix invalid leaf accesses due to incorrect utimes
operations"), this might not be the case and when that happens it makes
send_utimes() access use an unrelated leaf item as the target inode item
or access beyond a leaf's boundaries (when the leaf is full and
path->slots[0] matches the number of items in the leaf).

So if the call to btrfs_search_slot() done by send_utimes() does not find
the inode item, just make sure send_utimes() returns -ENOENT and does not
silently accesses unrelated leaf items or does invalid leaf accesses, also
allowing us to easialy and deterministically catch such algorithmic/logic
bugs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 8b65396..2db8dc8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2502,6 +2502,8 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
 	if (ret < 0)
 		goto out;
 
-- 
2.7.0.rc3

