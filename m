From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Wed, 04 Jan 2012 21:23:18 -0500
Message-ID: <4F050996.1060206@cn.fujitsu.com>
References: <20120104214445.GE17026@dastard> <20120104221105.GF17026@dastard> <4F04D178.2070006@csamuel.org> <20120104230122.GA24466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120104230122.GA24466@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/04/2012 06:01 PM, Dave Chinner wrote:
> On Thu, Jan 05, 2012 at 09:23:52AM +1100, Chris Samuel wrote:
>> On 05/01/12 09:11, Dave Chinner wrote:
>>
>>> Looks to be reproducable.
>> Does this happen with rc6 ?
> 
> I haven't tried. All I'm doing is running some benchmarks to get
> numbers for a talk I'm giving about improvements in XFS metadata
> scalability, so I wanted to update my last set of numbers from
> 2.6.39.
> 
> As it was, these benchmarks also failed on btrfs with oopsen and
> corruptions back in 2.6.39 time frame.  e.g. same VM, same
> test, different crashes, similar slowdowns as reported here:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/11062
> 
> Given that there is now a history of this simple test uncovering
> problems, perhaps this is a test that should be run more regularly
> by btrfs developers?
> 
>> If not then it might be easy to track down as there are only
>> 2 modifications between rc6 and rc7..
> 
> They don't look like they'd be responsible for fixing an extent tree
> corruption, and I don't really have the time to do an open-ended
> bisect to find where the problem fix arose.
> 
> As it is, 3rd attempt failed at 22m inodes, without the warning this
> time:
> 
> [   59.433452] device fsid 4d27dc14-562d-4722-9591-723bd2bbe94c devid 1 transid 4 /dev/vdc
> [   59.437050] btrfs: disk space caching is enabled
> [  753.258465] ------------[ cut here ]------------
> [  753.259806] kernel BUG at fs/btrfs/extent-tree.c:5797!
> [  753.260014] invalid opcode: 0000 [#1] SMP
> [  753.260014] CPU 7
> [  753.260014] Modules linked in:
> [  753.260014]
> [  753.260014] Pid: 2874, comm: fs_mark Not tainted 3.2.0-rc7-dgc+ #167 Bochs Bochs
> [  753.260014] RIP: 0010:[<ffffffff815b475b>]  [<ffffffff815b475b>] run_clustered_refs+0x7eb/0x800
> [  753.260014] RSP: 0018:ffff8800430258a8  EFLAGS: 00010286
> [  753.260014] RAX: 00000000ffffffe4 RBX: ffff88009c8ab1c0 RCX: 0000000000000000
> [  753.260014] RDX: 0000000000000008 RSI: 0000000000000282 RDI: 0000000000000000
> [  753.260014] RBP: ffff880043025988 R08: 0000000000000000 R09: 0000000000000002
> [  753.260014] R10: ffff8801188f6000 R11: ffff880101b50d20 R12: ffff88008fc1ad40
> [  753.260014] R13: ffff88003940a6c0 R14: ffff880118a49000 R15: ffff88010fc77e80
> [  753.260014] FS:  00007f416ce90700(0000) GS:ffff88011fdc0000(0000) knlGS:0000000000000000
> [  753.260014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  753.260014] CR2: 00007f416c2f6000 CR3: 000000003aaea000 CR4: 00000000000006e0
> [  753.260014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  753.260014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  753.260014] Process fs_mark (pid: 2874, threadinfo ffff880043024000, task ffff8800090e6180)
> [  753.260014] Stack:
> [  753.260014]  0000000000000000 0000000000000000 ffff880000000001 0000000000000000
> [  753.260014]  ffff88010fc77f38 0000000000000e92 0000000000000000 0000000000000002
> [  753.260014]  0000000000000e03 0000000000000e68 0000000000000000 ffff8800430259d8
> [  753.260014] Call Trace:
> [  753.260014]  [<ffffffff815b483a>] btrfs_run_delayed_refs+0xca/0x220
> [  753.260014]  [<ffffffff815c5469>] btrfs_commit_transaction+0x359/0x840
> [  753.260014]  [<ffffffff810ac420>] ? add_wait_queue+0x60/0x60
> [  753.260014]  [<ffffffff815c5da4>] ? start_transaction+0x94/0x2b0
> [  753.260014]  [<ffffffff815ac80c>] may_commit_transaction+0x6c/0x100
> [  753.260014]  [<ffffffff815b2b47>] reserve_metadata_bytes.isra.71+0x5a7/0x660
> [  753.260014]  [<ffffffff81073c23>] ? __wake_up+0x53/0x70
> [  753.260014]  [<ffffffff815a43ba>] ? btrfs_free_path+0x2a/0x40
> [  753.260014]  [<ffffffff815b2f9e>] btrfs_block_rsv_add+0x3e/0x70
> [  753.260014]  [<ffffffff81666dfb>] ? security_d_instantiate+0x1b/0x30
> [  753.260014]  [<ffffffff815c5f65>] start_transaction+0x255/0x2b0
> [  753.260014]  [<ffffffff815c6283>] btrfs_start_transaction+0x13/0x20
> [  753.260014]  [<ffffffff815d2236>] btrfs_create+0x46/0x220
> [  753.260014]  [<ffffffff8116c204>] vfs_create+0xb4/0xf0
> [  753.260014]  [<ffffffff8116e1d7>] do_last.isra.45+0x547/0x7c0
> [  753.260014]  [<ffffffff8116f7ab>] path_openat+0xcb/0x3d0
> [  753.260014]  [<ffffffff81ab168e>] ? _raw_spin_lock+0xe/0x20
> [  753.260014]  [<ffffffff8117cc1e>] ? vfsmount_lock_local_unlock+0x1e/0x30
> [  753.260014]  [<ffffffff8116fbd2>] do_filp_open+0x42/0xa0
> [  753.260014]  [<ffffffff8117c487>] ? alloc_fd+0xf7/0x150
> [  753.260014]  [<ffffffff8115f8e7>] do_sys_open+0xf7/0x1d0
> [  753.260014]  [<ffffffff810b572a>] ? do_gettimeofday+0x1a/0x50
> [  753.260014]  [<ffffffff8115f9e0>] sys_open+0x20/0x30
> [  753.260014]  [<ffffffff81ab9502>] system_call_fastpath+0x16/0x1b
> [  753.260014] Code: ff e9 37 f9 ff ff be 95 00 00 00 48 c7 c7 43 6f df 81 e8 99 5f ad ff e9 36 f9 ff ff 80 fa b2 0f 84 d0 f9 ff ff 0f 0b 0f 0b 0f 0b <0f> 0b 0f 0b 0f
> [  753.260014] RIP  [<ffffffff815b475b>] run_clustered_refs+0x7eb/0x800
> [  753.260014]  RSP <ffff8800430258a8>
> [  753.330089] ---[ end trace f3d0e286a928c349 ]---
> 
> It's hard to tell exactly what path gets to that BUG_ON(), so much
> code is inlined by the compiler into run_clustered_refs() that I
> can't tell exactly how it got to the BUG_ON() triggered in
> alloc_reserved_tree_block().
> 

This seems to be an oops led by ENOSPC.

Thanks for the report.


> (As an aside, this is why XFS use noinline for most of it's static
> functions - so that stack traces are accurate when a problem occurs.
> Debuggability of complex code paths is far more important than the
> small speed improvement automatic inlining of static functions
> gives...)
> 

Make sense.

thanks,
liubo

> Cheers,
> 
> Dave.

