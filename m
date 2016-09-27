Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35804 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933205AbcI0JZF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 05:25:05 -0400
Received: by mail-wm0-f53.google.com with SMTP id l132so164797557wmf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Sep 2016 02:25:01 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
Subject: Multiple bad pages state on fstrim and softlockup on umount
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, dsterba@suse.com, jbacik@fb.com
Message-ID: <57EA3AE5.4040608@kyup.com>
Date: Tue, 27 Sep 2016 12:24:53 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 
This morning I got the following splats on one of my server: 
[116337.888998] BUG: Bad page state in process fstrim  pfn:45f65a
[116337.889178] page:ffffea00117d9680 count:0 mapcount:0 mapping:ffff88013bed7ae8 index:0x3a8d3
[116337.889479] flags: 0x2fffc000000000c(referenced|uptodate)
[116337.889794] page dumped because: non-NULL mapping
[116337.896248] CPU: 2 PID: 32269 Comm: fstrim Tainted: P           O    4.4.14-clouder5 #2
[116337.896536] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116337.896825]  0000000000000000 ffff880400b1ba10 ffffffff812f4059 ffffea00117d9680
[116337.897297]  ffffffff81a0aa7e ffff880400b1ba38 ffffffff8112d6d0 0000000000000000
[116337.897768]  0000000000000001 ffff88047fffa000 ffff880400b1ba88 ffffffff8112e1c6
[116337.898239] Call Trace:
[116337.898413]  [<ffffffff812f4059>] dump_stack+0x67/0x9e
[116337.898585]  [<ffffffff8112d6d0>] bad_page.part.64+0xb0/0x100
[116337.898762]  [<ffffffff8112e1c6>] free_pages_prepare+0x2f6/0x310
[116337.898938]  [<ffffffff81130165>] free_hot_cold_page+0x35/0x1f0
[116337.899114]  [<ffffffff811917a9>] ? mem_cgroup_uncharge+0x29/0x30
[116337.899289]  [<ffffffff811381e8>] ? __page_cache_release+0x28/0x150
[116337.899464]  [<ffffffff811389f0>] put_page+0x40/0x50
[116337.899661]  [<ffffffffa06f6d9b>] btrfs_release_extent_buffer_page+0x6b/0x100 [btrfs]
[116337.899966]  [<ffffffffa06f6e7d>] release_extent_buffer+0x4d/0xc0 [btrfs]
[116337.900151]  [<ffffffffa06f733b>] free_extent_buffer+0x4b/0x90 [btrfs]
[116337.900336]  [<ffffffffa06a9d57>] btrfs_release_path+0x27/0x90 [btrfs]
[116337.900524]  [<ffffffffa0716702>] __lookup_free_space_inode+0xc2/0x150 [btrfs]
[116337.900827]  [<ffffffffa071829d>] lookup_free_space_inode+0x5d/0xd0 [btrfs]
[116337.901013]  [<ffffffffa0719841>] load_free_space_cache+0x81/0x1c0 [btrfs]
[116337.901195]  [<ffffffffa06b58d8>] cache_block_group+0x1b8/0x3b0 [btrfs]
[116337.901369]  [<ffffffff810942d0>] ? wait_woken+0xb0/0xb0
[116337.901552]  [<ffffffffa06c462b>] btrfs_trim_fs+0xdb/0x3d0 [btrfs]
[116337.901725]  [<ffffffff811a2d5d>] ? terminate_walk+0x6d/0xe0
[116337.901898]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.902082]  [<ffffffffa0705d60>] btrfs_ioctl_fitrim+0x130/0x180 [btrfs]
[116337.902266]  [<ffffffffa070d111>] btrfs_ioctl+0x1271/0x2710 [btrfs]
[116337.902441]  [<ffffffff811a8cb2>] ? do_filp_open+0x92/0xe0
[116337.902614]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.902788]  [<ffffffff811abe8f>] do_vfs_ioctl+0x30f/0x560
[116337.902957]  [<ffffffff811a7e03>] ? putname+0x53/0x60
[116337.903129]  [<ffffffff811ac159>] SyS_ioctl+0x79/0x90
[116337.903302]  [<ffffffff8161449b>] entry_SYSCALL_64_fastpath+0x16/0x6e

