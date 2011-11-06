From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] btrfs: Don't leak mem in scrub_fixup().
Date: Sun, 6 Nov 2011 23:33:24 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1111062331350.5763@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It seems to me that we may leak the memory allocated to 'multi' in
scrub_fixup() if, for example, 'length' turns out to be less than
PAGE_SIZE after we call btrfs_map_block(). This patch should take care
of the leak by always kfree'ing 'multi' before we return in that error
case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/scrub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

 Compile tested only since I don't have any btrfs filesystems to test on.

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a8d03d5..b53433e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -271,6 +271,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
 			      &multi, 0);
 	if (ret || !multi || length < PAGE_SIZE) {
+		kfree(multi);
 		printk(KERN_ERR
 		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
 		       (unsigned long long)logical);
-- 
1.7.7.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

