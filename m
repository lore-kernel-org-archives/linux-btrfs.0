Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaBHHil (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 02:38:41 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s187ceCe021575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Feb 2014 07:38:41 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s187cdPl021497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Feb 2014 07:38:39 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s187cd37023946
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Feb 2014 07:38:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix a spinlock warning when cleaning up aborted transaction
Date: Sat,  8 Feb 2014 15:38:08 +0800
Message-Id: <1391845088-14665-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given now we have 2 spinlock for management of delayed refs,
CONFIG_DEBUG_SPINLOCK=y helped me find this,

[ 4723.413809] BUG: spinlock wrong CPU on CPU#1, btrfs-transacti/2258
[ 4723.414882]  lock: 0xffff880048377670, .magic: dead4ead, .owner: btrfs-transacti/2258, .owner_cpu: 2
[ 4723.417146] CPU: 1 PID: 2258 Comm: btrfs-transacti Tainted: G        W  O 3.12.0+ #4
[ 4723.421321] Call Trace:
[ 4723.421872]  [<ffffffff81680fe7>] dump_stack+0x54/0x74
[ 4723.422753]  [<ffffffff81681093>] spin_dump+0x8c/0x91
[ 4723.424979]  [<ffffffff816810b9>] spin_bug+0x21/0x26
[ 4723.425846]  [<ffffffff81323956>] do_raw_spin_unlock+0x66/0x90
[ 4723.434424]  [<ffffffff81689bf7>] _raw_spin_unlock+0x27/0x40
[ 4723.438747]  [<ffffffffa015da9e>] btrfs_cleanup_one_transaction+0x35e/0x710 [btrfs]
[ 4723.443321]  [<ffffffffa015df54>] btrfs_cleanup_transaction+0x104/0x570 [btrfs]
[ 4723.444692]  [<ffffffff810c1b5d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[ 4723.450336]  [<ffffffff810c1c2d>] ? trace_hardirqs_on+0xd/0x10
[ 4723.451332]  [<ffffffffa015e5ee>] transaction_kthread+0x22e/0x270 [btrfs]
[ 4723.452543]  [<ffffffffa015e3c0>] ? btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[ 4723.457833]  [<ffffffff81079efa>] kthread+0xea/0xf0
[ 4723.458990]  [<ffffffff81079e10>] ? kthread_create_on_node+0x140/0x140
[ 4723.460133]  [<ffffffff81692aac>] ret_from_fork+0x7c/0xb0
[ 4723.460865]  [<ffffffff81079e10>] ? kthread_create_on_node+0x140/0x140
[ 4723.496521] ------------[ cut here ]------------

----------------------------------------------------------------------

The reason is that we get to call cond_resched_lock(&head_ref->lock) while
still holding @delayed_refs->lock.

So it's different with __btrfs_run_delayed_refs(), where we do drop-acquire
dance before and after actually processing delayed refs.

Here we don't drop the lock, others are not able to add new delayed refs to
head_ref, so cond_resched_lock(&head_ref->lock) is not necessary here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Fix typo in the title, s/lockdep/spinlock/g

 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de6a48f..735738b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3853,7 +3853,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 			rb_erase(&ref->rb_node, &head->ref_root);
 			atomic_dec(&delayed_refs->num_entries);
 			btrfs_put_delayed_ref(ref);
-			cond_resched_lock(&head->lock);
 		}
 		if (head->must_insert_reserved)
 			pin_bytes = true;
-- 
1.8.1.4

