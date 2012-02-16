From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs: be less strict on finding next node in clear_extent_bit
Date: Thu, 16 Feb 2012 18:34:36 +0800
Message-ID: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In clear_extent_bit, it is enough that next node is adjacent in tree level.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fcf77e1..e941cc4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -577,8 +577,7 @@ hit_next:
 	if (start <= end && next_node) {
 		state = rb_entry(next_node, struct extent_state,
 				 rb_node);
-		if (state->start == start)
-			goto hit_next;
+		goto hit_next;
 	}
 	goto search_again;
 
-- 
1.6.5.2

