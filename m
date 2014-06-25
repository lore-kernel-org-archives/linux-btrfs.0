Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5251 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbaFYUqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 16:46:06 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>, <stable@vger.kernel.org>
Subject: [PATCH] btrfs: only unlock block in verify_parent_transid if we locked it
Date: Wed, 25 Jun 2014 13:45:41 -0700
Message-ID: <1403729141-10434-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a regression from my patch a26e8c9f75b0bfd8cccc9e8f110737b136eb5994, we
need to only unlock the block if we were the one who locked it.  Otherwise this
will trip BUG_ON()'s in locking.c  Thanks,

cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa1..f00165d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -369,7 +369,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 out:
 	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
 			     &cached_state, GFP_NOFS);
-	btrfs_tree_read_unlock_blocking(eb);
+	if (need_lock)
+		btrfs_tree_read_unlock_blocking(eb);
 	return ret;
 }
 
-- 
2.0.0

