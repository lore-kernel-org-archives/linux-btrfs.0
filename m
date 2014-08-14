Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35538 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNKZ7 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 14 Aug 2014 06:25:59 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: shrink further sizeof(struct extent_buffer)
Date: Thu, 14 Aug 2014 12:25:14 +0100
Message-Id: <1408015514-18021-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The map_start and map_len fields aren't used anywhere, so just remove
them. On a x86_64 system, this reduced sizeof(struct extent_buffer)
from 296 bytes to 280 bytes, and therefore 14 extent_buffer structs can
now fit into a page instead of 13.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ce02cc9..5e91fb9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -125,8 +125,6 @@ struct extent_state {
 struct extent_buffer {
 	u64 start;
 	unsigned long len;
-	unsigned long map_start;
-	unsigned long map_len;
 	unsigned long bflags;
 	struct btrfs_fs_info *fs_info;
 	spinlock_t refs_lock;
-- 
1.9.1

