Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:65453 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFPLVH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 07:21:07 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so5533001wes.11
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 04:21:05 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove unused wait queue in struct extent_buffer
Date: Mon, 16 Jun 2014 13:14:25 +0100
Message-Id: <1402920865-3120-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The lock_wq wait queue is not used anywhere, therefore just remove it.
On a x86_64 system, this reduced sizeof(struct extent_buffer) from 320
bytes down to 296 bytes, which means a 4Kb page can now be used for
13 extent buffers instead of 12.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_io.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 8b63f2d..dbbea4f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -158,7 +158,6 @@ struct extent_buffer {
 	 * to unlock
 	 */
 	wait_queue_head_t read_lock_wq;
-	wait_queue_head_t lock_wq;
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
 #ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
-- 
1.9.1

