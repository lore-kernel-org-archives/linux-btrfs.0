From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: Fix cluster window start
Date: Mon, 2 Nov 2009 14:40:24 -0500
Message-ID: <20091102194024.GA3382@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We use cluster->window_start as a hint of where to find the block group for
our allocation.  The problem is we also use this offset as a minimum starting
offset when we look through our cluster for allocations.  So what happens is
we end up setting this offset to whatever the last entry we found was, so if
there happen to be multiple entries, every allocation after the first one once
we've refilled the cluster will fail, and we'll have to refill the cluster.
Fix this by setting cluster->window_start to window_start, which is the offset
of the _first_ entry we find in this cluster.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cb2849f..8f01904 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1305,8 +1305,6 @@ again:
 		}
 	}
 
-	cluster->window_start = entry->offset;
-
 	/*
 	 * now we've found our entries, pull them out of the free space
 	 * cache and put them into the cluster rbtree
@@ -1336,6 +1334,7 @@ again:
 	}
 
 	cluster->max_size = max_extent;
+	cluster->window_start = window_start;
 got_it:
 	ret = 0;
 	atomic_inc(&block_group->count);
-- 
1.6.2.5

