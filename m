Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63826C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24442208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5s8WTDe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24442208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbeKLALO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbeKLALO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEInO0171429
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Jw3rpiQ39EO3PUtPJQcbsmzZSa0SHGh6XyAwA5OHki8=;
 b=O5s8WTDei+gBa17/lrvlcWToG7EIwPcQ9xvd9tE9ZHl18UtAFveoz/y9SNuwtcsijint
 me0N8lJqEsoYo+t42qSKtqyB1qA6Ge5ud6VI4wdjIhWzie5yhN7hj0KwlrkzQIDgL4GZ
 kojwEXOwn7T+tKxzN68Br6mO6IL7etcMGbQew6+l5e1gX0o6+CHQi2d92AGNRFFpkjXU
 xzO0FGcBLvZaqyMeNs1FL/ZKGGb/ifv5LJ+LcfsGn7ocPaVkQFsgAokh7IBK+z/K9429
 /Mbcj/2F6p8MdEQ5ypdTIhyQ1/QPeIIDm4W77dG/OXA+fnF/QkhmrTEH6DWfk22swmxL Aw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nnw6ea4a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMUbn010344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:30 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMUqg010324
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:30 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:30 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: fix UAF due to race between replace start and cancel
Date:   Sun, 11 Nov 2018 22:22:19 +0800
Message-Id: <1541946144-8174-5-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
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
index 35ce10f18607..d32d696d931c 100644
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

