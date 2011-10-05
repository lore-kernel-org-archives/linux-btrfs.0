From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: alleviate gfp flags in end_bio_extent_readpage
Date: Wed,  5 Oct 2011 12:19:00 +0200
Message-ID: <1317809940-25043-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Use of GFP_ATOMIC is not necessary in this context. This makes
consistent use of GFP_NOFS flag being passed to all funcions like
lock_extent_bits/unlock_extent_bits/set_extent_bit/clear_extent_bit.
(Then the mask argument could be later dropped and the flags used
directly at the allocation calls and not needlessly passed down the
call chain.)

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0ada0b7..ac71bbf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1932,9 +1932,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		if (uptodate) {
 			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
+					    GFP_NOFS);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+		unlock_extent_cached(tree, start, end, &cached, GFP_NOFS);
 
 		if (whole_page) {
 			if (uptodate) {
-- 
1.7.6

