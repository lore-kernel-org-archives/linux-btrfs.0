Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55446 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbeGSLr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:47:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 628E4ACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs: remove unused member async_submit_bio::bio_flags
Date: Thu, 19 Jul 2018 13:05:11 +0200
Message-Id: <e6794d38ba5d03a2ce833e4a6f0d4d55355cd6f9.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After splitting the start and end hooks in a758781d4b76c3 ("btrfs:
separate types for submit_bio_start and submit_bio_done"), some of
the function arguments were dropped but not removed from the structure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index edc2daef423b..2e7932c753b2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -110,7 +110,6 @@ struct async_submit_bio {
 	extent_submit_bio_start_t *submit_bio_start;
 	extent_submit_bio_done_t *submit_bio_done;
 	int mirror_num;
-	unsigned long bio_flags;
 	/*
 	 * bio_offset is optional, can be used if the pages in the bio
 	 * can't tell us where in the file the bio should go
@@ -808,7 +807,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	btrfs_init_work(&async->work, btrfs_worker_helper, run_one_async_start,
 			run_one_async_done, run_one_async_free);
 
-	async->bio_flags = bio_flags;
 	async->bio_offset = bio_offset;
 
 	async->status = 0;
-- 
2.18.0

