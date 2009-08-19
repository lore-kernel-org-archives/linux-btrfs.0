From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix bitmap size tracking
Date: Wed, 19 Aug 2009 15:28:57 -0400
Message-ID: <20090819192857.GD7761@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we first go to add free space, we allocate a new info and set the offset
and bytes to the space we are adding.  This is fine, except we actually set the
size of a bitmap as we set the bits in it, so if we add space to a bitmap, we'd
end up counting the same space twice.  This isn't a huge deal, it just makes the
allocator behave weirdly since it will think that a bitmap entry has more space
than it ends up actually having.  I used a BUG_ON() to catch when this problem
happened, and with this patch I no longer get the BUG_ON().

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5edcee3..4eb2964 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -403,6 +403,7 @@ static void add_new_bitmap(struct btrfs_block_group_cache *block_group,
 	BUG_ON(block_group->total_bitmaps >= max_bitmaps);
 
 	info->offset = offset_to_bitmap(block_group, offset);
+	info->bytes = 0;
 	link_free_space(block_group, info);
 	block_group->total_bitmaps++;
 
-- 
1.5.4.3

