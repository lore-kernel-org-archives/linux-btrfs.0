Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46998 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932226AbdCXCAl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 22:00:41 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v2 4/5] btrfs: dev-replace: Wait flighting bio before removing target device
Date: Fri, 24 Mar 2017 10:00:26 +0800
Message-ID: <20170324020027.21228-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When dev replace is cancelled by running scrub, we will free target
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
 Code: 67 28 48 c7 c7 27 7f c9 81 e8 90 6c d4 ff e8 0b bb 54 00 41 c1 ec 09 48 8b 7b 08 45 85 e4 0f 85 be 00 00 00 48 8b 87 00 01 00 00 <4c> 8b b0 e0 05 00 00 4d 85 f6 0f 84 86 01 00 00 4c 8b af f0 00
 RIP: generic_make_request_checks+0x4d/0x610 RSP: ffffc90001337bb8

In btrfs_dev_replace_finishing(), we will call
btrfs_rm_dev_replace_blocked() to wait bios before destroying the target
device when scrub is finished normally.

However when scrub is aborted, either due to error or canceled by scrub,
we didn't wait bios, this can leads to use-after-free if there are bios
holding the target device.

Fix it by also calling btrfs_rm_dev_replace_blocked() before calling
btrfs_destroy_dev_replace_tgtdev().

Cc: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.12.1



