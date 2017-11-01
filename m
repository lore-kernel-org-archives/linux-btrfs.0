Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754197AbdKAJgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 05:36:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF94FAAB2
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Nov 2017 09:36:07 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use locked_end rather than open coding it
Date: Wed,  1 Nov 2017 11:36:05 +0200
Message-Id: <1509528965-4818-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right before we go into this loop locked_end is set to alloc_end - 1 and is
being used in nearby functions, no need to have exceptions. This just makes the
code consistent, no functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ecbe186cb5da..2a18a5f9c68e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3142,8 +3142,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 		 */
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, alloc_start,
 				 locked_end, &cached_state);
-		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    alloc_end - 1);
+		ordered = btrfs_lookup_first_ordered_extent(inode, locked_end);
+
 		if (ordered &&
 		    ordered->file_offset + ordered->len > alloc_start &&
 		    ordered->file_offset < alloc_end) {
-- 
2.7.4

