Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43815 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752186AbcKOOPF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 09:15:05 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFEEI6M040890
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 09:15:05 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r2x1b3bn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 09:15:04 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 07:15:04 -0700
Date: Tue, 15 Nov 2016 06:15:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nikolay Borisov <kernel@kyup.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        dsterba@suse.com
Subject: Re: list/count mismatch warning in rcu_do_batch (possibly triggered
 by a btrfs bug).
Reply-To: paulmck@linux.vnet.ibm.com
References: <fb1eaeb6-43d3-1d87-c822-4870be6b5a79@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb1eaeb6-43d3-1d87-c822-4870be6b5a79@kyup.com>
Message-Id: <20161115141501.GV4127@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2016 at 10:53:15AM +0200, Nikolay Borisov wrote:
> Hello Paul, 
> 
> I'm currently going through a crashdump which seems to indicate some 
> memory corruption, possibly triggered by btrfs.  I have several 
> entries such as : 
> 
> [1626691.276310] BUG: Bad page state in process fstrim  pfn:230ee7
> [1626691.276488] page:ffffea0008c3b9c0 count:0 mapcount:0 mapping:ffff8801106439c8 index:0x22d3
> [1626691.276774] flags: 0x2fffc000000000c(referenced|uptodate)
> [1626691.277084] page dumped because: non-NULL mapping
> [1626691.280607] CPU: 8 PID: 303 Comm: fstrim Tainted: P        W  O    4.4.26-clouder1 #3
> [1626691.280885] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> [1626691.281163]  0000000000000000 ffff8803b1b97a10 ffffffff812f4b79 ffffea0008c3b9c0
> [1626691.281623]  ffffffff81a0b20e ffff8803b1b97a38 ffffffff8112dcc0 0000000000000000
> [1626691.282085]  0000000000000001 ffff88047fffa000 ffff8803b1b97a88 ffffffff8112e7b6
> [1626691.282554] Call Trace:
> [1626691.282727]  [<ffffffff812f4b79>] dump_stack+0x67/0x9e
> [1626691.282899]  [<ffffffff8112dcc0>] bad_page.part.64+0xb0/0x100
> [1626691.283071]  [<ffffffff8112e7b6>] free_pages_prepare+0x2f6/0x310
> [1626691.283244]  [<ffffffff81130755>] free_hot_cold_page+0x35/0x1f0
> [1626691.283416]  [<ffffffff81191ea9>] ? mem_cgroup_uncharge+0x29/0x30
> [1626691.283588]  [<ffffffff811387b8>] ? __page_cache_release+0x28/0x150
> [1626691.283760]  [<ffffffff81138fc0>] put_page+0x40/0x50
> [1626691.283956]  [<ffffffffa0732d8b>] btrfs_release_extent_buffer_page+0x6b/0x100 [btrfs]
> [1626691.284259]  [<ffffffffa0732e6d>] release_extent_buffer+0x4d/0xc0 [btrfs]
> [1626691.284444]  [<ffffffffa073332b>] free_extent_buffer+0x4b/0x90 [btrfs]
> [1626691.284626]  [<ffffffffa06e5d57>] btrfs_release_path+0x27/0x90 [btrfs]
> [1626691.284814]  [<ffffffffa0752732>] __lookup_free_space_inode+0xc2/0x150 [btrfs]
> [1626691.285113]  [<ffffffffa07542cd>] lookup_free_space_inode+0x5d/0xd0 [btrfs]
> [1626691.285302]  [<ffffffffa0755871>] load_free_space_cache+0x81/0x1c0 [btrfs]
> [1626691.285486]  [<ffffffffa06f18d8>] cache_block_group+0x1b8/0x3b0 [btrfs]
> [1626691.285660]  [<ffffffff81094580>] ? wait_woken+0xb0/0xb0
> [1626691.285842]  [<ffffffffa070062b>] btrfs_trim_fs+0xdb/0x3d0 [btrfs]
> [1626691.286017]  [<ffffffff811a358d>] ? terminate_walk+0x6d/0xe0
> [1626691.286189]  [<ffffffff810777a2>] ? __might_sleep+0x52/0xb0
> [1626691.286375]  [<ffffffffa0741d50>] btrfs_ioctl_fitrim+0x130/0x180 [btrfs]
> [1626691.286561]  [<ffffffffa0749126>] btrfs_ioctl+0x1276/0x2710 [btrfs]
> [1626691.286734]  [<ffffffff811a94e2>] ? do_filp_open+0x92/0xe0
> [1626691.286905]  [<ffffffff810777a2>] ? __might_sleep+0x52/0xb0
> [1626691.287078]  [<ffffffff811ac6bf>] do_vfs_ioctl+0x30f/0x560
> [1626691.287248]  [<ffffffff811a8633>] ? putname+0x53/0x60
> [1626691.287420]  [<ffffffff811ac989>] SyS_ioctl+0x79/0x90
> [1626691.287591]  [<ffffffff8161531b>] entry_SYSCALL_64_fastpath+0x16/0x6e
> 
> But eventually the following warning is triggered: 
> 
> [1626691.326167] ------------[ cut here ]------------
> [1626691.326344] WARNING: CPU: 1 PID: 17122 at kernel/rcu/tree.c:2733 rcu_process_callbacks+0x5e2/0x620()
> [1626691.329962] CPU: 1 PID: 17122 Comm: btrfs-transacti Tainted: P    B   W  O    4.4.26-clouder1 #3
> [1626691.330255] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> [1626691.330546]  0000000000000000 ffff88047fc23e68 ffffffff812f4b79 0000000000000000
> [1626691.331023]  ffffffff81a04a61 ffff88047fc23ea0 ffffffff81052bd6 ffffffff81c40280
> [1626691.331504]  ffff88047fc35d38 0000000000000000 0000000000000005 ffff88047fc35d00
> [1626691.331978] Call Trace:
> [1626691.332146]  <IRQ>  [<ffffffff812f4b79>] dump_stack+0x67/0x9e
> [1626691.332373]  [<ffffffff81052bd6>] warn_slowpath_common+0x86/0xc0
> [1626691.332548]  [<ffffffff81052cca>] warn_slowpath_null+0x1a/0x20
> [1626691.332723]  [<ffffffff810ad752>] rcu_process_callbacks+0x5e2/0x620
> [1626691.332898]  [<ffffffff81057447>] __do_softirq+0x147/0x310
> [1626691.333072]  [<ffffffff8105775f>] irq_exit+0x5f/0x70
> [1626691.333246]  [<ffffffff81617902>] smp_apic_timer_interrupt+0x42/0x50
> [1626691.333422]  [<ffffffff81616069>] apic_timer_interrupt+0x89/0x90
> [1626691.333591]  <EOI>  [<ffffffff81311585>] ? __crc32c_le+0x65/0x110
> [1626691.333814]  [<ffffffff812c0877>] chksum_update+0x17/0x20
> [1626691.333986]  [<ffffffff812b24f6>] crypto_shash_update+0x36/0x100
> [1626691.334186]  [<ffffffffa0785375>] btrfs_crc32c+0x55/0x70 [btrfs]
> [1626691.334374]  [<ffffffffa073b94e>] ? __btrfs_map_block+0x61e/0x10f0 [btrfs]
> [1626691.334560]  [<ffffffffa070806b>] csum_tree_block+0x6b/0x180 [btrfs]
> [1626691.334735]  [<ffffffff8112bc1f>] ? mempool_alloc+0x5f/0x150
> [1626691.334906]  [<ffffffff8112bb45>] ? mempool_alloc_slab+0x15/0x20
> [1626691.335091]  [<ffffffffa0708481>] btree_csum_one_bio.isra.41+0xc1/0xd0 [btrfs]
> [1626691.335389]  [<ffffffffa070876d>] btree_submit_bio_hook+0x4d/0x110 [btrfs]
> [1626691.335577]  [<ffffffffa072c2ee>] submit_one_bio+0x6e/0xa0 [btrfs]
> [1626691.335762]  [<ffffffffa072ff00>] submit_extent_page+0xa0/0x230 [btrfs]
> [1626691.335949]  [<ffffffffa0730205>] write_one_eb.isra.36+0x175/0x200 [btrfs]
> [1626691.336137]  [<ffffffffa072c350>] ? end_extent_buffer_writeback+0x30/0x30 [btrfs]
> [1626691.336438]  [<ffffffffa0733682>] btree_write_cache_pages+0x312/0x400 [btrfs]
> [1626691.336738]  [<ffffffffa070752d>] btree_writepages+0x5d/0x70 [btrfs]
> [1626691.336912]  [<ffffffff8113735e>] do_writepages+0x1e/0x30
> [1626691.337082]  [<ffffffff8112a66a>] __filemap_fdatawrite_range+0xaa/0xf0
> [1626691.337255]  [<ffffffff8112a773>] filemap_fdatawrite_range+0x13/0x20
> [1626691.337440]  [<ffffffffa070fbbc>] btrfs_write_marked_extents+0x10c/0x130 [btrfs]
> [1626691.337733]  [<ffffffffa0786150>] btrfs_write_and_wait_transaction.isra.22+0x49/0x90 [btrfs]
> [1626691.338025]  [<ffffffffa07107eb>] btrfs_commit_transaction+0x7db/0xa60 [btrfs]
> [1626691.338313]  [<ffffffffa07107eb>] ? btrfs_commit_transaction+0x7db/0xa60 [btrfs]
> [1626691.338600]  [<ffffffffa0710b0a>] ? start_transaction+0x9a/0x4e0 [btrfs]
> [1626691.338780]  [<ffffffffa070b6d8>] transaction_kthread+0x218/0x280 [btrfs]
> [1626691.338958]  [<ffffffffa070b4c0>] ? btrfs_cleanup_transaction+0x590/0x590 [btrfs]
> [1626691.339242]  [<ffffffff810717bf>] kthread+0xef/0x110
> [1626691.339412]  [<ffffffff810716d0>] ? kthread_park+0x60/0x60
> [1626691.339585]  [<ffffffff816156bf>] ret_from_fork+0x3f/0x70
> [1626691.339755]  [<ffffffff810716d0>] ? kthread_park+0x60/0x60
> [1626691.339924] ---[ end trace dacbbac64b357f79 ]---
> 
> That warning is this code in rcu_do_batch: 
> 
> WARN_ON_ONCE((rdp->nxtlist == NULL) != (rdp->qlen == 0));