struct page state : http://paste.ubuntu.com/23240718/

[116337.903483] BUG: Bad page state in process fstrim  pfn:3d25bf
[116337.903656] page:ffffea000f496fc0 count:0 mapcount:0 mapping:ffff88013bed7ae8 index:0x3a8d2
[116337.903944] flags: 0x2fffc000000000c(referenced|uptodate)
[116337.904253] page dumped because: non-NULL mapping
[116337.908011] CPU: 2 PID: 32269 Comm: fstrim Tainted: P    B      O    4.4.14-clouder5 #2
[116337.908298] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116337.908584]  0000000000000000 ffff880400b1ba10 ffffffff812f4059 ffffea000f496fc0
[116337.909062]  ffffffff81a0aa7e ffff880400b1ba38 ffffffff8112d6d0 0000000000000000
[116337.909535]  0000000000000001 ffff88047fffa000 ffff880400b1ba88 ffffffff8112e1c6
[116337.910008] Call Trace:
[116337.910179]  [<ffffffff812f4059>] dump_stack+0x67/0x9e
[116337.910355]  [<ffffffff8112d6d0>] bad_page.part.64+0xb0/0x100
[116337.910525]  [<ffffffff8112e1c6>] free_pages_prepare+0x2f6/0x310
[116337.910698]  [<ffffffff81130165>] free_hot_cold_page+0x35/0x1f0
[116337.910870]  [<ffffffff811917a9>] ? mem_cgroup_uncharge+0x29/0x30
[116337.911043]  [<ffffffff811381e8>] ? __page_cache_release+0x28/0x150
[116337.911216]  [<ffffffff811389f0>] put_page+0x40/0x50
[116337.911407]  [<ffffffffa06f6d9b>] btrfs_release_extent_buffer_page+0x6b/0x100 [btrfs]
[116337.911707]  [<ffffffffa06f6e7d>] release_extent_buffer+0x4d/0xc0 [btrfs]
[116337.911889]  [<ffffffffa06f733b>] free_extent_buffer+0x4b/0x90 [btrfs]
[116337.912070]  [<ffffffffa06a9d57>] btrfs_release_path+0x27/0x90 [btrfs]
[116337.912255]  [<ffffffffa0716702>] __lookup_free_space_inode+0xc2/0x150 [btrfs]
[116337.912557]  [<ffffffffa071829d>] lookup_free_space_inode+0x5d/0xd0 [btrfs]
[116337.912741]  [<ffffffffa0719841>] load_free_space_cache+0x81/0x1c0 [btrfs]
[116337.912924]  [<ffffffffa06b58d8>] cache_block_group+0x1b8/0x3b0 [btrfs]
[116337.913099]  [<ffffffff810942d0>] ? wait_woken+0xb0/0xb0
[116337.913282]  [<ffffffffa06c462b>] btrfs_trim_fs+0xdb/0x3d0 [btrfs]
[116337.913453]  [<ffffffff811a2d5d>] ? terminate_walk+0x6d/0xe0
[116337.913624]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.913809]  [<ffffffffa0705d60>] btrfs_ioctl_fitrim+0x130/0x180 [btrfs]
[116337.913995]  [<ffffffffa070d111>] btrfs_ioctl+0x1271/0x2710 [btrfs]
[116337.914168]  [<ffffffff811a8cb2>] ? do_filp_open+0x92/0xe0
[116337.914341]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.914512]  [<ffffffff811abe8f>] do_vfs_ioctl+0x30f/0x560
[116337.914684]  [<ffffffff811a7e03>] ? putname+0x53/0x60
[116337.914855]  [<ffffffff811ac159>] SyS_ioctl+0x79/0x90
[116337.915027]  [<ffffffff8161449b>] entry_SYSCALL_64_fastpath+0x16/0x6e

