Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35306 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755862AbcLBETO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 23:19:14 -0500
Received: by mail-pf0-f173.google.com with SMTP id i88so50005408pfk.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 20:19:14 -0800 (PST)
Received: from zzz (c-73-239-167-150.hsd1.wa.comcast.net. [73.239.167.150])
        by smtp.gmail.com with ESMTPSA id a24sm3418727pfh.57.2016.12.01.20.19.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Dec 2016 20:19:13 -0800 (PST)
Date: Thu, 1 Dec 2016 20:19:11 -0800
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs lockdep warning: possible recursive locking of &ei->log_mutex
Message-ID: <20161202041911.GA1228@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using btrfs and a kernel with lockdep enabled (4.9-rc7, but this easily
could have been there for a while) I got the following lockdep warning:

[   37.796703] =============================================
[   37.796773] [ INFO: possible recursive locking detected ]
[   37.796854] 4.9.0-rc7 #351 Tainted: G             L 
[   37.796917] ---------------------------------------------
[   37.796986] systemd-journal/280 is trying to acquire lock:
[   37.797051]  (
[   37.797077] &ei->log_mutex
[   37.797119] ){+.+...}
[   37.797135] , at: 
[   37.797176] [<ffffffff8182714d>] btrfs_log_inode+0x33d/0x20a0
[   37.797254] 
               but task is already holding lock:
[   37.797328]  (
[   37.797353] &ei->log_mutex
[   37.797396] ){+.+...}
[   37.797411] , at: 
[   37.797449] [<ffffffff8182714d>] btrfs_log_inode+0x33d/0x20a0
[   37.797521] 
               other info that might help us debug this:
[   37.797603]  Possible unsafe locking scenario:

[   37.797682]        CPU0
[   37.797717]        ----
[   37.797751]   lock(
[   37.797782] &ei->log_mutex
[   37.797822] );
[   37.797848]   lock(
[   37.797878] &ei->log_mutex
[   37.797920] );
[   37.797946] 
                *** DEADLOCK ***

[   37.798020]  May be due to missing lock nesting notation

[   37.798120] 3 locks held by systemd-journal/280:
[   37.798180]  #0: 
[   37.798208]  (
[   37.798238] &sb->s_type->i_mutex_key
[   37.798269] #9
[   37.798299] ){+.+.+.}
[   37.798315] , at: 
[   37.798354] [<ffffffff817a0511>] btrfs_sync_file+0x1b1/0x990
[   37.798425]  #1: 
[   37.798453]  (
[   37.798483] sb_internal
[   37.798501] ){.+.+.+}
[   37.798538] , at: 
[   37.798553] [<ffffffff8175ca9c>] start_transaction+0x7bc/0xe60
[   37.798632]  #2: 
[   37.798660]  (
[   37.798690] &ei->log_mutex
[   37.798711] ){+.+...}
[   37.798747] , at: 
[   37.798763] [<ffffffff8182714d>] btrfs_log_inode+0x33d/0x20a0
[   37.798840] 
               stack backtrace:
