Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756625Ab3KOD5b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 22:57:31 -0500
Date: Thu, 14 Nov 2013 22:57:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Use trace condition for get_extent tracepoint
Message-ID: <20131114225729.463bd2e6@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing an if statement to test some condition to know if we should
trigger a tracepoint is pointless when tracing is disabled. This just
adds overhead and wastes a branch prediction. This is why the
TRACE_EVENT_CONDITION() was created. It places the check inside the jump
label so that the branch does not happen unless tracing is enabled.

That is, instead of doing:

	if (em)
		trace_btrfs_get_extent(root, em);

Which is basically this:

	if (em)
		if (static_key(trace_btrfs_get_extent)) {


Using a TRACE_EVENT_CONDITION() we can just do:

	trace_btrfs_get_extent(root, em);

And the condition trace event will do:

	if (static_key(trace_btrfs_get_extent)) {
		if (em) {
			...

The static key is a non conditional jump (or nop) that is faster than
having to check if em is NULL or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 51e3afa..a9ad918 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6173,8 +6173,7 @@ insert:
 	write_unlock(&em_tree->lock);
 out:
 
-	if (em)
-		trace_btrfs_get_extent(root, em);
+	trace_btrfs_get_extent(root, em);
 
 	if (path)
 		btrfs_free_path(path);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f18b3b7..4832d75 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -162,12 +162,14 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 		{ EXTENT_FLAG_LOGGING,	 	"LOGGING" 	},	\
 		{ EXTENT_FLAG_FILLING,	 	"FILLING" 	})
 
-TRACE_EVENT(btrfs_get_extent,
+TRACE_EVENT_CONDITION(btrfs_get_extent,
 
 	TP_PROTO(struct btrfs_root *root, struct extent_map *map),
 
 	TP_ARGS(root, map),
 
+	TP_CONDITION(map),
+
 	TP_STRUCT__entry(
 		__field(	u64,  root_objectid	)
 		__field(	u64,  start		)
