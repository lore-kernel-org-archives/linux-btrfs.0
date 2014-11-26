Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53114 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962AbaKZQw5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 11:52:57 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sAQGfCV8014483
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 08:52:57 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1qwjjq01wk-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 08:52:56 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make get_caching_control unconditionally return the ctl
Date: Wed, 26 Nov 2014 11:52:54 -0500
Message-ID: <1417020774-10945-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was written when we didn't do a caching control for the fast free space
cache loading.  However we started doing that a long time ago, and there is
still a small window of time that we could be caching the block group the fast
way, so if there is a caching_ctl at all on the block group just return it, the
callers all wait properly for what they want.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 031dafb..74eb29d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -315,12 +315,6 @@ get_caching_control(struct btrfs_block_group_cache *cache)
 	struct btrfs_caching_control *ctl;
 
 	spin_lock(&cache->lock);
-	if (cache->cached != BTRFS_CACHE_STARTED) {
-		spin_unlock(&cache->lock);
-		return NULL;
-	}
-
-	/* We're loading it the fast way, so we don't have a caching_ctl. */
 	if (!cache->caching_ctl) {
 		spin_unlock(&cache->lock);
 		return NULL;
@@ -594,6 +588,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	spin_unlock(&cache->lock);
 
 	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
+		mutex_lock(&caching_ctl->mutex);
 		ret = load_free_space_cache(fs_info, cache);
 
 		spin_lock(&cache->lock);
@@ -601,6 +596,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 			cache->caching_ctl = NULL;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			cache->last_byte_to_unpin = (u64)-1;
+			caching_ctl->progress = (u64)-1;
 		} else {
 			if (load_cache_only) {
 				cache->caching_ctl = NULL;
@@ -610,6 +606,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 			}
 		}
 		spin_unlock(&cache->lock);
+		mutex_unlock(&caching_ctl->mutex);
+
 		wake_up(&caching_ctl->wait);
 		if (ret == 1) {
 			put_caching_control(caching_ctl);
-- 
1.9.3

