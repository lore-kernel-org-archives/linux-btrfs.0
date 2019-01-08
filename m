Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC593C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A53F206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977109;
	bh=VlIgRuaSNnBR+g671nIEmXN/Op4Q/NY+B0HAX7L1l80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=riopGGWPCgz1mok24Xa+Lq28+mNd301vBbTRD61DcJyH+WVBFFud5jsP3PFBqZfgA
	 FbExL6XbS1jebCGltWx6zq05Tjmr6wjuLB9fpq0OLbfZZ6ircShRtvIjm1RA9BtJv4
	 yZ5xhxBspNc1mPECCHqlAxQE9D38ZpZ4AkiLxnx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfAHTvo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731057AbfAHTbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28F220883;
        Tue,  8 Jan 2019 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975881;
        bh=VlIgRuaSNnBR+g671nIEmXN/Op4Q/NY+B0HAX7L1l80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdOxrKXSdvCio+O2Gc8QIaQM1b5oolAkeXonCOVlpZyQcxrHQposXtUBo38UN1qer
         f9dCg/A1wevnhwMN/eRdTG44OoqG63Ohw/sxKgOktQeCpv/VlgQDognssF+BmKdcHm
         AmxaTQTrRtj776xEEQUX3rmdkUY2UycUfL2XKAco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 58/97] btrfs: fix use-after-free due to race between replace start and cancel
Date:   Tue,  8 Jan 2019 14:29:07 -0500
Message-Id: <20190108192949.122407-58-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit d189dd70e2556181732598956d808ea53cc8774e ]

The device replace cancel thread can race with the replace start thread
and if fs_info::scrubs_running is not yet set, btrfs_scrub_cancel() will
fail to stop the scrub thread.

The scrub thread continues with the scrub for replace which then will
try to write to the target device and which is already freed by the
cancel thread.

scrub_setup_ctx() warns as tgtdev is NULL.

  struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
  {
  ...
	  if (is_dev_replace) {
		  WARN_ON(!fs_info->dev_replace.tgtdev);  <===
		  sctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
		  sctx->wr_tgtdev = fs_info->dev_replace.tgtdev;
		  sctx->flush_all_writes = false;
	  }

  [ 6724.497655] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 1) to /dev/sdc started
  [ 6753.945017] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 1) to /dev/sdc canceled
  [ 6852.426700] WARNING: CPU: 0 PID: 4494 at fs/btrfs/scrub.c:622 scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
  ...
  [ 6852.428928] RIP: 0010:scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
  ...
  [ 6852.432970] Call Trace:
  [ 6852.433202]  btrfs_scrub_dev+0x19b/0x5c0 [btrfs]
  [ 6852.433471]  btrfs_dev_replace_start+0x48c/0x6a0 [btrfs]
  [ 6852.433800]  btrfs_dev_replace_by_ioctl+0x3a/0x60 [btrfs]
  [ 6852.434097]  btrfs_ioctl+0x2476/0x2d20 [btrfs]
  [ 6852.434365]  ? do_sigaction+0x7d/0x1e0
  [ 6852.434623]  do_vfs_ioctl+0xa9/0x6c0
  [ 6852.434865]  ? syscall_trace_enter+0x1c8/0x310
  [ 6852.435124]  ? syscall_trace_enter+0x1c8/0x310
  [ 6852.435387]  ksys_ioctl+0x60/0x90
  [ 6852.435663]  __x64_sys_ioctl+0x16/0x20
  [ 6852.435907]  do_syscall_64+0x50/0x180
  [ 6852.436150]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Further, as the replace thread enters scrub_write_page_to_dev_replace()
