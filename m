From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: sparse lock verification annotations for wait_on_state
Date: Thu, 20 Nov 2008 19:39:22 +0100
Message-ID: <20081120183922.GB20770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/extent_io.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/extent_io.c	2008-11-20 19:37:10.000000000 +0100
+++ btrfs-unstable/fs/btrfs/extent_io.c	2008-11-20 19:38:44.000000000 +0100
@@ -577,6 +577,8 @@ EXPORT_SYMBOL(clear_extent_bit);
 
 static int wait_on_state(struct extent_io_tree *tree,
 			 struct extent_state *state)
+		__releases(tree->lock)
+		__acquires(tree->lock)
 {
 	DEFINE_WAIT(wait);
 	prepare_to_wait(&state->wq, &wait, TASK_UNINTERRUPTIBLE);