[   37.798902] CPU: 2 PID: 280 Comm: systemd-journal Tainted: G             L  4.9.0-rc7 #351
[   37.799017] Hardware name: Dell Inc. Inspiron 15-7568/0M5YMV, BIOS 01.00.00 08/07/2015
[   37.799111]  ffff880213ca72d0 ffffffff81a1fe82 ffffffff84056000 ffffffff83a98ae0
[   37.799230]  ffff880213ca7498 ffffffff811f43c1 dffffc0000000000 ffff88021470cf20
[   37.799348]  dffffc0000000000 ffffffff82fa15c0 ffff88021470cf00 1ffff10042794e72
[   37.799465] Call Trace:
[   37.799522]  [<ffffffff81a1fe82>] dump_stack+0x68/0x96
[   37.799591]  [<ffffffff811f43c1>] __lock_acquire+0x1bd1/0x5290
[   37.799670]  [<ffffffff811f27f0>] ? debug_check_no_locks_freed+0x280/0x280
[   37.799760]  [<ffffffff811f27f0>] ? debug_check_no_locks_freed+0x280/0x280
[   37.799849]  [<ffffffff811f1c88>] ? mark_held_locks+0xc8/0x120
[   37.799926]  [<ffffffff811f1c88>] ? mark_held_locks+0xc8/0x120
[   37.800001]  [<ffffffff82764c41>] ? __mutex_unlock_slowpath+0x221/0x420
[   37.800088]  [<ffffffff811f84fd>] lock_acquire+0xdd/0x190
[   37.800160]  [<ffffffff8182714d>] ? btrfs_log_inode+0x33d/0x20a0
[   37.800239]  [<ffffffff82764a20>] ? __ww_mutex_lock_interruptible+0x1500/0x1500
[   37.800333]  [<ffffffff82760004>] mutex_lock_nested+0xa4/0x7e0
[   37.803435]  [<ffffffff8182714d>] ? btrfs_log_inode+0x33d/0x20a0
[   37.806090]  [<ffffffff8275ff60>] ? mutex_trylock+0x3f0/0x3f0
[   37.808347]  [<ffffffff8173b2af>] ? __btrfs_btree_balance_dirty+0xcf/0x1a0
[   37.811207]  [<ffffffff81873c3b>] ? btrfs_commit_inode_delayed_inode+0x23b/0x360
[   37.814263]  [<ffffffff8182714d>] btrfs_log_inode+0x33d/0x20a0
[   37.817343]  [<ffffffff8148683f>] ? iget5_locked+0x8f/0x3a0
[   37.820420]  [<ffffffff82769a92>] ? _raw_spin_unlock+0x22/0x30
[   37.823462]  [<ffffffff8175f2d0>] ? btrfs_i_callback+0x20/0x20
[   37.826466]  [<ffffffff81826e10>] ? btrfs_log_changed_extents+0x15b0/0x15b0
[   37.829300]  [<ffffffff817b4922>] ? release_extent_buffer+0x102/0x150
[   37.832101]  [<ffffffff817b4922>] ? release_extent_buffer+0x102/0x150
[   37.834628]  [<ffffffff817c6052>] ? free_extent_buffer+0xe2/0x220
[   37.837466]  [<ffffffff816d1215>] ? btrfs_release_path+0x85/0x1b0
[   37.840325]  [<ffffffff81828533>] btrfs_log_inode+0x1723/0x20a0
[   37.843265]  [<ffffffff81826e10>] ? btrfs_log_changed_extents+0x15b0/0x15b0
[   37.846248]  [<ffffffff82760471>] ? mutex_lock_nested+0x511/0x7e0
[   37.849177]  [<ffffffff811f1c88>] ? mark_held_locks+0xc8/0x120
[   37.852120]  [<ffffffff82764c41>] ? __mutex_unlock_slowpath+0x221/0x420
[   37.855053]  [<ffffffff82764a20>] ? __ww_mutex_lock_interruptible+0x1500/0x1500
[   37.858013]  [<ffffffff818295e9>] btrfs_log_inode_parent+0x689/0x2280
[   37.860982]  [<ffffffff81828f60>] ? btrfs_end_log_trans+0x70/0x70
[   37.863918]  [<ffffffff8147a191>] ? dget_parent+0x91/0x350
[   37.866855]  [<ffffffff8147a1a9>] ? dget_parent+0xa9/0x350
[   37.869762]  [<ffffffff8182e434>] btrfs_log_dentry_safe+0x74/0xa0
[   37.872650]  [<ffffffff817a08ae>] btrfs_sync_file+0x54e/0x990
[   37.875570]  [<ffffffff817a0360>] ? start_ordered_ops+0x20/0x20
[   37.878502]  [<ffffffff81003629>] ? syscall_trace_enter+0x289/0x7c0
[   37.881140]  [<ffffffff817a0360>] ? start_ordered_ops+0x20/0x20
[   37.883550]  [<ffffffff814c0158>] vfs_fsync_range+0xe8/0x280
[   37.886026]  [<ffffffff814c0348>] do_fsync+0x38/0x60
[   37.888499]  [<ffffffff814c0a10>] ? SyS_syncfs+0xc0/0xc0
[   37.891003]  [<ffffffff814c0a1b>] SyS_fsync+0xb/0x10
[   37.893851]  [<ffffffff81003f1c>] do_syscall_64+0x17c/0x420
[   37.896879]  [<ffffffff8276a224>] entry_SYSCALL64_slow_path+0x25/0x25
