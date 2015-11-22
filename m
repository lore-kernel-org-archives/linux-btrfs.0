Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37841 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbKVVkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 16:40:00 -0500
Received: by wmww144 with SMTP id w144so82497507wmw.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 13:39:59 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Mon, 23 Nov 2015 02:39:44 +0500
Message-ID: <CABXGCsM2=xypLXTj9QrotwH-RiZm+WdHuyGLUtCeA3t5KAmRHA@mail.gmail.com>
Subject: INFO: task tracker-store:2686 blocked for more than 120 seconds.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[  239.881241] INFO: task tracker-store:2686 blocked for more than 120 seconds.
[  239.881245]       Not tainted 4.2.6-300.fc23.x86_64+debug #1
[  239.881246] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  239.881247] tracker-store   D ffff8807fe1d76d8 11528  2686      1 0x00000000
[  239.881254]  ffff8807a7aef1e8 0000000000000096 ffff8807f997b800
0000000000000000
[  239.881256]  ffff8807f61faa40 ffff8807a79c5480 ffff8807a7aef1e8
ffff8807a7af0000
[  239.881258]  ffff8807fe1d76c0 7fffffffffffffff ffffffff8186d450
ffff8807a7aef3b0
[  239.881260] Call Trace:
[  239.881267]  [<ffffffff8186d450>] ? bit_wait+0x50/0x50
[  239.881268]  [<ffffffff8186cade>] schedule+0x3e/0x90
[  239.881270]  [<ffffffff81871705>] schedule_timeout+0x255/0x410
[  239.881274]  [<ffffffff81107f5d>] ? mark_held_locks+0x7d/0xb0
[  239.881279]  [<ffffffff8113e00d>] ? ktime_get+0x7d/0x140
[  239.881281]  [<ffffffff8186d450>] ? bit_wait+0x50/0x50
[  239.881283]  [<ffffffff811080b9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[  239.881287]  [<ffffffff810267d9>] ? read_tsc+0x9/0x10
[  239.881289]  [<ffffffff8113e03c>] ? ktime_get+0xac/0x140
[  239.881292]  [<ffffffff811902d3>] ? __delayacct_blkio_start+0x23/0x30
[  239.881294]  [<ffffffff8186d450>] ? bit_wait+0x50/0x50
[  239.881296]  [<ffffffff8186c024>] io_schedule_timeout+0xa4/0x110
[  239.881297]  [<ffffffff8186d485>] bit_wait_io+0x35/0x50
[  239.881299]  [<ffffffff8186d01d>] __wait_on_bit+0x5d/0x90
[  239.881303]  [<ffffffff811e12cf>] wait_on_page_bit+0xcf/0xf0
[  239.881305]  [<ffffffff810fbfc0>] ? autoremove_wake_function+0x40/0x40
[  239.881329]  [<ffffffffa06f1319>]
read_extent_buffer_pages+0x2c9/0x300 [btrfs]
[  239.881340]  [<ffffffffa06c0ec0>] ? free_root_pointers+0x60/0x60 [btrfs]
[  239.881347]  [<ffffffffa06c1e8c>]
btree_read_extent_buffer_pages.constprop.54+0xac/0x110 [btrfs]
[  239.881354]  [<ffffffffa06c3171>] read_tree_block+0x41/0x70 [btrfs]
[  239.881360]  [<ffffffffa06a048e>]
read_block_for_search.isra.34+0x13e/0x380 [btrfs]
[  239.881366]  [<ffffffffa06a27f4>] btrfs_search_slot+0x384/0xa10 [btrfs]
[  239.881369]  [<ffffffff811080b9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[  239.881375]  [<ffffffffa06bd08e>] btrfs_lookup_csum+0x4e/0x150 [btrfs]
[  239.881382]  [<ffffffffa06bd345>]
__btrfs_lookup_bio_sums.isra.6+0x1b5/0x510 [btrfs]
[  239.881389]  [<ffffffffa06c2c5c>] ? btrfs_bio_wq_end_io+0x2c/0x80 [btrfs]
[  239.881395]  [<ffffffffa06bd926>] btrfs_lookup_bio_sums+0x36/0x40 [btrfs]
[  239.881402]  [<ffffffffa06cd661>] btrfs_submit_bio_hook+0x131/0x1b0 [btrfs]
[  239.881410]  [<ffffffffa06e8bde>] submit_one_bio+0x6e/0xa0 [btrfs]
[  239.881417]  [<ffffffffa06edac5>] submit_extent_page+0xe5/0x1e0 [btrfs]
[  239.881423]  [<ffffffffa06eee8e>] __do_readpage+0x39e/0x940 [btrfs]
[  239.881429]  [<ffffffffa06ed200>] ?
btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  239.881436]  [<ffffffffa06d0140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  239.881443]  [<ffffffffa06ef7f4>]
__extent_readpages.constprop.40+0x2c4/0x2e0 [btrfs]
[  239.881445]  [<ffffffff811e3168>] ? __add_to_page_cache_locked+0x408/0x470
[  239.881451]  [<ffffffffa06d0140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  239.881458]  [<ffffffffa06efe77>] extent_readpages+0x197/0x1f0 [btrfs]
[  239.881464]  [<ffffffffa06d0140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  239.881469]  [<ffffffffa06cda6f>] btrfs_readpages+0x1f/0x30 [btrfs]
[  239.881472]  [<ffffffff811f42cf>] __do_page_cache_readahead+0x2af/0x330
[  239.881473]  [<ffffffff811f419d>] ? __do_page_cache_readahead+0x17d/0x330
[  239.881475]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
[  239.881477]  [<ffffffff811f4433>] ondemand_readahead+0xe3/0x460
[  239.881480]  [<ffffffff812a2132>] ? inode_congested+0x122/0x210
[  239.881482]  [<ffffffff811f4823>] page_cache_async_readahead+0x73/0x80
[  239.881483]  [<ffffffff811e44b2>] generic_file_read_iter+0x452/0x610
[  239.881485]  [<ffffffff81107f5d>] ? mark_held_locks+0x7d/0xb0
[  239.881487]  [<ffffffff8126fe1c>] __vfs_read+0xcc/0x100
[  239.881488]  [<ffffffff8127073a>] vfs_read+0x8a/0x140
[  239.881490]  [<ffffffff812714e8>] SyS_read+0x58/0xd0
[  239.881493]  [<ffffffff818735ee>] entry_SYSCALL_64_fastpath+0x12/0x76
[  239.881495] 1 lock held by tracker-store/2686:
[  239.881495]  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<ffffffff81293149>] __fdget_pos+0x49/0x50




--
Best Regards,
Mike Gavrilov.
