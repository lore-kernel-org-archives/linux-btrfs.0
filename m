Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58637 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759879Ab3CZTiI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:38:08 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 978337C04E0
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:38:08 -0600 (MDT)
Date: Tue, 26 Mar 2013 15:38:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130326193805.GG28030@localhost.localdomain>
References: <20130326133053.GK1955@localhost.localdomain>
 <5151A75C.6080703@profihost.ag>
 <20130326144426.GL1955@localhost.localdomain>
 <5151B8AF.60900@profihost.ag>
 <20130326152553.GN1955@localhost.localdomain>
 <5151CA87.3050801@profihost.ag>
 <20130326174554.GB28030@localhost.localdomain>
 <5151F180.4050405@profihost.ag>
 <20130326191651.GF28030@localhost.localdomain>
 <5151F56C.5070502@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5151F56C.5070502@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 01:22:20PM -0600, Stefan Priebe wrote:
> Hi,
> 
> but when i transfer big files i see now this one:
> [20368.784736] INFO: task rsync:14911 blocked for more than 120 seconds.
> [20368.821978] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [20368.895140] rsync           D ffffffff8160f580     0 14911      1 
> 0x00000000
> [20368.895148]  ffff8801ca63fc78 0000000000000086 ffff8800c28f8198 
> ffff88022394f800
> [20368.895158]  ffff8801ca63ffd8 ffff8801ca63ffd8 ffff8801ca63ffd8 
> 0000000000012c40
> [20368.895163]  ffffffff81a11440 ffff8801c9d36340 ffff8801ca63fc88 
> ffff8801cefce130
> [20368.895169] Call Trace:
> [20368.895180]  [<ffffffff8151a774>] schedule+0x24/0x70
> [20368.895207]  [<ffffffffa0158c75>] 
> wait_current_trans.isra.32+0x95/0x100 [btrfs]
> [20368.895214]  [<ffffffff8106d4f0>] ? add_wait_queue+0x60/0x60
> [20368.895236]  [<ffffffffa015a45d>] 
> start_transaction.part.33+0x13d/0x4d0 [btrfs]
> [20368.895252]  [<ffffffff811420f3>] ? inode_permission+0x13/0x50
> [20368.895271]  [<ffffffffa015a814>] start_transaction+0x24/0x30 [btrfs]
> [20368.895287]  [<ffffffffa015aae3>] btrfs_start_transaction+0x13/0x20 
> [btrfs]
> [20368.895302]  [<ffffffffa015b2f0>] __unlink_start_trans+0x70/0x460 [btrfs]
> [20368.895307]  [<ffffffff8150ee3e>] ? check_acl+0x5a/0x122
> [20368.895312]  [<ffffffff81055ff0>] ? ns_capable+0x30/0x60
> [20368.895317]  [<ffffffff811413bd>] ? generic_permission+0xbd/0x110
> [20368.895336]  [<ffffffffa0163f92>] btrfs_unlink+0x32/0xc0 [btrfs]
> [20368.895341]  [<ffffffff8114186d>] vfs_unlink.part.61+0x6d/0xd0
> [20368.895345]  [<ffffffff81143ad7>] vfs_unlink+0x37/0x50
> [20368.895349]  [<ffffffff81143c8b>] do_unlinkat+0x19b/0x240
> [20368.895354]  [<ffffffff81146171>] sys_unlink+0x11/0x20
> [20368.895359]  [<ffffffff8151c2e9>] system_call_fastpath+0x16/0x1b
> 
> Speed is just 100kb/s instead of 100MB/s.
> 

Hrm I wonder if 512 is too small for your case, can you add this patch to the
pile and see what dmesg says when you are having these problems?  Thanks,

Josef


diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 50767bb..d19c9f6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -31,6 +31,7 @@
 #include "inode-map.h"
 #include "volumes.h"
 #include "dev-replace.h"
+#include "math.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -576,10 +577,19 @@ void btrfs_throttle(struct btrfs_root *root)
 static int should_end_transaction(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root)
 {
-	int ret;
+	struct btrfs_block_rsv *block_rsv = &root->fs_info->global_block_rsv;
+	u64 num_bytes = 0;
+	int ret = 1;
 
-	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
-	return ret ? 1 : 0;
+	spin_lock(&block_rsv->lock);
+	num_bytes = div_factor(block_rsv->size, 5);
+	if (block_rsv->reserved >= num_bytes)
+		ret = 0;
+	else
+		printk(KERN_ERR "we're pretty low, setting blocked, reserved %Lu, size %Lu, num %Lu\n",
+		       block_rsv->reserved, block_rsv->size, num_bytes);
+	spin_unlock(&block_rsv->lock);
+	return ret;
 }
 
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

