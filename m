Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbbK0Pdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 10:33:32 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 90C25AC05
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 15:31:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: use smaller type for btrfs_path locks
Date: Fri, 27 Nov 2015 16:31:45 +0100
Message-Id: <cbd8e97ad970ced49419a344366aae7773e3f57b.1448637387.git.dsterba@suse.com>
In-Reply-To: <cover.1448637387.git.dsterba@suse.com>
References: <cover.1448637387.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The values of btrfs_path::locks are 0 to 4, fit into a u8. Let's see:

* overall size of btrfs_path drops down from 136 to 112 (-24 bytes),
* better packing in a slab page +6 objects
* the whole structure now fits to 2 cachelines
* slight decrease in code size:

   text    data     bss     dec     hex filename
 938731   43670   23144 1005545   f57e9 fs/btrfs/btrfs.ko.before
 938203   43670   23144 1005017   f55d9 fs/btrfs/btrfs.ko.after

(and the generated assembly does not change much)

The main purpose is to decrease the size of the structure without
affecting performance. The byte access is usually well behaving accross
arches, the locks are not accessed frequently and sometimes just
compared to zero.

Note for further size reduction attempts: the slots could be made u16
but this might generate worse code on some arches (non-byte and non-int
access). Also the range of operations on slots is wider compared to
locks and the potential performance drop should be evaluated first.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4e00412dc5ff..caa8d53912a7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -595,7 +595,7 @@ struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
 	int slots[BTRFS_MAX_LEVEL];
 	/* if there is real range locking, this locks field will change */
-	int locks[BTRFS_MAX_LEVEL];
+	u8 locks[BTRFS_MAX_LEVEL];
 	u8 reada;
 	/* keep some upper locks as we walk down */
 	u8 lowest_level;
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
