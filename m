From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check cache->caching_ctl before returning if caching has started
Date: Thu, 16 Sep 2010 16:18:33 -0400
Message-ID: <1284668313-20563-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With the free space disk caching we can mark the block group as started with the
caching, but we don't have a caching ctl.  This can race with anybody else who
tries to get the caching ctl before we cache (this is very hard to do btw).  So
instead check to see if cache->caching_ctl is set, and if not return NULL.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8ef6aa6..91a0a41 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -242,6 +242,12 @@ get_caching_control(struct btrfs_block_group_cache *cache)
 		return NULL;
 	}
 
+	/* We're loading it the fast way, so we don't have a caching_ctl. */
+	if (!cache->caching_ctl) {
+		spin_unlock(&cache->lock);
+		return NULL;
+	}
+
 	ctl = cache->caching_ctl;
 	atomic_inc(&ctl->count);
 	spin_unlock(&cache->lock);
-- 
1.6.6.1

