Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47185 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaHHArw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 7 Aug 2014 20:47:52 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: clone, don't create invalid hole extent map
Date: Fri,  8 Aug 2014 02:47:06 +0100
Message-Id: <1407462426-6420-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407462426-6420-1-git-send-email-fdmanana@suse.com>
References: <1407462426-6420-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cloning a file that consists of an inline extent, we were creating
an extent map that represents a non-existing trailing hole starting at a
file offset that isn't a multiple of the sector size. This happened because
when processing an inline extent we weren't aligning the extent's length to
the sector size, and therefore incorrectly treating the range
[inline_extent_length; sector_size[ as a hole.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d490abd..6e3a0d1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3494,7 +3494,8 @@ process_slot:
 			btrfs_mark_buffer_dirty(leaf);
 			btrfs_release_path(path);
 
-			last_dest_end = new_key.offset + datal;
+			last_dest_end = ALIGN(new_key.offset + datal,
+					      root->sectorsize);
 			ret = clone_finish_inode_update(trans, inode,
 							last_dest_end,
 							destoff, olen);
-- 
1.9.1

