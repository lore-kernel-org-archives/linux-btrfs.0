Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34032 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932263AbeF2I46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4F602AD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/14] btrfs: raid56: add new helper for starting async work
Date: Fri, 29 Jun 2018 10:56:56 +0200
Message-Id: <893bfb0617d66960810ec4ec7176949b7fa28957.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add helper that schedules a given function to run on the rmw workqueue.
This will replace several standalone helpers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1a1b7d6c44cb..f30d847baf07 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -174,6 +174,12 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check);
 static void async_scrub_parity(struct btrfs_raid_bio *rbio);
 
+static void start_async_work(struct btrfs_raid_bio *rbio, btrfs_func_t work_func)
+{
+	btrfs_init_work(&rbio->work, btrfs_rmw_helper, work_func, NULL, NULL);
+	btrfs_queue_work(rbio->fs_info->rmw_workers, &rbio->work);
+}
+
 /*
  * the stripe hash table is used for locking, and to collect
  * bios in hopes of making a full stripe
-- 
2.17.1

