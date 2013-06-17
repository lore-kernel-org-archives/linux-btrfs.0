Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3FQTpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 15:45:15 -0400
Date: Mon, 17 Jun 2013 15:45:04 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: btrfs triggered 'MAX_LOCKDEP_CHAINS too low'
Message-ID: <20130617194504.GA16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Something else I've seen a few times from my io script
(Always during btrfs runs)...

BUG: MAX_LOCKDEP_CHAINS too low!
turning off the locking correctness validator.
Please attach the output of /proc/lock_stat to the bug report
CPU: 1 PID: 492255 Comm: kworker/u8:0 Not tainted 3.10.0-rc6+ #6
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
Workqueue: writeback bdi_writeback_workfn (flush-btrfs-6)
 0000000000000000 ffff8800266df2e8 ffffffff816aee0f ffff8800266df3a8
 ffffffff810ba3e6 0000000000000092 ffffffff810b4c38 0000000000000092
 ffffffff824dfaa0 ffff8800266df328 0000000000003698 ffff880012662500
Call Trace:
 [<ffffffff816aee0f>] dump_stack+0x19/0x1b
 [<ffffffff810ba3e6>] __lock_acquire+0x1b16/0x1b70
 [<ffffffff810b4c38>] ? trace_hardirqs_off_caller+0x28/0xd0
 [<ffffffff810baef9>] ? lock_release_non_nested+0x1c9/0x340
 [<ffffffff810babe3>] lock_acquire+0x93/0x1e0
 [<ffffffffa036fa97>] ? free_extent_buffer+0x37/0xa0 [btrfs]
 [<ffffffff816b6221>] _raw_spin_lock+0x41/0x80
 [<ffffffffa036fa97>] ? free_extent_buffer+0x37/0xa0 [btrfs]
 [<ffffffffa036fa97>] free_extent_buffer+0x37/0xa0 [btrfs]
 [<ffffffffa032dfc6>] btrfs_next_old_leaf+0x2e6/0x4b0 [btrfs]
 [<ffffffffa032e1a0>] btrfs_next_leaf+0x10/0x20 [btrfs]
 [<ffffffffa0362951>] __btrfs_drop_extents+0x181/0xb00 [btrfs]
 [<ffffffffa03251ea>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa03251ea>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa03251ea>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa0363d7b>] btrfs_drop_extents+0x6b/0xa0 [btrfs]
 [<ffffffffa03568c3>] cow_file_range_inline+0xe3/0x1c0 [btrfs]
 [<ffffffff810b5a65>] ? lock_release_holdtime.part.28+0xe5/0x160
 [<ffffffffa0356caa>] __cow_file_range+0x30a/0x480 [btrfs]
 [<ffffffff810b4d62>] ? get_lock_stats+0x22/0x70
 [<ffffffffa0357995>] cow_file_range+0x95/0xe0 [btrfs]
 [<ffffffffa0357d2d>] run_delalloc_range+0x34d/0x390 [btrfs]
 [<ffffffffa036c481>] ? find_lock_delalloc_range.constprop.44+0x1e1/0x200 [btrfs]
 [<ffffffffa036e23f>] __extent_writepage+0x3af/0x860 [btrfs]
 [<ffffffff81333860>] ? delay_tsc+0x90/0xe0
 [<ffffffffa036e972>] extent_write_cache_pages.isra.34.constprop.49+0x282/0x3f0 [btrfs]
 [<ffffffff810b4c38>] ? trace_hardirqs_off_caller+0x28/0xd0
 [<ffffffff810b4d62>] ? get_lock_stats+0x22/0x70
 [<ffffffffa036edcc>] extent_writepages+0x4c/0x60 [btrfs]
 [<ffffffffa03543b0>] ? btrfs_writepage_end_io_hook+0x240/0x240 [btrfs]
 [<ffffffff810b5a66>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffffa0351398>] btrfs_writepages+0x28/0x30 [btrfs]
 [<ffffffff81149921>] do_writepages+0x21/0x50
 [<ffffffff811df320>] __writeback_single_inode+0x40/0x5d0
 [<ffffffff811dfb5a>] writeback_sb_inodes+0x2aa/0x630
 [<ffffffff811e00a4>] wb_writeback+0xf4/0x590
 [<ffffffff811e0c17>] wb_do_writeback+0xc7/0x310
 [<ffffffff8106bf36>] ? set_worker_desc+0x76/0x90
 [<ffffffff811e0ef3>] bdi_writeback_workfn+0x93/0x390
 [<ffffffff810691c1>] process_one_work+0x211/0x6f0
 [<ffffffff81069155>] ? process_one_work+0x1a5/0x6f0
 [<ffffffff810697bc>] worker_thread+0x11c/0x390
 [<ffffffff810696a0>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff81071d5d>] kthread+0xed/0x100
 [<ffffffff81071c70>] ? insert_kthread_work+0x80/0x80
 [<ffffffff816bf11c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81071c70>] ? insert_kthread_work+0x80/0x80

lockstats output is at http://codemonkey.org.uk/junk/lockstats.txt

	Dave

