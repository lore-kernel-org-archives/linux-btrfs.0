Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:35727 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab3AHTiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 14:38:10 -0500
Received: from lenny.home.zabbo.net (unknown [192.168.242.141])
	by tetsuo.zabbo.net (Postfix) with ESMTP id EFD4B72001F7
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2013 11:38:09 -0800 (PST)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix btrfs_cont_expand() freeing IS_ERR em
Date: Tue,  8 Jan 2013 11:37:58 -0800
Message-Id: <1357673878-25591-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_cont_expand() tries to free an IS_ERR em as it gets an error from
btrfs_get_extent() and breaks out of its loop.

An instance of -EEXIST was reported in the wild:

  https://bugzilla.redhat.com/show_bug.cgi?id=874407

I have no idea if that -EEXIST is surprising, or not.  Regardless, this
error handling should be cleaned up to handle other reasonable errors
(ENOMEM, EIO; whatever).

This seemed to be the only buggy freeing of the relatively rare IS_ERR
em so I opted to fix the caller rather than teach free_extent_map() to
use IS_ERR_OR_NULL().

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index edd30ae..0bc7bb3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3690,6 +3690,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				block_end - cur_offset, 0);
 		if (IS_ERR(em)) {
 			err = PTR_ERR(em);
+			em = NULL;
 			break;
 		}
 		last_byte = min(extent_map_end(em), block_end);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