This could be caused by memory corruption or by a double-free bug
involving one of the call_rcu() functions.

CONFIG_DEBUG_OBJECTS_RCU_HEAD=y would check for a call_rcu() double-free
bug.

> Eventually the machines crashes in kmem_cache_alloc: 
> 
> [1626694.130460] BUG: unable to handle kernel paging request at 00000000039ac000
> [1626694.130731] IP: [<ffffffff8117e3d7>] kmem_cache_alloc+0x77/0x220
> [1626694.130954] PGD 29b86b067 PUD 38d8bd067 PMD 0 
> [1626694.131260] Oops: 0000 [#1] SMP 
> [1626694.134847] CPU: 1 PID: 731 Comm: rsync Tainted: P    B   W  O    4.4.26-clouder1 #3
> [1626694.135135] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> [1626694.135422] task: ffff88027bdb9b80 ti: ffff8801de078000 task.ti: ffff8801de078000
> [1626694.135706] RIP: 0010:[<ffffffff8117e3d7>]  [<ffffffff8117e3d7>] kmem_cache_alloc+0x77/0x220
> [1626694.136041] RSP: 0018:ffff8801de07b900  EFLAGS: 00010282
> [1626694.136210] RAX: 0000000000000000 RBX: 0000000002408840 RCX: 000000000089da3e
> [1626694.136499] RDX: 000000000089da3d RSI: 0000000000000507 RDI: ffffffff81a0ce11
> [1626694.136787] RBP: ffff8801de07b930 R08: 000060fb80008b60 R09: 00000000039ac000
> [1626694.137071] R10: ffff8803d1ec3520 R11: 0000000000000000 R12: 0000000002408840
> [1626694.139976] R13: ffffffffa072c73a R14: ffff8803eb6d1900 R15: ffff8803eb6d1900
> [1626694.140263] FS:  00007fd7a4a38700(0000) GS:ffff88047fc20000(0000) knlGS:0000000000000000
> [1626694.140562] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1626694.140736] CR2: 00000000039ac000 CR3: 000000039aec6000 CR4: 00000000000406e0
> [1626694.141027] Stack:
> [1626694.141193]  ffff8801de07b900 ffff8801e5ffc000 0000000000004000 ffff8801e5ffc000
> [1626694.141670]  0000000003990000 0000000000004000 ffff8801de07b960 ffffffffa072c73a
> [1626694.142139]  ffff8801e5ffc000 0000000000000000 0000000003990000 ffff8801f7bdd908
> [1626694.142608] Call Trace:
> [1626694.142799]  [<ffffffffa072c73a>] __alloc_extent_buffer+0x2a/0xe0 [btrfs]
> [1626694.142988]  [<ffffffffa0732fe7>] alloc_extent_buffer+0x67/0x360 [btrfs]
> [1626694.143175]  [<ffffffffa0708a00>] read_tree_block+0x20/0x70 [btrfs]
> [1626694.143357]  [<ffffffffa06e8899>] read_block_for_search.isra.32+0x129/0x340 [btrfs]
> [1626694.143657]  [<ffffffffa06eaa01>] btrfs_search_slot+0x3e1/0x9d0 [btrfs]
> [1626694.143830]  [<ffffffff811b2da5>] ? inode_init_always+0x105/0x1b0
> [1626694.144014]  [<ffffffffa07057bf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [1626694.144202]  [<ffffffffa071cb07>] btrfs_iget+0xd7/0x6a0 [btrfs]
> [1626694.144385]  [<ffffffffa071d894>] btrfs_lookup_dentry+0x3e4/0x530 [btrfs]
> [1626694.144570]  [<ffffffffa071d9f2>] btrfs_lookup+0x12/0x40 [btrfs]
> [1626694.144743]  [<ffffffff811a2e6d>] lookup_real+0x1d/0x60
> [1626694.144912]  [<ffffffff811a31e3>] __lookup_hash+0x33/0x40
> [1626694.145084]  [<ffffffff811a5b72>] walk_component+0x212/0x4e0
> [1626694.145255]  [<ffffffff811a649d>] path_lookupat+0x5d/0x110
> [1626694.145427]  [<ffffffff811a89ba>] filename_lookup+0x9a/0x110
> [1626694.145614]  [<ffffffffa0765bcd>] ? btrfs_delayed_update_inode+0x14d/0x4e0 [btrfs]
> [1626694.145902]  [<ffffffff811a8677>] ? getname_flags+0x37/0x1a0
> [1626694.146073]  [<ffffffff8117e51a>] ? kmem_cache_alloc+0x1ba/0x220
> [1626694.146245]  [<ffffffff811a8677>] ? getname_flags+0x37/0x1a0
> [1626694.146416]  [<ffffffff811a8ae6>] user_path_at_empty+0x36/0x40
> [1626694.146588]  [<ffffffff8119e0e3>] vfs_fstatat+0x53/0xa0
> [1626694.146758]  [<ffffffff8119e5d2>] SYSC_newlstat+0x22/0x40
> [1626694.146930]  [<ffffffff8119e7ee>] SyS_newlstat+0xe/0x10
> [1626694.147102]  [<ffffffff8161531b>] entry_SYSCALL_64_fastpath+0x16/0x6e
> 
> I know most of this is out of your area of expertise but what I'm hoping is that the 
> rcu corruption at least point in the right direction as to the root cause. Under what 
> conditions is it "expected" to have list/count mismatch when running the rcu callbacks?
> Is it plausible that a memory corruption, induced by btrfs can have such an effect on 
> core RCU data structures? So what exactly does the warning mean? 

It might well.  Memory corruption can cause all sorts of knock-on problems.
But list/count mismatches are never expected behvavior.

If the problem is reproducible, bisection would be very helpful.

Otherwise, it might be helpful to get the btrfs guys involved.

							Thanx, Paul

