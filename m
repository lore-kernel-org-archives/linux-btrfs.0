Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35904 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2GDDh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 23:37:29 -0400
Received: by wgbdr13 with SMTP id dr13so6916119wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 20:37:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
Date: Wed, 4 Jul 2012 11:37:28 +0800
Message-ID: <CAMVG2st-qr+PpTUQB=wQ-_21h=d86=aDayb7FvFSSZf4ZyRVhQ@mail.gmail.com>
Subject: Re: Please hammer my for-linus branch
From: Daniel J Blueman <daniel@quora.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Josef Bacik <jbacik@fusionio.com>, liubo <liubo2009@cn.fujitsu.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hi everyone,
>
> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
> for-linus branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>
> Some of the changes are fixes for the tree logging code, so I ran some
> extra crash runs against them Friday night.
>
> I ended up with a new crash in the tree log directory deletion replay
> code, so I didn't send out the pull request to Linus.
>
> It isn't clear yet if the new crash is because I was testing differently
> or if it is a regression.  I'm nailing it down this weekend, but please
> give my for-linus a shot.

I consistently run into this assertion [1] while running a fio
workload on a fresh RAID10 filesystem with a balance running.

Let me know if you need steps to reproduce, debug etc.

Thanks,
  Daniel

--- [1]

kernel BUG at fs/btrfs/extent-tree.c:1728!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC CPU 1

Modules linked in: brd dm_crypt dm_mod kvm_intel kvm binfmt_misc
coretemp microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi netconsole btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video

Pid: 31436, comm: btrfs Tainted: G        W    3.4.0-debug+ #6 Dell
Inc. Latitude E5420/0H5TG2
RIP: 0010:[<ffffffffa00ad739>]  [<ffffffffa00ad739>]
update_inline_extent_backref+0x2a9/0x2b0 [btrfs]
RSP: 0018:ffff88021dfab858  EFLAGS: 00010213
RAX: 00000000000000b0 RBX: ffff8802061555a0 RCX: ffff88021cf1d000
RDX: 0000000000000000 RSI: 0000000000000f3a RDI: ffff8800c4e5bc20
RBP: ffff88021dfab8b8 R08: 00000000000000b0 R09: ffff88021dfab808
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800c4e5bc20
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000f10
FS:  00007fdb25012740(0000) GS:ffff88022ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f882b763f70 CR3: 000000021d547000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 31436, threadinfo ffff88021dfaa000, task ffff88021fdc5ca0)
Stack:
 ffff8801ff3ed000 000000098123124f ffff8801ff3ed000 ffff8802083270a0
 0000000000000000 0000000000000f3a ffff880206156000 ffff8802061555a0
 ffff8801ff3ed000 ffff8802083270a0 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa00ad7c8>] insert_inline_extent_backref+0x88/0x100 [btrfs]
 [<ffffffffa00a0be5>] ? btrfs_alloc_path+0x15/0x20 [btrfs]
 [<ffffffffa00ad8da>] __btrfs_inc_extent_ref+0x9a/0x1f0 [btrfs]
 [<ffffffffa00af077>] run_delayed_tree_ref+0x167/0x190 [btrfs]
 [<ffffffffa00b2efe>] run_one_delayed_ref+0xde/0xf0 [btrfs]
 [<ffffffffa00b2fed>] run_clustered_refs+0xdd/0x370 [btrfs]
 [<ffffffffa00b33c9>] btrfs_run_delayed_refs+0x149/0x340 [btrfs]
 [<ffffffffa00c4c97>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
 [<ffffffffa00c4f93>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
 [<ffffffffa01114e9>] relocate_block_group+0x439/0x560 [btrfs]
 [<ffffffffa01117d4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eea4a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e9722>] ? free_extent_buffer+0x32/0x90 [btrfs]
 [<ffffffffa00f1db4>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00f21a3>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f7f30>] btrfs_ioctl_balance+0x140/0x440 [btrfs]
 [<ffffffffa00fbd67>] btrfs_ioctl+0x5c7/0x7f0 [btrfs]
 [<ffffffff810f1616>] ? do_brk+0x246/0x360
 [<ffffffff8112f607>] do_vfs_ioctl+0x87/0x340
 [<ffffffff8122a434>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8112f90a>] sys_ioctl+0x4a/0x80
 [<ffffffff815b8122>] system_call_fastpath+0x16/0x1b
Code:e8 5d f6 02 00 45 31 c9 48 8b 4d a0 89 c2 44 8b 45 a8 eb b5 66 0f
1f 44 00 00 41 bd 0d 00 00 00 00 41 be 0d 00 00 00 00 e9 6b fe ff ff
f>0b 0f 0b 0f 1f 00 55 48 89 e5 48 83 c4 80 48 8b 45 20 4c 89
RIP  [<ffffffffa00ad739>] update_inline_extent_backref+0x2a9/0x2b0 [btrfs]
 RSP <ffff88021dfab858>
-- 
Daniel J Blueman
