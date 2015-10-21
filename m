Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from swwu.com ([81.4.102.7]:43861 "EHLO swwu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbJUXgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 19:36:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 22 Oct 2015 01:36:46 +0200
From: Victor <services@swwu.com>
To: linux-btrfs@vger.kernel.org
Cc: spender@grsecurity.net, pageexec@freemail.hu, re.emese@gmail.com
Subject: overflow in inode.c, file.c
Message-ID: <fdb1fe411a9aa68d196737cbee851a1b@swwu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, while using linux-⁠4.2.3 (btrfs-⁠progs v4.2.2) with the latest
grsec patch to date, a feature in the grsec patchset, an overflow
checker (made by emese) seems to have found some bugs in the btrfs
code itself (this is not caused by grsec).

First bug: fs/⁠btrfs/⁠inode.c:5759

For example -⁠-⁠>

***********************************
Oct 18 16:09:18 TestMachine kernel: [    8.449128] PAX: size overflow
detected in function btrfs_real_readdir fs/⁠btrfs/⁠inode.c:5760
cicus.935_282 max, count: 9, decl: pos; num: 0; context: dir_context;
Oct 18 16:09:18 TestMachine kernel: [    8.449132] CPU: 0 PID: 2630
Comm: polkitd Not tainted 4.2.3-⁠grsec #1
Oct 18 16:09:18 TestMachine kernel: [    8.449134] Hardware name:
Gigabyte Technology Co., Ltd. H81ND2H/⁠H81ND2H, BIOS F3 08/⁠11/⁠2015
Oct 18 16:09:18 TestMachine kernel: [    8.449135]  ffffffff81901608
0000000000000000 ffffffff819015e6 ffffc90004973d48
Oct 18 16:09:18 TestMachine kernel: [    8.449139]  ffffffff81742f0f
0000000000000007 ffffffff81901608 ffffc90004973d78
Oct 18 16:09:18 TestMachine kernel: [    8.449141]  ffffffff811cb706
0000000000000000 ffff8800d47359e0 ffffc90004973ed8
Oct 18 16:09:18 TestMachine kernel: [    8.449144] Call Trace:
Oct 18 16:09:18 TestMachine kernel: [    8.449151]
[<ffffffff81742f0f>] dump_stack+0x4c/⁠0x7f
Oct 18 16:09:18 TestMachine kernel: [    8.449154]
[<ffffffff811cb706>] report_size_overflow+0x36/⁠0x40
Oct 18 16:09:18 TestMachine kernel: [    8.449158]
[<ffffffff812ef0bc>] btrfs_real_readdir+0x69c/⁠0x6d0
Oct 18 16:09:18 TestMachine kernel: [    8.449160]
[<ffffffff811dafc8>] iterate_dir+0xa8/⁠0x150
Oct 18 16:09:18 TestMachine kernel: [    8.449164]
[<ffffffff811e6d8d>] ? __fget_light+0x2d/⁠0x70
Oct 18 16:09:18 TestMachine kernel: [    8.449166]
[<ffffffff811dba3a>] SyS_getdents+0xba/⁠0x1c0
Oct 18 16:09:18 TestMachine kernel: [    8.449169]
[<ffffffff811db070>] ? iterate_dir+0x150/⁠0x150
Oct 18 16:09:18 TestMachine kernel: [    8.449173]
[<ffffffff81749b69>] entry_SYSCALL_64_fastpath+0x12/⁠0x83
Oct 18 16:09:18 TestMachine kernel: [    8.449230] Overflow: 7fffffff

*************************************

Second bug: fs/⁠btrfs/⁠file.c:1871

Example-⁠-⁠>

********************************
Oct 18 16:09:20 TestMachine kernel: [   10.526375] PAX: size overflow
detected in function btrfs_sync_file fs/⁠btrfs/⁠file.c:1871
cicus.679_107 max, count: 289, decl: btrfs_wait_ordered_range; num: 3;
context: fndecl;
Oct 18 16:09:20 TestMachine kernel: [   10.526380] CPU: 1 PID: 3160
Comm: mysqld Not tainted 4.2.3-⁠grsec #1
Oct 18 16:09:20 TestMachine kernel: [   10.526382] Hardware name:
Gigabyte Technology Co., Ltd. H81ND2H/⁠H81ND2H, BIOS F3 08/⁠11/⁠2015
Oct 18 16:09:20 TestMachine kernel: [   10.526384]  ffffffff819019e5
0000000000000000 ffffffff81901924 ffffc90004d8bd98
Oct 18 16:09:20 TestMachine kernel: [   10.526387]  ffffffff81742f0f
ffff88021f28ddc0 ffffffff819019e5 ffffc90004d8bdc8
Oct 18 16:09:20 TestMachine kernel: [   10.526390]  ffffffff811cb706
ffff880202e9e270 0000000000000000 8000000000000000
Oct 18 16:09:20 TestMachine kernel: [   10.526392] Call Trace:
Oct 18 16:09:20 TestMachine kernel: [   10.526399]
[<ffffffff81742f0f>] dump_stack+0x4c/⁠0x7f
Oct 18 16:09:20 TestMachine kernel: [   10.526402]
[<ffffffff811cb706>] report_size_overflow+0x36/⁠0x40
Oct 18 16:09:20 TestMachine kernel: [   10.526404]
[<ffffffff81306a40>] btrfs_sync_file+0x90/⁠0x490
Oct 18 16:09:20 TestMachine kernel: [   10.526407]
[<ffffffff811fc199>] vfs_fsync_range+0x59/⁠0xc0
Oct 18 16:09:20 TestMachine kernel: [   10.526410]
[<ffffffff811e6d8d>] ? __fget_light+0x2d/⁠0x70
Oct 18 16:09:20 TestMachine kernel: [   10.526411]
[<ffffffff811fc26c>] do_fsync+0x3c/⁠0x70
Oct 18 16:09:20 TestMachine kernel: [   10.526413]
[<ffffffff811fc545>] SyS_fsync+0x15/⁠0x30
Oct 18 16:09:20 TestMachine kernel: [   10.526415]
[<ffffffff81749b69>] entry_SYSCALL_64_fastpath+0x12/⁠0x83
*********************************


len = end -⁠ start + 1

vfs_fsync calls vfs_fsync_range with 0 and LLONG_MAX for start and end.
In btrfs_sync_file the above expression causes a signed overflow
(undefined behaviour) with these values.



This is the whole dmesg http://pastebin.com/S9gjYpYX , thanks