Page-state: http://paste.ubuntu.com/23240738/

[116337.915208] BUG: Bad page state in process fstrim  pfn:38a5cf
[116337.915382] page:ffffea000e2973c0 count:0 mapcount:0 mapping:ffff88013bed7ae8 index:0x3a8d1
[116337.915671] flags: 0x2fffc000000000c(referenced|uptodate)
[116337.915981] page dumped because: non-NULL mapping
[116337.919764] CPU: 2 PID: 32269 Comm: fstrim Tainted: P    B      O    4.4.14-clouder5 #2
[116337.920047] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116337.920327]  0000000000000000 ffff880400b1ba10 ffffffff812f4059 ffffea000e2973c0
[116337.920789]  ffffffff81a0aa7e ffff880400b1ba38 ffffffff8112d6d0 0000000000000000
[116337.921252]  0000000000000001 ffff88047fffa000 ffff880400b1ba88 ffffffff8112e1c6
[116337.921720] Call Trace:
[116337.921892]  [<ffffffff812f4059>] dump_stack+0x67/0x9e
[116337.922065]  [<ffffffff8112d6d0>] bad_page.part.64+0xb0/0x100
[116337.922237]  [<ffffffff8112e1c6>] free_pages_prepare+0x2f6/0x310
[116337.922414]  [<ffffffff81130165>] free_hot_cold_page+0x35/0x1f0
[116337.922587]  [<ffffffff811917a9>] ? mem_cgroup_uncharge+0x29/0x30
[116337.922761]  [<ffffffff811381e8>] ? __page_cache_release+0x28/0x150
[116337.922935]  [<ffffffff811389f0>] put_page+0x40/0x50
[116337.923124]  [<ffffffffa06f6d9b>] btrfs_release_extent_buffer_page+0x6b/0x100 [btrfs]
[116337.923424]  [<ffffffffa06f6e7d>] release_extent_buffer+0x4d/0xc0 [btrfs]
[116337.923607]  [<ffffffffa06f733b>] free_extent_buffer+0x4b/0x90 [btrfs]
[116337.923790]  [<ffffffffa06a9d57>] btrfs_release_path+0x27/0x90 [btrfs]
[116337.923975]  [<ffffffffa0716702>] __lookup_free_space_inode+0xc2/0x150 [btrfs]
[116337.924277]  [<ffffffffa071829d>] lookup_free_space_inode+0x5d/0xd0 [btrfs]
[116337.924465]  [<ffffffffa0719841>] load_free_space_cache+0x81/0x1c0 [btrfs]
[116337.924649]  [<ffffffffa06b58d8>] cache_block_group+0x1b8/0x3b0 [btrfs]
[116337.924824]  [<ffffffff810942d0>] ? wait_woken+0xb0/0xb0
[116337.925006]  [<ffffffffa06c462b>] btrfs_trim_fs+0xdb/0x3d0 [btrfs]
[116337.925179]  [<ffffffff811a2d5d>] ? terminate_walk+0x6d/0xe0
[116337.925353]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.925537]  [<ffffffffa0705d60>] btrfs_ioctl_fitrim+0x130/0x180 [btrfs]
[116337.925723]  [<ffffffffa070d111>] btrfs_ioctl+0x1271/0x2710 [btrfs]
[116337.925895]  [<ffffffff811a8cb2>] ? do_filp_open+0x92/0xe0
[116337.926068]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.926240]  [<ffffffff811abe8f>] do_vfs_ioctl+0x30f/0x560
[116337.926412]  [<ffffffff811a7e03>] ? putname+0x53/0x60
[116337.926583]  [<ffffffff811ac159>] SyS_ioctl+0x79/0x90
[116337.926755]  [<ffffffff8161449b>] entry_SYSCALL_64_fastpath+0x16/0x6e

