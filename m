Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeIGTgl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:41 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDE12AC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/11] btrfs: open code btrfs_dev_replace_stats_inc
Date: Fri,  7 Sep 2018 16:55:06 +0200
Message-Id: <111cb329e58b7b24af11c248e861859997cbfc89.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The wrapper is too trivial, open coding does not make it less readable.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.h |  5 -----
 fs/btrfs/scrub.c       | 11 ++++-------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 39f022c457ff..1c91bf9ef39a 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -29,9 +29,4 @@ void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
 
-static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
-{
-	atomic64_inc(stat_value);
-}
-
 #endif
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4bcc275f7612..902819d3cf41 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1124,7 +1124,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 
 			if (scrub_write_page_to_dev_replace(sblock_other,
 							    page_num) != 0) {
-				btrfs_dev_replace_stats_inc(
+				atomic64_inc(
 					&fs_info->dev_replace.num_write_errors);
 				success = 0;
 			}
@@ -1564,8 +1564,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		if (btrfsic_submit_bio_wait(bio)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
-			btrfs_dev_replace_stats_inc(
-				&fs_info->dev_replace.num_write_errors);
+			atomic64_inc(&fs_info->dev_replace.num_write_errors);
 			bio_put(bio);
 			return -EIO;
 		}
@@ -1592,8 +1591,7 @@ static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
 
 		ret = scrub_write_page_to_dev_replace(sblock, page_num);
 		if (ret)
-			btrfs_dev_replace_stats_inc(
-				&fs_info->dev_replace.num_write_errors);
+			atomic64_inc(&fs_info->dev_replace.num_write_errors);
 	}
 }
 
@@ -1726,8 +1724,7 @@ static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
 			struct scrub_page *spage = sbio->pagev[i];
 
 			spage->io_error = 1;
-			btrfs_dev_replace_stats_inc(&dev_replace->
-						    num_write_errors);
+			atomic64_inc(&dev_replace->num_write_errors);
 		}
 	}
 
-- 
2.18.0
