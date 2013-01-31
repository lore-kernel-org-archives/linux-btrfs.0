Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:46898 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736Ab3AaAGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/11] btrfs: remove unnecessary DEFINE_WAIT() declarations
Date: Wed, 30 Jan 2013 18:55:00 -0600
Message-Id: <1359593702-53056-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No point in DEFINE_WAIT(wait) if it's not used!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/extent-tree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8b8adc..0bb3424 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5478,7 +5478,6 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 				u64 num_bytes)
 {
 	struct btrfs_caching_control *caching_ctl;
-	DEFINE_WAIT(wait);
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
@@ -5495,7 +5494,6 @@ static noinline int
 wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_caching_control *caching_ctl;
-	DEFINE_WAIT(wait);
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-- 
1.7.1

