Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19843 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2GWLur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 07:50:47 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6NBojYr018324
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 19:50:45 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make btrfs's allocation smoothly with preallocation
Date: Mon, 23 Jul 2012 19:50:03 +0800
Message-Id: <1343044203-23834-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For backref walking, we've introduce delayed ref's sequence.  However,
it changes our preallocation behavior.

The story is that when we preallocate an extent and then mark it written
piece by piece, the ideal case should be that we don't need to COW the
extent, which is why we use 'preallocate'.

But we may not make use of preallocation, since when we check for cross refs on
the extent, we may have two ref entries which have the same content except
the sequence value, and we recognize them as cross refs and do COW to allocate
another extent.

So we end up with several pieces of space instead of an whole extent.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6e1d367..d845b4a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2581,8 +2581,10 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 
 	node = rb_prev(node);
 	if (node) {
+		int seq = ref->seq;
+
 		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
-		if (ref->bytenr == bytenr)
+		if (ref->bytenr == bytenr && ref->seq == seq)
 			goto out_unlock;
 	}
 
-- 
1.6.5.2

