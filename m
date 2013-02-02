Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:53643 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3BBMoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 07:44:25 -0500
Message-ID: <1359809062.6019.42.camel@boolette.noo>
Subject: Re: System unmountable RW
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org
Date: Sat, 02 Feb 2013 13:44:22 +0100
In-Reply-To: <1359803076.6019.39.camel@boolette.noo>
References: <1359756678.6019.30.camel@boolette.noo>
	 <CAE5mzvgyOqw4ddd-jsW=QxLFqb8deB5d_jiB+WOj9t5hcq8_8A@mail.gmail.com>
	 <1359803076.6019.39.camel@boolette.noo>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le samedi 02 février 2013 à 12:04 +0100, Olivier Bonvalet a écrit :
> Le vendredi 01 février 2013 à 17:09 -0600, cwillu a écrit :
> > > then I do : mount -o rw,remount /backup/
> > >
> > > Feb  1 22:32:38 frozen kernel: [   65.780686] btrfs: force zlib compression
> > > Feb  1 22:32:38 frozen kernel: [   65.780700] btrfs: not using ssd allocation scheme
> > > Feb  1 22:32:38 frozen kernel: [   65.780706] btrfs: disk space caching is enabled
> > >
> > >
> > > I let that mount run days, without any success. It stay running, and I can't interrupt it (CTRL+C or kill).
> > 
> > Hit alt-sysrq-w at that point, and then post your dmesg; there should
> > be at least one stacktrace in there (possibly many), which should give
> > a good idea where it's hanging up.
> > --
> 
> Thanks for your help !
> 
> So, I upgraded to a 3.7.5 kernel (I had to recompile a kernel to enable
> sysrq), and just after reboot, I did a "mount -o remount,rw /backup/"
> followed by that sysrq :
> 
> [   70.382124] btrfs: force zlib compression
> [   70.382139] btrfs: not using ssd allocation scheme
> [   70.382145] btrfs: disk space caching is enabled
> [   92.228436] SysRq : Show Blocked State
> [   92.228451]   task                        PC stack   pid father
> [   92.228471] btrfs-cache-1   D ffff8802bfd92080     0  1766      2 0x00000000
> [   92.228481]  ffff8802af9e5a20 0000000000000246 0000000000000008 ffff8802b0c6d3b0
> [   92.228494]  0000000000012080 ffff8802afc83fd8 ffff8802afc83fd8 ffff8802af9e5a20
> [   92.228505]  0000000000000000 ffff8802bfd92080 ffff8802af9e5a20 ffff8802afc83b30
> [   92.228517] Call Trace:
> [   92.228530]  [<ffffffff810a0b75>] ? __lock_page+0x66/0x66
> [   92.228540]  [<ffffffff8132c920>] ? io_schedule+0x56/0x6d
> [   92.228548]  [<ffffffff810a0b7c>] ? sleep_on_page+0x7/0xc
> [   92.228556]  [<ffffffff8132b98d>] ? __wait_on_bit+0x3e/0x75
> [   92.228564]  [<ffffffff810a0c31>] ? wait_on_page_bit+0x6e/0x73
> [   92.228574]  [<ffffffff81060544>] ? autoremove_wake_function+0x2a/0x2a
> [   92.228601]  [<ffffffffa005889d>] ? read_extent_buffer_pages+0x1f3/0x247 [btrfs]
> [   92.228622]  [<ffffffffa003c299>] ? btree_readpage_end_io_hook+0x1d9/0x1d9 [btrfs]
> [   92.228643]  [<ffffffffa003b7ea>] ? btree_read_extent_buffer_pages.constprop.118+0x5a/0xf3 [btrfs]
> [   92.228663]  [<ffffffffa003caa0>] ? read_tree_block+0x25/0x2d [btrfs]
> [   92.228677]  [<ffffffffa00279e7>] ? read_block_for_search.isra.51+0x294/0x2cc [btrfs]
> [   92.228694]  [<ffffffffa002b6fc>] ? btrfs_next_old_leaf+0x156/0x324 [btrfs]
> [   92.228711]  [<ffffffffa002ed74>] ? caching_thread+0x19c/0x2d0 [btrfs]
> [   92.228721]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
> [   92.228742]  [<ffffffffa0060d01>] ? worker_loop+0x175/0x4b0 [btrfs]
> [   92.228761]  [<ffffffffa0060b8c>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
> [   92.228780]  [<ffffffffa0060b8c>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
> [   92.228789]  [<ffffffff8105fc53>] ? kthread+0x81/0x89
> [   92.228797]  [<ffffffff81002c46>] ? xen_mc_issue.constprop.27+0x6/0x1e
> [   92.228806]  [<ffffffff81060000>] ? kthread_unpark+0x2a/0x41
> [   92.228814]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
> [   92.228824]  [<ffffffff8132db3c>] ? ret_from_fork+0x7c/0xb0
> [   92.228832]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
> [   92.228839] btrfs-transacti D ffff8802bfd12080     0  1788      2 0x00000000
> [   92.228848]  ffff8802af9e39f0 0000000000000246 000000000000002a ffff8802b0c6cd40
> [   92.228860]  0000000000012080 ffff8802a9d7bfd8 ffff8802a9d7bfd8 ffff8802af9e39f0
> [   92.228871]  ffffffff8107ba5f ffff8802aa226000 ffff8802af7241e8 ffff8802a9d7bdf0
> [   92.228882] Call Trace:
> [   92.228889]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
> [   92.228909]  [<ffffffffa0040fdf>] ? wait_current_trans.isra.33+0xb3/0xe7 [btrfs]
> [   92.228919]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
> [   92.228938]  [<ffffffffa0042454>] ? start_transaction+0x33f/0x366 [btrfs]
> [   92.228956]  [<ffffffffa003b60e>] ? transaction_kthread+0xbe/0x183 [btrfs]
> [   92.228973]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
> [   92.228989]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
> [   92.228997]  [<ffffffff8105fc53>] ? kthread+0x81/0x89
> [   92.229005]  [<ffffffff81002c46>] ? xen_mc_issue.constprop.27+0x6/0x1e
> [   92.229013]  [<ffffffff81060000>] ? kthread_unpark+0x2a/0x41
> [   92.229021]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
> [   92.229030]  [<ffffffff8132db3c>] ? ret_from_fork+0x7c/0xb0
> [   92.229037]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
> [   92.229049] mount           D ffff8802bfc92080     0  2642   2595 0x00000000
> [   92.229057]  ffff8802b031b9f0 0000000000000286 ffff8802aa300408 ffff8802b0c6c6d0
> [   92.229068]  0000000000012080 ffff8802afdebfd8 ffff8802afdebfd8 ffff8802b031b9f0
> [   92.229079]  ffffffffa006cce5 ffff8802b0cbc5c0 ffff8802b031b9f0 ffffffffffffffff
> [   92.229090] Call Trace:
> [   92.229109]  [<ffffffffa006cce5>] ? __lookup_free_space_inode+0xd5/0x104 [btrfs]
> [   92.229119]  [<ffffffff8132cf5b>] ? rwsem_down_failed_common+0xe3/0x117
> [   92.229129]  [<ffffffff8119d543>] ? call_rwsem_down_write_failed+0x13/0x20
> [   92.229149]  [<ffffffffa006eebe>] ? load_free_space_cache+0xd1/0x16a [btrfs]
> [   92.229158]  [<ffffffff8132bfc6>] ? down_write+0x1c/0x1d
> [   92.229173]  [<ffffffffa002d151>] ? cache_block_group.isra.56+0x2a5/0x30e [btrfs]
> [   92.229182]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
> [   92.229197]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
> [   92.229213]  [<ffffffffa0030d98>] ? find_free_extent.isra.77+0x342/0x7a4 [btrfs]
> [   92.229228]  [<ffffffffa0027203>] ? comp_keys+0x26/0x2b [btrfs]
> [   92.229247]  [<ffffffffa006699a>] ? btrfs_tree_read_unlock+0x7b/0x8a [btrfs]
> [   92.229262]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
> [   92.229279]  [<ffffffffa00335f1>] ? btrfs_reserve_extent+0x7c/0x100 [btrfs]
> [   92.229300]  [<ffffffffa00466f7>] ? __btrfs_prealloc_file_range+0xc9/0x30f [btrfs]
> [   92.229311]  [<ffffffff810cf871>] ? virt_to_head_page+0x7/0x2b
> [   92.229319]  [<ffffffff810d16d0>] ? kmem_cache_free+0x11/0xb5
> [   92.229334]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
> [   92.229353]  [<ffffffffa006c3f5>] ? spin_unlock+0x5/0x8 [btrfs]
> [   92.229370]  [<ffffffffa0035443>] ? btrfs_write_dirty_block_groups+0x214/0x50f [btrfs]
> [   92.229385]  [<ffffffffa0089741>] ? commit_cowonly_roots+0x11e/0x1dd [btrfs]
> [   92.229406]  [<ffffffffa0078dde>] ? spin_unlock+0x5/0x8 [btrfs]
> [   92.232243]  [<ffffffffa0041947>] ? btrfs_commit_transaction+0x467/0x927 [btrfs]
> [   92.232243]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
> [   92.232243]  [<ffffffffa00423f3>] ? start_transaction+0x2de/0x366 [btrfs]
> [   92.232243]  [<ffffffffa0053196>] ? do_raw_spin_unlock+0x5/0x8 [btrfs]
> [   92.232243]  [<ffffffffa0078741>] ? btrfs_recover_relocation+0x25e/0x32b [btrfs]
> [   92.232243]  [<ffffffffa0023cd8>] ? btrfs_remount+0x10c/0x1c8 [btrfs]
> [   92.232243]  [<ffffffff810e7a52>] ? do_raw_spin_unlock+0x5/0x8
> [   92.232243]  [<ffffffff810dc07f>] ? do_remount_sb+0xb1/0x155
> [   92.232243]  [<ffffffff810f0304>] ? do_mount+0x1ff/0x6d7
> [   92.232243]  [<ffffffff810f0861>] ? sys_mount+0x85/0xbf
> [   92.232243]  [<ffffffff8132dbe9>] ? system_call_fastpath+0x16/0x1b
> 
> 
> So I suppose for now that the «space cache» stuff is working, so maybe I
> should retry in some hours, when they will not be IO anymore ?
> 
> Olivier
> 
> 
> 
> --

Then, after some time, there space cache process is stoped, and now I
have :

[ 6356.638082] SysRq : Show Blocked State
[ 6356.638097]   task                        PC stack   pid father
[ 6356.638116] btrfs-transacti D ffff8802bfc12080     0  1788      2 0x00000000
[ 6356.638127]  ffff8802af9e39f0 0000000000000246 ffffffffa0042250 ffffffff816133f0
[ 6356.638140]  0000000000012080 ffff8802a9d7bfd8 ffff8802a9d7bfd8 ffff8802af9e39f0
[ 6356.638151]  ffffffff8107ba5f ffff8802957632e8 ffff8802af7241e8 ffff8802a9d7bdf0
[ 6356.638163] Call Trace:
[ 6356.638188]  [<ffffffffa0042250>] ? start_transaction+0x13b/0x366 [btrfs]
[ 6356.638201]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 6356.638220]  [<ffffffffa0040fdf>] ? wait_current_trans.isra.33+0xb3/0xe7 [btrfs]
[ 6356.638232]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 6356.638251]  [<ffffffffa0042454>] ? start_transaction+0x33f/0x366 [btrfs]
[ 6356.638270]  [<ffffffffa003b60e>] ? transaction_kthread+0xbe/0x183 [btrfs]
[ 6356.638288]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
[ 6356.638305]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
[ 6356.638313]  [<ffffffff8105fc53>] ? kthread+0x81/0x89
[ 6356.638322]  [<ffffffff81002c46>] ? xen_mc_issue.constprop.27+0x6/0x1e
[ 6356.638331]  [<ffffffff81060000>] ? kthread_unpark+0x2a/0x41
[ 6356.638339]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
[ 6356.638349]  [<ffffffff8132db3c>] ? ret_from_fork+0x7c/0xb0
[ 6356.638357]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
[ 6356.638368] mount           D ffff8802bfc12080     0  2642   2595 0x00000000
[ 6356.638378]  ffff8802b031b9f0 0000000000000286 000000000000000e ffffffff816133f0
[ 6356.638390]  0000000000012080 ffff8802afdebfd8 ffff8802afdebfd8 ffff8802b031b9f0
[ 6356.638401]  ffffffff8107ba5f ffff8802aa2b6810 ffff8802afdeb7b0 ffff8802afdeb7c8
[ 6356.638412] Call Trace:
[ 6356.638420]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 6356.638441]  [<ffffffffa0066660>] ? btrfs_tree_lock+0xcf/0x224 [btrfs]
[ 6356.638463]  [<ffffffffa0057941>] ? alloc_extent_buffer+0x6f/0x2d6 [btrfs]
[ 6356.638472]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 6356.638490]  [<ffffffffa00338c4>] ? btrfs_init_new_buffer+0x5a/0xe2 [btrfs]
[ 6356.638507]  [<ffffffffa0033aeb>] ? btrfs_alloc_free_block+0x19f/0x29d [btrfs]
[ 6356.638518]  [<ffffffff810a7e26>] ? __set_page_dirty_nobuffers+0xc4/0xe0
[ 6356.638532]  [<ffffffffa00261a8>] ? __btrfs_cow_block+0xf2/0x372 [btrfs]
[ 6356.638547]  [<ffffffffa0026551>] ? btrfs_cow_block+0xee/0xfd [btrfs]
[ 6356.638562]  [<ffffffffa00290e8>] ? btrfs_search_slot+0x234/0x660 [btrfs]
[ 6356.638577]  [<ffffffffa002a475>] ? btrfs_insert_empty_items+0x5d/0xae [btrfs]
[ 6356.638595]  [<ffffffffa0032b0a>] ? run_clustered_refs+0x4b1/0x81d [btrfs]
[ 6356.638604]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 6356.638621]  [<ffffffffa00350eb>] ? btrfs_run_delayed_refs+0xea/0x22e [btrfs]
[ 6356.638641]  [<ffffffffa00418c8>] ? btrfs_commit_transaction+0x3e8/0x927 [btrfs]
[ 6356.638651]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 6356.638668]  [<ffffffffa0041f8e>] ? __btrfs_end_transaction+0x158/0x2c4 [btrfs]
[ 6356.638685]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
[ 6356.638701]  [<ffffffffa0033f34>] ? btrfs_drop_snapshot+0x34b/0x4b5 [btrfs]
[ 6356.638723]  [<ffffffffa0077b95>] ? merge_reloc_roots+0xe0/0x113 [btrfs]
[ 6356.638742]  [<ffffffffa007874f>] ? btrfs_recover_relocation+0x26c/0x32b [btrfs]
[ 6356.638756]  [<ffffffffa0023cd8>] ? btrfs_remount+0x10c/0x1c8 [btrfs]
[ 6356.638765]  [<ffffffff810e7a52>] ? do_raw_spin_unlock+0x5/0x8
[ 6356.638774]  [<ffffffff810dc07f>] ? do_remount_sb+0xb1/0x155
[ 6356.638782]  [<ffffffff810f0304>] ? do_mount+0x1ff/0x6d7
[ 6356.638790]  [<ffffffff810f0861>] ? sys_mount+0x85/0xbf
[ 6356.638798]  [<ffffffff8132dbe9>] ? system_call_fastpath+0x16/0x1b




