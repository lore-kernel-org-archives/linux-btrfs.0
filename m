Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F39C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 05:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD3121780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 05:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nuZl/a96"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD3121780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbeKNPwI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 10:52:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49562 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbeKNPwI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 10:52:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAE5mwXa185446
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 05:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=wYvBVUqSEOlxah/nyN/E35+3f1gdC6hvhT94SBYOhF0=;
 b=nuZl/a96Yh5B3QzjljP8VqE2KMasq1fvaoFqClndAp+RdfBPWw880GQsxhB9ujIapmZ9
 7Qb+5IIcNDqQIlo80QoYzE5uRuFQr19SMEH/RsWJFyrqcx1FFml8uA9P48XYhKOSxcYe
 oYr4wMINC4gWG6gSqW2M97rr4pI4hWF5GRB0Jz+vXu3wYCfwPIf/SiAxqqqqO/m6rcdl
 LXhBx3ho7Bi1hM9kmy1hnUoQ2KJ2T0rJDh24lhMaN3zr8BNuSi2mF46vyHyzb/+Xy0xb
 MY5G4D5TLml0bMtOI+ab9dkEFtz7ieNFZFa+B+tPQq91vwhBUbsAZuQpDfzEJNSs5vgm 7A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nr7cs16hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 05:50:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAE5oMtK031476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 05:50:22 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAE5oMOX010643
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 05:50:22 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 21:50:22 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9 v2.1] btrfs: fix UAF due to race between replace start and cancel
Date:   Wed, 14 Nov 2018 13:50:26 +0800
Message-Id: <1542174626-26129-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-5-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-5-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140052
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
v2->v2.1: Fix compiler warning. (I couldn't reproduce on gcc 4.8.5)

fs/btrfs/dev-replace.c: In function ‘btrfs_dev_replace_cancel’:
fs/btrfs/dev-replace.c:865:9: warning: ‘result’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return result;
         ^~~~~~

v1->v2: pls ref to the cover letter

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

