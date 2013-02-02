Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:54052 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3BBNP0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 08:15:26 -0500
Message-ID: <1359810923.6019.44.camel@boolette.noo>
Subject: Re: System unmountable RW
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org
Date: Sat, 02 Feb 2013 14:15:23 +0100
In-Reply-To: <1359809062.6019.42.camel@boolette.noo>
References: <1359756678.6019.30.camel@boolette.noo>
	 <CAE5mzvgyOqw4ddd-jsW=QxLFqb8deB5d_jiB+WOj9t5hcq8_8A@mail.gmail.com>
	 <1359803076.6019.39.camel@boolette.noo>
	 <1359809062.6019.42.camel@boolette.noo>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Then, 30 minutes later there is no change, so I suppose it's "frozen".
I hope it can help :

[ 8081.557019] SysRq : Show Blocked State
[ 8081.557034]   task                        PC stack   pid father
[ 8081.557053] btrfs-transacti D ffff8802bfc12080     0  1788      2 0x00000000
[ 8081.557064]  ffff8802af9e39f0 0000000000000246 ffffffffa0042250 ffffffff816133f0
[ 8081.557076]  0000000000012080 ffff8802a9d7bfd8 ffff8802a9d7bfd8 ffff8802af9e39f0
[ 8081.557088]  ffffffff8107ba5f ffff8802957632e8 ffff8802af7241e8 ffff8802a9d7bdf0
[ 8081.557099] Call Trace:
[ 8081.557124]  [<ffffffffa0042250>] ? start_transaction+0x13b/0x366 [btrfs]
[ 8081.557137]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 8081.557157]  [<ffffffffa0040fdf>] ? wait_current_trans.isra.33+0xb3/0xe7 [btrfs]
[ 8081.557168]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 8081.557187]  [<ffffffffa0042454>] ? start_transaction+0x33f/0x366 [btrfs]
[ 8081.557206]  [<ffffffffa003b60e>] ? transaction_kthread+0xbe/0x183 [btrfs]
[ 8081.557224]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
[ 8081.557240]  [<ffffffffa003b550>] ? try_to_freeze+0x2c/0x2c [btrfs]
[ 8081.557249]  [<ffffffff8105fc53>] ? kthread+0x81/0x89
[ 8081.557258]  [<ffffffff81002c46>] ? xen_mc_issue.constprop.27+0x6/0x1e
[ 8081.557267]  [<ffffffff81060000>] ? kthread_unpark+0x2a/0x41
[ 8081.557275]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
[ 8081.557285]  [<ffffffff8132db3c>] ? ret_from_fork+0x7c/0xb0
[ 8081.557293]  [<ffffffff8105fbd2>] ? __kthread_parkme+0x5b/0x5b
[ 8081.557304] mount           D ffff8802bfc12080     0  2642   2595 0x00000000
[ 8081.557314]  ffff8802b031b9f0 0000000000000286 000000000000000e ffffffff816133f0
[ 8081.557325]  0000000000012080 ffff8802afdebfd8 ffff8802afdebfd8 ffff8802b031b9f0
[ 8081.557336]  ffffffff8107ba5f ffff8802aa2b6810 ffff8802afdeb7b0 ffff8802afdeb7c8
[ 8081.557348] Call Trace:
[ 8081.557355]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 8081.557376]  [<ffffffffa0066660>] ? btrfs_tree_lock+0xcf/0x224 [btrfs]
[ 8081.557399]  [<ffffffffa0057941>] ? alloc_extent_buffer+0x6f/0x2d6 [btrfs]
[ 8081.557408]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 8081.557426]  [<ffffffffa00338c4>] ? btrfs_init_new_buffer+0x5a/0xe2 [btrfs]
[ 8081.557443]  [<ffffffffa0033aeb>] ? btrfs_alloc_free_block+0x19f/0x29d [btrfs]
[ 8081.557454]  [<ffffffff810a7e26>] ? __set_page_dirty_nobuffers+0xc4/0xe0
[ 8081.557468]  [<ffffffffa00261a8>] ? __btrfs_cow_block+0xf2/0x372 [btrfs]
[ 8081.557483]  [<ffffffffa0026551>] ? btrfs_cow_block+0xee/0xfd [btrfs]
[ 8081.557498]  [<ffffffffa00290e8>] ? btrfs_search_slot+0x234/0x660 [btrfs]
[ 8081.557513]  [<ffffffffa002a475>] ? btrfs_insert_empty_items+0x5d/0xae [btrfs]
[ 8081.557531]  [<ffffffffa0032b0a>] ? run_clustered_refs+0x4b1/0x81d [btrfs]
[ 8081.557540]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
[ 8081.557557]  [<ffffffffa00350eb>] ? btrfs_run_delayed_refs+0xea/0x22e [btrfs]
[ 8081.557577]  [<ffffffffa00418c8>] ? btrfs_commit_transaction+0x3e8/0x927 [btrfs]
[ 8081.557587]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
[ 8081.557605]  [<ffffffffa0041f8e>] ? __btrfs_end_transaction+0x158/0x2c4 [btrfs]
[ 8081.557621]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
[ 8081.557638]  [<ffffffffa0033f34>] ? btrfs_drop_snapshot+0x34b/0x4b5 [btrfs]
[ 8081.557659]  [<ffffffffa0077b95>] ? merge_reloc_roots+0xe0/0x113 [btrfs]
[ 8081.557679]  [<ffffffffa007874f>] ? btrfs_recover_relocation+0x26c/0x32b [btrfs]
[ 8081.557693]  [<ffffffffa0023cd8>] ? btrfs_remount+0x10c/0x1c8 [btrfs]
[ 8081.557702]  [<ffffffff810e7a52>] ? do_raw_spin_unlock+0x5/0x8
[ 8081.557711]  [<ffffffff810dc07f>] ? do_remount_sb+0xb1/0x155
[ 8081.557719]  [<ffffffff810f0304>] ? do_mount+0x1ff/0x6d7
[ 8081.557726]  [<ffffffff810f0861>] ? sys_mount+0x85/0xbf
[ 8081.557734]  [<ffffffff8132dbe9>] ? system_call_fastpath+0x16/0x1b





