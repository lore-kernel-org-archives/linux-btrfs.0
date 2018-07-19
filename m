Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbeGSLrz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:47:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFB28AD7A
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: remove unused member async_submit_bio::fs_info
Date: Thu, 19 Jul 2018 13:05:09 +0200
Message-Id: <eca4f1ca127261cf82114dbe76740b669a965460.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduced by c6100a4b4e3d1 ("Btrfs: replace tree->mapping with
tree->private_data") to be used in run_one_async_done where it got
unused after 736cd52e0c720103 ("Btrfs: remove nr_async_submits and
async_submit_draining").

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e3858b2fe014..edc2daef423b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -106,7 +106,6 @@ void __cold btrfs_end_io_wq_exit(void)
  */
 struct async_submit_bio {
 	void *private_data;
-	struct btrfs_fs_info *fs_info;
 	struct bio *bio;
 	extent_submit_bio_start_t *submit_bio_start;
 	extent_submit_bio_done_t *submit_bio_done;
@@ -801,7 +800,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		return BLK_STS_RESOURCE;
 
 	async->private_data = private_data;
-	async->fs_info = fs_info;
 	async->bio = bio;
 	async->mirror_num = mirror_num;
 	async->submit_bio_start = submit_bio_start;
-- 
2.18.0