Page state: http://paste.ubuntu.com/23240744/

[116337.926936] BUG: Bad page state in process fstrim  pfn:42e332
[116337.927108] page:ffffea0010b8cc80 count:0 mapcount:0 mapping:ffff88013bed7ae8 index:0x3a8d0
[116337.927401] flags: 0x2fffc000000010c(referenced|uptodate|owner_priv_1)
[116337.927761] page dumped because: non-NULL mapping
[116337.931539] CPU: 2 PID: 32269 Comm: fstrim Tainted: P    B      O    4.4.14-clouder5 #2
[116337.931827] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116337.932115]  0000000000000000 ffff880400b1ba10 ffffffff812f4059 ffffea0010b8cc80
[116337.932586]  ffffffff81a0aa7e ffff880400b1ba38 ffffffff8112d6d0 0000000000000000
[116337.933056]  0000000000000001 ffff88047fffa000 ffff880400b1ba88 ffffffff8112e1c6
[116337.933524] Call Trace:
[116337.933694]  [<ffffffff812f4059>] dump_stack+0x67/0x9e
[116337.933864]  [<ffffffff8112d6d0>] bad_page.part.64+0xb0/0x100
[116337.934037]  [<ffffffff8112e1c6>] free_pages_prepare+0x2f6/0x310
[116337.934210]  [<ffffffff81130165>] free_hot_cold_page+0x35/0x1f0
[116337.934380]  [<ffffffff811917a9>] ? mem_cgroup_uncharge+0x29/0x30
[116337.934548]  [<ffffffff811381e8>] ? __page_cache_release+0x28/0x150
[116337.934716]  [<ffffffff811389f0>] put_page+0x40/0x50
[116337.934901]  [<ffffffffa06f6d9b>] btrfs_release_extent_buffer_page+0x6b/0x100 [btrfs]
[116337.935194]  [<ffffffffa06f6e7d>] release_extent_buffer+0x4d/0xc0 [btrfs]
[116337.938063]  [<ffffffffa06f733b>] free_extent_buffer+0x4b/0x90 [btrfs]
[116337.938246]  [<ffffffffa06a9d57>] btrfs_release_path+0x27/0x90 [btrfs]
[116337.938432]  [<ffffffffa0716702>] __lookup_free_space_inode+0xc2/0x150 [btrfs]
[116337.938737]  [<ffffffffa071829d>] lookup_free_space_inode+0x5d/0xd0 [btrfs]
[116337.938924]  [<ffffffffa0719841>] load_free_space_cache+0x81/0x1c0 [btrfs]
[116337.939109]  [<ffffffffa06b58d8>] cache_block_group+0x1b8/0x3b0 [btrfs]
[116337.939287]  [<ffffffff810942d0>] ? wait_woken+0xb0/0xb0
[116337.939469]  [<ffffffffa06c462b>] btrfs_trim_fs+0xdb/0x3d0 [btrfs]
[116337.939645]  [<ffffffff811a2d5d>] ? terminate_walk+0x6d/0xe0
[116337.939820]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.940005]  [<ffffffffa0705d60>] btrfs_ioctl_fitrim+0x130/0x180 [btrfs]
[116337.940192]  [<ffffffffa070d111>] btrfs_ioctl+0x1271/0x2710 [btrfs]
[116337.940367]  [<ffffffff811a8cb2>] ? do_filp_open+0x92/0xe0
[116337.940540]  [<ffffffff810775a2>] ? __might_sleep+0x52/0xb0
[116337.940714]  [<ffffffff811abe8f>] do_vfs_ioctl+0x30f/0x560
[116337.940885]  [<ffffffff811a7e03>] ? putname+0x53/0x60
[116337.941058]  [<ffffffff811ac159>] SyS_ioctl+0x79/0x90
[116337.941230]  [<ffffffff8161449b>] entry_SYSCALL_64_fastpath+0x16/0x6e

