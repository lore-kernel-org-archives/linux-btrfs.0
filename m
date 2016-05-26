Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcEZHBt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 03:01:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@kernel.org, fdmanana@suse.com
Subject: [PATCH] btrfs: Add debug warning for new block group reservations
Date: Thu, 26 May 2016 15:01:25 +0800
Message-Id: <20160526070125.6850-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the we are using atomic and wait queue for block group
reservations and it's not controlled by lockdep, we need pay much more
attention to any modification to write path.

Or it's very easy to under flow block group reservations and cause lock
balance.

Add warning on for dec_block_group_reservations() if the reservations is
already minus.

Although such warning doesn't always catch the directly caller, but should
provides good enough clue for later debug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9424864..3639b44 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6243,6 +6243,7 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 	ASSERT(bg);
 	if (atomic_dec_and_test(&bg->reservations))
 		wake_up_atomic_t(&bg->reservations);
+	WARN_ON(atomic_read(&bg->reservations) < 0)
 	btrfs_put_block_group(bg);
 }
 
-- 
2.8.3



