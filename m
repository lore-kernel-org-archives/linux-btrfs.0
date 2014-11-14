Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63591 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161810AbaKNVQf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 16:16:35 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: [PATCH] Btrfs: do not move em to modified list when unpinning
Date: Fri, 14 Nov 2014 16:16:30 -0500
Message-ID: <1415999790-4144-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use the modified list to keep track of which extents have been modified so we
know which ones are candidates for logging at fsync() time.  Newly modified
extents are added to the list at modification time, around the same time the
ordered extent is created.  We do this so that we don't have to wait for ordered
extents to complete before we know what we need to log.  The problem is when
something like this happens

log extent 0-4k on inode 1
copy csum for 0-4k from ordered extent into log
sync log
commit transaction
log some other extent on inode 1
ordered extent for 0-4k completes and adds itself onto modified list again
log changed extents
see ordered extent for 0-4k has already been logged
	at this point we assume the csum has been copied
sync log
crash

On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
which is the same one that we are replaying which also drops the csum, and then
we won't find the csum in the log for that bytenr.  This of course causes us to
have errors about not having csums for certain ranges of our inode.  So remove
the modified list manipulation in unpin_extent_cache, any modified extents
should have been added well before now, and we don't want them re-logged.  This
fixes my test that I could reliably reproduce this problem with.  Thanks,

cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_map.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 225302b..6a98bdd 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -287,8 +287,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	if (!em)
 		goto out;
 
-	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
-		list_move(&em->list, &tree->modified_extents);
 	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 	em->mod_start = em->start;
-- 
1.8.3.1