So all of those 4 pages belong to the same btrfs instance, verified by
following mapping->host->i_sb->s_type. The inode has an
i_ino = 1 BTRFS_BTREE_INODE_OBJECTID, which means this is the main
btree inode. I've also created separated pastes with the struct page 
state in the hopes of providing some hints. 

These are then followed by the following softlockup/rcu stall warnings: 

[116360.728279] INFO: rcu_sched self-detected stall on CPU
[116360.728506]         2-...: (21000 ticks this GP) idle=917/140000000000001/0 softirq=42408991/42408991 fqs=6997 [116360.728795]          (t=21001 jiffies g=14896304 c=14896303 q=6826)
[116360.729012] Task dump for CPU 2:
[116360.729180] umount          R  running task        0 32509  30645 0x00000008
[116360.729447]  ffffffff81c40280 ffff88047fc43dc0 ffffffff8107f53d 0000000000000002
[116360.729917]  ffffffff81c40280 ffff88047fc43dd8 ffffffff81081ce9 0000000000000003
[116360.730388]  ffff88047fc43e08 ffffffff810aa34b ffff88047fc55d00 ffffffff81c40280
[116360.730861] Call Trace:
[116360.731028]  <IRQ>  [<ffffffff8107f53d>] sched_show_task+0xbd/0x120
[116360.731257]  [<ffffffff81081ce9>] dump_cpu_task+0x39/0x40
[116360.731431]  [<ffffffff810aa34b>] rcu_dump_cpu_stacks+0x8b/0xc0
[116360.731606]  [<ffffffff810ade76>] rcu_check_callbacks+0x4d6/0x7b0
[116360.731779]  [<ffffffff810c0a50>] ? tick_init_highres+0x20/0x20
[116360.731953]  [<ffffffff810b28b9>] update_process_times+0x39/0x60
[116360.732127]  [<ffffffff810c0a9d>] tick_sched_timer+0x4d/0x180
[116360.732300]  [<ffffffff810c0a50>] ? tick_init_highres+0x20/0x20
[116360.732473]  [<ffffffff810b3197>] __hrtimer_run_queues+0xe7/0x260
[116360.732646]  [<ffffffff810b3718>] hrtimer_interrupt+0xa8/0x1a0
[116360.732822]  [<ffffffff81034608>] local_apic_timer_interrupt+0x38/0x60
[116360.733000]  [<ffffffff81616a7d>] smp_apic_timer_interrupt+0x3d/0x50
[116360.733175]  [<ffffffff816151e9>] apic_timer_interrupt+0x89/0x90
[116360.733348]  <EOI>  [<ffffffff8112b2ce>] ? find_get_entries+0x4e/0x150
[116360.733569]  [<ffffffff8112b39d>] ? find_get_entries+0x11d/0x150
[116360.733740]  [<ffffffff81139a7e>] pagevec_lookup_entries+0x1e/0x30
[116360.733909]  [<ffffffff81139d24>] invalidate_inode_pages2_range+0xb4/0x3d0
[116360.734080]  [<ffffffff8113a057>] invalidate_inode_pages2+0x17/0x20
[116360.734278]  [<ffffffffa06cf8be>] close_ctree+0x17e/0x340 [btrfs]
[116360.734449]  [<ffffffff811b4ae8>] ? evict_inodes+0x168/0x180
[116360.734631]  [<ffffffffa06a0e99>] btrfs_put_super+0x19/0x20 [btrfs]
[116360.734801]  [<ffffffff8119b71f>] generic_shutdown_super+0x6f/0x100
[116360.734972]  [<ffffffff8119c2a2>] kill_anon_super+0x12/0x20
[116360.735157]  [<ffffffffa06a50e8>] btrfs_kill_super+0x18/0x120 [btrfs]
[116360.735333]  [<ffffffff8119b203>] deactivate_locked_super+0x43/0x70
[116360.735506]  [<ffffffff8119b28c>] deactivate_super+0x5c/0x60
[116360.735679]  [<ffffffff811b868f>] cleanup_mnt+0x3f/0x90
[116360.735852]  [<ffffffff811b8722>] __cleanup_mnt+0x12/0x20
[116360.736025]  [<ffffffff8106fc6f>] task_work_run+0x7f/0xb0
[116360.736199]  [<ffffffff81002210>] exit_to_usermode_loop+0xc0/0xd0
[116360.736376]  [<ffffffff81002a90>] syscall_return_slowpath+0x80/0xf0
[116360.736552]  [<ffffffff816145f4>] int_ret_from_sys_call+0x25/0x9f

