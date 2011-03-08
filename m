From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] remove unneeded DEFINE_WAITs
Date: Tue,  8 Mar 2011 12:34:10 +0100
Message-ID: <1299584050-6014-1-git-send-email-sensille@gmx.net>
Cc: jansen@webgods.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7aaa10..c1f0c28 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4790,7 +4790,6 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 				u64 num_bytes)
 {
 	struct btrfs_caching_control *caching_ctl;
-	DEFINE_WAIT(wait);
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
@@ -4807,7 +4806,6 @@ static noinline int
 wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_caching_control *caching_ctl;
-	DEFINE_WAIT(wait);
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-- 
1.7.3.4

