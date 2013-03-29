Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38722 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3C2OCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 10:02:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CC4919A0645
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 08:02:10 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id KH1wyPftLwchhVXY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 08:02:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't drop path when printing out tree errors in scrub
Date: Fri, 29 Mar 2013 10:09:34 -0400
Message-ID: <1364566174-3962-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a panic where we were panicing somewhere in
tree_backref_for_extent from scrub_print_warning.  He only captured the trace
but looking at scrub_print_warning we drop the path right before we mess with
the extent buffer to print out a bunch of stuff, which isn't right.  So fix this
by dropping the path after we use the eb if we need to.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/scrub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e4b6fbc..907497a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -542,7 +542,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	eb = path->nodes[0];
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-	btrfs_release_path(path);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
@@ -558,7 +557,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 				ret < 0 ? -1 : ref_level,
 				ret < 0 ? -1 : ref_root);
 		} while (ret != 1);
+		btrfs_release_path(path);
 	} else {
+		btrfs_release_path(path);
 		swarn.path = path;
 		swarn.dev = dev;
 		iterate_extent_inodes(fs_info, found_key.objectid,
-- 
1.7.7.6