[116360.736728] INFO: rcu_sched detected stalls on CPUs/tasks:
[116360.736955]         2-...: (21001 ticks this GP) idle=917/140000000000000/0 softirq=42408991/42408991 fqs=6998 [116360.737250]         (detected by 1, t=21010 jiffies, g=14896304, c=14896303, q=6826)
[116360.737584] Task dump for CPU 2:
[116360.737752] umount          R  running task        0 32509  30645 0x00000008
[116360.738017]  ffffea00085c109c ffffffffffffff10 ffffffff8112b2d8 0000000000000010
[116360.738488]  0000000000000282 ffff88023934bbc8 0000000000000018 ffffffff8112b39d
[116360.738957]  ffff88046f013b40 ffff88013bed7af0 000000000003a8d0 000000000003a900
[116360.739427] Call Trace:
[116360.739597]  [<ffffffff8112b2d8>] ? find_get_entries+0x58/0x150
[116360.739767]  [<ffffffff8112b39d>] ? find_get_entries+0x11d/0x150
[116360.739940]  [<ffffffff81139a7e>] ? pagevec_lookup_entries+0x1e/0x30
[116360.740111]  [<ffffffff81139d24>] ? invalidate_inode_pages2_range+0xb4/0x3d0
[116360.740286]  [<ffffffff8113a057>] ? invalidate_inode_pages2+0x17/0x20
[116360.740478]  [<ffffffffa06cf8be>] ? close_ctree+0x17e/0x340 [btrfs]
[116360.740649]  [<ffffffff811b4ae8>] ? evict_inodes+0x168/0x180
[116360.740831]  [<ffffffffa06a0e99>] ? btrfs_put_super+0x19/0x20 [btrfs]
[116360.741005]  [<ffffffff8119b71f>] ? generic_shutdown_super+0x6f/0x100
[116360.741177]  [<ffffffff8119c2a2>] ? kill_anon_super+0x12/0x20
[116360.741361]  [<ffffffffa06a50e8>] ? btrfs_kill_super+0x18/0x120 [btrfs]
[116360.741534]  [<ffffffff8119b203>] ? deactivate_locked_super+0x43/0x70
[116360.741707]  [<ffffffff8119b28c>] ? deactivate_super+0x5c/0x60
[116360.741878]  [<ffffffff811b868f>] ? cleanup_mnt+0x3f/0x90
[116360.742047]  [<ffffffff811b8722>] ? __cleanup_mnt+0x12/0x20
[116360.742219]  [<ffffffff8106fc6f>] ? task_work_run+0x7f/0xb0
[116360.742391]  [<ffffffff81002210>] ? exit_to_usermode_loop+0xc0/0xd0
[116360.742565]  [<ffffffff81002a90>] ? syscall_return_slowpath+0x80/0xf0
[116360.742739]  [<ffffffff816145f4>] ? int_ret_from_sys_call+0x25/0x9f

