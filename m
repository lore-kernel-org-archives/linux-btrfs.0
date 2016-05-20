Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbcETPIx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:08:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CD01B20374
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:51 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3100C20364
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:50 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: fix race setting block group back to RW mode during device replace
Date: Fri, 20 May 2016 05:45:10 +0100
Message-Id: <1463719510-3014-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

After it finishes processing a device extent, the device replace code sets
back the block group to RW mode and then after that it sets the left cursor
to match the logical end address of the block group, so that future writes
into extents belonging to the block group go both the source (old) and
target (new) devices. However from the moment we turn the block group
back to RW mode we have a short time window, that lasts until we update
the left cursor's value, where extents can be allocated from the block
group and written to, in which case they will not be copied/written to
the target (new) device. Fix this by updating the left cursor's value
before turning the block group back to RW mode.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a58e0ae..c4c09a8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3680,6 +3680,11 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		scrub_pause_off(fs_info);
 
+		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
+		dev_replace->cursor_left = dev_replace->cursor_right;
+		dev_replace->item_needs_writeback = 1;
+		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
+
 		if (ro_set)
 			btrfs_dec_block_group_ro(root, cache);
 
@@ -3717,11 +3722,6 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			ret = -ENOMEM;
 			break;
 		}
-
-		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
-		dev_replace->cursor_left = dev_replace->cursor_right;
-		dev_replace->item_needs_writeback = 1;
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
 skip:
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
-- 
2.7.0.rc3

