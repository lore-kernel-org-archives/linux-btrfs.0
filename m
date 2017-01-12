Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16944 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdALSg4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 13:36:56 -0500
Date: Thu, 12 Jan 2017 10:44:28 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: master - btrfs lockdep splat
Message-ID: <20170112184427.GB24433@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1484244732.4987.11.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484244732.4987.11.camel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017 at 07:12:12PM +0100, Mike Galbraith wrote:
> Greetings,
> 
> I wanted to do some -rt testing, but seems non-rt kernels aren't
> lockdep clean with btrfs /, making -rt testing a bit premature.
> 
> (hm, 28a235931 Btrfs: fix lockdep warning on deadlock against an inode's log mutex)

It's rather a false-positive lockdep warning than a real deadlock, and a
patch[1] has been queued to fix it.

[1]: https://patchwork.kernel.org/patch/9473431/

Thanks,

-liubo
>  
> [  876.622587] =============================================
> [  876.622588] [ INFO: possible recursive locking detected ]
> [  876.622589] 4.10.0-master #36 Tainted: G            E  
> [  876.622590] ---------------------------------------------
> [  876.622591] vi/3364 is trying to acquire lock:
> [  876.622592]  (&ei->log_mutex){+.+...}, at: [<ffffffffa03d42ec>] btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622628] but task is already holding lock:
> [  876.622629]  (&ei->log_mutex){+.+...}, at: [<ffffffffa03d42ec>] btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622641] other info that might help us debug this:
> [  876.622642]  Possible unsafe locking scenario:
> [  876.622643]        CPU0
> [  876.622644]        ----
> [  876.622644]   lock(&ei->log_mutex);
> [  876.622648]   lock(&ei->log_mutex);
> [  876.622649] *** DEADLOCK ***
> [  876.622650]  May be due to missing lock nesting notation
> [  876.622651] 3 locks held by vi/3364:
> [  876.622651]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa03a3c84>] btrfs_sync_file+0x154/0x480 [btrfs]
> [  876.622664]  #1:  (sb_internal){.+.+..}, at: [<ffffffffa038b397>] start_transaction+0x2a7/0x540 [btrfs]
> [  876.622674]  #2:  (&ei->log_mutex){+.+...}, at: [<ffffffffa03d42ec>] btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622685] stack backtrace:
> [  876.622687] CPU: 3 PID: 3364 Comm: vi Tainted: G            E   4.10.0-master #36
> [  876.622688] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20161202_174313-build11a 04/01/2014
> [  876.622689] Call Trace:
> [  876.622698]  dump_stack+0x85/0xc9
> [  876.622704]  __lock_acquire+0x9f9/0x1550
> [  876.622715]  ? __btrfs_release_delayed_node+0x79/0x2d0 [btrfs]
> [  876.622717]  lock_acquire+0xbd/0x200
> [  876.622726]  ? btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622732]  mutex_lock_nested+0x69/0x660
> [  876.622741]  ? btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622750]  ? __btrfs_release_delayed_node+0x79/0x2d0 [btrfs]
> [  876.622759]  ? btrfs_commit_inode_delayed_inode+0xeb/0x130 [btrfs]
> [  876.622767]  btrfs_log_inode+0x13c/0xbd0 [btrfs]
> [  876.622771]  ? __might_sleep+0x4a/0x90
> [  876.622781]  ? btrfs_i_callback+0x20/0x20 [btrfs]
> [  876.622791]  ? free_extent_buffer+0x4b/0x90 [btrfs]
> [  876.622799]  btrfs_log_inode+0x572/0xbd0 [btrfs]
> [  876.622808]  btrfs_log_inode_parent+0x26a/0x9b0 [btrfs]
> [  876.622812]  ? dget_parent+0x77/0x170
> [  876.622821]  btrfs_log_dentry_safe+0x62/0x80 [btrfs]
> [  876.622830]  btrfs_sync_file+0x2eb/0x480 [btrfs]
> [  876.622834]  vfs_fsync_range+0x3d/0xb0
> [  876.622836]  ? trace_hardirqs_on_caller+0xf9/0x1c0
> [  876.622837]  do_fsync+0x3d/0x70
> [  876.622839]  SyS_fsync+0x10/0x20
> [  876.622840]  entry_SYSCALL_64_fastpath+0x1f/0xc2
> [  876.622842] RIP: 0033:0x7f7fbe3da290
> [  876.622843] RSP: 002b:00007ffe2778f0b8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> [  876.622844] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7fbe3da290
> [  876.622845] RDX: 000000000000103d RSI: 000000000143e5d0 RDI: 0000000000000003
> [  876.622846] RBP: 0000000001285f10 R08: 000000000143e5d0 R09: 0000000000000000
> [  876.622847] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  876.622847] R13: 0000000000002000 R14: 0000000000000001 R15: 00000000012821a0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
