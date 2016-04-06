Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36319 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbcDFP4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 11:56:47 -0400
From: Bastien Philbert <bastienphilbert@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs:Change BUG_ON to new error path in  __clear_extent_bit
Date: Wed,  6 Apr 2016 11:56:36 -0400
Message-Id: <1459958196-31346-1-git-send-email-bastienphilbert@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This remove the unnessary BUG_ON if the allocation with
alloc_extent_state_atomic fails due to this function
failure not being unrecoverable. Instead we now change
this BUG_ON into a new error path that jumps to the goto
label, out from freeing previously allocated resources
before returning the error code -ENOMEM to signal callers
that the call to __clear_extent_bit failed due to a memory
allocation failure.

Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 fs/btrfs/extent_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0..4c87b77 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -682,7 +682,10 @@ hit_next:
 
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
-- 
2.5.0

