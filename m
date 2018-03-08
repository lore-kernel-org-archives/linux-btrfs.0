Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41546 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964788AbeCHG3q (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 8 Mar 2018 01:29:46 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: free-space-cache: Enhance free space cache free space check
Date: Thu,  8 Mar 2018 14:29:36 +0800
Message-Id: <20180308062936.26846-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we found free space difference between free space cache and block
group item, we just discard this free space cache.

Normally such difference is caused by btrfs_reserve_extent() called by
delalloc which is out of a transaction.
And since all btrfs_release_extent() is called with a transaction, under
heavy race free space cache can have less free space than block group
item.

Normally kernel will detect such difference and just discard that cache.

However we must be more careful if free space cache has more free space
cache, and if that happens, paried with above race one invalid free
space cache can be loaded into kernel.

So if we find any free space cache who has more free space then block
group item, we report it as an error other than ignoring it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
BTW, invalid free space cache found in dm-log-writes test case just
has 0 free space, so it won't trigger such error.
---
 check/main.c       |  4 +++-
 free-space-cache.c | 30 +++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/check/main.c b/check/main.c
index 97baae583f04..bc31f7e32061 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5339,7 +5339,9 @@ static int check_space_cache(struct btrfs_root *root)
 			error += ret;
 		} else {
 			ret = load_free_space_cache(root->fs_info, cache);
-			if (!ret)
+			if (ret < 0)
+				error++;
+			if (ret <= 0)
 				continue;
 		}
 
diff --git a/free-space-cache.c b/free-space-cache.c
index f933f9f1cf3f..777c5fc682c5 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -438,7 +438,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	struct btrfs_path *path;
 	u64 used = btrfs_block_group_used(&block_group->item);
 	int ret = 0;
-	int matched;
+	u64 bg_free;
+	s64 diff;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -448,18 +449,33 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				      block_group->key.objectid);
 	btrfs_free_path(path);
 
-	matched = (ctl->free_space == (block_group->key.offset - used -
-				       block_group->bytes_super));
-	if (ret == 1 && !matched) {
+	bg_free = block_group->key.offset - used - block_group->bytes_super;
+	diff = ctl->free_space - bg_free;
+	if (ret == 1 && diff) {
 		__btrfs_remove_free_space_cache(ctl);
 		fprintf(stderr,
-		       "block group %llu has wrong amount of free space\n",
-		       block_group->key.objectid);
+		       "block group %llu has wrong amount of free space, free space cache has %llu block group has %llu\n",
+		       block_group->key.objectid, ctl->free_space, bg_free);
+		/*
+		 * Due to btrfs_reserve_extent() can happen out of a
+		 * transaction, but all btrfs_release_extent() happens inside
+		 * a transaction, so under heavy race it's possible that free
+		 * space cache has less free space, and both kernel just discard
+		 * such cache. But if we find some case where free space cache
+		 * has more free space, this means under certain case such
+		 * cache can be loaded and cause double allocate.
+		 *
+		 * Detect such possibility here.
+		 */
+		if (diff > 0)
+			error(
+"free space cache has more free space than block group item, this could leads to serious corruption, please contact btrfs developers");
 		ret = -1;
 	}
 
 	if (ret < 0) {
-		ret = 0;
+		if (diff <= 0)
+			ret = 0;
 
 		fprintf(stderr,
 		       "failed to load free space cache for block group %llu\n",
-- 
2.16.2

