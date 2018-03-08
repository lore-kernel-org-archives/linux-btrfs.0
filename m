Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755544AbeCHOgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:13 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB74CAE22
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:11 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 20/22] btrfs: remove unused parameters from extent_submit_bio_start_t
Date: Thu,  8 Mar 2018 15:33:51 +0100
Message-Id: <2b2e5453c8fb6f5fe2da8d0d54c4b3649a629ce3.1520518877.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove parameters not used by any of the callbacks.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 2 --
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 4 +---
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6ffc97305d6a..e396ed366751 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -725,7 +725,6 @@ static void run_one_async_start(struct btrfs_work *work)
 
 	async = container_of(work, struct  async_submit_bio, work);
 	ret = async->submit_bio_start(async->private_data, async->bio,
-				      async->mirror_num, async->bio_flags,
 				      async->bio_offset);
 	if (ret)
 		async->status = ret;
@@ -808,7 +807,6 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
 }
 
 static blk_status_t __btree_submit_bio_start(void *private_data, struct bio *bio,
-					     int mirror_num, unsigned long bio_flags,
 					     u64 bio_offset)
 {
 	/*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 202546435db6..1d3792568e64 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -97,8 +97,7 @@ typedef	blk_status_t (extent_submit_bio_hook_t)(void *private_data, struct bio *
 				       u64 bio_offset);
 
 typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
-		struct bio *bio, int mirror_num, unsigned long bio_flags,
-		u64 bio_offset);
+		struct bio *bio, u64 bio_offset);
 
 typedef blk_status_t (extent_submit_bio_done_t)(void *private_data,
 		struct bio *bio, int mirror_num, unsigned long bio_flags,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f53470112670..9b33544caaf8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1922,7 +1922,6 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
  * are inserted into the btree
  */
 static blk_status_t __btrfs_submit_bio_start(void *private_data, struct bio *bio,
-				    int mirror_num, unsigned long bio_flags,
 				    u64 bio_offset)
 {
 	struct inode *inode = private_data;
@@ -8271,8 +8270,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 }
 
 static blk_status_t __btrfs_submit_bio_start_direct_io(void *private_data,
-				    struct bio *bio, int mirror_num,
-				    unsigned long bio_flags, u64 offset)
+				    struct bio *bio, u64 offset)
 {
 	struct inode *inode = private_data;
 	blk_status_t ret;
-- 
2.16.2

