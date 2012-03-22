From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 28/35] btrfs: Remove BUG_ON from __finish_chunk_alloc()
Date: Wed, 21 Mar 2012 21:11:32 -0400
Message-ID: <20120322011136.926025527@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_chunk() unconditionally BUGs on any error returned from
__finish_chunk_alloc() so there's no need for two BUG_ON lines. Remove the
one from __finish_chunk_alloc().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/volumes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8bf19e1..8a30d63 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3383,7 +3383,8 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		device = map->stripes[index].dev;
 		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
-		BUG_ON(ret);
+		if (ret)
+			goto out_free;
 		index++;
 	}
 
@@ -3430,6 +3431,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 					     item_size);
 	}
 
+out_free:
 	kfree(chunk);
 	return ret;
 }
-- 
1.7.9



