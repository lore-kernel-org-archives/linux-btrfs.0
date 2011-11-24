From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 37/99] btrfs: wait_on_state should return void
Date: Wed, 23 Nov 2011 19:36:10 -0500
Message-ID: <20111124004224.102240165@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 wait_on_state has no error conditions and should return void. Its callers
 already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -621,8 +621,8 @@ search_again:
				  cached_state, GFP_ATOMIC);
 }
 
-static int wait_on_state(struct extent_io_tree *tree,
-			 struct extent_state *state)
+static void wait_on_state(struct extent_io_tree *tree,
+			  struct extent_state *state)
 		__releases(tree->lock)
 		__acquires(tree->lock)
 {
@@ -632,7 +632,6 @@ static int wait_on_state(struct extent_i
 	schedule();
 	spin_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
-	return 0;
 }
 
 /*



