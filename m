Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753401AbeF2PTA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 11:19:00 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1B0BACD8
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 15:18:58 +0000 (UTC)
Date: Fri, 29 Jun 2018 17:18:57 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/14] btrfs: raid56: don't lock stripe cache table when
 freeing
Message-ID: <20180629151857.GV2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1530262400.git.dsterba@suse.com>
 <6c508b165cc727f07137f0208ce68ce3ce70c2c9.1530262400.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6c508b165cc727f07137f0208ce68ce3ce70c2c9.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 10:57:07AM +0200, David Sterba wrote:
> This is called either at the end of the mount or if the mount fails.
> In both cases, there's nothing running that can use the table so the
> lock is pointless.

And then lockdep says no. The umount path frees the table but there's
some unfinished bio that wants to use the table from the interrupt
context. And this is puzzling, there should be no IO in flight, all
workers should be stopped.

btrfs/011:

[ 1339.169842] ================================
[ 1339.171891] WARNING: inconsistent lock state
[ 1339.173724] 4.17.0-rc7-default+ #168 Not tainted
[ 1339.175661] --------------------------------
[ 1339.177479] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[ 1339.179758] umount/4029 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1339.182008] 0000000096eee2cd (&(&cur->lock)->rlock){?.-.}, at: __remove_rbio_from_cache+0x5f/0x140 [btrfs]
[ 1339.183982] {IN-HARDIRQ-W} state was registered at:
[ 1339.184819]   _raw_spin_lock_irqsave+0x43/0x52
[ 1339.185433]   unlock_stripe+0x78/0x3d0 [btrfs]
[ 1339.186041]   rbio_orig_end_io+0x41/0xd0 [btrfs]
[ 1339.186648]   blk_update_request+0xd7/0x330
[ 1339.187205]   blk_mq_end_request+0x18/0x70
[ 1339.187752]   flush_smp_call_function_queue+0x83/0x120
[ 1339.188405]   smp_call_function_single_interrupt+0x43/0x270
[ 1339.189094]   call_function_single_interrupt+0xf/0x20
[ 1339.189733]   native_safe_halt+0x2/0x10
[ 1339.190255]   default_idle+0x1f/0x190
[ 1339.190759]   do_idle+0x217/0x240
[ 1339.191229]   cpu_startup_entry+0x6f/0x80
[ 1339.191768]   start_secondary+0x192/0x1e0
[ 1339.192385]   secondary_startup_64+0xa5/0xb0
[ 1339.193145] irq event stamp: 783817
[ 1339.193701] hardirqs last  enabled at (783817): [<ffffffff8267234d>] _raw_spin_unlock_irqrestore+0x4d/0x60
[ 1339.194896] hardirqs last disabled at (783816): [<ffffffff82672a10>] _raw_spin_lock_irqsave+0x20/0x52
[ 1339.196010] softirqs last  enabled at (777902): [<ffffffff82a00397>] __do_softirq+0x397/0x502
[ 1339.197435] softirqs last disabled at (777879): [<ffffffff82066311>] irq_exit+0xc1/0xd0
[ 1339.198797]
[ 1339.198797] other info that might help us debug this:
[ 1339.200011]  Possible unsafe locking scenario:
[ 1339.200011]
[ 1339.201066]        CPU0
[ 1339.201464]        ----
[ 1339.201845]   lock(&(&cur->lock)->rlock);
[ 1339.202372]   <Interrupt>
[ 1339.202768]     lock(&(&cur->lock)->rlock);
[ 1339.203313]
[ 1339.203313]  *** DEADLOCK ***
[ 1339.203313]
[ 1339.204215] 1 lock held by umount/4029:
[ 1339.204727]  #0: 000000007c3dd992 (&type->s_umount_key#26){++++}, at: deactivate_super+0x43/0x50
[ 1339.205822]
[ 1339.205822] stack backtrace:
[ 1339.206660] CPU: 2 PID: 4029 Comm: umount Not tainted 4.17.0-rc7-default+ #168
[ 1339.207875] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 1339.209357] Call Trace:
[ 1339.209742]  dump_stack+0x85/0xc0
[ 1339.210204]  print_usage_bug.cold.57+0x1aa/0x1e4
[ 1339.210790]  ? print_shortest_lock_dependencies+0x40/0x40
[ 1339.211680]  mark_lock+0x530/0x630
[ 1339.212291]  ? print_shortest_lock_dependencies+0x40/0x40
[ 1339.213180]  __lock_acquire+0x549/0xf60
[ 1339.213855]  ? flush_work+0x24a/0x280
[ 1339.214485]  ? __lock_is_held+0x4f/0x90
[ 1339.215176]  lock_acquire+0x9e/0x1d0
[ 1339.215850]  ? __remove_rbio_from_cache+0x5f/0x140 [btrfs]
[ 1339.216755]  _raw_spin_lock+0x2c/0x40
[ 1339.217303]  ? __remove_rbio_from_cache+0x5f/0x140 [btrfs]
[ 1339.218005]  __remove_rbio_from_cache+0x5f/0x140 [btrfs]
[ 1339.218687]  btrfs_free_stripe_hash_table+0x2a/0x50 [btrfs]
[ 1339.219393]  close_ctree+0x1d7/0x330 [btrfs]
[ 1339.219961]  generic_shutdown_super+0x64/0x100
[ 1339.220659]  kill_anon_super+0xe/0x20
[ 1339.221245]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 1339.221840]  deactivate_locked_super+0x29/0x60
[ 1339.222416]  cleanup_mnt+0x3b/0x70
[ 1339.222892]  task_work_run+0x9b/0xd0
[ 1339.223388]  exit_to_usermode_loop+0x99/0xa0
[ 1339.223949]  do_syscall_64+0x16c/0x170
[ 1339.224603]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1339.225457] RIP: 0033:0x7ffb9180d017
[ 1339.226063] RSP: 002b:00007fff9cb72a28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 1339.227289] RAX: 0000000000000000 RBX: 000055b804721970 RCX: 00007ffb9180d017
[ 1339.228373] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055b804721b50
[ 1339.229451] RBP: 0000000000000000 R08: 000055b804721b70 R09: 00007fff9cb71290
[ 1339.230524] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffb91d291c4
[ 1339.231604] R13: 000055b804721b50 R14: 0000000000000000 R15: 00007fff9cb72c98
