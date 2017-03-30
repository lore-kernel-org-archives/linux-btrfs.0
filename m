Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37806 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755177AbdC3GdE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:33:04 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v4 4/5] btrfs: Wait flighting bio before freeing target device for raid56
Date: Thu, 30 Mar 2017 14:32:50 +0800
Message-ID: <20170330063251.16872-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
References: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When raid56 dev replace is cancelled by running scrub, we will free target
device without waiting flighting bios, causing the following NULL
pointer deference or general protection.

 BUG: unable to handle kernel NULL pointer dereference at 00000000000005e0
 IP: generic_make_request_checks+0x4d/0x610
 CPU: 1 PID: 11676 Comm: kworker/u4:14 Tainted: G  O    4.11.0-rc2 #72
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
 Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper [btrfs]
 task: ffff88002875b4c0 task.stack: ffffc90001334000
 RIP: 0010:generic_make_request_checks+0x4d/0x610
 Call Trace:
  ? generic_make_request+0xc7/0x360
  generic_make_request+0x24/0x360
  ? generic_make_request+0xc7/0x360
  submit_bio+0x64/0x120
  ? page_in_rbio+0x4d/0x80 [btrfs]
  ? rbio_orig_end_io+0x80/0x80 [btrfs]
  finish_rmw+0x3f4/0x540 [btrfs]
  validate_rbio_for_rmw+0x36/0x40 [btrfs]
  raid_rmw_end_io+0x7a/0x90 [btrfs]
  bio_endio+0x56/0x60
  end_workqueue_fn+0x3c/0x40 [btrfs]
  btrfs_scrubparity_helper+0xef/0x620 [btrfs]
  btrfs_endio_raid56_helper+0xe/0x10 [btrfs]
  process_one_work+0x2af/0x720
  ? process_one_work+0x22b/0x720
  worker_thread+0x4b/0x4f0
  kthread+0x10f/0x150
  ? process_one_work+0x720/0x720
  ? kthread_create_on_node+0x40/0x40
  ret_from_fork+0x2e/0x40
 RIP: generic_make_request_checks+0x4d/0x610 RSP: ffffc90001337bb8

In btrfs_dev_replace_finishing(), we will call
btrfs_rm_dev_replace_blocked() to wait bios before destroying the target
device when scrub is finished normally.

However when dev replace is aborted, either due to error or canceled by
scrub, we didn't wait bios, this can leads to use-after-free if there
are bios holding the target device.

Furthermore, for raid56 scrub, at least 2 places are calling
btrfs_map_sblock() without protection of bio_counter, leading to the
problem.

This patch fixes the problem by
1) Wait bio_counter before freeing target device when canceling replace
2) When calling btrfs_map_sblock() for raid56, use bio_counter to
   protect the call.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/dev-replace.c |  2 ++
 fs/btrfs/raid56.c      | 14 ++++++++++++++
 fs/btrfs/scrub.c       |  5 +++++
 3 files changed, 21 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e653921f05d9..b9d88136b5a9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -546,8 +546,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		mutex_unlock(&uuid_mutex);
+		btrfs_rm_dev_replace_blocked(fs_info);
 		if (tgt_device)
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+		btrfs_rm_dev_replace_unblocked(fs_info);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
 		return scrub_ret;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1571bf26dc07..5c180fea32ab 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2194,6 +2194,8 @@ static void read_rebuild_work(struct btrfs_work *work)
 /*
  * The following code is used to scrub/replace the parity stripe
  *
+ * Caller must have already increased bio_counter for getting @bbio.
+ *
  * Note: We need make sure all the pages that add into the scrub/replace
  * raid bio are correct and not be changed during the scrub/replace. That
  * is those pages just hold metadata or file data with checksum.
@@ -2231,6 +2233,12 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	ASSERT(rbio->stripe_npages == stripe_nsectors);
 	bitmap_copy(rbio->dbitmap, dbitmap, stripe_nsectors);
 
+	/*
+	 * We have already increased bio_counter when getting bbio, record it
+	 * so we can free it at rbio_orig_end_io().
+	 */
+	rbio->generic_bio_cnt = 1;
+
 	return rbio;
 }
 
@@ -2673,6 +2681,12 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		return NULL;
 	}
 
+	/*
+	 * When we get bbio, we have already increased bio_counter, record it
+	 * so we can free it at rbio_orig_end_io()
+	 */
+	rbio->generic_bio_cnt = 1;
+
 	return rbio;
 }
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bffbe3ce7d70..5720ecdad5d7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2427,6 +2427,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	int ret;
 	int i;
 
+	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
 			&length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -2471,6 +2472,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 rbio_out:
 	bio_put(bio);
 bbio_out:
+	btrfs_bio_counter_dec(fs_info);
 	btrfs_put_bbio(bbio);
 	spin_lock(&sctx->stat_lock);
 	sctx->stat.malloc_errors++;
@@ -3014,6 +3016,8 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto out;
 
 	length = sparity->logic_end - sparity->logic_start;
+
+	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_WRITE, sparity->logic_start,
 			       &length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -3041,6 +3045,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 rbio_out:
 	bio_put(bio);
 bbio_out:
+	btrfs_bio_counter_dec(fs_info);
 	btrfs_put_bbio(bbio);
 	bitmap_or(sparity->ebitmap, sparity->ebitmap, sparity->dbitmap,
 		  sparity->nsectors);
-- 
2.12.1



