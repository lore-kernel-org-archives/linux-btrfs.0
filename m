From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 07/35] btrfs: avoid NULL deref in btrfs_reserve_extent with DEBUG_ENOSPC
Date: Wed, 21 Mar 2012 21:11:11 -0400
Message-ID: <20120322011133.957336170@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 __find_space_info can return NULL but we don't check it before calling
 dump_space_info().

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 37e0a80..c32a9bf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5838,7 +5838,8 @@ again:
 			printk(KERN_ERR "btrfs allocation failed flags %llu, "
 			       "wanted %llu\n", (unsigned long long)data,
 			       (unsigned long long)num_bytes);
-			dump_space_info(sinfo, num_bytes, 1);
+			if (sinfo)
+				dump_space_info(sinfo, num_bytes, 1);
 		}
 	}
 
-- 
1.7.9



