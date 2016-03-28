Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:38768 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbcC1BOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 21:14:12 -0400
Date: Sun, 27 Mar 2016 21:14:00 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160328011400.GA19000@codemonkey.org.uk>
References: <20160324225411.GA1612@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160324225411.GA1612@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 06:54:11PM -0400, Dave Jones wrote:
 > Just hit this on a tree from earlier this morning, v4.5-11140 or so.
 > 
 > WARNING: CPU: 2 PID: 32570 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 > CPU: 2 PID: 32570 Comm: rm Not tainted 4.5.0-think+ #14
 >  ffffffffc039baf9 00000000ef721ef0 ffff88025966fc08 ffffffff8957bcdb
 >  0000000000000000 0000000000000000 ffff88025966fc50 ffffffff890b41f1
 >  ffff88045d918040 0000242d4eed6048 ffff88024eed6048 ffff88024eed6048
 > Call Trace:
 >  [<ffffffffc039baf9>] ? btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 >  [<ffffffff8957bcdb>] dump_stack+0x68/0x9d
 >  [<ffffffff890b41f1>] __warn+0x111/0x130
 >  [<ffffffff890b43fd>] warn_slowpath_null+0x1d/0x20
 >  [<ffffffffc039baf9>] btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 >  [<ffffffff89352307>] destroy_inode+0x67/0x90
 >  [<ffffffff893524e7>] evict+0x1b7/0x240
 >  [<ffffffff893529be>] iput+0x3ae/0x4e0
 >  [<ffffffff8934c93e>] ? dput+0x20e/0x460
 >  [<ffffffff8933ee26>] do_unlinkat+0x256/0x440
 >  [<ffffffff8933ebd0>] ? do_rmdir+0x350/0x350
 >  [<ffffffff890031e7>] ? syscall_trace_enter_phase1+0x87/0x260
 >  [<ffffffff89003160>] ? enter_from_user_mode+0x50/0x50
 >  [<ffffffff8913c3b5>] ? __lock_is_held+0x25/0xd0
 >  [<ffffffff891411f2>] ? mark_held_locks+0x22/0xc0
 >  [<ffffffff890034ed>] ? syscall_trace_enter_phase2+0x12d/0x3d0
 >  [<ffffffff893400b0>] ? SyS_rmdir+0x20/0x20
 >  [<ffffffff893400cb>] SyS_unlinkat+0x1b/0x30
 >  [<ffffffff89003ac4>] do_syscall_64+0xf4/0x240
 >  [<ffffffff89d520da>] entry_SYSCALL64_slow_path+0x25/0x25
 > ---[ end trace a48ce4e6a1b5e409 ]---
 > 
 > 
 > That's WARN_ON(BTRFS_I(inode)->csum_bytes);
 > 
 > *maybe* it's a bad disk, but there's no indication in dmesg of anything awry.
 > Spinning rust on SATA, nothing special.

Same WARN_ON is reachable from umount too..

WARNING: CPU: 2 PID: 20092 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x40c/0x480 [btrfs]
CPU: 2 PID: 20092 Comm: umount Tainted: G        W       4.5.0-think+ #1
 00000000ffffffff 00000000a32c482b ffff8803cd187b60 ffffffff9d63af84
 0000000000000000 0000000000000000 ffffffffc05c5e40 ffffffffc04d316c
 ffff8803cd187ba8 ffffffff9d0c4c27 ffff880460d80040 0000242dcd187bb0
Call Trace:
 [<ffffffff9d63af84>] dump_stack+0x95/0xe1
 [<ffffffffc04d316c>] ? btrfs_destroy_inode+0x40c/0x480 [btrfs]
 [<ffffffff9d0c4c27>] __warn+0x147/0x170
 [<ffffffff9d0c4e91>] warn_slowpath_null+0x31/0x40
 [<ffffffffc04d316c>] btrfs_destroy_inode+0x40c/0x480 [btrfs]
 [<ffffffffc04d2d60>] ? btrfs_test_destroy_inode+0x40/0x40 [btrfs]
 [<ffffffff9d3bf7e7>] destroy_inode+0x77/0xb0
 [<ffffffff9d3bfa2e>] evict+0x20e/0x2c0
 [<ffffffff9d3bfb50>] dispose_list+0x70/0xb0
 [<ffffffff9d3c14ef>] evict_inodes+0x26f/0x2c0
 [<ffffffff9d3c1280>] ? inode_add_lru+0x60/0x60
 [<ffffffff9d40baa5>] ? fsnotify_unmount_inodes+0x215/0x2c0
 [<ffffffff9d38e336>] generic_shutdown_super+0x76/0x1c0
 [<ffffffff9d38e899>] kill_anon_super+0x29/0x40
 [<ffffffffc044c421>] btrfs_kill_super+0x31/0x130 [btrfs]
 [<ffffffff9d38ec1f>] deactivate_locked_super+0x6f/0xb0
 [<ffffffff9d38f2c9>] deactivate_super+0x99/0xb0
 [<ffffffff9d3c8610>] cleanup_mnt+0x70/0xd0
 [<ffffffff9d3c86db>] __cleanup_mnt+0x1b/0x20
 [<ffffffff9d103d1f>] task_work_run+0xef/0x130
 [<ffffffff9d0023c9>] exit_to_usermode_loop+0xf9/0x100
 [<ffffffff9d004068>] do_syscall_64+0x238/0x2b0
 [<ffffffff9df3831a>] entry_SYSCALL64_slow_path+0x25/0x25

