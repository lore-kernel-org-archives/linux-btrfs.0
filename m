Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:48362 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933033AbcKJOfd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 09:35:33 -0500
Date: Thu, 10 Nov 2016 09:35:20 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs btree_ctree_super fault
Message-ID: <20161110143520.6fdu34afv45ui3y6@codemonkey.org.uk>
References: <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161106165539.ybwm6rqvzh2k6uja@codemonkey.org.uk>
 <20161108145912.fcjvwxcpqgd7kjei@codemonkey.org.uk>
 <01d76d90-8d90-e09b-40a0-63488425348d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01d76d90-8d90-e09b-40a0-63488425348d@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 10:08:04AM -0500, Chris Mason wrote:
 
 > > And another new one:
 > >
 > > kernel BUG at fs/btrfs/ctree.c:3172!
 > > 
 > > Call Trace:
 > >  [<ffffffffa009cff0>] __btrfs_drop_extents+0xb00/0xe30 [btrfs]
 > 
 > We've been hunting this one for at least two years.  It's the white 
 > whale of btrfs bugs.  Josef has a semi-reliable reproducer now, but I 
 > think it's not the same as the pagevec based problems you reported earlier.

Great, now for whatever reason, I'm hitting this over and over.

Even better, after the last time I hit it, it reboot and this happened during boot..

BTRFS info (device sda6): disk space caching is enabled
BTRFS info (device sda6): has skinny extents
BTRFS info (device sda3): disk space caching is enabled
------------[ cut here ]------------
WARNING: CPU: 1 PID: 443 at fs/btrfs/file.c:546 btrfs_drop_extent_cache+0x411/0x420 [btrfs]
CPU: 1 PID: 443 Comm: mount Not tainted 4.9.0-rc4-think+ #1 
 ffffc90000c4b468  ffffffff813b66bc  0000000000000000  0000000000000000
 ffffc90000c4b4a8  ffffffff81086d2b  0000022200c4b488  000000000002f265
 40c8dded1afd6000  ffff8804ff5cddc8  ffff8804ef26f2b8  40c8dded1afd5000
Call Trace:
 [<ffffffff813b66bc>] dump_stack+0x4f/0x73
 [<ffffffff81086d2b>] __warn+0xcb/0xf0
 [<ffffffff81086e5d>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa009c0f1>] btrfs_drop_extent_cache+0x411/0x420 [btrfs]
 [<ffffffff81215923>] ? alloc_debug_processing+0x73/0x1b0
 [<ffffffffa009c93f>] __btrfs_drop_extents+0x44f/0xe30 [btrfs]
 [<ffffffffa005426a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa005426a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffff8121842a>] ? kmem_cache_alloc+0x2aa/0x330
 [<ffffffffa005426a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa009e399>] btrfs_drop_extents+0x79/0xa0 [btrfs]
 [<ffffffffa00ce4d1>] replay_one_extent+0x1e1/0x710 [btrfs]
 [<ffffffffa00cec6d>] replay_one_buffer+0x26d/0x7e0 [btrfs]
 [<ffffffff8121732c>] ? ___slab_alloc.constprop.83+0x27c/0x5c0
 [<ffffffffa005426a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffff813d5b87>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffffa00ca3db>] walk_up_log_tree+0xeb/0x240 [btrfs]
 [<ffffffffa00ca5d6>] walk_log_tree+0xa6/0x1d0 [btrfs]
 [<ffffffffa00d32fc>] btrfs_recover_log_trees+0x1dc/0x460 [btrfs]
 [<ffffffffa00cea00>] ? replay_one_extent+0x710/0x710 [btrfs]
 [<ffffffffa0081f65>] open_ctree+0x2575/0x2670 [btrfs]
 [<ffffffffa005144b>] btrfs_mount+0xd0b/0xe10 [btrfs]
 [<ffffffff811da804>] ? pcpu_alloc+0x2d4/0x660
 [<ffffffff810dce41>] ? lockdep_init_map+0x61/0x200
 [<ffffffff810d39eb>] ? __init_waitqueue_head+0x3b/0x50
 [<ffffffff81243794>] mount_fs+0x14/0xa0
 [<ffffffff8126305b>] vfs_kern_mount+0x6b/0x150
 [<ffffffffa0050a08>] btrfs_mount+0x2c8/0xe10 [btrfs]
 [<ffffffff811da804>] ? pcpu_alloc+0x2d4/0x660
 [<ffffffff810dce41>] ? lockdep_init_map+0x61/0x200
 [<ffffffff810dce41>] ? lockdep_init_map+0x61/0x200
 [<ffffffff810d39eb>] ? __init_waitqueue_head+0x3b/0x50
 [<ffffffff81243794>] mount_fs+0x14/0xa0
 [<ffffffff8126305b>] vfs_kern_mount+0x6b/0x150
 [<ffffffff81265bd2>] do_mount+0x1c2/0xda0
 [<ffffffff811d41c0>] ? memdup_user+0x60/0x90
 [<ffffffff81266ac3>] SyS_mount+0x83/0xd0
 [<ffffffff81002d81>] do_syscall_64+0x61/0x170
 [<ffffffff81894ccb>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace d3fa03bb9c115bbe ]---
BTRFS: error (device sda3) in btrfs_replay_log:2491: errno=-17 Object already exists (Failed to recover log tree)
BTRFS error (device sda3): cleaner transaction attach returned -30
BTRFS error (device sda3): open_ctree failed


Guess I'll hit it with btrfsck and hope for the best..

	Dave
