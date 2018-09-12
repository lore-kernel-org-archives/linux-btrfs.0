Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:36867 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbeILTuh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:50:37 -0400
Received: by mail-qt0-f176.google.com with SMTP id n6-v6so2099799qtl.4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 07:45:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: wait on caching when putting the bg cache
Date: Wed, 12 Sep 2018 10:45:45 -0400
Message-Id: <20180912144545.5564-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While testing my backport I noticed there was a panic if I ran
generic/416 generic/417 generic/418 all in a row.  This just happened to
uncover a race where we had outstanding IO after we destroy all of our
workqueues, and then we'd go to queue the endio work on those free'd
workqueues.  This is because we aren't waiting for the caching threads
to be done before freeing everything up, so to fix this make sure we
wait on any outstanding caching that's being done before we free up the
block group, so we're sure to be done with all IO by the time we get to
btrfs_stop_all_workers().  This fixes the panic I was seeing
consistently in testing.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 414492a18f1e..2eb2e37f2354 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9889,6 +9889,7 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 
 		block_group = btrfs_lookup_first_block_group(info, last);
 		while (block_group) {
+			wait_block_group_cache_done(block_group);
 			spin_lock(&block_group->lock);
 			if (block_group->iref)
 				break;
-- 
2.14.3
