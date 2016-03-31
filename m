Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:59704 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbcCaNpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 09:45:54 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1alcv2-0007lJ-TJ
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 15:45:52 +0200
Date: Thu, 31 Mar 2016 15:45:52 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to cancel btrfs balance on unmounted filesystem
Message-ID: <20160331134552.GY9342@torres.zugschlus.de>
References: <20160331062112.GT9342@torres.zugschlus.de>
 <20160331130137.6b130aa0@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160331130137.6b130aa0@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 01:01:37PM +0500, Roman Mamedov wrote:
> On Thu, 31 Mar 2016 08:21:12 +0200
> Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > the balance restarts immediately after mounting
> 
> You can use the skip_balance mount option to prevent that.

Thanks. I now have this in all fstabs. On the system in questionl, I
was able to sneak in a btrfs balance cancel before the system hanged
itself.

Mar 31 08:17:42 fan kernel: [  240.595465] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
Mar 31 08:17:42 fan kernel: [  240.595604]       Tainted: G        W       4.4.6-zgws1 #2
Mar 31 08:17:42 fan kernel: [  240.595705] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 31 08:17:42 fan kernel: [  240.595845] kworker/u16:0   D ffff88062fc956c0     0     6      2 0x00000000
Mar 31 08:17:42 fan kernel: [  240.595913] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
Mar 31 08:17:42 fan kernel: [  240.595919]  ffff88017ca680c0 0000000000000002 ffff88017ca78000 ffff88017ca77ca0
Mar 31 08:17:42 fan kernel: [  240.595927]  ffff8800c9388960 0000000000000002 ffffffff81409e1c ffff88017ca680c0
Mar 31 08:17:42 fan kernel: [  240.595934]  ffffffff81408329 7fffffffffffffff ffffffff81409e5a 000000c0a044e7d3
Mar 31 08:17:42 fan kernel: [  240.595941] Call Trace:
Mar 31 08:17:42 fan kernel: [  240.595955]  [<ffffffff81409e1c>] ? usleep_range+0x35/0x35
Mar 31 08:17:42 fan kernel: [  240.595964]  [<ffffffff81408329>] ? schedule+0x6f/0x7c
Mar 31 08:17:42 fan kernel: [  240.595973]  [<ffffffff81409e5a>] ? schedule_timeout+0x3e/0x128
Mar 31 08:17:42 fan kernel: [  240.595981]  [<ffffffff811293f9>] ? ____cache_alloc+0x1bd/0x277
Mar 31 08:17:42 fan kernel: [  240.595990]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.595997]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.596006]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar 31 08:17:42 fan kernel: [  240.596047]  [<ffffffffa0456832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596093]  [<ffffffffa046c815>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596140]  [<ffffffffa0472e9d>] ? btrfs_finish_ordered_io+0x418/0x4d7 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596187]  [<ffffffffa0491ec4>] ? btrfs_scrubparity_helper+0xf4/0x233 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596198]  [<ffffffff81063b4f>] ? process_one_work+0x178/0x27b
Mar 31 08:17:42 fan kernel: [  240.596206]  [<ffffffff810640d3>] ? worker_thread+0x1da/0x280
Mar 31 08:17:42 fan kernel: [  240.596213]  [<ffffffff81063ef9>] ? rescuer_thread+0x284/0x284
Mar 31 08:17:42 fan kernel: [  240.596220]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar 31 08:17:42 fan kernel: [  240.596227]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.596234]  [<ffffffff8140abff>] ? ret_from_fork+0x3f/0x70
Mar 31 08:17:42 fan kernel: [  240.596240]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.596272] INFO: task kworker/u16:2:134 blocked for more than 120 seconds.
Mar 31 08:17:42 fan kernel: [  240.596399]       Tainted: G        W       4.4.6-zgws1 #2
Mar 31 08:17:42 fan kernel: [  240.596499] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 31 08:17:42 fan kernel: [  240.596637] kworker/u16:2   D ffff88062fcd56c0     0   134      2 0x00000000
Mar 31 08:17:42 fan kernel: [  240.596688] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596692]  ffff8806130e4780 0000000000000003 ffff880613108000 ffff880613107ca0
Mar 31 08:17:42 fan kernel: [  240.596699]  ffff8805caa1d960 0000000000000002 ffffffff81409e1c ffff8806130e4780
Mar 31 08:17:42 fan kernel: [  240.596706]  ffffffff81408329 7fffffffffffffff ffffffff81409e5a ffff88062fd556c0
Mar 31 08:17:42 fan kernel: [  240.596712] Call Trace:
Mar 31 08:17:42 fan kernel: [  240.596721]  [<ffffffff81409e1c>] ? usleep_range+0x35/0x35
Mar 31 08:17:42 fan kernel: [  240.596728]  [<ffffffff81408329>] ? schedule+0x6f/0x7c
Mar 31 08:17:42 fan kernel: [  240.596735]  [<ffffffff81409e5a>] ? schedule_timeout+0x3e/0x128
Mar 31 08:17:42 fan kernel: [  240.596742]  [<ffffffff8106e853>] ? check_preempt_curr+0x41/0x63
Mar 31 08:17:42 fan kernel: [  240.596750]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar 31 08:17:42 fan kernel: [  240.596757]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.596764]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.596771]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar 31 08:17:42 fan kernel: [  240.596812]  [<ffffffffa0456832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596858]  [<ffffffffa046c815>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596904]  [<ffffffffa0472e9d>] ? btrfs_finish_ordered_io+0x418/0x4d7 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596952]  [<ffffffffa0491ec4>] ? btrfs_scrubparity_helper+0xf4/0x233 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.596960]  [<ffffffff81063b4f>] ? process_one_work+0x178/0x27b
Mar 31 08:17:42 fan kernel: [  240.596968]  [<ffffffff810640d3>] ? worker_thread+0x1da/0x280
Mar 31 08:17:42 fan kernel: [  240.596976]  [<ffffffff81063ef9>] ? rescuer_thread+0x284/0x284
Mar 31 08:17:42 fan kernel: [  240.596982]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar 31 08:17:42 fan kernel: [  240.596989]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.596995]  [<ffffffff8140abff>] ? ret_from_fork+0x3f/0x70
Mar 31 08:17:42 fan kernel: [  240.597001]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.599190] INFO: task kworker/u16:7:139 blocked for more than 120 seconds.
Mar 31 08:17:42 fan kernel: [  240.599316]       Tainted: G        W       4.4.6-zgws1 #2
Mar 31 08:17:42 fan kernel: [  240.599463] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 31 08:17:42 fan kernel: [  240.605365] kworker/u16:7   D ffff88062fd556c0     0   139      2 0x00000000
Mar 31 08:17:42 fan kernel: [  240.605376] Workqueue: writeback wb_workfn (flush-btrfs-1)
Mar 31 08:17:42 fan kernel: [  240.605382]  ffff880614fef3c0 00ff880600000005 ffff88061311c000 ffff88061311b740
Mar 31 08:17:42 fan kernel: [  240.605389]  ffff8805cb01bd20 0000000000000002 ffffffff81409e1c ffff880614fef3c0
Mar 31 08:17:42 fan kernel: [  240.605395]  ffffffff81408329 7fffffffffffffff ffffffff81409e5a ffff88062fc956c0
Mar 31 08:17:42 fan kernel: [  240.605402] Call Trace:
Mar 31 08:17:42 fan kernel: [  240.605410]  [<ffffffff81409e1c>] ? usleep_range+0x35/0x35
Mar 31 08:17:42 fan kernel: [  240.605417]  [<ffffffff81408329>] ? schedule+0x6f/0x7c
Mar 31 08:17:42 fan kernel: [  240.605425]  [<ffffffff81409e5a>] ? schedule_timeout+0x3e/0x128
Mar 31 08:17:42 fan kernel: [  240.605433]  [<ffffffff8106e853>] ? check_preempt_curr+0x41/0x63
Mar 31 08:17:42 fan kernel: [  240.605440]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar 31 08:17:42 fan kernel: [  240.605448]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.605456]  [<ffffffff8140a5ed>] ? _raw_spin_lock_irq+0x5/0xa
Mar 31 08:17:42 fan kernel: [  240.605463]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.605471]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar 31 08:17:42 fan kernel: [  240.605513]  [<ffffffffa0456832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605560]  [<ffffffffa046c815>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605607]  [<ffffffffa0470f3f>] ? cow_file_range_inline+0x4a2/0x4ba [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605653]  [<ffffffffa0471019>] ? cow_file_range+0xc2/0x37e [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605663]  [<ffffffff81073fe5>] ? account_entity_enqueue+0x4f/0x7f
Mar 31 08:17:42 fan kernel: [  240.605711]  [<ffffffffa0481f70>] ? find_delalloc_range.constprop.40+0xe5/0xf7 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605758]  [<ffffffffa0471ad6>] ? run_delalloc_range+0xc8/0x327 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605806]  [<ffffffffa0483d2d>] ? writepage_delalloc.isra.27+0xb1/0x137 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605854]  [<ffffffffa0485c6d>] ? __extent_writepage+0x129/0x1e7 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605902]  [<ffffffffa0485efb>] ? extent_write_cache_pages.isra.23.constprop.44+0x1d0/0x264 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605949]  [<ffffffffa046d4ab>] ? btrfs_submit_bio_hook+0xfb/0x145 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.605995]  [<ffffffffa046df70>] ? btrfs_retry_endio+0x8e/0x8e [btrfs]
Mar 31 08:17:42 fan kernel: [  240.606041]  [<ffffffffa046d4f5>] ? btrfs_submit_bio_hook+0x145/0x145 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.606089]  [<ffffffffa04863a1>] ? extent_writepages+0x49/0x60 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.606136]  [<ffffffffa046f627>] ? btrfs_writepage_start_hook+0xc1/0xc1 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.606145]  [<ffffffff8115c9d7>] ? __writeback_single_inode+0x78/0x307
Mar 31 08:17:42 fan kernel: [  240.606154]  [<ffffffff8115d014>] ? writeback_sb_inodes+0x1f4/0x3a7
Mar 31 08:17:42 fan kernel: [  240.606163]  [<ffffffff8115d22a>] ? __writeback_inodes_wb+0x63/0x9a
Mar 31 08:17:42 fan kernel: [  240.606172]  [<ffffffff8115d45f>] ? wb_writeback+0x15b/0x2b5
Mar 31 08:17:42 fan kernel: [  240.606179]  [<ffffffff8115dae1>] ? wb_workfn+0x19b/0x2ab
Mar 31 08:17:42 fan kernel: [  240.606184]  [<ffffffff8115dae1>] ? wb_workfn+0x19b/0x2ab
Mar 31 08:17:42 fan kernel: [  240.606193]  [<ffffffff81063b4f>] ? process_one_work+0x178/0x27b
Mar 31 08:17:42 fan kernel: [  240.606201]  [<ffffffff810640d3>] ? worker_thread+0x1da/0x280
Mar 31 08:17:42 fan kernel: [  240.606209]  [<ffffffff81063ef9>] ? rescuer_thread+0x284/0x284
Mar 31 08:17:42 fan kernel: [  240.606216]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar 31 08:17:42 fan kernel: [  240.606223]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.606229]  [<ffffffff8140abff>] ? ret_from_fork+0x3f/0x70
Mar 31 08:17:42 fan kernel: [  240.606236]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.606290] INFO: task btrfs-balance:760 blocked for more than 120 seconds.
Mar 31 08:17:42 fan kernel: [  240.612187]       Tainted: G        W       4.4.6-zgws1 #2
Mar 31 08:17:42 fan kernel: [  240.618118] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 31 08:17:42 fan kernel: [  240.624162] btrfs-balance   D ffff88062fc156c0     0   760      2 0x00000000
Mar 31 08:17:42 fan kernel: [  240.624169]  ffff880610b6d2c0 0000000000000000 ffff8805e6574000 ffff8805e6573bd0
Mar 31 08:17:42 fan kernel: [  240.624188]  ffff8805cb01a360 0000000000000002 ffffffff81409e1c ffff880610b6d2c0
Mar 31 08:17:42 fan kernel: [  240.624199]  ffffffff81408329 7fffffffffffffff ffffffff81409e5a ffff88062fc956c0
Mar 31 08:17:42 fan kernel: [  240.624205] Call Trace:
Mar 31 08:17:42 fan kernel: [  240.624214]  [<ffffffff81409e1c>] ? usleep_range+0x35/0x35
Mar 31 08:17:42 fan kernel: [  240.624221]  [<ffffffff81408329>] ? schedule+0x6f/0x7c
Mar 31 08:17:42 fan kernel: [  240.624228]  [<ffffffff81409e5a>] ? schedule_timeout+0x3e/0x128
Mar 31 08:17:42 fan kernel: [  240.624253]  [<ffffffff8106e853>] ? check_preempt_curr+0x41/0x63
Mar 31 08:17:42 fan kernel: [  240.624270]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar 31 08:17:42 fan kernel: [  240.624278]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.624285]  [<ffffffff81408a60>] ? __wait_for_common+0x121/0x16d
Mar 31 08:17:42 fan kernel: [  240.624295]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar 31 08:17:42 fan kernel: [  240.624337]  [<ffffffffa0456832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624397]  [<ffffffffa046c815>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624453]  [<ffffffffa04abe8b>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624503]  [<ffffffffa0481100>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624551]  [<ffffffffa04ac1b0>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624600]  [<ffffffffa048b180>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624648]  [<ffffffffa048c96c>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624699]  [<ffffffffa048ca27>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624747]  [<ffffffffa048c9d8>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar 31 08:17:42 fan kernel: [  240.624756]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar 31 08:17:42 fan kernel: [  240.624763]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 31 08:17:42 fan kernel: [  240.624770]  [<ffffffff8140abff>] ? ret_from_fork+0x3f/0x70
Mar 31 08:17:42 fan kernel: [  240.624778]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16

followed by the first "BTRFS: block rsv returned -28" fifteen seconds
later.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
