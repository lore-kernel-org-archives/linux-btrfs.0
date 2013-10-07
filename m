Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33780 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3JGKn2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 06:43:28 -0400
Received: by mail-ea0-f180.google.com with SMTP id h10so3079910eaj.25
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 03:43:26 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH] Btrfs: fix the dev-replace suspend sequence
Date: Mon,  7 Oct 2013 13:42:57 +0300
Message-Id: <1381142577-7957-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace progresses strictly from lower to higher offsets, and the
progress is tracked in chunks, by storing the physical offset of the
dev_extent which is being copied in the cursor_left field of
btrfs_dev_replace_item.  When we are done copying the chunk,
left_cursor is updated to point one byte past the dev_extent, so that
on resume we can skip the dev_extents that have already been copied.

There is a major bug (which goes all the way back to the inception of
dev-replace in 3.8) in the way left_cursor is bumped: the bump is done
unconditionally, without any regard to the scrub_chunk return value.
On suspend (and also on any kind of error) scrub_chunk returns early,
i.e. without completing the copy.  This leads to us skipping the chunk
that hasn't been fully copied yet when resuming.

Fix this by doing the cursor_left update only if scrub_chunk ret is 0.
(On suspend scrub_chunk returns with -ECANCELED, so this fix covers
both suspend and error cases.)

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/scrub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a18e0e2..f21e2df 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2717,8 +2717,6 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		mutex_unlock(&fs_info->scrub_lock);
 		wake_up(&fs_info->scrub_pause_wait);
 
-		dev_replace->cursor_left = dev_replace->cursor_right;
-		dev_replace->item_needs_writeback = 1;
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
@@ -2732,6 +2730,9 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			break;
 		}
 
+		dev_replace->cursor_left = dev_replace->cursor_right;
+		dev_replace->item_needs_writeback = 1;
+
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
 	}
-- 
1.7.10.4

