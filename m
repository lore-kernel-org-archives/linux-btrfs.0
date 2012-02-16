From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/4] Btrfs: skip states when they does not contain bits to clear
Date: Thu, 16 Feb 2012 18:34:37 +0800
Message-ID: <1329388479-31341-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Clearing a range's bits is different with setting them, since we don't
need to touch them when states do not contain bits we want.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e941cc4..e791fef 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -513,6 +513,15 @@ hit_next:
 	WARN_ON(state->end < start);
 	last_end = state->end;
 
+	if (state->end < end && !need_resched())
+		next_node = rb_next(&state->rb_node);
+	else
+		next_node = NULL;
+
+	/* the state doesn't have the wanted bits, go ahead */
+	if (!(state->state & bits))
+		goto next;
+
 	/*
 	 *     | ---- desired range ---- |
 	 *  | state | or
@@ -565,12 +574,8 @@ hit_next:
 		goto out;
 	}
 
-	if (state->end < end && prealloc && !need_resched())
-		next_node = rb_next(&state->rb_node);
-	else
-		next_node = NULL;
-
 	set |= clear_state_bit(tree, state, &bits, wake);
+next:
 	if (last_end == (u64)-1)
 		goto out;
 	start = last_end + 1;
-- 
1.6.5.2

