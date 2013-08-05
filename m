Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:59932 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3HEPZ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 11:25:28 -0400
Received: by mail-we0-f176.google.com with SMTP id q56so2548839wes.7
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 08:25:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: return ENOSPC when target space is full
Date: Mon,  5 Aug 2013 16:25:12 +0100
Message-Id: <1375716312-26899-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In extent-tree.c:do_chunk_alloc(), early on we returned 0 (success)
when the target space was full and when chunk allocation is needed.
However, later on in that same function we return ENOSPC if
btrfs_alloc_chunk() fails (and chunk allocation was needed) and
set the space's full flag.

This was inconsistent, as -ENOSPC should be returned if the space
is full and a chunk allocation needs to performed. If the space is
full but no chunk allocation is needed, just return 0 (success).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e868c35..ef89a66 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3829,8 +3829,12 @@ again:
 	if (force < space_info->force_alloc)
 		force = space_info->force_alloc;
 	if (space_info->full) {
+		if (should_alloc_chunk(extent_root, space_info, force))
+			ret = -ENOSPC;
+		else
+			ret = 0;
 		spin_unlock(&space_info->lock);
-		return 0;
+		return ret;
 	}
 
 	if (!should_alloc_chunk(extent_root, space_info, force)) {
-- 
1.7.9.5