without the target device it panics:

  static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
				      struct scrub_page *spage)
  {
  ...
	bio_set_dev(bio, sbio->dev->bdev); <======

  [ 6929.715145] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
  ..
  [ 6929.717106] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
  [ 6929.717420] RIP: 0010:scrub_write_page_to_dev_replace+0xb4/0x260
  [btrfs]
  ..
  [ 6929.721430] Call Trace:
  [ 6929.721663]  scrub_write_block_to_dev_replace+0x3f/0x60 [btrfs]
  [ 6929.721975]  scrub_bio_end_io_worker+0x1af/0x490 [btrfs]
  [ 6929.722277]  normal_work_helper+0xf0/0x4c0 [btrfs]
  [ 6929.722552]  process_one_work+0x1f4/0x520
  [ 6929.722805]  ? process_one_work+0x16e/0x520
  [ 6929.723063]  worker_thread+0x46/0x3d0
  [ 6929.723313]  kthread+0xf8/0x130
  [ 6929.723544]  ? process_one_work+0x520/0x520
  [ 6929.723800]  ? kthread_delayed_work_timer_fn+0x80/0x80
  [ 6929.724081]  ret_from_fork+0x3a/0x50

Fix this by letting the btrfs_dev_replace_finishing() to do the job of
cleaning after the cancel, including freeing of the target device.
btrfs_dev_replace_finishing() is called when btrfs_scub_dev() returns
along with the scrub return status.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 63 +++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 981434764bb9..c26579d3f7b6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -800,39 +800,58 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
 		btrfs_dev_replace_write_unlock(dev_replace);
-		goto leave;
+		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
+		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
+		tgt_device = dev_replace->tgtdev;
+		src_device = dev_replace->srcdev;
+		btrfs_dev_replace_write_unlock(dev_replace);
+		btrfs_scrub_cancel(fs_info);
+		/* btrfs_dev_replace_finishing() will handle the cleanup part */
+		btrfs_info_in_rcu(fs_info,
+			"dev_replace from %s (devid %llu) to %s canceled",
+			btrfs_dev_name(src_device), src_device->devid,
+			btrfs_dev_name(tgt_device));
+		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
+		/*
+		 * Scrub doing the replace isn't running so we need to do the
+		 * cleanup step of btrfs_dev_replace_finishing() here
+		 */
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 		tgt_device = dev_replace->tgtdev;
 		src_device = dev_replace->srcdev;
 		dev_replace->tgtdev = NULL;
 		dev_replace->srcdev = NULL;
-		break;
-	}
-	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
-	dev_replace->time_stopped = ktime_get_real_seconds();
-	dev_replace->item_needs_writeback = 1;
-	btrfs_dev_replace_write_unlock(dev_replace);
-	btrfs_scrub_cancel(fs_info);
+		dev_replace->replace_state =
+				BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
+		dev_replace->time_stopped = ktime_get_real_seconds();
+		dev_replace->item_needs_writeback = 1;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-		return PTR_ERR(trans);
-	}
-	ret = btrfs_commit_transaction(trans);
-	WARN_ON(ret);
+		btrfs_dev_replace_write_unlock(dev_replace);
 
-	btrfs_info_in_rcu(fs_info,
-		"dev_replace from %s (devid %llu) to %s canceled",
-		btrfs_dev_name(src_device), src_device->devid,
-		btrfs_dev_name(tgt_device));
+		btrfs_scrub_cancel(fs_info);
+
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
+			return PTR_ERR(trans);
+		}
+		ret = btrfs_commit_transaction(trans);
+		WARN_ON(ret);
 
-	if (tgt_device)
-		btrfs_destroy_dev_replace_tgtdev(tgt_device);
+		btrfs_info_in_rcu(fs_info,
+		"suspended dev_replace from %s (devid %llu) to %s canceled",
+			btrfs_dev_name(src_device), src_device->devid,
+			btrfs_dev_name(tgt_device));
+
+		if (tgt_device)
+			btrfs_destroy_dev_replace_tgtdev(tgt_device);
+		break;
+	default:
+		result = -EINVAL;
+	}
 
-leave:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 	return result;
 }
-- 
2.19.1

