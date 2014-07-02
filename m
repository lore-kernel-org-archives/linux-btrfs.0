Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34590 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbaGBSaQ (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 2 Jul 2014 14:30:16 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: read lock extent buffer while walking backrefs
Date: Wed,  2 Jul 2014 20:07:54 +0100
Message-Id: <1404328074-3751-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before processing the extent buffer, acquire a read lock on it, so
that we're safe against concurrent updates on the extent buffer.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/backref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e25564b..a1efd39 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1001,8 +1001,11 @@ again:
 					ret = -EIO;
 					goto out;
 				}
+				btrfs_tree_read_lock(eb);
+				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
+				btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
 					goto out;
-- 
1.9.1

