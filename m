Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52988 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab3BKUfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 15:35:40 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 160917C0433
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 13:35:40 -0700 (MST)
Date: Mon, 11 Feb 2013 15:35:37 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the deadlock between the transaction attach
 and commit
Message-ID: <20130211203537.GB2611@localhost.localdomain>
References: <5114A177.5020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5114A177.5020604@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 11:55:51PM -0700, Miao Xie wrote:
> Here is the whole story:
> 	Trans_Attach_Task		Trans_Commit_Task
> 					btrfs_commit_transaction()
> 					 |->wait writers to be 1
> 	btrfs_attach_transaction()	 |
> 	btrfs_commit_transaction()	 |
> 	 |				 |->set trans_no_join to 1
> 	 |				 |  (close join transaction)
> 	 |->btrfs_run_ordered_operations |
> 	    (Those ordered operations	 |
> 	     are added when releasing	 |
> 	     file)			 |
> 	     |->btrfs_join_transaction() |
> 		|->wait_commit()	 |
> 					 |->wait writers to be 1
> 
> Then these two tasks waited for each other.
> 
> As we know, btrfs_attach_transaction() is used to catch the current
> transaction, and commit it, so if someone has committed the transaction,
> it is unnecessary to join it and commit it, wait is the best choice
> for it. In this way, we can fix the above problem.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

This caused another problem

[ 8050.503904] btrfs-transacti D 0000000000000000     0  5546      2 0x00000080
[ 8050.503913]  ffff88037bfb9d18 0000000000000046 ffff88037bfb9cb8 ffffffff810c6d4d
[ 8050.503924]  ffff88037c4d8000 ffff88037bfb9fd8 ffff88037bfb9fd8 ffff88037bfb9fd8
[ 8050.503933]  ffff88042f17a000 ffff88037c4d8000 ffff88042c33b000 ffff88037ba0bdb8
[ 8050.503943] Call Trace:
[ 8050.503953]  [<ffffffff810c6d4d>] ? trace_hardirqs_on+0xd/0x10
[ 8050.503962]  [<ffffffff816507c9>] schedule+0x29/0x70
[ 8050.504002]  [<ffffffffa084eb75>] wait_current_trans+0xb5/0x110 [btrfs]
[ 8050.504011]  [<ffffffff810891f0>] ? __init_waitqueue_head+0x60/0x60
[ 8050.504047]  [<ffffffffa08503c0>] start_transaction+0x160/0x4e0 [btrfs]
[ 8050.504082]  [<ffffffffa0850757>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[ 8050.504114]  [<ffffffffa084857a>] transaction_kthread+0x15a/0x240 [btrfs]
[ 8050.504147]  [<ffffffffa0848420>] ? btrfs_destroy_delayed_refs+0x330/0x330 [btrfs]
[ 8050.504155]  [<ffffffff8108883a>] kthread+0xea/0xf0
[ 8050.504166]  [<ffffffff81088750>] ? flush_kthread_worker+0x150/0x150
[ 8050.504175]  [<ffffffff8165a06c>] ret_from_fork+0x7c/0xb0
[ 8050.504183]  [<ffffffff81088750>] ? flush_kthread_worker+0x150/0x150
[ 8050.504189] sync            D 0000000000000000     0  5572   5342 0x00000080
[ 8050.504198]  ffff88037c235dd8 0000000000000046 ffff88037c235d78 ffffffff810c6d4d
[ 8050.504207]  ffff88037ca8a000 ffff88037c235fd8 ffff88037c235fd8 ffff88037c235fd8
[ 8050.504217]  ffff88042f184000 ffff88037ca8a000 ffff88042c33b000 ffff88037ba0bdb8
[ 8050.504227] Call Trace:
[ 8050.504236]  [<ffffffff810c6d4d>] ? trace_hardirqs_on+0xd/0x10
[ 8050.504245]  [<ffffffff816507c9>] schedule+0x29/0x70
[ 8050.504278]  [<ffffffffa084eb75>] wait_current_trans+0xb5/0x110 [btrfs]
[ 8050.504287]  [<ffffffff810891f0>] ? __init_waitqueue_head+0x60/0x60
[ 8050.504322]  [<ffffffffa08503c0>] start_transaction+0x160/0x4e0 [btrfs]
[ 8050.504360]  [<ffffffffa0866d94>] ? btrfs_wait_ordered_extents+0x174/0x230 [btrfs]
[ 8050.504395]  [<ffffffffa0850757>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[ 8050.504420]  [<ffffffffa0820133>] btrfs_sync_fs+0x53/0x130 [btrfs]
[ 8050.504430]  [<ffffffff811cac30>] ? __sync_filesystem+0x60/0x60
[ 8050.504438]  [<ffffffff811cac30>] ? __sync_filesystem+0x60/0x60
[ 8050.504447]  [<ffffffff811cac50>] sync_fs_one_sb+0x20/0x30
[ 8050.504455]  [<ffffffff8119e0c1>] iterate_supers+0xf1/0x100
[ 8050.504463]  [<ffffffff811cad25>] sys_sync+0x55/0x90
[ 8050.504472]  [<ffffffff8165a119>] system_call_fastpath+0x16/0x1b

So we're getting stuck in the

if (may_wait_transaction())
	wait_current_trans();

thing.  If we set blocked in __btrfs_end_transaction we'll just sit there
forever because nobody can actually commit the transaction.  Probably need to
change this to

if (type == TRANS_ATTACH && trans->in_commit)

or something like that.  Me and kdave reproduced by running 274 in a loop, it
happpened pretty quick.  I'd fix it myself but I have to leave my house for
people to come look at it.  If you haven't fixed this by tomorrow I'll fix it
up.  Thanks,

Josef
