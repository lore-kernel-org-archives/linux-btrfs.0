From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/4] Btrfs: don't look at the extent buffer level 3 times in a row
Date: Wed, 11 May 2011 17:35:53 -0400
Message-ID: <1305149755-4413-2-git-send-email-josef@redhat.com>
References: <1305149755-4413-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305149755-4413-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We have a bit of debugging in btrfs_search_slot to make sure the level of the
cow block is the same as the original block we were cow'ing.  I don't think I've
ever seen this tripped, so kill it.  This saves us 2 kmap's per level in our
search.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 009bcf7..f7a0a64 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1672,9 +1672,6 @@ again:
 		}
 cow_done:
 		BUG_ON(!cow && ins_len);
-		if (level != btrfs_header_level(b))
-			WARN_ON(1);
-		level = btrfs_header_level(b);
 
 		p->nodes[level] = b;
 		if (!p->skip_locking)
-- 
1.7.2.3

