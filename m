From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 14/20] btrfs: Document BUG() in find_lock_delalloc_range()
Date: Thu, 15 Sep 2011 10:34:53 -0700
Message-ID: <1316108099-5099-15-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

We BUG_ON a nonzero, non -EAGAIN ret from lock_delalloc_range(). As it turns
out there is no other possible return value that makes sense anyway.  The
bare BUG_ON(ret) was a bit confusing and looked like something that needed
fixing. This patch documents the BUG_ON() so we know why it's there.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent_io.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d418164..2eb366d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1303,7 +1303,15 @@ again:
 			goto out_failed;
 		}
 	}
-	BUG_ON(ret);
+	if (ret) {
+		/*
+		 * This should never happen - lock_delalloc_pages only returns
+		 * 0 or -EAGAIN which are handled above.
+		 */
+		printk(KERN_ERR "btrfs: unexpected return %d from "
+		       "lock_delalloc_pages\n", ret);
+		BUG();
+	}
 
 	/* step three, lock the state bits for the whole range */
 	lock_extent_bits(tree, delalloc_start, delalloc_end,
-- 
1.7.6

