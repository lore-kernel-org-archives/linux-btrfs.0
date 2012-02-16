From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/4] Btrfs: kick out redundant stuff in convert_extent_bit
Date: Thu, 16 Feb 2012 18:34:38 +0800
Message-ID: <1329388479-31341-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

clear_state_bit will do merge_state for us, so kick out the redundant one.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e791fef..039c5c6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -965,8 +965,6 @@ hit_next:
 
 		set_state_bits(tree, state, &bits);
 		clear_state_bit(tree, state, &clear_bits, 0);
-
-		merge_state(tree, state);
 		if (last_end == (u64)-1)
 			goto out;
 
@@ -1011,7 +1009,6 @@ hit_next:
 		if (state->end <= end) {
 			set_state_bits(tree, state, &bits);
 			clear_state_bit(tree, state, &clear_bits, 0);
-			merge_state(tree, state);
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
@@ -1072,8 +1069,6 @@ hit_next:
 
 		set_state_bits(tree, prealloc, &bits);
 		clear_state_bit(tree, prealloc, &clear_bits, 0);
-
-		merge_state(tree, prealloc);
 		prealloc = NULL;
 		goto out;
 	}
-- 
1.6.5.2

