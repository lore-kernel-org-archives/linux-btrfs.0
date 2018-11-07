Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C38EC46464
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F09612081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aocCFaE9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F09612081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeKGVNl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeKGVNk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7Bd8Lh166965
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=mPGwsT0mloa5ITNh/eaiMKCWl8zB4J28TApY64RRkZU=;
 b=aocCFaE9WbVnsVvJqDMkfUoNw+eZGJ3LZl3HGzgimR0ZpIIjrvYJANxrsWewBWYTb1OQ
 3k2T0Hk012VmsZeB2miIUPZV8KTeJl2TmolE88tgXAY5U5BEIU/kywrFWh+m6IdSrrNV
 hHdn1reeL+cGNfgLMcSqKMCy1CR3F8mgHb5EHIAQCWSIWwXj6S1WlguPylImmvb2C6rj
 kyYat19g258Zy42yl9XbGHaA5OAix+YeVNC+rGgGuffaJxORD7bUh0rFa7XvYYPVc0/q
 RMMIeB3nchnxqhILbuQj6+8ynSUaS0K6CybxXxgEXhJMfUrXr4734xnc30qUgaiIMZIx hw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nh3mpty7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7Bhd81000350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:39 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA7BhdEm005518
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:39 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:39 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: fix UAF due to race between replace start and cancel
Date:   Wed,  7 Nov 2018 19:43:25 +0800
Message-Id: <1541591010-29789-5-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

replace cancel thread can race with the replace start thread and if
fs_info::scrubs_running is not yet set the btrfs_scrub_cancel() will fail
to stop the scrub thread, so the scrub thread continue with the scrub for
replace which then shall try to write to the target device and which is
already freed by the cancel thread. Please ref to the logs below.

So scrub_setup_ctx() warns as tgtdev is null.

static noinline_for_stack
struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int
is_dev_replace)
{
::
        if (is_dev_replace) {
                WARN_ON(!fs_info->dev_replace.tgtdev);  <===
                sctx->pages_per_wr_bio = SCRUB_PAGES_PER_WR_BIO;
                sctx->wr_tgtdev = fs_info->dev_replace.tgtdev;
                sctx->flush_all_writes = false;
        }

[ 6724.497655] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 1) to /dev/sdc started
[ 6753.945017] BTRFS info (device sdb): dev_replace from /dev/sdb (devid 1) to /dev/sdc canceled
[ 6852.426700] WARNING: CPU: 0 PID: 4494 at fs/btrfs/scrub.c:622 scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
::
[ 6852.428928] RIP: 0010:scrub_setup_ctx.isra.19+0x220/0x230 [btrfs]
::
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

Further, as the replace thread enters the
scrub_write_page_to_dev_replace() without the target device it panics

static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
                                    struct scrub_page *spage)
{
::
      bio_set_dev(bio, sbio->dev->bdev); <======

[ 6929.715145] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
::
[ 6929.717106] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
[ 6929.717420] RIP: 0010:scrub_write_page_to_dev_replace+0xb4/0x260
[btrfs]
::
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
---
 fs/btrfs/dev-replace.c | 61 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e001c2418940..90c124edec76 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -797,39 +797,56 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
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
+		/*
+		 * btrfs_dev_replace_finishing() will handle the cleanup part
+		 */
+		btrfs_info_in_rcu(fs_info,
+			"dev_replace from %s (devid %llu) to %s canceled",
+			btrfs_dev_name(src_device), src_device->devid,
+			btrfs_dev_name(tgt_device));
+		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
+		/*
+		 * scrub doing the replace isn't running so do the cleanup here
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
+		dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
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
+	}
 
-leave:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 	return result;
 }
-- 
1.8.3.1

