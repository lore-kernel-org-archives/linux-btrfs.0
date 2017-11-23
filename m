Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbdKWIvu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 03:51:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C611CAC7D
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 08:51:48 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: enadolski@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant FLAG_VACANCY
Date: Thu, 23 Nov 2017 10:51:43 +0200
Message-Id: <1511427103-3843-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 9036c10208e1 ("Btrfs: update hole handling v2") added the FLAG_VACANCY
to denote holes, however there was already a consistent way of flagging
extents which represent hole - ->block_start = EXTENT_MAP_HOLE. And also
the only place where this flag is checked is in the fiemap code, but the
block_start value is also checked and every other place in the filesystem
detects holes by using block_start value's. So remove the extra flag. This
survived a full xfstest run

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c         | 4 +---
 fs/btrfs/extent_map.h        | 1 -
 fs/btrfs/inode.c             | 1 -
 fs/btrfs/tests/inode-tests.c | 5 -----
 include/trace/events/btrfs.h | 1 -
 5 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e6e4ca225aa9..82ae918a85e0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4321,10 +4321,8 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 			return em;
 
 		/* if this isn't a hole return it */
-		if (!test_bit(EXTENT_FLAG_VACANCY, &em->flags) &&
-		    em->block_start != EXTENT_MAP_HOLE) {
+		if (em->block_start != EXTENT_MAP_HOLE)
 			return em;
-		}
 
 		/* this is a hole, advance to the next extent */
 		offset = extent_map_end(em);
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index a67b2def5413..5bafab76a105 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -12,7 +12,6 @@
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
 #define EXTENT_FLAG_COMPRESSED 1
-#define EXTENT_FLAG_VACANCY 2 /* no file extent item found */
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
 #define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
 #define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ed8783a3a88..6450eeabaf4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7117,7 +7117,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	em->len = len;
 not_found_em:
 	em->block_start = EXTENT_MAP_HOLE;
-	set_bit(EXTENT_FLAG_VACANCY, &em->flags);
 insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 3406c0a84a06..1b910cf0c093 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -288,10 +288,6 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 		test_msg("Expected a hole, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (!test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
-		test_msg("Vacancy flag wasn't set properly\n");
-		goto out;
-	}
 	free_extent_map(em);
 	btrfs_drop_extent_cache(BTRFS_I(inode), 0, (u64)-1, 0);
 
@@ -1130,7 +1126,6 @@ int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 	int ret;
 
 	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
-	set_bit(EXTENT_FLAG_VACANCY, &vacancy_only);
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
 	test_msg("Running btrfs_get_extent tests\n");
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 5848ae7845da..36fad4599baf 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -192,7 +192,6 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 	__print_flags(flag, "|",					\
 		{ (1 << EXTENT_FLAG_PINNED), 		"PINNED" 	},\
 		{ (1 << EXTENT_FLAG_COMPRESSED), 	"COMPRESSED" 	},\
-		{ (1 << EXTENT_FLAG_VACANCY), 		"VACANCY" 	},\
 		{ (1 << EXTENT_FLAG_PREALLOC), 		"PREALLOC" 	},\
 		{ (1 << EXTENT_FLAG_LOGGING),	 	"LOGGING" 	},\
 		{ (1 << EXTENT_FLAG_FILLING),	 	"FILLING" 	},\
-- 
2.7.4

