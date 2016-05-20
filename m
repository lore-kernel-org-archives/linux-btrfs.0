Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbcETPIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:08:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C307420364
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:38 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 9EC802012D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:37 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: fix unprotected assignment of the left cursor for device replace
Date: Fri, 20 May 2016 05:44:58 +0100
Message-Id: <1463719498-2057-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were assigning new values to fields of the device replace object
without holding the respective lock after processing each device extent.
This is important for the left cursor field which can be accessed by a
concurrent task running __btrfs_map_block (which, correctly, takes the
device replace lock).
So change these fields while holding the device replace lock.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a181b52..a58e0ae 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3640,9 +3640,11 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			break;
 		}
 
+		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
+		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
 		ret = scrub_chunk(sctx, scrub_dev, chunk_offset, length,
 				  found_key.offset, cache, is_dev_replace);
 
@@ -3716,8 +3718,10 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			break;
 		}
 
+		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;
+		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
 skip:
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
-- 
2.7.0.rc3

