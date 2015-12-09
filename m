Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:56058 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbLIEZk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 23:25:40 -0500
Date: Tue, 8 Dec 2015 23:25:28 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151209042528.GA2413@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure if I've already reported this one, but I've been seeing this
a lot this last couple days.

kernel BUG at mm/page-writeback.c:2654!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
CPU: 1 PID: 2566 Comm: trinity-c1 Tainted: G        W       4.4.0-rc4-think+ #14
task: ffff880462811b80 ti: ffff8800cd808000 task.ti: ffff8800cd808000
RIP: 0010:[<ffffffff8826ff40>]  [<ffffffff8826ff40>] clear_page_dirty_for_io+0x180/0x1d0
RSP: 0018:ffff8800cd80fa00  EFLAGS: 00010246
RAX: 800000000000080c RBX: ffffea0011098a00 RCX: ffff8800cd80fbb7
RDX: dffffc0000000000 RSI: 1ffff10019b01f76 RDI: ffffea0011098a00
RBP: ffff8800cd80fa20 R08: ffff880453272000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88045326f2c0
R13: ffff88046272a310 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f186573d700(0000) GS:ffff880468a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000010dd580 CR3: 000000046261c000 CR4: 00000000001406e0
Stack:
 0000000000000001 ffff88046272a310 ffff88046272a310 0000000000000000
 ffff8800cd80fa90 ffffffffc03891b5 ffff8800cd80fb30 ffff880402400040
 ffff88045326f0e8 0000000000001000 ffff88045326ed88 ffff8800cd80fbb0
Call Trace:
 [<ffffffffc03891b5>] lock_and_cleanup_extent_if_need+0xa5/0x260 [btrfs]
 [<ffffffffc038acf4>] __btrfs_buffered_write+0x324/0x8a0 [btrfs]
 [<ffffffffc038a9d0>] ? btrfs_dirty_pages+0xf0/0xf0 [btrfs]
 [<ffffffff88261adc>] ? generic_file_direct_write+0x2ac/0x2c0
 [<ffffffff88261830>] ? generic_file_read_iter+0xa00/0xa00
 [<ffffffffc039066d>] btrfs_file_write_iter+0x6dd/0x800 [btrfs]
 [<ffffffff882f6a0d>] __vfs_write+0x21d/0x260
 [<ffffffff882f67f0>] ? __vfs_read+0x260/0x260
 [<ffffffff8812ed62>] ? __lock_is_held+0x92/0xd0
 [<ffffffff880ee3b1>] ? preempt_count_sub+0xc1/0x120
 [<ffffffff8812cd47>] ? percpu_down_read+0x57/0xa0
 [<ffffffff882fbde4>] ? __sb_start_write+0xb4/0xf0
 [<ffffffff882f77f6>] vfs_write+0xf6/0x260
 [<ffffffff882f8e0f>] SyS_write+0xbf/0x160
 [<ffffffff882f8d50>] ? SyS_read+0x160/0x160
 [<ffffffff88002017>] ? trace_hardirqs_on_thunk+0x17/0x19
 [<ffffffff88cea997>] entry_SYSCALL_64_fastpath+0x12/0x6b
Code: 61 01 49 8d bd f0 00 00 00 8d 14 c5 08 00 00 00 e8 b6 cd 31 00 f6 c7 02 74 20 e8 8c 41 ec ff 53 9d b8 01 00 00 00 e9 1d ff ff ff <0f> 0b 48 89 df e8 b6 f5 ff ff e9 41 ff ff ff 53 9d e8 0a e7 eb 


That BUG is..

2653 
2654         BUG_ON(!PageLocked(page));
2655 

