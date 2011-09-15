From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 20/20] btrfs: Remove BUG_ON from __finish_chunk_alloc()
Date: Thu, 15 Sep 2011 10:34:59 -0700
Message-ID: <1316108099-5099-21-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_chunk() unconditionally BUGs on any error returned from
__finish_chunk_alloc() so there's no need for two BUG_ON lines. Remove the
one from __finish_chunk_alloc().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 50547f3..804328c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2571,7 +2571,8 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		device = map->stripes[index].dev;
 		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
-		BUG_ON(ret);
+		if (ret)
+			goto out_free;
 		index++;
 	}
 
@@ -2611,6 +2612,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 
+out_free:
 	kfree(chunk);
 	return 0;
 }
-- 
1.7.6

