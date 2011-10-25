From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 17/66] btrfs: wait_on_state should return void
Date: Mon, 24 Oct 2011 21:02:53 -0400
Message-ID: <20111025010852.519696541@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
 	goto again;
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


