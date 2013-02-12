Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099Ab3BLM4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 07:56:34 -0500
Date: Tue, 12 Feb 2013 13:56:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the deadlock between the transaction attach
 and commit
Message-ID: <20130212125632.GV12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5114A177.5020604@cn.fujitsu.com>
 <20130211203537.GB2611@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130211203537.GB2611@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 03:35:37PM -0500, Josef Bacik wrote:
> or something like that.  Me and kdave reproduced by running 274 in a loop, it
> happpened pretty quick.  I'd fix it myself but I have to leave my house for
> people to come look at it.  If you haven't fixed this by tomorrow I'll fix it
> up.  Thanks,

I found 224 stuck with this

[ 3840.176147] INFO: task btrfs-transacti:3692 blocked for more than 480 seconds.
[ 3840.176157] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3840.176162] btrfs-transacti D 0000000000000000     0  3692      2 0x00000000
[ 3840.176172]  ffff880103a3bd98 0000000000000046 0000000000000000 ffff880103a3a010
[ 3840.176183]  ffff880103a3a000 ffff880103a3a010 ffff880103a3a000 ffff880103a3a000
[ 3840.176190]  ffff880103a3a000 ffff880103a3bfd8 ffff880102814800 ffffffff81a14420
[ 3840.176200] Call Trace:
[ 3840.176218]  [<ffffffff8108a0c9>] ? enqueue_entity+0x229/0xa40
[ 3840.176230]  [<ffffffff815efc14>] schedule+0x24/0x70
[ 3840.176296]  [<ffffffffa00cd0f5>] wait_current_trans+0xc5/0x110 [btrfs]
[ 3840.176306]  [<ffffffff8106d890>] ? wake_up_bit+0x40/0x40
[ 3840.176361]  [<ffffffffa00cfa48>] start_transaction+0x228/0x4c0 [btrfs]
[ 3840.176400]  [<ffffffffa00cfcf2>] btrfs_attach_transaction+0x12/0x20 [btrfs]
[ 3840.176434]  [<ffffffffa00c95c7>] transaction_kthread+0x167/0x220 [btrfs]
[ 3840.176476]  [<ffffffffa00c9460>] ? __btree_submit_bio_start+0x10/0x10 [btrfs]
[ 3840.176494]  [<ffffffff8106d086>] kthread+0xc6/0xd0
[ 3840.176506]  [<ffffffff8106cfc0>] ? kthread_freezable_should_stop+0x70/0x70
[ 3840.176514]  [<ffffffff815f82bc>] ret_from_fork+0x7c/0xb0
[ 3840.176522]  [<ffffffff8106cfc0>] ? kthread_freezable_should_stop+0x70/0x70
[ 3840.176528] INFO: task rm:15763 blocked for more than 480 seconds.
[ 3840.176531] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3840.176534] rm              D 0000000000000002     0 15763   3517 0x00000000
[ 3840.176544]  ffff8801071b7c88 0000000000000086 00000002000280da ffff8801071b6010
[ 3840.176551]  ffff8801071b6000 ffff8801071b6010 ffff8801071b6000 ffff8801071b6000
[ 3840.176558]  ffff8801071b6000 ffff8801071b7fd8 ffff8800be5762c0 ffff88012af063c0
[ 3840.176567] Call Trace:
[ 3840.176578]  [<ffffffff8111f942>] ? __alloc_pages_nodemask+0x162/0x250
[ 3840.176608]  [<ffffffffa00be468>] ? reserve_metadata_bytes+0x378/0x490 [btrfs]
[ 3840.176622]  [<ffffffff815efc14>] schedule+0x24/0x70
[ 3840.176664]  [<ffffffffa00cd0f5>] wait_current_trans+0xc5/0x110 [btrfs]
[ 3840.176671]  [<ffffffff8106d890>] ? wake_up_bit+0x40/0x40
[ 3840.176721]  [<ffffffffa00cfa48>] start_transaction+0x228/0x4c0 [btrfs]
[ 3840.176769]  [<ffffffffa00cffd3>] btrfs_start_transaction+0x13/0x20 [btrfs]
[ 3840.176812]  [<ffffffffa00d192e>] __unlink_start_trans+0x7e/0x490 [btrfs]
[ 3840.176832]  [<ffffffff811891d7>] ? __d_lookup+0xa7/0x170
[ 3840.176839]  [<ffffffff811432f1>] ? handle_pte_fault+0x91/0x200
[ 3840.176849]  [<ffffffff81291fc9>] ? security_inode_permission+0x19/0x20
[ 3840.176893]  [<ffffffffa00daca6>] btrfs_unlink+0x36/0xd0 [btrfs]
[ 3840.176899]  [<ffffffff8117f7f4>] vfs_unlink+0xb4/0x110
[ 3840.176905]  [<ffffffff81183f83>] do_unlinkat+0x233/0x240
[ 3840.176912]  [<ffffffff811841ad>] sys_unlinkat+0x1d/0x40
[ 3840.176918]  [<ffffffff815f8369>] system_call_fastpath+0x16/0x1b

mounted with noatime,space_cache

david