[116385.810019] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [umount:32509]
[116385.813912] CPU: 2 PID: 32509 Comm: umount Tainted: P    B      O    4.4.14-clouder5 #2
[116385.814198] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116385.814485] task: ffff880458a3e040 ti: ffff880239348000 task.ti: ffff880239348000
[116385.814779] RIP: 0010:[<ffffffff8112b33e>]  [<ffffffff8112b33e>] find_get_entries+0xbe/0x150
[116385.815123] RSP: 0018:ffff88023934bbc8  EFLAGS: 00000246
[116385.815295] RAX: 0000000000000030 RBX: ffff88023934bc68 RCX: 000000000003a8c7
[116385.815591] RDX: ffff8803b66db2d8 RSI: 0000000000000000 RDI: ffffea00085c109c
[116385.815883] RBP: ffff88023934bc18 R08: 0000000000000000 R09: ffffea0010b8cc80
[116385.816166] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000003a8be
[116385.816452] R13: 000000000000000a R14: 000000000000000e R15: ffff88023934bce8
[116385.816738] FS:  00007f69615bf740(0000) GS:ffff88047fc40000(0000) knlGS:0000000000000000
[116385.817028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[116385.817199] CR2: ffffffffff600400 CR3: 000000029a2c6000 CR4: 00000000000406e0
[116385.817482] Stack:
[116385.817644]  ffff88046f013b40 ffff88013bed7af0 000000000003a8d0 000000000003a900
[116385.818118]  ffffea00100230e0 ffff88023934bcd8 ffff88013bed7ae8 ffffffffffffffff
[116385.818579]  ffffea000c86d680 000000000000000d ffff88023934bc30 ffffffff81139a7e
[116385.819041] Call Trace:
[116385.819207]  [<ffffffff81139a7e>] pagevec_lookup_entries+0x1e/0x30
[116385.819375]  [<ffffffff81139d24>] invalidate_inode_pages2_range+0xb4/0x3d0
[116385.819544]  [<ffffffff8113a057>] invalidate_inode_pages2+0x17/0x20
[116385.819735]  [<ffffffffa06cf8be>] close_ctree+0x17e/0x340 [btrfs]
[116385.819908]  [<ffffffff811b4ae8>] ? evict_inodes+0x168/0x180
[116385.820092]  [<ffffffffa06a0e99>] btrfs_put_super+0x19/0x20 [btrfs]
[116385.820268]  [<ffffffff8119b71f>] generic_shutdown_super+0x6f/0x100
[116385.820440]  [<ffffffff8119c2a2>] kill_anon_super+0x12/0x20
[116385.820618]  [<ffffffffa06a50e8>] btrfs_kill_super+0x18/0x120 [btrfs]
[116385.820791]  [<ffffffff8119b203>] deactivate_locked_super+0x43/0x70
[116385.820964]  [<ffffffff8119b28c>] deactivate_super+0x5c/0x60
[116385.821137]  [<ffffffff811b868f>] cleanup_mnt+0x3f/0x90
[116385.821307]  [<ffffffff811b8722>] __cleanup_mnt+0x12/0x20
[116385.821478]  [<ffffffff8106fc6f>] task_work_run+0x7f/0xb0
[116385.821650]  [<ffffffff81002210>] exit_to_usermode_loop+0xc0/0xd0
[116385.821822]  [<ffffffff81002a90>] syscall_return_slowpath+0x80/0xf0
[116385.821998]  [<ffffffff816145f4>] int_ret_from_sys_call+0x25/0x9f
[116385.822170] Code: f7 0f 84 8e 00 00 00 48 8b 45 c8 48 29 c8 48 83 e8 01 48 85 c0 7e 64 48 83 45 c0 01 48 83 c2 08 48 83 3a 00 74 e8 48 85 d2 74 50 <4c> 8b 0a 4d 85 c9 75 88 48 8b 4d c0 eb ce 41 89 c2 45 85 d2 74 
[116385.825590] Kernel panic - not syncing: softlockup: hung tasks
[116385.825762] CPU: 2 PID: 32509 Comm: umount Tainted: P    B      O L  4.4.14-clouder5 #2
[116385.826049] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
[116385.826335]  0000000000000000 ffff88047fc43e18 ffffffff812f4059 ffffffff81a0552e
[116385.826805]  ffff88047fc43ea8 ffff88047fc43e98 ffffffff811273dd 0000000000000008
[116385.827278]  ffff88047fc43ea8 ffff88047fc43e40 0000000000000000 0000000000000000
[116385.827750] Call Trace:
[116385.827912]  <IRQ>  [<ffffffff812f4059>] dump_stack+0x67/0x9e
[116385.828136]  [<ffffffff811273dd>] panic+0xc5/0x20b
[116385.828308]  [<ffffffff810e1a6c>] watchdog_timer_fn+0x1dc/0x1e0
[116385.828478]  [<ffffffff810e1890>] ? watchdog+0x40/0x40
[116385.828649]  [<ffffffff810b3197>] __hrtimer_run_queues+0xe7/0x260
[116385.828819]  [<ffffffff810b3718>] hrtimer_interrupt+0xa8/0x1a0
[116385.828994]  [<ffffffff81034608>] local_apic_timer_interrupt+0x38/0x60
[116385.829168]  [<ffffffff81616a7d>] smp_apic_timer_interrupt+0x3d/0x50
[116385.829342]  [<ffffffff816151e9>] apic_timer_interrupt+0x89/0x90
[116385.832191]  <EOI>  [<ffffffff8112b33e>] ? find_get_entries+0xbe/0x150
[116385.832413]  [<ffffffff8112b39d>] ? find_get_entries+0x11d/0x150
[116385.832587]  [<ffffffff81139a7e>] pagevec_lookup_entries+0x1e/0x30
[116385.832754]  [<ffffffff81139d24>] invalidate_inode_pages2_range+0xb4/0x3d0
[116385.832924]  [<ffffffff8113a057>] invalidate_inode_pages2+0x17/0x20
[116385.833109]  [<ffffffffa06cf8be>] close_ctree+0x17e/0x340 [btrfs]
[116385.833277]  [<ffffffff811b4ae8>] ? evict_inodes+0x168/0x180
[116385.833452]  [<ffffffffa06a0e99>] btrfs_put_super+0x19/0x20 [btrfs]
[116385.833620]  [<ffffffff8119b71f>] generic_shutdown_super+0x6f/0x100
[116385.833788]  [<ffffffff8119c2a2>] kill_anon_super+0x12/0x20
[116385.833965]  [<ffffffffa06a50e8>] btrfs_kill_super+0x18/0x120 [btrfs]
[116385.834136]  [<ffffffff8119b203>] deactivate_locked_super+0x43/0x70
[116385.834306]  [<ffffffff8119b28c>] deactivate_super+0x5c/0x60
[116385.834476]  [<ffffffff811b868f>] cleanup_mnt+0x3f/0x90
[116385.834647]  [<ffffffff811b8722>] __cleanup_mnt+0x12/0x20
[116385.834819]  [<ffffffff8106fc6f>] task_work_run+0x7f/0xb0
[116385.834990]  [<ffffffff81002210>] exit_to_usermode_loop+0xc0/0xd0
[116385.835165]  [<ffffffff81002a90>] syscall_return_slowpath+0x80/0xf0
[116385.835341]  [<ffffffff816145f4>] int_ret_from_sys_call+0x25/0x9f 

Inspecting the disassembly and the stack proves that the invalidate_inode_pages2 is
being called for the same address_map as the one which generated the bogus page errors
earlier. And this seems to be the mapping for the btrfs.

I guess there are 2 questions that need to be answered: 

1. Why the "bad page state" errors are occuring. My understanding
is that when we are doing fstrim pages are being freed while they are 
still mapped. 

2. Is the subsequent softlockups/stalls caused by (1)

Any ideas how to debug this further will be much appreciated. 



