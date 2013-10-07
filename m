Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60551 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3JGTUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 15:20:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D65A19A035C
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 13:20:54 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id AfAAlM1e8y8jnptI (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 13:20:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fixup reserved trace points
Date: Mon, 7 Oct 2013 15:20:52 -0400
Message-ID: <1381173652-8065-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In trying to track down where we were leaking reserved space I noticed our
reserve extent tracepoints are a little off.  First we were saying that the
reserved space had been alloced in btrfs_reserve_extent, which isn't the case,
this needs to be triggered when we actually allocate the space when we run the
delayed ref.  We were also missing a few places where we should have been
tracing the btrfs_reserve_extent_free tracepoint.  With these in place I was
able to put together where we were leaking reserved space.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a07d510..86b57c8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5263,6 +5263,8 @@ static int pin_down_extent(struct btrfs_root *root,
 
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+	if (reserved)
+		trace_btrfs_reserved_extent_free(root, bytenr, num_bytes);
 	return 0;
 }
 
@@ -5966,6 +5968,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
+		trace_btrfs_reserved_extent_free(root, buf->start, buf->len);
 		pin = 0;
 	}
 out:
@@ -6593,8 +6596,6 @@ again:
 		}
 	}
 
-	trace_btrfs_reserved_extent_alloc(root, ins->objectid, ins->offset);
-
 	return ret;
 }
 
@@ -6706,6 +6707,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			ins->objectid, ins->offset);
 		BUG();
 	}
+	trace_btrfs_reserved_extent_alloc(root, ins->objectid, ins->offset);
 	return ret;
 }
 
@@ -6778,6 +6780,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 			ins->objectid, ins->offset);
 		BUG();
 	}
+
+	trace_btrfs_reserved_extent_alloc(root, ins->objectid, root->leafsize);
 	return ret;
 }
 
-- 
1.8.3.1

