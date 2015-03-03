Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbbCCQff (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 11:35:35 -0500
Date: Tue, 3 Mar 2015 17:35:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
Message-ID: <20150303163533.GE11093@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425318415-322-1-git-send-email-jbacik@fb.com>
 <20150303110257.GA18292@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150303110257.GA18292@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 07:02:58PM +0800, Liu Bo wrote:
> On Mon, Mar 02, 2015 at 12:46:55PM -0500, Josef Bacik wrote:
> > Dave could hit this assert consistently running btrfs/078.  This is because
> > when we update the block groups we could truncate the free space, which would
> > try to delete the csums for that range and dirty the csum root.  For this to
> > happen we have to have already written out the csum root so it's kind of hard to
> > hit this case.  This patch fixes this by changing the logic to only write the
> > dirty block groups if the dirty_cowonly_roots list is empty.  This will get us
> > the same effect as before since we add the extent root last, and will cover the
> > case that we dirty some other root again but not the extent root.  Thanks,
> 
> Free space inode is NODATASUM, so its searching csum tree in
> __btrfs_free_extent() is really unnecessary, by skipping that, csum tree
> won't be inserted into dirty_cowonly_roots list again, so it also passed btrfs/078,
> at least on my box.

I can hit the bug [1] even with Josef's patch, I'm can test your fix if you
want.

MKFS_OPTIONS  -- -O skinny-metadata,extref -m single -d single --mixed /dev/sdc1
MOUNT_OPTIONS -- -o enospc_debug,space_cache,noatime /dev/sdc1 /mnt/a2

on top of 3.19-rc5 with Chris' for-linus.


[1]

[  773.601170] BTRFS: assertion failed: list_empty(&cur_trans->dirty_bgs), file: fs/btrfs/transaction.c, line: 2007
[  773.601170] ------------[ cut here ]------------
[  773.601172] kernel BUG at fs/btrfs/ctree.h:4012!
[  773.601177] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  773.601183] Modules linked in: rpcsec_gss_krb5 loop btrfs
[  773.601187] CPU: 1 PID: 28350 Comm: fsstress Tainted: G        W      3.19.0-rc5-default+ #233
[  773.601189] Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS TSRSCRB1.86C.0047.B00.0610170821 10/17/06
[  773.601191] task: ffff88004e220000 ti: ffff880076f30000 task.ti: ffff880076f30000
[  773.601220] RIP: 0010:[<ffffffffa003824e>]  [<ffffffffa003824e>] assfail.clone.0+0x1e/0x20 [btrfs]
[  773.601224] RSP: 0018:ffff880076f33e58  EFLAGS: 00010292
[  773.601226] RAX: 0000000000000064 RBX: ffff8800789026e0 RCX: 0000000000000001
[  773.601227] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
[  773.601229] RBP: ffff880076f33e58 R08: 0000000000000001 R09: 0000000000000000
[  773.601230] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880075c3d000
[  773.601232] R13: ffff880078927518 R14: ffff880078927380 R15: ffff88006bab63a8
[  773.601234] FS:  00007fb829fd4700(0000) GS:ffff88007d400000(0000) knlGS:0000000000000000
[  773.601236] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  773.601237] CR2: 00007f0fa86f3990 CR3: 0000000079102000 CR4: 00000000000007e0
[  773.601239] Stack:
[  773.601244]  ffff880076f33ed8 ffffffffa0039d9b ffff88007892738c 00ff880075c3d000
[  773.601249]  0000000000000000 ffff88004e220000 ffff8800781dd730 ffff880075c3d000
[  773.601254]  ffff880075c3d000 ffff880075f7e868 0000000000000001 ffff8800781dc000
[  773.601256] Call Trace:
[  773.601274]  [<ffffffffa0039d9b>] btrfs_commit_transaction+0xb1b/0xb60 [btrfs]
[  773.601289]  [<ffffffffa0004679>] btrfs_sync_fs+0x79/0x120 [btrfs]
[  773.601295]  [<ffffffff811d3610>] ? SyS_tee+0x360/0x360
[  773.601298]  [<ffffffff811d3630>] sync_fs_one_sb+0x20/0x30
[  773.601303]  [<ffffffff811a5231>] iterate_supers+0xf1/0x100
[  773.601307]  [<ffffffff811d3965>] sys_sync+0x55/0x90
[  773.601313]  [<ffffffff81a9fc12>] system_call_fastpath+0x12/0x17
